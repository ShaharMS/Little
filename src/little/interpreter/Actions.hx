package little.interpreter;

import haxe.macro.Context.Message;
import haxe.xml.Parser;
import haxe.xml.Access;
import little.tools.Layer;
import little.interpreter.Interpreter.*;
import little.Keywords.*;
import little.interpreter.memory.*;
import little.interpreter.Runtime;
import little.parser.Tokens.ParserTokens;

using StringTools;
using little.tools.Extensions;
using little.tools.TextTools;

@:access(little.interpreter.Runtime)
@:access(little.interpreter.Interpreter)
class Actions {
    
    public static var memory:MemoryTree = Interpreter.memory;

    /**
    	Switch Current Working Memory
    **/
    public static function scwm(memory:MemoryTree) {
        Actions.memory = memory;
    }
    
    public static function error(message:String, layer:Layer = INTERPRETER):ParserTokens {
        Runtime.throwError(ErrorMessage(message), layer);
        return ErrorMessage(message);
    }

    public static function warn(message:String, layer:Layer = INTERPRETER):ParserTokens {
        Runtime.warn(ErrorMessage(message), layer);
        return ErrorMessage(message);
    }

    public static function setLine(l:Int) {
        var o = Runtime.line;
        Runtime.line = l;

        for (listener in Runtime.onLineChanged) listener(o);
    }

    public static function setModule(name:String) {
        var o = Runtime.currentModule;
        Runtime.currentModule = name;

        // Listeners
    }

    public static function splitLine() {
        // Listeners
    }

    public static function declareVariable(name:ParserTokens, type:ParserTokens, doc:ParserTokens) {
        function access(onObject:MemoryObject, prop:ParserTokens, objName:String):MemoryObject {
            switch prop {
                case PropertyAccess(_, property): {
                    objName += '$PROPERTY_ACCESS_SIGN${prop.value()}';
                    // trace(object, prop.value(), property);
                    if (onObject.get(prop.value()) == null) {
                        // We can already know that object.name.property is null
                        error('Unable to create `$objName$PROPERTY_ACCESS_SIGN${property.identifier()}`: `$objName` Does not contain property `${property.identifier()}`.');
                        return null;
                    }
                    return access(onObject.get(prop.value()), property, objName);
                }
                case _: {
                    if (onObject.get(prop.identifier()) == null) {
                        onObject.set(prop.identifier(), new MemoryObject(NullValue, type, onObject, doc.value()));
                    }
                    return onObject.get(prop.identifier());
                }
            }
        }
        switch name {
            case PropertyAccess(name, property): {
                access(memory.get(name.value()), property, name.value());
            }
            case _: {
                if (memory.exists(name.value())) {
                    warn('Variable ${name.value()} already exists. New declaration ignored.');
                } else memory.set(name.value(), new MemoryObject(NullValue, type != null ? type : NullValue, memory.object, doc.value())); 
            }
        }
        
        // Listeners

        return read(name);
    }

    public static function declareFunction(name:ParserTokens, params:ParserTokens, type:ParserTokens, doc:ParserTokens) {
        function access(object:MemoryObject, prop:ParserTokens, objName:String):MemoryObject {
            switch prop {
                case PropertyAccess(_, nestedProperty): {
                    objName += '$PROPERTY_ACCESS_SIGN${prop.value()}';
                    // trace(object, prop.value(), property);
                    if (object.get(prop.value()) == null) {
                        // We can already know that object.name.property is null
                        error('Unable to create `$objName$PROPERTY_ACCESS_SIGN${nestedProperty.identifier()}`: `$objName` Does not contain property `${nestedProperty.identifier()}`.');
                        return null;
                    }
                    return access(object.get(prop.value()), nestedProperty, objName);
                }
                case _: {
                    if (object.get(prop.identifier()) == null) {
                        object.set(prop.identifier(), new MemoryObject(NullValue, null, params.getParameters()[0], type != null ? type : NullValue, object, doc.value()));
                    }
                    return object.get(prop.identifier());
                }
            }
        }
        switch name {
            case PropertyAccess(name, property): {
                access(memory.get(name.value()), property, name.value());
            }
            case _: {
                
                if (memory.exists(name.value())) {
                    warn('Function ${name.value()} already exists. New declaration ignored.');
                } else memory.set(name.value(), new MemoryObject(NullValue, null, params.getParameters()[0], type, memory.object, doc.value())); 
            }
        }

        // Listeners

        return read(name);
    }

    public static function condition(name:ParserTokens, conditionParams:ParserTokens, body:ParserTokens, ?type:ParserTokens):ParserTokens {
        if (memory.get(name.value()) == null) {
            return error('No Such Condition:  `${name.value()}`');
        } 
        else {
			trace(name.value(), memory.get(name.value()));
            var o = memory.get(name.value()).use(PartArray([conditionParams, body]));
			trace(o);
			if (o.equals(NullValue)) return o;
            if (o.getName() == "ErrorMessage") return error(o.value());
            return o;
        }

        // Listeners

    }

    public static function write(assignees:Array<ParserTokens>, value:ParserTokens, ?type:ParserTokens):ParserTokens {
        var v = evaluate(value);
        for (a in assignees) {
            var assignee = accessObject(a, memory);
            if (assignee == null) continue;
            if (assignee.params != null)
                assignee.value = value;
            else {
                trace(value, v, getValueType(v));
                if (v.getName() != "ErrorMessage") {
                    assignee.value = v;
                    trace(assignee.value, assignee.type);
                }
            }
        }

        // Listeners

        return v != null ? v : value;
    }

    public static function call(name:ParserTokens, params:ParserTokens):ParserTokens {
		trace(params);
        if (memory.get(name.value()) == null) {
            return error('No Such Function: `${name.value()}`');
        } 
        else {
            var o = memory.get(name.value()).use(params);
            if (o.getName() == "ErrorMessage") return error(o.value());
            return o;
        }
    }

    public static function read(name:ParserTokens):ParserTokens {
        var word = name.identifier();
        return evaluate(if (memory.get(word) != null) memory.get(word).value else ErrorMessage('No Such Variable: `$word`'));
    }

    public static function type(value:ParserTokens, type:ParserTokens):ParserTokens {
        var val = evaluate(value);
        var valT = getValueType(val);
        var t = evaluate(type);

        if (t.equals(valT)) {
            return val;
        } else {
            warn('Mismatch at type declaration: the value $value has been declared as being of type $t, while its type is $valT. This might cause issues.', INTERPRETER_VALUE_EVALUATOR);
            return val;
        }
    }

    public static function run(body:Array<ParserTokens>):ParserTokens {
        var returnVal:ParserTokens = null;

        var i = 0;
        while (i < body.length) {
            var token = body[i];
            if (token == null) {i++; continue;}
            switch token {
                case SetLine(line): Runtime.line = line;
                case Module(name): Runtime.currentModule = name;
                case SplitLine:
                case Variable(name, type, doc): {
                    declareVariable(name, type, doc);
                    returnVal = NullValue;
                }
                case Function(name, params, type, doc): {
                    declareFunction(name, params, type, doc);
                    returnVal = NullValue;
                }
                case Condition(name, exp, body, type): {
                    returnVal = condition(name, exp, body, type);
                }
                case Write(assignees, value, type): {
                    returnVal = write(assignees, value, type);
                }
                case FunctionCall(name, params): {
                    returnVal = call(name, params);
                }
                case Return(value, type): {
                    return evaluate(value);
                }
                case Block(body, type): {
                    returnVal = run(body);
                }
                case PropertyAccess(name, property): {
                    returnVal = evaluate(token);
                }
                case Read(name): {
                    returnVal =  read(name);
                }
                case _: returnVal = evaluate(token);
            }
            i++;
        }
        return returnVal;
    }

    public static function evaluate(exp:ParserTokens, ?dontThrow:Bool = false):ParserTokens {

        if (memory == null) memory = Interpreter.memory; // If no memory map is given, use the base one.

        if (exp == null) {
            // trace("null token");
            return NullValue;
        }

        switch exp {
            case Number(_) | Decimal(_) | Characters(_) | TrueValue | FalseValue | NullValue | Sign(_): return exp;
            case ErrorMessage(msg): {
                if (!dontThrow) Runtime.throwError(exp, INTERPRETER_VALUE_EVALUATOR);
                return exp;
            }
            case SetLine(line): {
                setLine(line);
                return NullValue;
            }
            case SplitLine: {
                splitLine();
                return NullValue;
            }
            case Module(name): {
                setModule(name);
                return NullValue;
            }
            case Expression(parts, _): {
                return evaluateExpressionParts(parts);
            }
            case Block(body, t): {
                var returnVal = run(body);
                if (t == null) return evaluate(returnVal, dontThrow);
				return evaluate(type(returnVal, t), dontThrow);
            }
            case PartArray(parts): {
                return PartArray([for (p in parts) evaluate(p, dontThrow)]);
            }
            case Identifier(word): {
                return evaluate(if (memory.get(word) != null) memory.get(word).value else ErrorMessage('No Such Variable: `$word`'), dontThrow);
            }
            case TypeDeclaration(value, t): return type(value, t);
            case Write(assignees, value, type): return write(assignees, value, type);
            case Read(name): return read(name);
            case FunctionCall(name, params): return call(name, params);
            case Condition(name, exp, body, type): return condition(name, exp, body, type);
            case Variable(name, type, doc): return declareVariable(name, type, doc);
            case Function(name, params, type, doc): return declareFunction(name, params, type, doc);
            case External(_): return Characters("External Function/Variable");
            case PropertyAccess(_, _): {
                var o = accessObject(exp, memory);
                if (o != null) return o.value;
                return NullValue;
            }
            case Return(value, t): return evaluate(type(value, t));
            case _: return evaluate(ErrorMessage('Unable to evaluate token `$exp`'), dontThrow);
        }
    }

    public static function calculate(parts:Array<ParserTokens>):ParserTokens {
        
		// First - force correct order of operations
        return null;

    }
}