package little.interpreter;

import little.tools.PrettyPrinter;
import haxe.macro.Context.Message;
import haxe.xml.Parser;
import haxe.xml.Access;
import little.tools.Layer;
import little.interpreter.memory.*;
import little.interpreter.Runtime;
import little.parser.Tokens.ParserTokens;

using StringTools;
using little.tools.Extensions;
using little.tools.TextTools;

@:access(little.interpreter.Runtime)
@:access(little.interpreter.Interpreter)
class Actions {
    

	static var memory:Memory = Runtime.memory;

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
        trace(Runtime.stdout.output);
        throw "";
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
                    objName += '${Little.keywords.PROPERTY_ACCESS_SIGN}${prop.value()}';
                    // trace(object, prop.value(), property);
                    if (onObject.get(prop.value()) == null) {
                        // We can already know that object.name.property is null
                        error('Unable to create `$objName${Little.keywords.PROPERTY_ACCESS_SIGN}${property.identifier()}`: `$objName` Does not contain property `${property.identifier()}`.');
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
                    objName += '${Little.keywords.PROPERTY_ACCESS_SIGN}${prop.value()}';
                    // trace(object, prop.value(), property);
                    if (object.get(prop.value()) == null) {
                        // We can already know that object.name.property is null
                        error('Unable to create `$objName${Little.keywords.PROPERTY_ACCESS_SIGN}${nestedProperty.identifier()}`: `$objName` Does not contain property `${nestedProperty.identifier()}`.');
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
            var o = memory.get(name.value()).use(PartArray([conditionParams, body]));
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
        var v = null;
        if (assignees.containsAny(x -> x.is(FUNCTION))) v = value;
        else v = evaluate(value);
        for (a in assignees) {
            var assignee = Interpreter.accessObject(a, memory);
            if (assignee == null) continue;
            if (assignee.parameters != null)
                assignee.value = value;
            else {
                if (v.getName() != "ErrorMessage") {
                    assignee.value = v;
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

        if (!t.is(MODULE) || !valT.is(MODULE)) {
            trace(val, valT, t);
        }
        if (t.equals(valT)) {
            return val;
        } else {
            var castFunc = Interpreter.accessObject(value).get(Little.keywords.TYPE_CAST_FUNCTION_PREFIX + t.value());
            if (castFunc == null) {
                warn('Mismatch at type declaration: the value $value has been declared as being of type $t, while its type is $valT. This might cause issues.', INTERPRETER_VALUE_EVALUATOR);
                return val;
            }
            return castFunc.use(PartArray([]));
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
					var currentLine = Runtime.line;
                    returnVal = call(name, params);
					setLine(currentLine);
                }
                case Return(value, type): {
                    return evaluate(value);
                }
                case Block(body, type): {
					var currentLine = Runtime.line;
                    returnVal = run(body);
					setLine(currentLine);
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
            case Expression(parts, t): {
                if (t != null) return type(calculate(parts), t);
                return calculate(parts);
            }
            case Block(body, t): {
				var currentLine = Runtime.line;
                var returnVal = run(body);
				setLine(currentLine);
                if (t == null) return evaluate(returnVal, dontThrow);
				return evaluate(type(returnVal, t), dontThrow);
            }
            case FunctionCall(name, params): {
				var currentLine = Runtime.line;
				return call(name, params);
				setLine(currentLine);
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
    public static function calculate(p:Array<ParserTokens>):ParserTokens {

        while (p.length == 1 && p[0].parameter(0) is Array) p = p[0].parameter(0);

		var tokens = group(p);
        var castType:ParserTokens = null;

        if (tokens.length == 1) {
            if (tokens[0].is(PART_ARRAY)) tokens = tokens[0].parameter(0);
            else if (tokens[0].is(EXPRESSION)) {
                tokens = tokens[0].parameter(0);
                castType = tokens[0].parameter(1);
            }
        }

        var calculated:ParserTokens = null;
        var sign:String = "";

        tokens = tokens.filter(x -> x != null); // Safety clause, for strange edge cases such as 2 + ---5.
        for (token in tokens) {
            switch token {
                case PartArray(parts): {
                    if (sign != "" && calculated == null) calculated = Operators.call(sign, calculate(parts)); // RHS operator
                    else if (calculated == null) calculated = calculate(parts);
                    else if (sign == null) error("Two values cannot come one after the other. At least one of them should be an operator, or, put an operator in between.");
                    else {
                        calculated = Operators.call(calculated, sign, calculate(parts)); // standard operator
                    }
                }
                case Sign(s): {
                    sign = s;
                    if (tokens[tokens.length - 1].equals(token)) calculated = Operators.call(calculated, sign); //LHS operator
                }
                case Expression(parts, t): {
                    var val = t != null ? type(calculate(parts), t) : calculate(parts);
                    if (sign != "" && calculated == null) calculated = Operators.call(sign, val); // RHS operator
                    else if (calculated == null) calculated = val;
                    else if (sign == null) error("Two values cannot come one after the other. At least one of them should be an operator, or, put an operator in between.");
                    else {
                        calculated = Operators.call(calculated, sign, val); // standard operator
                    }
                }
                case _: {
                    if (sign != "" && calculated == null) calculated = Operators.call(sign, token);
                    else if (calculated == null) calculated = token;
                    else if (sign == null) error("Two values cannot come one after the other. At least one of them should be an operator, or, put an operator in between.");
                    else {
                        calculated = Operators.call(calculated, sign, token);
                    }
                }
            }
        }

        if (castType != null) return type(calculated, castType);
        return calculated;

    }

	public static function group(tokens:Array<ParserTokens>):Array<ParserTokens> {
		var post = tokens;
		var pre = [];

		for (operatorGroup in Little.operators.iterateByPriority()) {
            pre = post.copy();
            post = [];
			// We'll group everything by only recognizing specific signs each "stage" - 
			// The signs recognized first will be of the highest priority.
			// One drawback of this system is that its a little messier to detect chaining (e.g. 5!!, √√√64)

			var i = 0;
			while (i < pre.length) {
				var token = pre[i].is(READ, IDENTIFIER, BLOCK) ? evaluate(pre[i]) : pre[i];

                switch token {
                    case Sign(operatorGroup.filter(x -> x.sign == _).length > 0 => true): {

                        // If theres an operator before this one, its RHS_ONLY. If theres an operator after, its LHS_ONLY
                        // If theres no operator, its LHS_RHS

                        // First lets do a simple edge case - i = pre.length - 1 => LHS_ONLY operator.
                        if (i == pre.length - 1) {
                            post.push(PartArray([post.pop(), token]));
                            break;
                        }

                        var lookbehind = post.length > 0 ? post[post.length - 1] /* Post has only evaluated tokens */ : Sign("_"); // Just an arbitrary "sign" to not have null here
                        var lookahead = pre[i + 1].is(READ, IDENTIFIER, BLOCK) ? evaluate(pre[i + 1]) : pre[i + 1];

                        if (lookbehind.is(SIGN) && operatorGroup.filter(x -> x.sign == lookbehind.parameter(1)).length > 0) { // Because of our check above, valid for the start of an expression too.
                            if (lookahead.is(SIGN)) {
                                i++;
                                // Look ahead until we run out of signs. Then, group the iterated signs and the final operand into an array,
                                // and pass it onto "group()". Pay attention - this only groups signs with the current priority level.
                                if (i + 1 >= pre.length) error("Expression ended with an operator, when an operand was expected.");
                                var lookahead2 = pre[i + 1].is(READ, IDENTIFIER, BLOCK) ? evaluate(pre[i + 1]) : pre[i + 1];
                                var g = [];
                                while (lookahead2.is(SIGN) && operatorGroup.filter(x -> x.sign == lookahead2.parameter(1) && x.side == RHS_ONLY).length > 0) {
                                    g.push(lookahead2);
                                    i++;
                                    if (i + 1 >= pre.length) error("Expression ended with an operator, when an operand was expected.");
                                    lookahead2 = pre[i + 1].is(READ, IDENTIFIER, BLOCK) ? evaluate(pre[i + 1]) : pre[i + 1];
                                } 
                                // Last token is an operand
                                g.push(lookahead2);
                                post.push(PartArray([token, PartArray(group(g))]));
                                i++; // +1 because we consumed lookahead2 for the PartArray arg

                            } else if (lookahead.is(EXPRESSION)) {
                                post.push(PartArray([token, Expression(group(lookahead.parameter(0)), lookahead.parameter(1))]));
                            } else {
                                post.push(PartArray([token, lookahead]));
                            }
                        } else if (lookahead.is(SIGN) && operatorGroup.filter(x -> x.sign == lookahead.parameter(0)).length > 0) {
                            /* This can be one of two cases:
                            - were working on a binary operator before a unary operator (1 or more)
                            - were working on a unary operator (1 or more) before a binary operator

                            We should naturally prioritize unary operators since they, resulting from their definition, always come first.
                            This makes the parsing very easy, since the first possible binary operator must be the binary one: (pretend +, - and ! are of the same priority)
                            5!! + ---5
                            both + and - cant be LHS_ONLY, so grouping is:
                            (((5!)!) + (-(-(-5)))) */

                            if (operatorGroup.filter(x -> x.sign == token.parameter(0) && x.side == LHS_ONLY).length > 0) {
                                post.push(PartArray([post.pop(), token]));
                            } else if (operatorGroup.filter(x -> x.sign == token.parameter(0) && x.side == LHS_RHS).length > 0) {
                                var operand1 = post.pop();
                                var op = lookahead;
                                // We have to repeat the check in RHS_ONLY, since RHS can also start with a sign
                                if (i + 2 >= pre.length) error("Expression ended with an operator, when an operand was expected.");
                                var lookahead2 = pre[i + 2].is(READ, IDENTIFIER, BLOCK) ? evaluate(pre[i + 2]) : pre[i + 2];
                                
                                if (!lookahead2.is(SIGN)) {
                                    post.push(PartArray([operand1, token, PartArray([lookahead, lookahead2])]));
                                    i += 2; // +2 because we consumed both lookahead and lookahead2 for the PartArray arg
								} else {
                                    var g = [];
                                    while (lookahead2.is(SIGN) && operatorGroup.filter(x -> x.sign == lookahead2.parameter(0) && x.side == RHS_ONLY).length > 0) {
                                        g.push(lookahead2);
                                        i++;
                                        if (i + 2 >= pre.length) error("Expression ended with an operator, when an operand was expected.");
                                        lookahead2 = pre[i + 2].is(READ, IDENTIFIER, BLOCK) ? evaluate(pre[i + 2]) : pre[i + 2];
                                    } 
									// Last token is an operand
									g.push(lookahead2);
									// And increment i since lookahead2 uses i + 1
									i++;

									var operand2 = g.length == 1 ? g[0] : PartArray(group(g));
									post.push(PartArray([operand1, op, operand2]));
								}
                            } else if (operatorGroup.filter(x -> x.sign == token.parameter(0) && x.side == RHS_ONLY).length > 0) {
                                error("An operator that expects a right side can't be preceded by an operator that expects a left side.");
                            }
                            
                        } else {
                            // Both sides are regular operands, so we just pop from `post` and take the lookahead
                            // And no, we should'nt worry about order of operations here. because of this "algorithm"'s format, all 
                            // operators are of the same priority, and its the user's responsibility to use parentheses when needed.
                            if (lookahead.is(SIGN)) {
                                post.push(PartArray([post.pop(), token]));
                            } else {
                                post.push(PartArray([post.pop(), token, lookahead]));
                                i++;
                            }
                        }
                    }
                    case Expression(parts, type): post.push(Expression(group(parts), type));
                    case _: post.push(token);
                }
                i++;
			}
		}

        return post;
	}
}