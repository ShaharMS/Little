package little.interpreter;

import haxe.macro.Context.Message;
import haxe.xml.Parser;
import haxe.xml.Access;
import little.tools.Layer;
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
    
    /**
        Raise an error in the program, with the given message.
        @param message The error message
        @param layer The layer of the error. see `little.tools.Layer`.
        @return the error token, as ParserTokens.ErrorMessage(msg:String)
    **/
    public static function error(message:String, layer:Layer = INTERPRETER):ParserTokens {
        Runtime.throwError(ErrorMessage(message), layer);
        return ErrorMessage(message);
    }

    /**
        Raise a warning in the program, with the given message. A warning never stops execution.
        @param message The warning message
        @param layer The layer of the warning. see `little.tools.Layer`.
        @return the warning token, as ParserTokens.ErrorMessage(msg:String)
    **/
    public static function warn(message:String, layer:Layer = INTERPRETER):ParserTokens {
        Runtime.warn(ErrorMessage(message), layer);
        return ErrorMessage(message);
    }

    /**
        Set the current line of the program
    **/
    public static function setLine(l:Int) {
        var o = Runtime.line;
        Runtime.line = l;

        for (listener in Runtime.onLineChanged) listener(o);
    }

    /**
        Set the current module
    **/
    public static function setModule(name:String) {
        var o = Runtime.currentModule;
        Runtime.currentModule = name;

        // Listeners
    }

    /**
        Split the current line. In other words, create a new line, but keep the old line number.
    **/
    public static function splitLine() {
        // Listeners
    }

    /**
        Declare a new variable. That variable will be added to the current working memory. Switch the working memory using `scwm`
        @param name The name of the variable. Can be any token stringifiyable via `token.value()`.
        @param type The type of the variable. Can be any token stringifiyable via `token.value()`.
        @param doc The documentation of the variable. Should be a `ParserTokens.Documentation(doc:String)`
    **/
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
                } else memory.set(name.value(), new MemoryObject(NullValue, type != null ? evaluate(type) : NullValue, memory.object, doc.value())); 
            }
        }
        
        // Listeners

        return read(name);
    }

    /**
        Declare a new function. That function will be added to the current working memory. Switch the working memory using `scwm`
        @param name The name of the function. Can be any token stringifiyable via `token.value()`.
        @param params The parameters of the function. Should be a `ParserTokens.PartArray(parts:Array<ParserTokens>)`
        @param type The type of the function. Can be any token stringifiyable via `token.value()`.
        @param doc The documentation of the function. Should be a `ParserTokens.Documentation(doc:String)`
    **/
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
                } else memory.set(name.value(), new MemoryObject(NullValue, null, params.getParameters()[0], type != null ? evaluate(type) : NullValue, memory.object, doc.value())); 
            }
        }

        // Listeners

        return read(name);
    }

	/**
		Calls a condition. The condition's `body` is repeated `0` to `n` times, depending on the condition's `conditionParams`.
		@param name The name of the condition. Can be any token stringifiyable via `token.value()`.
		@param conditionParams The parameters of the condition. Should be either a `ParserTokens.PartArray(parts:Array<ParserTokens>)`. **Note** - any `ParserToken` with a single, `Array<ParserToken>` parameter should work too (`Expression`, `Block`)
		@param body The body of the condition. Should be a `Block(body:Array<ParserTokens>, type:ParserTokens);`
	**/
    public static function condition(name:ParserTokens, conditionParams:ParserTokens, body:ParserTokens):ParserTokens {
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

    /**
		Assign a value to multiple variables/functions/types.
    	@param assignees The variables/functions/types to assign to. Should be a `ParserTokens.Variable(name:ParserTokens, type:ParserTokens, doc:ParserTokens)` or `ParserTokens.Function(name:ParserTokens, params:ParserTokens, type:ParserTokens, doc:ParserTokens)`
    	@param value The value to assign. Can be any token which has a non-void value (not `ParserTokens.SplitLine`, `ParserTokens.SetLine(line:Int)`...)
    	@return The value given, evaluated using `Actions.evaluate(value)`
    **/
    public static function write(assignees:Array<ParserTokens>, value:ParserTokens):ParserTokens {
        var v = evaluate(value);
        for (a in assignees) {
            var assignee = Interpreter.accessObject(a, memory);
            if (assignee == null) continue;
            if (assignee.params != null)
                assignee.value = value;
            else {
                trace(value, v, Interpreter.getValueType(v));
                if (v.getName() != "ErrorMessage") {
                    assignee.value = v;
                    trace(assignee.value, assignee.type);
                }
            }
        }

        // Listeners

        return v;
    }

	/**
		Calls a function and returns the result using `params`.
		@param name The name of the function. Can be any token stringifiyable via `token.value()`.
		@param params The parameters of the function. Should be a `ParserTokens.PartArray(parts:Array<ParserTokens>)`
	**/
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

	/**
		Reads the value of a variable/function. When reading a function, the body is returned as a `ParserTokens.Block(body:Array<ParserTokens>, type:ParserTokens)`.
		@param name The name of the variable/function. Should be one of `ParserTokens.Identifier(name:String)`, `ParserTokens.Read(name:String)` or `ParserTokens.PropertyAccess(name:ParserTokens, property:ParserTokens)`
		@return The value of the variable/function
	**/
    public static function read(name:ParserTokens):ParserTokens {
		if (name.getName() == "PropertyAccess") {
			return evaluate(name);
		}
        var word = name.identifier();
        return evaluate(if (memory.get(word) != null) memory.get(word).value else ErrorMessage('No Such Variable: `$word`'));
    }

	/**
		Casts a value to a type
		@param value The value to cast. Can be any token which has a non-void value (not `ParserTokens.SplitLine`, `ParserTokens.SetLine(line:Int)`...)
		@param type The type to cast to. Can be any token which resolves to `ParserTokens.Module(name:String)`
		@return The value given, casted to the type.
	**/
    public static function type(value:ParserTokens, type:ParserTokens):ParserTokens {
        var val = evaluate(value);
        var valT = Interpreter.getValueType(val);
        var t = evaluate(type);

        if (t.equals(valT)) {
            return val;
        } else {
            warn('Mismatch at type declaration: the value $value has been declared as being of type $t, while its type is $valT. This might cause issues.', INTERPRETER_VALUE_EVALUATOR);
            return val;
        }
    }

	/**
		Runs the tokens and returns the result
		@param body The tokens to run
		@return The result of the tokens
	**/
    public static function run(body:Array<ParserTokens>):ParserTokens {
        var returnVal:ParserTokens = null;

        var i = 0;
        while (i < body.length) {
            var token = body[i];
            if (token == null) {i++; continue;}
            switch token {
                case SetLine(line): {
                    setLine(line);
                }
                case Module(name): {
                    setModule(name);
                }
                case SplitLine: splitLine();
                case Variable(name, type, doc): {
                    declareVariable(name, type, doc);
                    returnVal = NullValue;
                }
                case Function(name, params, type, doc): {
                    declareFunction(name, params, type, doc);
                    returnVal = NullValue;
                }
                case Condition(name, exp, body): {
                    returnVal = condition(name, exp, body);
                }
                case Write(assignees, value): {
                    returnVal = write(assignees, value);
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

    /**
    	A combination of `Actions.run` and `Actions.calculate`, which operates on a single `ParserTokens` token
    	@param exp the token to evaluate
    	@param dontThrow if `true`, `Runtime.throwError` is not called when an error occurs
    	@return the result of the evaluation
    **/
    public static function evaluate(exp:ParserTokens, ?dontThrow:Bool = false):ParserTokens {

        if (memory == null) memory = Interpreter.memory; // If no memory map is given, use the base one.

        if (exp == null) {
            // trace("null token");
            return NullValue;
        }

        switch exp {
            case Number(_) | Decimal(_) | Characters(_) | TrueValue | FalseValue | NullValue | Sign(_) | Module(_): return exp;
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
            case Expression(parts, _): {
                return calculate(parts);
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
            case Write(assignees, value): return write(assignees, value);
            case Read(name): return read(name);
            case FunctionCall(name, params): return call(name, params);
            case Condition(name, exp, body): return condition(name, exp, body);
            case Variable(name, type, doc): return declareVariable(name, type, doc);
            case Function(name, params, type, doc): return declareFunction(name, params, type, doc);
            case External(_): return Characters("External Function/Variable");
            case PropertyAccess(_, _): {
                var o = Interpreter.accessObject(exp, memory);
                if (o != null) return o.value;
                return NullValue;
            }
            case Return(value, t): return evaluate(type(value, t));
            case _: return evaluate(ErrorMessage('Unable to evaluate token `$exp`'), dontThrow);
        }
    }

	/**
		Calculates the result of a given expression. An "alternative" to `Actions.run()`, 
		but instead of having code running and memory writing capabilities, it's capable of 
		calculating complex equations of different types. example:

		| Function | Input | Result | Process |
		|:---: | :--- | --- | --- |
		| 				  		| `1 + 1` 			| `1` 		| picks up the last token. |
		| `Actions.run()` 		| `(2 + 2)` 		| `4` 		| picks up the last token. its an expression, so it's evaluated |
		|						| `3 + (5 * 2)!` 	| `!` 		| picks up the last token. |
		| --------------------- | ----------------- | --------- | -------------------------------------------------------------- |
		|  						| `1 + 1` 			| `2` 		| evaluates all tokens and calculates the relations between them |
		| `Actions.calculate()` | `(2 + 2)` 		| `4` 		| evaluates all tokens and calculates the relations between them |
		| 						| `3 + (5 * 2)!` 	| `3628803` | evaluates all tokens and calculates the relations between them |
		@param parts The parts of the expression
		@return The result of the expression
	**/
    public static function calculate(parts:Array<ParserTokens>):ParserTokens {
        
		

        return null;

    }

	public static function group(tokens:Array<ParserTokens>) {
		var post = [];
		var pre = tokens;

		for (operatorGroup in Little.operators.iterateByPriority()) {
			// We'll group everything by only recognizing specific signs each "stage" - 
			// The signs recognized first will be of the highest priority.
			// One drawback of this system is that its a little messier to detect chaining (e.g. 5!!, √√√64)

			var i = 0;
			while (i < pre.length) {
				var token = pre[i].is(READ, IDENTIFIER) ? evaluate(pre[i]) : pre[i];

				
			}
		}

		return null;
	}
}