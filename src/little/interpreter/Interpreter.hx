package little.interpreter;

import haxe.Rest;
import little.interpreter.Tokens.InterpTokens;
import little.tools.PrettyPrinter;
import little.tools.Layer;
import little.Little.memory;


using StringTools;
using Std;
using Math;
using little.tools.TextTools;
using little.tools.Extensions;
@:access(little.interpreter.Runtime)
class Interpreter {
	public static function convert(pre:Rest<little.parser.Tokens.ParserTokens>):Array<InterpTokens> {
		if (pre.length == 1 && pre[0] == null) return [null];
		var post:Array<InterpTokens> = [];

		for (item in pre) {
			post.push(switch item {
				case SetLine(line): SetLine(line);
				case SplitLine: SplitLine;
				case Variable(name, type, doc): VariableDeclaration(convert(name)[0], type == null ? Little.keywords.TYPE_DYNAMIC.asTokenPath() : convert(type)[0], doc == null ? Characters("") : convert(doc)[0]);
				case Function(name, params, type, doc): FunctionDeclaration(convert(name)[0], convert(params)[0], type == null ? Little.keywords.TYPE_DYNAMIC.asTokenPath() : convert(type)[0], doc == null ? Characters("") : convert(doc)[0]);
				case ConditionCall(name, exp, body): ConditionCall(convert(name)[0], convert(exp)[0], convert(body)[0]);
				case Read(name): null;
				case Write(assignees, value): Write(convert(...assignees), convert(value)[0]);
				case Identifier(word): Identifier(word);
				case TypeDeclaration(value, type): TypeCast(convert(value)[0], convert(type)[0]);
				case FunctionCall(name, params): FunctionCall(convert(name)[0], convert(params)[0]);
				case Return(value, type): FunctionReturn(convert(value)[0], type == null ? Little.keywords.TYPE_DYNAMIC.asTokenPath() : convert(type)[0]);
				case Expression(parts, type): Expression(convert(...parts), type == null ? Little.keywords.TYPE_DYNAMIC.asTokenPath() : convert(type)[0]);
				case Block(body, type): Block(convert(...body), type == null ? Little.keywords.TYPE_DYNAMIC.asTokenPath() : convert(type)[0]);
				case PartArray(parts): PartArray(convert(...parts));
				case PropertyAccess(name, property): PropertyAccess(convert(name)[0], convert(property)[0]);
				case Sign(sign): Sign(sign);
				case Number(num): num.parseFloat().abs() > 2_147_483_647 ? Decimal(num.parseFloat()) : Number(num.parseInt());
				case Decimal(num): Decimal(num.parseFloat());
				case Characters(string): Characters(string);
				case Documentation(doc): Characters('""$doc""'); // Kinda strange behavior, should maybe disable entirely/throw an error.
				case ErrorMessage(msg): ErrorMessage(msg);
				case NullValue: NullValue;
				case TrueValue: TrueValue;
				case FalseValue: FalseValue;
				case Custom(name, params): throw 'Custom tokens cannot remain when transitioning from Parser to Interpreter tokens (found $item)';
			});
		}

		return post;
	}

	
    /**
        Raise an error in the program, with the given message.
        @param message The error message
        @param layer The layer of the error. see `little.tools.Layer`.
        @return the error token, as InterpTokens.ErrorMessage(msg:String)
    **/
    public static function error(message:String, layer:Layer = INTERPRETER):InterpTokens {
        Little.runtime.throwError(ErrorMessage(message), layer);
        throw "";
        return ErrorMessage(message);
    }

    /**
        Raise a warning in the program, with the given message. A warning never stops execution.
        @param message The warning message
        @param layer The layer of the warning. see `little.tools.Layer`.
        @return the warning token, as InterpTokens.ErrorMessage(msg:String)
    **/
    public static function warn(message:String, layer:Layer = INTERPRETER):InterpTokens {
        Little.runtime.warn(ErrorMessage(message), layer);
        return ErrorMessage(message);
    }

	public static function assert(token:InterpTokens, isType:InterpTokensSimple, ?errorMessage:String = null) {
		if (!token.is(isType)) {
			Little.runtime.throwError(errorMessage != null ? ErrorMessage(errorMessage) : ErrorMessage('Assertion failed, token $token is not of type $isType'), INTERPRETER);
			return NullValue;
		}
		return token;
	}

    /**
        Set the current line of the program
    **/
    public static function setLine(l:Int) {
        var o = Little.runtime.line;
        Little.runtime.line = l;

        for (listener in Little.runtime.onLineChanged) listener(o);
    }

    /**
        Split the current line. In other words, create a new line, but keep the old line number.
    **/
    public static function splitLine() {
        for (listener in Little.runtime.onLineSplit) listener();
    }

    /**
        Declare a new variable. That variable will be added to the current scope.
        @param name The name of the variable. Can be any token stringifiyable via `token.extractIdentifier()`.
        @param type The type of the variable. Can be any token stringifiyable via `token.extractIdentifier()`.
        @param doc The documentation of the variable. Should be a `InterpTokens.Documentation(doc:String)`
    **/
    public static function declareVariable(name:InterpTokens, type:InterpTokens, doc:InterpTokens) {
		var path = name.asStringPath();
		memory.write(path, NullValue, type.extractIdentifier(), doc != null ? evaluate(doc).extractIdentifier() : "");

        // Listeners
    }

    /**
        Declare a new function. That function will be added to the current scope.
        @param name The name of the function. Can be any token stringifiyable via `token.extractIdentifier()`.
        @param params The parameters of the function. Should be a `InterpTokens.PartArray(parts:Array<InterpTokens>)`
        @param doc The documentation of the function. Should be a `InterpTokens.Documentation(doc:String)`
    **/
    public static function declareFunction(name:InterpTokens, params:InterpTokens, doc:InterpTokens) {
        var path = name.asStringPath();

		var paramMap = new OrderedMap<String, InterpTokens>();
		// Because values are allowed as well as types, were gonna abuse TypeCasts:
		var array = (params.parameter(0) : Array<InterpTokens>); 
		for (entry in array) {
			if (entry.is(SPLIT_LINE, SET_LINE)) continue;
			switch entry {
				case VariableDeclaration(name, null, _): paramMap[name.extractIdentifier()] = TypeCast(NullValue, Identifier(Little.keywords.TYPE_DYNAMIC));
				case VariableDeclaration(name, type, _): paramMap[name.extractIdentifier()] = TypeCast(NullValue, type);
				case Write(assignees, value): {
					switch assignees[0] {
						case VariableDeclaration(name, null, _): paramMap[name.extractIdentifier()] = TypeCast(value, Identifier(Little.keywords.TYPE_DYNAMIC));
						case VariableDeclaration(name, type, _): paramMap[name.extractIdentifier()] = TypeCast(value, type);
						default:
					}
				}
				default:
			}
		}

		memory.write(path, FunctionCode(paramMap, Block([], Identifier(Little.keywords.TYPE_DYNAMIC))), Little.keywords.TYPE_FUNCTION, doc != null ? evaluate(doc).extractIdentifier() : "");
    
        // Listeners
    }

	/**
		Calls a condition. The condition's `body` is repeated `0` to `n` times, depending on the condition's `conditionParams`.
		@param pattern The pattern of the condition. Should be a `InterpTokens.PartArray(parts:Array<InterpTokens>)`
		@param body The body of the condition. Should be a `InterpTokens.Block(body:Array<InterpTokens>)`
	**/
    public static function condition(name:InterpTokens, pattern:InterpTokens, body:InterpTokens):InterpTokens {
        var conditionToken = memory.read(...name.asStringPath());
		assert(conditionToken.objectValue, CONDITION_CODE, '${name.asStringPath()} is not a condition.');

		var patterns:Map<Array<InterpTokens>, InterpTokens> = conditionToken.objectValue.parameter(0);
		var givenPattern = pattern.parameter(0);
		function fit(given:Array<InterpTokens>, pattern:Array<InterpTokens>, currentlyFits:Bool = true):Bool {
			for (i in 0...given.length) {
				if (pattern[i] == null) continue;
				if (given[i].equals(pattern[i])) continue;
				if (given[i].getName() != pattern[i].getName()) return false;
				switch given[i] {
					case SetLine(_) | Number(_) | Decimal(_) | Characters(_) | Documentation(_) | Sign(_) | Identifier(_) | ErrorMessage(_): if (pattern[i].parameter(0) != null) return false; 
					case VariableDeclaration(_, _, _) | FunctionDeclaration(_, _, _, _) | ClassDeclaration(_, _) | ConditionDeclaration(_, _, _): currentlyFits = currentlyFits && fit(cast given[i].getParameters(), cast pattern[i].getParameters(), currentlyFits);
					case ConditionCode(_): return false; // Cant be matched with, only valid in the context of a condition definition. Represented by other tokens in other cases
					case FunctionCode(_, _): return false; // same as above
					case ConditionCall(_, _, _) | FunctionCall(_, _): currentlyFits = currentlyFits && fit(cast given[i].getParameters(), cast pattern[i].getParameters(), currentlyFits);
					case FunctionReturn(_, _) | TypeCast(_, _): currentlyFits = currentlyFits && fit(cast given[i].getParameters(), cast pattern[i].getParameters(), currentlyFits);
					case Write(assignees, value): {
						var patternAssignees:Array<InterpTokens> = pattern[i].parameter(0);
						if (patternAssignees != null) currentlyFits = currentlyFits && fit(assignees, patternAssignees, currentlyFits);
						if (pattern[i].parameter(1) != null) currentlyFits = currentlyFits && fit(cast value.getParameters(), cast pattern[i].parameter(1).getParameters(), currentlyFits);
					}
					case Expression(parts, type) | Block(parts, type): {
						var patternParts:Array<InterpTokens> = pattern[i].parameter(0).copy();
						if (patternParts != null) currentlyFits = currentlyFits && fit(parts, patternParts, currentlyFits);
						if (pattern[i].parameter(1) != null) currentlyFits = currentlyFits && fit(cast type.getParameters(), cast pattern[i].parameter(1).getParameters(), currentlyFits);
					}
					case PartArray(parts): {
						var patternParts:Array<InterpTokens> = pattern[i].parameter(0);
						if (patternParts != null) currentlyFits = currentlyFits && fit(parts, patternParts, currentlyFits);
					}
					case PropertyAccess(name, property): currentlyFits = currentlyFits && fit(cast given[i].getParameters(), cast pattern[i].getParameters(), currentlyFits);
					case Object(props, typeName): return false; // Cant be matched with, only valid in the context of object instantiation. Represented by FunctionCall in most cases.
					case _: continue;
				}

				if (!currentlyFits) return false;
			}

			return currentlyFits;
		}

		var patternString = PrettyPrinter.stringifyInterpreter(pattern);
		// We might want to attach stuff to the body, so we need to make it so it doesn't create a new scope & strip type info from it
		var bodyString = PrettyPrinter.stringifyInterpreter(body.parameter(0)); 

		for (pattern => caller in patterns) {
			if (pattern == null || fit(givenPattern, pattern)) { // As per the docs, a null pattern means any pattern
				var conditionRunner = (caller.parameter(0) : Array<InterpTokens>);
				var params = [
					Write([VariableDeclaration(Identifier(Little.keywords.CONDITION_PATTERN_PARAMETER_NAME), Identifier(Little.keywords.TYPE_STRING), null)], Characters(patternString)),
					Write([VariableDeclaration(Identifier(Little.keywords.CONDITION_BODY_PARAMETER_NAME), Identifier(Little.keywords.TYPE_STRING), null)], Characters(bodyString)),
				];
				return run(params.concat(conditionRunner));
			}
		}

		return error('Pattern $patternString is not supported in condition ${name.asStringPath()} (patterns (`*` means any value): \n\t(${[for (pattern in patterns.keys()) pattern].map(x -> PrettyPrinter.stringifyInterpreter(x).replace("null", "*")).join('),\n\t(')})\n)');

        // Listeners

    }

    /**
		Assign a value to multiple variables/functions/types.
    	@param assignees The variables/functions/types to assign to. Should be a `InterpTokens.VariableDeclaration(name:InterpTokens, type:InterpTokens, doc:InterpTokens)` or `ParserTokens.FunctionDeclaration(name:InterpTokens, params:ParserTokens, type:InterpTokens, doc:InterpTokens)`
    	@param value The value to assign. Can be any token which has a non-void value (not `InterpTokens.SplitLine`, `InterpTokens.SetLine(line:Int)`...)
    	@return The value given, evaluated using `Interpreter.evaluate(value)`
    **/
    public static function write(assignees:Array<InterpTokens>, value:InterpTokens):InterpTokens {

		var vars = [], funcs = [];
		var containsFunction = false;
		var containsVariable = false;
		for (assignee in assignees) {
			switch assignee {
				case VariableDeclaration(name, type, doc): declareVariable(name, type, doc); vars.push(name); containsVariable = true;
				case FunctionDeclaration(name, params, type, doc): declareFunction(name, params, doc); funcs.push(name); containsFunction = true; //TODO: find a way to store function type
				case ConditionDeclaration(name, ct, doc): // TODO: Condition declaration is not implemented yet.
				case _: vars.push(assignee); containsVariable = true;
			}
		}

		if (containsFunction) {
			var paths = funcs.map(x -> x.asStringPath());
			for (path in paths) {
				var func = memory.read(...path).objectValue;
				memory.set(path, FunctionCode(func.parameter(0), value), Little.keywords.TYPE_FUNCTION, "");
			}
		}

		if (containsVariable) {
			var paths = vars.map(x -> x.asStringPath());
			var evaluated = evaluate(value); // No need to calculate multiple times, so we just evaluate once
			for (path in paths) {
				memory.set(path, evaluated, evaluated.type(), "");
			}
		}
        
		// Listeners

        for (listener in Little.runtime.onWriteValue.copy()) {
            listener(vars.map(x -> x.extractIdentifier()).concat(funcs.map(x -> x.extractIdentifier())));
        }

        return value;
    }

	/**
		Calls a function and returns the result using `params`.
		@param name The name of the function. Can be any token stringifiyable via `token.value()`.
		@param params The parameters of the function. Should be a `InterpTokens.PartArray(parts:Array<InterpTokens>)`
	**/
    public static function call(name:InterpTokens, params:InterpTokens):InterpTokens {
        var functionCode = evaluate(name);
        var processedParams = [];
        var current = [];
        for (p in (params.parameter(0) : Array<InterpTokens>)) {
            switch p {
                case SplitLine: {
                    processedParams.push(calculate(current));
                    current = [];
                }
                case SetLine(l): setLine(l);
                case _: current.push(p);
            }
        }
        if (current.length > 0) processedParams.push(calculate(current));

		switch functionCode {
			case FunctionCode(requiredParams, body): {
				var given = processedParams;
				
				var attachment = [];
				for (key => typeCast in requiredParams.keyValueIterator()) {
					var name = key, value = NullValue, type = Identifier(Little.keywords.TYPE_DYNAMIC);
					switch typeCast {
						case TypeCast(NullValue, t): type = t; 
						case TypeCast(v, _.parameter(0) == Little.keywords.TYPE_DYNAMIC => true): value = v;
						case TypeCast(v, t): type = t; value = v;
						case _:
					}
                    if (processedParams.length > 0) value = processedParams.shift(); // Todo, handle mid-function optional arguments.
					attachment.push(Write([VariableDeclaration(Identifier(name), type, null)], value));
				}
				return run(attachment.concat(body.parameter(0)));
			}
			case _: return null;
		}

    }

	/**
		Reads the value of a variable/function, When reading a function, the body is returned as a `InterpTokens.FunctionCode(requiredParams:OrderedMap<String, InterpTokens.Identifier>, body:InterpTokens)`.
		@param name The name of the variable/function. Should be one of `InterpTokens.Identifier(name:String)` or `InterpTokens.PropertyAccess(name:InterpTokens, property:InterpTokens)`
		@return The value of the variable/function
	**/
    public static function read(name:InterpTokens):InterpTokens {
		return memory.read(...name.asStringPath()).objectValue;
    }

	/**
		Casts a value to a type
		@param value The value to cast. Can be any token which has a non-void value (not `InterpTokens.SplitLine`, `InterpTokens.SetLine(line:Int)`...)
		@param type The type to cast to. Can be any token which resolves to a correct string path.
		@return The value given, casted to the type.
	**/
    public static function typeCast(value:InterpTokens, type:InterpTokens):InterpTokens {
		if (value.is(NUMBER) && type.parameter(0) == Little.keywords.TYPE_FLOAT) {
			return Decimal(value.parameter(0));
		}
		if (value.is(DECIMAL) && type.parameter(0) == Little.keywords.TYPE_INT) {
			return Number(Std.int(value.parameter(0)));
		}
		if (value.is(NUMBER, DECIMAL) && type.parameter(0) == Little.keywords.TYPE_STRING) {
			return Characters(Std.string(value.parameter(0)));
		}
		if (value.is(TRUE_VALUE, FALSE_VALUE, NULL_VALUE) && type.parameter(0) == Little.keywords.TYPE_STRING) {
			return Characters(value.is(TRUE_VALUE) ? Little.keywords.TRUE_VALUE : value.is(FALSE_VALUE) ? Little.keywords.FALSE_VALUE : Little.keywords.NULL_VALUE);
		}

        return value; // TODO, needs to be done with types in memory management
		
    }

	/**
		Runs the tokens and returns the result.
		Adds a new scope.
		@param body The tokens to run
		@return The result of the tokens
	**/
    public static function run(body:Array<InterpTokens>):InterpTokens {
        var returnVal:InterpTokens = null;
		memory.referrer.pushScope();
        var i = 0;
        while (i < body.length) {
            var token = body[i];
            //trace('Running: $token. $i');
            if (token == null) {i++; continue;}
			Little.runtime.currentToken = token;
            switch token {
                case SetLine(line): {
                    setLine(line);
                }
                case SplitLine: splitLine();
                case VariableDeclaration(name, type, doc): {
                    declareVariable(name.is(BLOCK) ? evaluate(name) : name, type.is(BLOCK) ? evaluate(type) : type, doc != null ? evaluate(doc) : Characters(""));
                    returnVal = NullValue;
                }
                case FunctionDeclaration(name, params, type, doc): {
					declareFunction(name.is(BLOCK) ? evaluate(name) : name, params, doc != null ? evaluate(doc) : Characters("")); // TODO: type is not used
                    returnVal = NullValue;
                }
                case ConditionCall(name, exp, body): {
                    returnVal = condition(name, exp, body);
                }
                case Write(assignees, value): {
                    returnVal = write(assignees, value);
                }
                case FunctionCall(name, params): {
                    returnVal = call(name, params);
                }
                case FunctionReturn(value, type): {
                    return evaluate(value); // TODO
                }
                case Block(body, type): {
                    returnVal = run(body);
                }
                case PropertyAccess(name, property): {
                    returnVal = evaluate(token);
                }
                case Identifier(name): {
                    returnVal =  read(token);
                }
                case HaxeExtern(func): {
                    returnVal = evaluate(func());
                }
                case _: returnVal = evaluate(token);
            }
			Little.runtime.previousToken = token;
            i++;
        }
		memory.referrer.popScope();
        return returnVal;
    }

    /**
    	A combination of `Interpreter.run` and `Interpreter.calculate`, which operates on a single `InterpTokens` token.
    	@param exp the token to evaluate
    	@param dontThrow if `true`, `Little.runtime.throwError` is not called when an error occurs
    	@return the result of the evaluation
    **/
    public static function evaluate(exp:InterpTokens, ?dontThrow:Bool = false):InterpTokens {

        switch exp {
            case Number(_) | Decimal(_) | Characters(_) | TrueValue | FalseValue | NullValue | Sign(_) | FunctionCode(_, _) | Object(_, _) | ClassPointer(_): return exp;
            case ErrorMessage(msg): {
                if (!dontThrow) Little.runtime.throwError(exp, INTERPRETER_VALUE_EVALUATOR);
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
                if (t.asJoinedStringPath() == Little.keywords.TYPE_DYNAMIC) return calculate(parts);
                return typeCast(calculate(parts), t);
            }
            case Block(body, t): {
				var currentLine = Little.runtime.line;
                var returnVal = run(body);
				setLine(currentLine);
                if (t.asJoinedStringPath() == Little.keywords.TYPE_DYNAMIC) return evaluate(returnVal, dontThrow);
				return evaluate(typeCast(returnVal, t), dontThrow);
            }
            case FunctionCall(name, params): {
				var currentLine = Little.runtime.line;
				return call(name, params);
				setLine(currentLine);
			}
            case PartArray(parts): {
                return PartArray([for (p in parts) evaluate(p, dontThrow)]);
            }
            case Identifier(word): {
                return read(exp);
            }
            case TypeCast(value, t): return typeCast(value, t);
            case Write(assignees, value): return write(assignees, value);
            case ConditionCall(name, exp, body): return condition(name, exp, body);
            case VariableDeclaration(name, type, doc): {
				declareVariable(name.is(BLOCK) ? evaluate(name) : name, type.is(BLOCK) ? evaluate(type) : type, evaluate(doc));
				return NullValue;
			}
            case FunctionDeclaration(name, params, type, doc): {
				declareFunction(name.is(BLOCK) ? evaluate(name) : name, params, evaluate(doc)); // TODO: type is not stored.
				return NullValue;
			}
            case PropertyAccess(name, property): {
                var path = exp.toIdentifierPath();
				// Two cases:
				//  - regular property access
				//  - access on inline value
				if (path.filter(p -> !p.is(IDENTIFIER)).length == 0) {
					return read(exp);
				} else if (!path[0].is(IDENTIFIER) && path.slice(1).filter(p -> !p.is(IDENTIFIER)).length == 0) {
					var value = evaluate(path[0]);
					return memory.readFrom({
						objectValue: value,
						objectAddress: memory.store(value)
					}, ...path.slice(1).map(ident -> ident.extractIdentifier())).objectValue; // Evaluation is never needed here, since only evaluated values can be stored.
				} else {
					return error('Cannot access ${path.join(Little.keywords.PROPERTY_ACCESS_SIGN)}, path cannot contain a raw value in the middle (for property: ${PrettyPrinter.stringifyInterpreter(path.slice(1).filter(p -> !p.is(IDENTIFIER))[0])}');
				}
            }
            case FunctionReturn(value, t): return evaluate(typeCast(value, t));
            case HaxeExtern(func): return evaluate(func());
            case _: return evaluate(ErrorMessage('Unable to evaluate token `$exp`'), dontThrow);
        }

		return NullValue;
    }

	/**
		Calculates the result of a given expression. An "alternative" to `Interpreter.run()`, 
		but instead of having code running and memory writing capabilities, it's capable of 
		calculating complex equations of different types. example:

		| Function | Input | Result | Process |
		|:---: | :--- | --- | --- |
		| 				  		| `1 + 1` 			| `1` 		| picks up the last token. |
		| `Interpreter.run()` 		| `(2 + 2)` 		| `4` 		| picks up the last token. its an expression, so it's evaluated |
		|						| `3 + (5 * 2)!` 	| `!` 		| picks up the last token. |
		| --------------------- | ----------------- | --------- | -------------------------------------------------------------- |
		|  						| `1 + 1` 			| `2` 		| evaluates all tokens and calculates the relations between them |
		| `Interpreter.calculate()` | `(2 + 2)` 		| `4` 		| evaluates all tokens and calculates the relations between them |
		| 						| `3 + (5 * 2)!` 	| `3628803` | evaluates all tokens and calculates the relations between them |
		@param parts The parts of the expression
		@return The result of the expression
	**/
    public static function calculate(p:Array<InterpTokens>):InterpTokens {

        while (p.length == 1 && p[0].parameter(0) is Array && !p[0].is(BLOCK)) p = p[0].parameter(0);

		var tokens = group(p);
        var castType:InterpTokens = null;

        if (tokens.length == 1) {
            if (tokens[0].is(PART_ARRAY)) tokens = tokens[0].parameter(0);
            else if (tokens[0].is(EXPRESSION)) {
                tokens = tokens[0].parameter(0);
                castType = tokens[0].parameter(1);
            } else if (tokens[0].is(BLOCK)) {
                tokens = [run(tokens[0].parameter(0))];
                castType = tokens[0].parameter(1);
            }
        }

        var calculated:InterpTokens = null;
        var sign:String = "";

        tokens = tokens.filter(x -> x != null); // Safety clause, for strange edge cases such as 2 + ---5.
        for (token in tokens) {
            switch token {
                case PartArray(parts): {
                    if (sign != "" && calculated == null) calculated = Operators.call(sign, calculate(parts)); // RHS operator
                    else if (calculated == null) calculated = calculate(parts);
                    else if (sign == "") error('Two values cannot come one after the other ($calculated, $token). At least one of them should be an operator, or, put an operator in between.');
                    else {
                        calculated = Operators.call(calculated, sign, calculate(parts)); // standard operator
                    }
                }
                case Sign(s): {
                    sign = s;
                    if (tokens[tokens.length - 1].equals(token)) calculated = Operators.call(calculated, sign); //LHS operator
                }
                case Expression(parts, t): {
                    var val = t != null ? typeCast(calculate(parts), t) : calculate(parts);
                    if (sign != "" && calculated == null) calculated = Operators.call(sign, val); // RHS operator
                    else if (calculated == null) calculated = val;
                    else if (sign == "") error('Two values cannot come one after the other ($calculated, $token). At least one of them should be an operator, or, put an operator in between.');
                    else {
                        calculated = Operators.call(calculated, sign, val); // standard operator
                    }
                }
                case _: {
                    if (sign != "" && calculated == null) calculated = Operators.call(sign, token);
					else if (sign == "" && calculated != null) throw 'Unexpected token: $token After calculating $calculated';
                    else if (calculated == null) calculated = token;
                    else if (sign == "") error('Two values cannot come one after the other ($calculated, $token). At least one of them should be an operator, or, put an operator in between.');
                    else {
                        calculated = Operators.call(calculated, sign, token);
                    }
                }
            }
        }

        if (castType != null) return typeCast(calculated, castType);
        return calculated;

    }

	public static function group(tokens:Array<InterpTokens>):Array<InterpTokens> {
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
				var token = pre[i].is(IDENTIFIER, BLOCK) ? evaluate(pre[i]) : pre[i];

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
                        var lookahead = pre[i + 1].is(IDENTIFIER, BLOCK) ? evaluate(pre[i + 1]) : pre[i + 1];

                        if (lookbehind.is(SIGN) && operatorGroup.filter(x -> x.sign == lookbehind.parameter(1)).length > 0) { // Because of our check above, valid for the start of an expression too.
                            if (lookahead.is(SIGN)) {
                                i++;
                                // Look ahead until we run out of signs. Then, group the iterated signs and the final operand into an array,
                                // and pass it onto "group()". Pay attention - this only groups signs with the current priority level.
                                if (i + 1 >= pre.length) error("Expression ended with an operator, when an operand was expected.");
                                var lookahead2 = pre[i + 1].is(IDENTIFIER, BLOCK) ? evaluate(pre[i + 1]) : pre[i + 1];
                                var g = [];
                                while (lookahead2.is(SIGN) && operatorGroup.filter(x -> x.sign == lookahead2.parameter(1) && x.side == RHS_ONLY).length > 0) {
                                    g.push(lookahead2);
                                    i++;
                                    if (i + 1 >= pre.length) error("Expression ended with an operator, when an operand was expected.");
                                    lookahead2 = pre[i + 1].is(IDENTIFIER, BLOCK) ? evaluate(pre[i + 1]) : pre[i + 1];
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
                                var lookahead2 = pre[i + 2].is(IDENTIFIER, BLOCK) ? evaluate(pre[i + 2]) : pre[i + 2];
                                
                                if (!lookahead2.is(SIGN)) {
                                    post.push(PartArray([operand1, token, PartArray([lookahead, lookahead2])]));
                                    i += 2; // +2 because we consumed both lookahead and lookahead2 for the PartArray arg
								} else {
                                    var g = [];
                                    while (lookahead2.is(SIGN) && operatorGroup.filter(x -> x.sign == lookahead2.parameter(0) && x.side == RHS_ONLY).length > 0) {
                                        g.push(lookahead2);
                                        i++;
                                        if (i + 2 >= pre.length) error("Expression ended with an operator, when an operand was expected.");
                                        lookahead2 = pre[i + 2].is(IDENTIFIER, BLOCK) ? evaluate(pre[i + 2]) : pre[i + 2];
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

