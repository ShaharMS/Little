package little.interpreter;

import little.tools.Layer;
import little.parser.Tokens.ParserTokens;
import little.Keywords.*;

using StringTools;
using Std;
using Math;
using little.tools.TextTools;
@:access(little.interpreter.Runtime)
class Interpreter {
    
    public static var errorThrown = false;

    public static var memory:Map<String, MemoryObject>;

    public static var currentConfig:RunConfig;

    public static function interpret(tokens:Array<ParserTokens>, runConfig:RunConfig) {
        trace(tokens);
        currentConfig = runConfig;
        if (tokens[0].getName() != "Module") {
            tokens.unshift(Module(runConfig.defaultModuleName));
        }
        return runTokens(tokens, runConfig.prioritizeVariableDeclarations, runConfig.prioritizeFunctionDeclarations, runConfig.strictTyping);
    }

    public static function runTokens(tokens:Array<ParserTokens>, preParseVars:Bool, preParseFuncs:Bool, strict:Bool):ParserTokens {
        // Todo: support preParseVars
        // Todo: support preParseFuncs
        // Todo: support strict typing

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
                    var str = stringifyTokenValue(name);
                    memory[str] = new MemoryObject(NullValue, type);
                    returnVal = memory[str].value;
                }
                case Action(name, params, type): {
                    var str = stringifyTokenValue(name);
                    memory[str] = new MemoryObject(NullValue, [], params.getParameters()[0], type);
                    returnVal = memory[str].value;
                }
                case Condition(name, exp, body, type): // Unimplemented for now
                case Write(assignees, value, type): {
                    var v = evaluate(value);
                    for (a in assignees) {
                        var assignee = accessObject(a);
                        if (assignee == null) continue;
                        if (assignee.params != null)
                            assignee.value = value;
                        else {
                            if (v.getName() == "ErrorMessage") {
                                Runtime.throwError(v, INTERPRETER);
                                assignee.value = NullValue;
                            } else {
                                assignee.value = v;
                            }
                        }
                    }
                    returnVal = value;
                }
                case ActionCall(name, params): {
                    if (memory[stringifyTokenValue(name)] == null) ErrorMessage('No Such Action:  `${stringifyTokenValue(name)}`');
                    returnVal = memory[stringifyTokenValue(name)].useFunction(params);
                }
                case Return(value, type): {
                    return evaluate(value);
                }
                case Block(body, type): {
                    trace(body);
                    returnVal = runTokens(body, preParseVars, preParseFuncs, strict);
                }
                case PropertyAccess(name, property): {
                    returnVal = evaluate(token);
                }
                case _: returnVal = evaluate(token);
            }
            i++;
        }
        return returnVal;
    }

    public static function evaluate(exp:ParserTokens):ParserTokens {
        if (exp == null) {
            trace("null token");
            return NullValue;
        }
        if (exp.getName() == "ErrorMessage") {
            Runtime.throwError(exp, INTERPRETER_VALUE_EVALUATOR);
            return exp;
        }

        switch exp {
            case SetLine(line): Runtime.line = line;
            case Module(name): Runtime.currentModule = name;
            case Expression(parts, _): {
                return evaluateExpressionParts(parts);
            }
            case Block(body, type): {
                var returnVal = runTokens(body, currentConfig.prioritizeVariableDeclarations, currentConfig.prioritizeFunctionDeclarations, currentConfig.strictTyping);
                return evaluate(returnVal);
            }
            case PartArray(parts): {
                return PartArray([for (p in parts) evaluate(p)]);
            }
            case Number(_) | Decimal(_) | Characters(_) | TrueValue | FalseValue | NullValue | Sign(_): return exp;
            case Identifier(word): {
                return evaluate(if (memory[word] != null) memory[word].value else ErrorMessage('No Such Definition: `$word`'));
            }
            case Write(_, value, _): return evaluate(value);
            case Read(name): {
                var str = stringifyTokenValue(name);
                return evaluate(if (memory[str] != null) memory[str].value else ErrorMessage('No Such Definition: `$str`'));
            }
            case ActionCall(name, params): {
                if (memory[stringifyTokenValue(name)] == null) return ErrorMessage('No Such Action:  `${stringifyTokenValue(name)}`');
                return evaluate(memory[stringifyTokenValue(name)].useFunction(params));
            }
            case Define(name, type): {
                var str = stringifyTokenValue(name);
                memory[str] = new MemoryObject(NullValue, type);
                return name;
            }
            case Action(name, params, type): {
                var str = stringifyTokenValue(name);
                memory[str] = new MemoryObject(NullValue, [], params.getParameters()[0], type);
                return name;
            }
            case External(get): return evaluate(get([]));
            case PropertyAccess(name, property): {
                var str = stringifyTokenValue(name);
                var prop = stringifyTokenIdentifier(property);
                if (memory[str] == null) return ErrorMessage('Unable to access property `$str$PROPERTY_ACCESS_SIGN$prop` - No Such Definition: `$str`');
                var obj = memory[str];
                function access(object:MemoryObject, prop:ParserTokens, objName:String):ParserTokens {
                    switch property {
                        case PropertyAccess(name, property): {
                            objName = objName + '$PROPERTY_ACCESS_SIGN${stringifyTokenValue(name)}';
                            if (object.props[stringifyTokenIdentifier(name)] == null) {
                                // We can already know that object.name.property is null
                                return ErrorMessage('Unable to access `$objName$PROPERTY_ACCESS_SIGN${stringifyTokenIdentifier(property)}`: `$objName` Does not contain property `${stringifyTokenIdentifier(property)}`.');
                            }
                            return access(object.props[stringifyTokenValue(name)], property, objName);
                        }
                        case ActionCall(name, params): {
                            if (object.props[stringifyTokenValue(name)] == null) {
                                return ErrorMessage('Unable to call `$objName$PROPERTY_ACCESS_SIGN${stringifyTokenValue(name)}(${stringifyTokenValue(params)})`: `$objName` Does not contain property `${stringifyTokenIdentifier(name)}`.');
                            }
                            return object.props[stringifyTokenValue(name)].useFunction(params);
                        }
                        case _: {
                            if (object.props[stringifyTokenValue(prop)] == null) {
                                object.props[stringifyTokenValue(prop)] = new MemoryObject(NullValue);
                            }
                            return object.props[stringifyTokenValue(prop)].value;
                        }
                    }
                }
                return access(obj, property, str);
                
            }
            case _:
        }

        

        return ErrorMessage('Unable to evaluate token `$exp`');
    }

    public static function accessObject(exp:ParserTokens):MemoryObject {
        
        switch exp {
            case Expression(parts, _): {
                return accessObject(evaluateExpressionParts(parts));
            }
            case Block(body, type): {
                var returnVal = runTokens(body, currentConfig.prioritizeVariableDeclarations, currentConfig.prioritizeFunctionDeclarations, currentConfig.strictTyping);
                return accessObject(evaluate(returnVal));
            }
            case Number(_) | Decimal(_) | Characters(_) | TrueValue | FalseValue | NullValue | Sign(_): return memory[stringifyTokenValue(exp)];
            case Identifier(word): {
                evaluate(if (memory[word] != null) memory[word].value else ErrorMessage('No Such Definition: `$word`'));
                return memory[word];
            }
            case Read(name): {
                var word = stringifyTokenValue(name);
                evaluate(if (memory[word] != null) memory[word].value else ErrorMessage('No Such Definition: `$word`'));
                return memory[word];
            }
            case ActionCall(name, params): {
                if (memory[stringifyTokenValue(name)] == null) evaluate(ErrorMessage('No Such Action:  `${stringifyTokenValue(name)}`'));
                return accessObject(memory[stringifyTokenValue(name)].useFunction(params));
            }
            case Define(name, type): {
                var str = stringifyTokenValue(name);
                memory[str] = new MemoryObject(NullValue, type);
                return memory[str];
            }
            case Action(name, params, type): {
                var str = stringifyTokenValue(name);
                memory[str] = new MemoryObject(NullValue, [], params.getParameters()[0], type);
                return memory[str];
            }
            case PropertyAccess(name, property): {
                var str = stringifyTokenValue(name);
                var prop = stringifyTokenIdentifier(property);
                if (memory[str] == null) evaluate(ErrorMessage('Unable to access property `$str$PROPERTY_ACCESS_SIGN$prop` - No Such Definition: `$str`'));
                var obj = memory[str];
                function access(object:MemoryObject, prop:ParserTokens, objName:String):MemoryObject {
                    switch property {
                        case PropertyAccess(name, property): {
                            objName += '$PROPERTY_ACCESS_SIGN${stringifyTokenValue(name)}';
                            trace(object, name, property);
                            if (object.props[stringifyTokenIdentifier(name)] == null) {
                                // We can already know that object.name.property is null
                                evaluate(ErrorMessage('Unable to access `$objName$PROPERTY_ACCESS_SIGN${stringifyTokenIdentifier(property)}`: `$objName` Does not contain property `${stringifyTokenIdentifier(property)}`.'));
                                return null;
                            }
                            return access(object.props[stringifyTokenValue(name)], property, objName);
                        }
                        case ActionCall(name, params): {
                            if (object.props[stringifyTokenValue(name)] == null) {
                                evaluate(ErrorMessage('Unable to call `$objName$PROPERTY_ACCESS_SIGN${stringifyTokenValue(name)}(${stringifyTokenValue(params)})`: `$objName` Does not contain property `${stringifyTokenIdentifier(name)}`.'));
                                return null;
                            }
                            return accessObject(object.props[stringifyTokenValue(name)].useFunction(params));
                        }
                        case _: {
                            if (object.props[stringifyTokenValue(prop)] == null) {
                                object.props[stringifyTokenValue(prop)] = new MemoryObject(NullValue);
                            }
                            return object.props[stringifyTokenValue(prop)];
                        }
                    }
                }
                return access(obj, property, str);
                
            }
            case _:
        }

        trace("null object");
        return null;
    }

    public static function stringifyTokenValue(token:ParserTokens):String {

        if (token.getName() == "ErrorMessage") Runtime.throwError(token, INTERPRETER_TOKEN_VALUE_STRINGIFIER);

        switch token {
            case Block(body, type): return stringifyTokenValue(runTokens(body, currentConfig.prioritizeVariableDeclarations, currentConfig.prioritizeFunctionDeclarations, currentConfig.strictTyping));
            case Expression(parts, type): return stringifyTokenValue(evaluate(token));
            case Characters(string): return string;
            case Number(num): return num;
            case Decimal(num): return num;
            case TrueValue: return Keywords.TRUE_VALUE;
            case FalseValue: return Keywords.FALSE_VALUE;
            case NullValue: return Keywords.NULL_VALUE;
            case Identifier(word) | Module(word): return word;
            case Read(name): {
                var str = stringifyTokenValue(name);
                return stringifyTokenValue(if (memory[str] != null) memory[str].value else ErrorMessage('No Such Definition: `$str`'));
            }
            case ActionCall(name, params): {
                var str = stringifyTokenValue(name);
                return stringifyTokenValue(if (memory[str] != null) memory[str].useFunction(params) else ErrorMessage('No Such Action: `$str`'));
            }
            case Write(_, value, _): {
                return stringifyTokenValue(value);
            }
            case Define(name, type): {
                memory[stringifyTokenValue(name)] = new MemoryObject(NullValue, [], null, type);
                return stringifyTokenValue(name);
            }
            case Action(name, params, type): {
                memory[stringifyTokenValue(name)] = new MemoryObject(NullValue, [], params.getParameters()[0], type);
                return stringifyTokenValue(name);
            }
            case PartArray(parts): {
                return [for (p in parts) stringifyTokenValue(evaluate(p))].join(","); 
            }
            case PropertyAccess(name, property): {
                return stringifyTokenValue(name);
            }
            case _:
        }
        trace(token);
        return "Something went wrong";
    }

    public static function stringifyTokenIdentifier(token:ParserTokens, prop = false):String {
        if (token.getName() == "ErrorMessage") Runtime.throwError(token, INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER);

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
                return stringifyTokenIdentifier(if (memory[str] != null) memory[str].useFunction(params) else ErrorMessage('No Such Action: `$str`'));
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
            case _:
        }
        trace(token);
        return "Something went wrong";
    }

    public static function evaluateExpressionParts(parts:Array<ParserTokens>):ParserTokens {

        parts = forceCorrectOrderOfOperations(parts);

        var value = "", valueType = TYPE_UNKNOWN, mode = "+";

        for (token in parts) {
            trace(token);
            var val:ParserTokens = evaluate(token);
            trace(val);
            switch val {
                case ErrorMessage(_): Runtime.throwError(val, Layer.INTERPRETER_VALUE_EVALUATOR);
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
                            case "+": value = "" + (value.parseInt() + num);
                            case "-": value = "" + (value.parseInt() - num);
                            case "*": value = "" + (value.parseInt() * num);
                            case "/": {
                                valueType = TYPE_FLOAT;
                                value = "" + (value.parseInt() / num);
                            }
                            case "^": value = "" + (Math.pow(value.parseInt(), num));
                            case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_BOOLEAN(${(val == TrueValue)})`');
                        }
                    } else if (valueType == TYPE_STRING) {
                        var bool = (val == TrueValue) ? "true" : "false";
                        switch mode {
                            case "+": value += bool;
                            case "-": value = value.replaceLast(bool, "");
                            case "*": value = value.multiply(bool.parseBool() ? 1 : 0);
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
                            case "+": value = "" + (value.parseInt() + num.parseInt());
                            case "-": value = "" + (value.parseInt() - num.parseInt());
                            case "*": value = "" + (value.parseInt() * num.parseInt());
                            case "/": {
                                valueType = TYPE_FLOAT;
                                value = "" + (value.parseInt() / num.parseInt());
                            }
                            case "^": value = "" + (Math.pow(value.parseInt(), num.parseInt()));
                            case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_INT($num)`');
                        }
                    } else if (valueType == TYPE_STRING) {
                        switch mode {
                            case "+": value += num;
                            case "-": value = value.replaceLast(num, "");
                            case "*": value = value.multiply(num.parseInt());
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
                            case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_FLOAT($num)`');
                        }
                    } else if (valueType == TYPE_STRING) {
                        switch mode {
                            case "+": value += num;
                            case "-": value = value.replaceLast(num, "");
                            case _: return ErrorMessage('Cannot preform `$valueType($value) $mode $TYPE_FLOAT($num)`');
                        }
                    }
                }
                case Characters(string): {
                    valueType = TYPE_STRING;
                    switch mode {
                        case "+": value += string;
                        case "-": value = value.replaceLast(string, "");
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
                case Sign("√") | Sign("^"): {
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