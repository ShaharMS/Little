package little.interpreter;

import little.tools.Layer;
import little.parser.Tokens.ParserTokens;
import little.Keywords.*;
import little.interpreter.memory.MemoryTree;

using StringTools;
using Std;
using Math;
using little.tools.TextTools;
@:access(little.interpreter.Runtime)
class Interpreter {
    
    public static var errorThrown = false;

    public static var memory:MemoryTree = new MemoryTree(new MemoryObject(NullValue));

    public static var currentConfig:RunConfig;

    public static function interpret(tokens:Array<ParserTokens>, runConfig:RunConfig) {
        //// trace(tokens);
        currentConfig = runConfig;
        if (tokens == null || tokens.length == 0) return NullValue;
        if (tokens[0].getName() != "Module") {
            tokens.unshift(Module(runConfig.defaultModuleName));
        }
        return runTokens(tokens, runConfig.prioritizeVariableDeclarations, runConfig.prioritizeFunctionDeclarations, runConfig.strictTyping);
    }

    public static function runTokens(tokens:Array<ParserTokens>, preParseVars:Bool, preParseFuncs:Bool, strict:Bool, ?memory:MemoryTree):ParserTokens {
        // Todo: support preParseVars
        // Todo: support preParseFuncs
        // Todo: support strict typing

        if (memory == null) memory = Interpreter.memory; // If no memory map is given, use the base one.

        var returnVal:ParserTokens = null;

        var i = 0;
        while (i < tokens.length) {
            var token = tokens[i];
            if (token == null) {i++; continue;}
            switch token {
                case SetLine(line): Runtime.line = line;
                case Module(name): Runtime.currentModule = name;
                case SplitLine:
                case Define(name, type): {
                    var object = accessObject(name, memory);
                    object = new MemoryObject(NullValue, type);
                    returnVal = object.value;
                }
                case Action(name, params, type): {
                    var object = accessObject(name, memory);
                    object = new MemoryObject(NullValue, null, params.getParameters()[0], type);
                    returnVal = object.value;
                }
                case Condition(name, exp, body, type): {
                    if (memory.get(stringifyTokenValue(name)) == null) {
                        Runtime.throwError(returnVal = ErrorMessage('No Such Condition:  `${stringifyTokenValue(name)}`'));
                    } 
                    else {
                        returnVal = memory.get(stringifyTokenValue(name)).use(PartArray([exp, body]));
                        if (returnVal.getName() == "ErrorMessage") Runtime.throwError(returnVal);
                    }
                }
                case Write(assignees, value, type): {
                    var v = null;
                    for (a in assignees) {
                        var assignee = accessObject(a);
                        if (assignee == null) continue;
                        if (assignee.params != null)
                            assignee.value = value;
                        else {
                            if (v == null)
                                v = evaluate(value);
                            if (v.getName() == "ErrorMessage") {
                                assignee.value = NullValue;
                            } else {
                                assignee.value = v;
                            }
                        }
                    }
                    returnVal = value;
                }
                case ActionCall(name, params): {
                    if (memory.get(stringifyTokenValue(name)) == null) {
                        Runtime.throwError(ErrorMessage('No Such Action:  `${stringifyTokenValue(name)}`'));
                    } 
                    else {
                        returnVal = memory.get(stringifyTokenValue(name)).use(params);
                        if (returnVal.getName() == "ErrorMessage") Runtime.throwError(returnVal);
                    }
                }
                case Return(value, type): {
                    return evaluate(value);
                }
                case Block(body, type): {
                    returnVal = runTokens(body, preParseVars, preParseFuncs, strict);
                }
                case PropertyAccess(name, property): {
                    returnVal = evaluate(token);
                }
                case Read(name): {
                    var str = stringifyTokenValue(name);
                    returnVal =  evaluate(if (memory.get(str) != null) memory.get(str).value else ErrorMessage('No Such Definition: `$str`'));
                }
                case _: returnVal = evaluate(token);
            }
            i++;
        }
        return returnVal;
    }

    public static function evaluate(exp:ParserTokens, ?memory:MemoryTree, ?dontThrow:Bool = false):ParserTokens {

        if (memory == null) memory = Interpreter.memory; // If no memory map is given, use the base one.

        if (exp == null) {
            // trace("null token");
            return NullValue;
        }

        switch exp {
            case ErrorMessage(msg): {
                if (!dontThrow) Runtime.throwError(exp, INTERPRETER_VALUE_EVALUATOR);
                return exp;
            }
            case SetLine(line): {
                Runtime.line = line; 
                return NullValue;
            }
            case SplitLine: return NullValue;
            case Module(name): {
                Runtime.currentModule = name;
                return NullValue;
            }
            case Expression(parts, _): {
                return evaluateExpressionParts(parts);
            }
            case Block(body, type): {
                var returnVal = runTokens(body, currentConfig.prioritizeVariableDeclarations, currentConfig.prioritizeFunctionDeclarations, currentConfig.strictTyping);
                return evaluate(returnVal, memory, dontThrow);
            }
            case PartArray(parts): {
                return PartArray([for (p in parts) evaluate(p, memory, dontThrow)]);
            }
            case Number(_) | Decimal(_) | Characters(_) | TrueValue | FalseValue | NullValue | Sign(_): return exp;
            case Identifier(word): {
                return evaluate(if (memory.get(word) != null) memory.get(word).value else ErrorMessage('No Such Definition: `$word`'), memory, dontThrow);
            }
            case TypeDeclaration(type): return evaluate(type, memory, dontThrow);
            case Write(assignees, value, type): {
                var v = null;
                for (a in assignees) {
                    var assignee = accessObject(a);
                    if (assignee == null) continue;
                    if (assignee.params != null)
                        assignee.value = value;
                    else {
                        if (v == null)
                            v = evaluate(value);
                        if (v.getName() == "ErrorMessage") {
                            assignee.value = NullValue;
                        } else {
                            assignee.value = v;
                        }
                    }
                }
                return evaluate(value, memory, dontThrow);
            }
            case Read(name): {
                var str = stringifyTokenValue(name);
                return evaluate(if (memory.get(str) != null) memory.get(str).value else ErrorMessage('No Such Definition: `$str`'), memory, dontThrow);
            }
            case ActionCall(name, params): {
                if (memory.get(stringifyTokenValue(name)) == null) return evaluate(ErrorMessage('No Such Action:  `${stringifyTokenValue(name)}`'));
                return evaluate(memory.get(stringifyTokenValue(name)).use(params), memory, dontThrow);
            }
            case Condition(name, exp, body, type): {
                if (memory.get(stringifyTokenValue(name)) == null) {
                    return evaluate(ErrorMessage('No Such Condition:  `${stringifyTokenValue(name)}`'), memory, dontThrow);
                } 
                else {
                    return evaluate(memory.get(stringifyTokenValue(name)).use(PartArray([exp, body])), memory, dontThrow);
                }
            }
            case Define(name, type): {
                var object = accessObject(name, memory);
                object = new MemoryObject(NullValue, type);
                return object.value;
            }
            case Action(name, params, type): {
                var object = accessObject(name, memory);
                object = new MemoryObject(NullValue, null, params.getParameters()[0], type);
                return object.value;
            }
            case External(get): return evaluate(get([]), memory, dontThrow);
            case PropertyAccess(_, _): {
                return accessObject(exp, memory).value;
            }
            case Return(value, type): {
                return evaluate(value, memory, dontThrow);
            }
            case _: {
                return evaluate(ErrorMessage('Unable to evaluate token `$exp`'), memory, dontThrow);
            }
        }

        

    }

    public static function accessObject(exp:ParserTokens, ?memory:MemoryTree):MemoryObject {
        
        if (memory == null) memory = Interpreter.memory; // If no memory map is given, use the base one.

        switch exp {
            case SetLine(line): Runtime.line = line;
            case Module(name): Runtime.currentModule = name;
            case Expression(parts, _): {
                return accessObject(evaluateExpressionParts(parts));
            }
            case Block(body, type): {
                var returnVal = runTokens(body, currentConfig.prioritizeVariableDeclarations, currentConfig.prioritizeFunctionDeclarations, currentConfig.strictTyping);
                return accessObject(evaluate(returnVal));
            }
            case Number(_): return new MemoryObject(exp, null, null, Identifier(TYPE_INT));
            case Decimal(_): return new MemoryObject(exp, null, null, Identifier(TYPE_FLOAT));
            case Characters(_): return new MemoryObject(exp, null, null, Identifier(TYPE_STRING));
            case Sign(_): return new MemoryObject(exp, null, null, Identifier(TYPE_SIGN));
            case TrueValue | FalseValue: return new MemoryObject(exp, null, null, Identifier(TYPE_BOOLEAN));
            case NullValue: return new MemoryObject(exp, null, null, Identifier(TYPE_VOID));
            case Identifier(word): {
                evaluate(if (memory.get(word) != null) memory.get(word).value else ErrorMessage('No Such Definition: `$word`'));
                return memory.get(word);
            }
            case Read(name): {
                var word = stringifyTokenValue(name);
                evaluate(if (memory.get(word) != null) memory.get(word).value else ErrorMessage('No Such Definition: `$word`'));
                return memory.get(word);
            }
            case ActionCall(name, params): {
                if (memory.get(stringifyTokenValue(name)) == null) evaluate(ErrorMessage('No Such Action:  `${stringifyTokenValue(name)}`'));
                return accessObject(memory.get(stringifyTokenValue(name)).use(params));
            }
            case Define(name, type): {
                function access(object:MemoryObject, prop:ParserTokens, objName:String):MemoryObject {
                    switch prop {
                        case PropertyAccess(_, property): {
                            objName += '$PROPERTY_ACCESS_SIGN${stringifyTokenValue(prop)}';
                            // trace(object, stringifyTokenValue(prop), property);
                            if (object.props.get(stringifyTokenValue(prop)) == null) {
                                // We can already know that object.name.property is null
                                evaluate(ErrorMessage('Unable to create `$objName$PROPERTY_ACCESS_SIGN${stringifyTokenIdentifier(property)}`: `$objName` Does not contain property `${stringifyTokenIdentifier(property)}`.'));
                                return null;
                            }
                            return access(object.props.get(stringifyTokenValue(prop)), property, objName);
                        }
                        case _: {
                            if (object.props.get(stringifyTokenIdentifier(prop)) == null) {
                                object.props.set(stringifyTokenIdentifier(prop), new MemoryObject(NullValue, type));
                            }
                            return object.props.get(stringifyTokenIdentifier(prop));
                        }
                    }
                }
                switch name {
                    case PropertyAccess(name, property): {
                        var obj = access(memory.get(stringifyTokenValue(name)), property, stringifyTokenValue(name));
                        return obj;
                    }
                    case _: {
                        memory.set(stringifyTokenValue(name), new MemoryObject(NullValue, type)); 
                        return memory.get(stringifyTokenValue(name));
                    }
                }
            }
            case Action(name, params, type): {
                function access(object:MemoryObject, prop:ParserTokens, objName:String):MemoryObject {
                    switch prop {
                        case PropertyAccess(_, property): {
                            objName += '$PROPERTY_ACCESS_SIGN${stringifyTokenValue(prop)}';
                            // trace(object, stringifyTokenValue(prop), property);
                            if (object.props.get(stringifyTokenValue(prop)) == null) {
                                // We can already know that object.name.property is null
                                evaluate(ErrorMessage('Unable to create `$objName$PROPERTY_ACCESS_SIGN${stringifyTokenIdentifier(property)}`: `$objName` Does not contain property `${stringifyTokenIdentifier(property)}`.'));
                                return null;
                            }
                            return access(object.props.get(stringifyTokenValue(prop)), property, objName);
                        }
                        case _: {
                            if (object.props.get(stringifyTokenIdentifier(prop)) == null) {
                                object.props.set(stringifyTokenIdentifier(prop), new MemoryObject(NullValue, null, params.getParameters()[0], type));
                            }
                            return object.props.get(stringifyTokenIdentifier(prop));
                        }
                    }
                }
                switch name {
                    case PropertyAccess(name, property): {
                        var obj = access(memory.get(stringifyTokenValue(name)), property, stringifyTokenValue(name));
                        return obj;
                    }
                    case _: {
                        trace(name, stringifyTokenValue(name));
                        memory.set(stringifyTokenValue(name), new MemoryObject(NullValue, null, params.getParameters()[0], type)); 
                        return memory.get(stringifyTokenValue(name));
                    }
                }
            }
            case PropertyAccess(n, p): {
                var str = stringifyTokenValue(n);
                var prop = stringifyTokenIdentifier(p);
                // trace(n, p);
                var obj = accessObject(n);
                if (obj == null) evaluate(ErrorMessage('Unable to access property `$str$PROPERTY_ACCESS_SIGN$prop`: No Such Definition: `$str`'));
                function access(object:MemoryObject, prop:ParserTokens, objName:String):MemoryObject {
                    switch prop {
                        case PropertyAccess(_, property): {
                            objName += '$PROPERTY_ACCESS_SIGN${stringifyTokenValue(prop)}';
                            // trace(object, stringifyTokenValue(prop), property);
                            if (object.props.get(stringifyTokenValue(prop)) == null) {
                                // We can already know that object.name.property is null
                                evaluate(ErrorMessage('Unable to access `$objName$PROPERTY_ACCESS_SIGN${stringifyTokenIdentifier(property)}`: `$objName` Does not contain property `${stringifyTokenIdentifier(property)}`.'));
                                return null;
                            }
                            return access(object.props.get(stringifyTokenValue(prop)), property, objName);
                        }
                        case ActionCall(name, params): {
                            if (object.props.get(stringifyTokenValue(name)) == null) {
                                evaluate(ErrorMessage('Unable to call `$objName$PROPERTY_ACCESS_SIGN${stringifyTokenValue(name)}(${stringifyTokenValue(params)})`: `$objName` Does not contain property `${stringifyTokenIdentifier(name)}`.'));
                                return null;
                            }
                            return new MemoryObject(object.props.get(stringifyTokenValue(name)).use(params)); // Todo: Should a new memory object actually be created here?
                        }
                        case _: {
                            if (object.props.get(stringifyTokenIdentifier(prop)) == null) {
                                object.props.set(stringifyTokenIdentifier(prop), new MemoryObject(NullValue));
                                evaluate(ErrorMessage('Unable to access `$str$PROPERTY_ACCESS_SIGN${stringifyTokenValue(prop)}`: `$str` Does not contain property `${stringifyTokenValue(prop)}`'));
                                return null;
                                // trace("Created new: " + objName, prop );
                            }
                            return object.props.get(stringifyTokenIdentifier(prop));
                        }
                    }
                }
                return access(obj, p, str);
                
            }
            case Return(value, type): {
                return accessObject(value);
            }
            case _: trace('Token $exp is inaccessible via memory. Returning null.');
        }

        // trace("null object");
        return null;
    }

    public static function createObject(exp:ParserTokens, ?memory:MemoryTree):MemoryObject {
        if (memory == null) memory = Interpreter.memory; // If no memory map is given, use the base one.

        switch exp {
            case SetLine(line): Runtime.line = line;
            case Module(name): Runtime.currentModule = name;
            case Expression(parts, _): {
                return createObject(evaluateExpressionParts(parts));
            }
            case Block(body, type): {
                var returnVal = runTokens(body, currentConfig.prioritizeVariableDeclarations, currentConfig.prioritizeFunctionDeclarations, currentConfig.strictTyping);
                return createObject(evaluate(returnVal));
            }
            case Number(_): return new MemoryObject(exp, null, null, Identifier(TYPE_INT));
            case Decimal(_): return new MemoryObject(exp, null, null, Identifier(TYPE_FLOAT));
            case Characters(_): return new MemoryObject(exp, null, null, Identifier(TYPE_STRING));
            case Sign(_): return new MemoryObject(exp, null, null, Identifier(TYPE_SIGN));
            case TrueValue | FalseValue: return new MemoryObject(exp, null, null, Identifier(TYPE_BOOLEAN));
            case NullValue: return new MemoryObject(exp, null, null, Identifier(TYPE_VOID));
            case Identifier(word): {
                var value = evaluate(if (memory.get(word) != null) memory.get(word).value else ErrorMessage('No Such Definition: `$word`'));
                return createObject(value);
            }
            case Read(name): {
                var word = stringifyTokenValue(name);
                var value = evaluate(if (memory.get(word) != null) memory.get(word).value else ErrorMessage('No Such Definition: `$word`'));
                return return createObject(value);
            }
            case ActionCall(name, params): {
                if (memory.get(stringifyTokenValue(name)) == null) evaluate(ErrorMessage('No Such Action:  `${stringifyTokenValue(name)}`'));
                return createObject(memory.get(stringifyTokenValue(name)).use(params));
            }
            case Define(name, type): {
                function access(object:MemoryObject, prop:ParserTokens, objName:String):MemoryObject {
                    switch prop {
                        case PropertyAccess(_, property): {
                            objName += '$PROPERTY_ACCESS_SIGN${stringifyTokenValue(prop)}';
                            // trace(object, stringifyTokenValue(prop), property);
                            if (object.props.get(stringifyTokenValue(prop)) == null) {
                                // We can already know that object.name.property is null
                                evaluate(ErrorMessage('Unable to create `$objName$PROPERTY_ACCESS_SIGN${stringifyTokenIdentifier(property)}`: `$objName` Does not contain property `${stringifyTokenIdentifier(property)}`.'));
                                return new MemoryObject(NullValue, type);
                            }
                            return access(object.props.get(stringifyTokenValue(prop)), property, objName);
                        }
                        case _: {
                            if (object.props.get(stringifyTokenIdentifier(prop)) == null) {
                                object.props.set(stringifyTokenIdentifier(prop), new MemoryObject(NullValue, type));
                            }
                            return object.props.get(stringifyTokenIdentifier(prop));
                        }
                    }
                }
                switch name {
                    case PropertyAccess(name, property): {
                        var obj = access(memory.get(stringifyTokenValue(name)), property, stringifyTokenValue(name));
                        return createObject(obj.value); // Counter intuitive, but consistency is more important
                    }
                    case _: {
                        return new MemoryObject(NullValue, type); 
                    }
                }
            }
            case Action(name, params, type): {
                function access(object:MemoryObject, prop:ParserTokens, objName:String):MemoryObject {
                    switch prop {
                        case PropertyAccess(_, property): {
                            objName += '$PROPERTY_ACCESS_SIGN${stringifyTokenValue(prop)}';
                            // trace(object, stringifyTokenValue(prop), property);
                            if (object.props.get(stringifyTokenValue(prop)) == null) {
                                // We can already know that object.name.property is null
                                evaluate(ErrorMessage('Unable to create `$objName$PROPERTY_ACCESS_SIGN${stringifyTokenIdentifier(property)}`: `$objName` Does not contain property `${stringifyTokenIdentifier(property)}`.'));
                                return new MemoryObject(NullValue, type);
                            }
                            return access(object.props.get(stringifyTokenValue(prop)), property, objName);
                        }
                        case _: {
                            if (object.props.get(stringifyTokenIdentifier(prop)) == null) {
                                object.props.set(stringifyTokenIdentifier(prop), new MemoryObject(NullValue, null, params.getParameters()[0], type));
                            }
                            return object.props.get(stringifyTokenIdentifier(prop));
                        }
                    }
                }
                switch name {
                    case PropertyAccess(name, property): {
                        var obj = access(memory.get(stringifyTokenValue(name)), property, stringifyTokenValue(name));
                        return createObject(obj.value);
                    }
                    case _: {
                        return new MemoryObject(NullValue, null, params.getParameters()[0], type); 
                    }
                }
            }
            case PropertyAccess(n, p): {
                var str = stringifyTokenValue(n);
                var prop = stringifyTokenIdentifier(p);
                // trace(n, p);
                if (memory.get(str) == null) evaluate(ErrorMessage('Unable to access property `$str$PROPERTY_ACCESS_SIGN$prop` - No Such Definition: `$str`'));
                var obj = memory.get(str);
                function access(object:MemoryObject, prop:ParserTokens, objName:String):MemoryObject {
                    switch prop {
                        case PropertyAccess(_, property): {
                            objName += '$PROPERTY_ACCESS_SIGN${stringifyTokenValue(prop)}';
                            // trace(object, stringifyTokenValue(prop), property);
                            if (object.props.get(stringifyTokenValue(prop)) == null) {
                                // We can already know that object.name.property is null
                                evaluate(ErrorMessage('Unable to access `$objName$PROPERTY_ACCESS_SIGN${stringifyTokenIdentifier(property)}`: `$objName` Does not contain property `${stringifyTokenIdentifier(property)}`.'));
                                return null;
                            }
                            return access(object.props.get(stringifyTokenValue(prop)), property, objName);
                        }
                        case ActionCall(name, params): {
                            if (object.props.get(stringifyTokenValue(name)) == null) {
                                evaluate(ErrorMessage('Unable to call `$objName$PROPERTY_ACCESS_SIGN${stringifyTokenValue(name)}(${stringifyTokenValue(params)})`: `$objName` Does not contain property `${stringifyTokenIdentifier(name)}`.'));
                                return null;
                            }
                            return new MemoryObject(object.props.get(stringifyTokenValue(name)).use(params)); // Todo: Should a new memory object actually be created here?
                        }
                        case _: {
                            if (object.props.get(stringifyTokenIdentifier(prop)) == null) {
                                object.props.set(stringifyTokenIdentifier(prop), new MemoryObject(NullValue));
                                // trace("Created new: " + objName, prop );
                            }
                            return object.props.get(stringifyTokenIdentifier(prop));
                        }
                    }
                }
                return createObject(access(obj, p, str).value); // Todo: Very questionable...
                
            }
            case Return(value, type): {
                return createObject(value);
            }
            case _: trace('Unable to create memory object from $exp. Returning null.');
        }

        // trace("null object");
        return null;
    }

    public static function stringifyTokenValue(token:ParserTokens, ?memory:MemoryTree):String {

        if (memory == null) memory = Interpreter.memory; // If no memory map is given, use the base one.

        switch token {
            case SetLine(line): return (Runtime.line = line) + "";
            case SplitLine: return token.getName();
            case Module(name): return Runtime.currentModule = name;
            case Block(body, type): return stringifyTokenValue(runTokens(body, currentConfig.prioritizeVariableDeclarations, currentConfig.prioritizeFunctionDeclarations, currentConfig.strictTyping));
            case Expression(parts, type): return stringifyTokenValue(evaluate(token));
            case Characters(string): return string;
            case Number(num): return num;
            case Decimal(num): return num;
            case TrueValue: return Keywords.TRUE_VALUE;
            case FalseValue: return Keywords.FALSE_VALUE;
            case NullValue: return Keywords.NULL_VALUE;
            case Identifier(word): return word;
            case Sign(sign): return sign;
            case Read(name): {
                var str = stringifyTokenValue(name);
                return stringifyTokenValue(if (memory.get(str) != null) memory.get(str).value else ErrorMessage('No Such Definition: `$str`'));
            }
            case ActionCall(name, params): {
                var str = stringifyTokenValue(name);
                return stringifyTokenValue(if (memory.get(str) != null) memory.get(str).use(params) else ErrorMessage('No Such Action: `$str`'));
            }
            case Write(_, value, _): {
                return stringifyTokenValue(value);
            }
            case Define(name, type): {
                memory.set(stringifyTokenValue(name), new MemoryObject(NullValue, [], null, type));
                return stringifyTokenValue(name);
            }
            case Action(name, params, type): {
                memory.set(stringifyTokenValue(name), new MemoryObject(NullValue, [], params.getParameters()[0], type));
                return stringifyTokenValue(name);
            }
            case PartArray(parts): {
                return [for (p in parts) stringifyTokenValue(evaluate(p))].join(","); 
            }
            case PropertyAccess(_, _) | Condition(_, _, _, _) | External(_) | ExternalCondition(_) | TypeDeclaration(_): {
                return stringifyTokenValue(evaluate(token, memory));
            }
            case Return(value, type): {
                return stringifyTokenValue(value);
            }
            case ErrorMessage(msg): {
                return msg;
            }
        }

        // trace(token);
        return "Something went wrong";
    }

    public static function stringifyTokenIdentifier(token:ParserTokens, ?prop = false, ?memory:MemoryTree):String {

        if (memory == null) memory = Interpreter.memory; // If no memory map is given, use the base one.

        switch token {
            case Block(body, type): return stringifyTokenIdentifier(runTokens(body, currentConfig.prioritizeVariableDeclarations, currentConfig.prioritizeFunctionDeclarations, currentConfig.strictTyping));
            case Expression(parts, type): return stringifyTokenIdentifier(evaluate(token));
            case Characters(string): return string;
            case Number(num): return num;
            case Decimal(num): return num;
            case TrueValue: return Keywords.TRUE_VALUE;
            case FalseValue: return Keywords.FALSE_VALUE;
            case NullValue: return Keywords.NULL_VALUE;
            case Identifier(word) | Module(word): return word;
            case Read(name): {
                return stringifyTokenIdentifier(name);
            }
            case ActionCall(name, params): {
                if (prop) return stringifyTokenValue(name);
                var str = stringifyTokenValue(name);
                return stringifyTokenIdentifier(if (memory.get(str) != null) memory.get(str).use(params) else ErrorMessage('No Such Action: `$str`'));
            }
            case Write(assignees, _, _): {
                return stringifyTokenIdentifier(assignees[0]);
            }
            case Define(name, type): {
                return stringifyTokenIdentifier(name);
            }
            case Action(name, params, type): {
                return stringifyTokenIdentifier(name);
            }
            case PartArray(parts): {
                return [for (p in parts) stringifyTokenValue(evaluate(p))].join(","); 
            }
            case PropertyAccess(name, property): {
                return stringifyTokenIdentifier(name);
            }
            case Condition(name, exp, body, type): {
                return stringifyTokenIdentifier(name);
            }
            case TypeDeclaration(type): {
                return stringifyTokenIdentifier(type);
            }
            case SplitLine: return ','; // Returns default line splitter.
            case Sign(sign): return sign;
            case SetLine(line): {
                Runtime.line = line;
                return "\n"; // Returns default newline.
            }
            case Return(value, type): {
                return stringifyTokenIdentifier(value);
            }
            case ErrorMessage(msg): {
                return token.getName(); // Might look goofy, but this function returns identifier names, not identifier values.
            }
            case External(_) | ExternalCondition(_): {
                Runtime.throwError(ErrorMessage('$token "does not have" a token identifier. it must be bound to one (for example, as a definiton\'s value.'), INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER);
                return "";
            }
        }
        // trace(token);
        return "Something went wrong";
    }

    public static function evaluateExpressionParts(parts:Array<ParserTokens>, ?memory:MemoryTree):ParserTokens {

        if (memory == null) memory = Interpreter.memory; // If no memory map is given, use the base one.

        parts = forceCorrectOrderOfOperations(parts);

        var value = "", valueType = TYPE_UNKNOWN, mode = "+";

        for (token in parts) {
            //trace(token);
            var val:ParserTokens = evaluate(token);
            //trace(val);
            switch val {
                case ErrorMessage(_): Runtime.throwError(val, INTERPRETER_VALUE_EVALUATOR);
                case Sign(sign): mode = sign;
                case TrueValue | FalseValue: {
                    if (valueType == TYPE_UNKNOWN) {
                        valueType = TYPE_BOOLEAN;
                        value = (val == TrueValue).string();
                    } else if (valueType == TYPE_BOOLEAN) {
                        var bool = (val == TrueValue);
                        switch mode {
                            case "&&": value = (value.parseBool() && bool).string();
                            case "||": value = (value.parseBool() || bool).string();
                            case "==": value = (value.parseBool() == bool).string();
                            case "^^" | "!=": value = (value.parseBool() != bool).string(); // xor
                            case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_BOOLEAN($bool)`');
                        }
                    } else if (valueType == TYPE_INT || valueType == TYPE_FLOAT) {
                        var num = (val == TrueValue) ? 1 : 0;
                        switch mode {
                            case "+": value = "" + (value.parseFloat() + num);
                            case "-": value = "" + (value.parseFloat() - num);
                            case "*": value = "" + (value.parseFloat() * num);
                            case "/": {
                                valueType = TYPE_FLOAT;
                                value = "" + (value.parseInt() / num);
                            }
                            case "^": value = "" + (Math.pow(value.parseInt(), num));
                            case "==" | ">=" |">" | "<" |  "<=" | "!=": {
                                valueType = TYPE_BOOLEAN;
                                value = switch mode {
                                    case "==": "" + (value == num.string());
                                    case ">=": "" + (value.parseFloat() >= num);
                                    case ">" : "" + (value.parseFloat() > num);
                                    case "<" : "" + (value.parseFloat() < num);
                                    case "<=": "" + (value.parseFloat() <= num);
                                    case "!=": "" + (value != num.string());
                                    case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_BOOLEAN($num)`'); 
                                }
                            }
                            case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_BOOLEAN(${(val == TrueValue)})`');
                        }
                    } else if (valueType == TYPE_STRING) {
                        var bool = (val == TrueValue) ? "true" : "false";
                        switch mode {
                            case "+": value += bool;
                            case "-": value = value.replaceLast(bool, "");
                            case "*": value = value.multiply(bool.parseBool() ? 1 : 0);
                            case "==" | ">=" |">" | "<" |  "<=" | "!=": {
                                valueType = TYPE_BOOLEAN;
                                value = switch mode {
                                    case "==": "" + false;
                                    case "!=": "" + true;
                                    case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_BOOLEAN($bool)`'); 
                                }
                            }
                            case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_BOOLEAN(${(val == TrueValue)})`');
                        }
                    }
                }
                case Number(num): {
                    if (valueType == TYPE_UNKNOWN) {
                        valueType = TYPE_INT;
                        switch mode {
                            case "+": value = "" + (num.parseInt());
                            case "-": value = "" + (-num.parseInt());
                            case _: return ErrorMessage('Cannot preform `$mode $TYPE_INT($num)` At the start of an expression');
                        }
                    } else if (valueType == TYPE_FLOAT || valueType == TYPE_INT || valueType == TYPE_BOOLEAN) {
                        if (valueType == TYPE_BOOLEAN) {
                            valueType = TYPE_INT;
                            // Convert true/false to 1/0
                            value = value.replace(TRUE_VALUE, "1").replace(FALSE_VALUE, "0").replace(NULL_VALUE, "0");
                        }
                        switch mode {
                            case "+": value = "" + (value.parseFloat() + num.parseInt());
                            case "-": value = "" + (value.parseFloat() - num.parseInt());
                            case "*": value = "" + (value.parseFloat() * num.parseInt());
                            case "/": {
                                valueType = TYPE_FLOAT;
                                value = "" + (value.parseInt() / num.parseInt());
                            }
                            case "^": value = "" + (Math.pow(value.parseInt(), num.parseInt()));
                            case "==" | ">=" |">" | "<" |  "<=" | "!=": {
                                valueType = TYPE_BOOLEAN;
                                value = switch mode {
                                    case "==": "" + (value == num);
                                    case ">=": "" + (value.parseFloat() >= num.parseInt());
                                    case ">" : "" + (value.parseFloat() > num.parseInt());
                                    case "<" : "" + (value.parseFloat() < num.parseInt());
                                    case "<=": "" + (value.parseFloat() <= num.parseInt());
                                    case "!=": "" + (value != num);
                                    case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_INT($num)`'); 
                                }
                            }
                            case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_INT($num)`');
                        }
                    } else if (valueType == TYPE_STRING) {
                        switch mode {
                            case "+": value += num;
                            case "-": value = value.replaceLast(num, "");
                            case "*": value = value.multiply(num.parseInt());
                            case "==" | ">=" |">" | "<" |  "<=" | "!=": {
                                valueType = TYPE_BOOLEAN;
                                value = switch mode {
                                    case "==": "" + false;
                                    case "!=": "" + true;
                                    case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_INT($num)`'); 
                                }
                            }
                            case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_INT($num)`');
                        }
                    }
                }
                case Decimal(num): {
                    if (valueType == TYPE_UNKNOWN) {
                        valueType = TYPE_FLOAT;
                        switch mode {
                            case "+": value = "" + (num.parseFloat());
                            case "-": value = "" + (-num.parseFloat());
                            case _: return ErrorMessage('Cannot preform `$mode $TYPE_FLOAT($num)` At the start of an expression');
                        }
                    } else if (valueType == TYPE_FLOAT || valueType == TYPE_INT || valueType == TYPE_BOOLEAN) {
                        if (valueType == TYPE_BOOLEAN) {
                            // Convert true/false to 1/0
                            value = value.replace(TRUE_VALUE, "1").replace(FALSE_VALUE, "0").replace(NULL_VALUE, "0");
                        }
                        valueType = TYPE_FLOAT;
                        switch mode {
                            case "+": value = "" + (value.parseFloat() + num.parseFloat());
                            case "-": value = "" + (value.parseFloat() - num.parseFloat());
                            case "*": value = "" + (value.parseFloat() * num.parseFloat());
                            case "/": value = "" + (value.parseFloat() / num.parseFloat());
                            case "^": value = "" + (Math.pow(value.parseFloat(), num.parseFloat()));
                            case "==" | ">=" |">" | "<" |  "<=" | "!=": {
                                valueType = TYPE_BOOLEAN;
                                value = switch mode {
                                    case "==": "" + (value == num);
                                    case ">=": "" + (value.parseFloat() >= num.parseFloat());
                                    case ">" : "" + (value.parseFloat() > num.parseFloat());
                                    case "<" : "" + (value.parseFloat() < num.parseFloat());
                                    case "<=": "" + (value.parseFloat() <= num.parseFloat());
                                    case "!=": "" + (value != num);
                                    case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_FLOAT($num)`'); 
                                }
                            }
                            case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_FLOAT($num)`');
                        }
                    } else if (valueType == TYPE_STRING) {
                        switch mode {
                            case "+": value += num;
                            case "-": value = value.replaceLast(num, "");
                            case "==" | ">=" | ">" | "<" | "<=" | "!=": {
                                valueType = TYPE_BOOLEAN;
                                value = switch mode {
                                    case "==": "" + false;
                                    case "!=": "" + true;
                                    case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_FLOAT($num)`'); 
                                }
                            }
                            case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_FLOAT($num)`');
                        }
                    }
                }
                case Characters(string): {
                    valueType = TYPE_STRING;
                    switch mode {
                        case "+": value += string;
                        case "-": value = value.replaceLast(string, "");
                        case "==" | ">=" |">" | "<" |  "<=" | "!=": {
                            valueType = TYPE_BOOLEAN;
                            value = switch mode {
                                case "==": "" + (value == string);
                                case ">=": "" + (value.length >= string.length);
                                case ">" : "" + (value.length > string.length);
                                case "<" : "" + (value.length < string.length);
                                case "<=": "" + (value.length <= string.length);
                                case "!=": "" + (value != string);
                                case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_STRING($string)`'); 
                            }
                        }
                        case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_STRING($string)`');
                    }
                }

                case _:
            }
        }

        switch valueType {
            case (_ == TYPE_INT => true): return Number(value);
            case (_ == TYPE_FLOAT => true): return Decimal(value);
            case (_ == TYPE_BOOLEAN => true): return value == "true" ? TrueValue : FalseValue;
            case (_ == TYPE_STRING => true): return Characters(value);
            case _: return NullValue;
        }

    }

    public static function forceCorrectOrderOfOperations(pre:Array<ParserTokens>):Array<ParserTokens> {
        
        if (pre.length == 3) return pre; // No need to reorder, nothing can be out of order

        // First, wrap ^ and √
        var post = [];
        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case Sign("^"): {
                    i++;
                    post.push(Expression([post.pop(), token, pre[i]], null));
                }
                case _: post.push(token);
            }
            i++;
        }

        // Then, * and /

        pre = post.copy();
        post = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case Sign("/") | Sign("*"): {
                    i++;
                    post.push(Expression([post.pop(), token, pre[i]], null));
                }
                case _: post.push(token);
            }
            i++;
        }

        return post;
    }
}