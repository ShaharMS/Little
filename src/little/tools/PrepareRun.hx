package little.tools;

import little.interpreter.memory.HashTables;
import little.interpreter.memory.MemoryPointer;
import little.interpreter.memory.MemoryPointer.POINTER_SIZE;
import haxe.Json;
import haxe.xml.Access;
import vision.tools.MathTools;
import little.lexer.Lexer;
import little.parser.Parser;
import little.interpreter.Interpreter;
import little.interpreter.Runtime;
import little.interpreter.Tokens;

using Std;
using little.tools.TextTools;
using little.tools.Extensions;


@:access(little.interpreter.Little.operators)
@:access(little.interpreter.Runtime)
/**
    Contains `Little`'s standard library, as a group of functions, each adding different types of features.
**/
class PrepareRun {
	/**
		Whether or not the standard library has been prepared.
	**/
	public static var prepared:Bool = false;

	/**
	    Adds Standard library types.
	**/
	public static function addTypes() {

		Little.plugin.registerType(Little.keywords.TYPE_FUNCTION, []);
		Little.plugin.registerType(Little.keywords.TYPE_CONDITION, []);
		Little.plugin.registerType(Little.keywords.TYPE_INT, []);
		Little.plugin.registerType(Little.keywords.TYPE_FLOAT, []);
		Little.plugin.registerType(Little.keywords.TYPE_STRING, []);
		Little.plugin.registerType(Little.keywords.TYPE_SIGN, []);

		Little.plugin.registerType(Little.keywords.TYPE_MODULE, [
			'public ${Little.keywords.TYPE_STRING} toString ()' => (address, _, _) -> {
				return Conversion.toLittleValue(Little.memory.getTypeName(address));
			}
		]);

		Little.plugin.registerType("Date", [
			'static ${Little.keywords.TYPE_STRING} now ()' => (_) -> {
				return Conversion.toLittleValue(Date.now().toString());
			}
		]);
		

		Little.plugin.registerType(Little.keywords.TYPE_INT, [
			'public ${Little.keywords.TYPE_STRING} toString ()' => (_, value, _) -> {
				return Conversion.toLittleValue(Std.string(value.parameter(0)));
			}
		]);

		Little.plugin.registerType(Little.keywords.TYPE_FLOAT, [
			'public ${Little.keywords.TYPE_STRING} toString ()' => (_, value, _) -> {
				return Conversion.toLittleValue(Std.string(value.parameter(0)));
			},
			'public ${Little.keywords.TYPE_BOOLEAN} isWhole ()' => (_, value, _) -> {
				return Conversion.toLittleValue((value.parameter(0) : Float) % 1 == 0);
			}
		]);

		Little.plugin.registerType(Little.keywords.TYPE_STRING, [
			'public ${Little.keywords.TYPE_INT} length' => (_, value) -> {
				return Conversion.toLittleValue(value.parameter(0).length);
			},
			'public ${Little.keywords.TYPE_STRING} charAt (define index as ${Little.keywords.TYPE_INT})' => (_, value, params) -> {
				return Conversion.toLittleValue(value.parameter(0).charAt(Conversion.toHaxeValue(params[0])));
			},
			'public ${Little.keywords.TYPE_STRING} substring (define start as ${Little.keywords.TYPE_INT}, define end as ${Little.keywords.TYPE_INT} = -1)' => (_, value, params) -> {
				return Characters(value.parameter(0).substring(Conversion.toHaxeValue(params[0]), Conversion.toHaxeValue(params[1])));
			},
			'public ${Little.keywords.TYPE_STRING} toLowerCase ()' => (_, value, _) -> {
				return Characters(value.parameter(0).toLowerCase());
			},
			'public ${Little.keywords.TYPE_STRING} toUpperCase ()' => (_, value, _) -> {
				return Characters(value.parameter(0).toUpperCase());
			},
			'public ${Little.keywords.TYPE_STRING} replace (define search as ${Little.keywords.TYPE_STRING}, define replace as ${Little.keywords.TYPE_STRING})' => (_, value, params) -> {
				return Characters(value.parameter(0).replace(Conversion.toHaxeValue(params[0]), Conversion.toHaxeValue(params[1])));
			},
			'public ${Little.keywords.TYPE_STRING} trim ()' => (_, value, _) -> {
				return Characters(value.parameter(0).trim());
			},
			'public ${Little.keywords.TYPE_STRING} remove (define search as ${Little.keywords.TYPE_STRING})' => (_, value, params) -> {
				return Characters(value.parameter(0).replace(Conversion.toHaxeValue(params[0]), ""));
			},
			'public ${Little.keywords.TYPE_BOOLEAN} contains (define search as ${Little.keywords.TYPE_STRING})' => (_, value, params) -> {
				return Conversion.toLittleValue(value.parameter(0).contains(Conversion.toHaxeValue(params[0])));
			},
			'public ${Little.keywords.TYPE_INT} indexOf (define search as ${Little.keywords.TYPE_STRING})' => (_, value, params) -> {
				return Conversion.toLittleValue(value.parameter(0).indexOf(Conversion.toHaxeValue(params[0])));
			},
			'public ${Little.keywords.TYPE_INT} lastIndexOf (define search as ${Little.keywords.TYPE_STRING})' => (_, value, params) -> {
				return Conversion.toLittleValue(value.parameter(0).lastIndexOf(Conversion.toHaxeValue(params[0])));
			},
			'public ${Little.keywords.TYPE_BOOLEAN} startsWith (define prefix as ${Little.keywords.TYPE_STRING})' => (_, value, params) -> {
				return Conversion.toLittleValue(value.parameter(0).indexOf(Conversion.toHaxeValue(params[0]) == 0));
			},
			'public ${Little.keywords.TYPE_BOOLEAN} endsWith (define postfix as ${Little.keywords.TYPE_STRING})' => (_, value, params) -> {
				return Conversion.toLittleValue(value.parameter(0).indexOf(Conversion.toHaxeValue(params[0])) == value.parameter(0).length - Conversion.toHaxeValue(params[0]).length);
			},

			'static ${Little.keywords.TYPE_STRING} fromCharCode (define code as ${Little.keywords.TYPE_INT})' => (_, value, params) -> {
				return Conversion.toLittleValue(String.fromCharCode(Conversion.toHaxeValue(params[0])));
			}
		]);
 
		Little.plugin.registerType("Object", [
			'static Object create (define fieldEstimate as ${Little.keywords.TYPE_INT} = 20)' => (params) -> {
				return Object([], "Object");
			}
		]);

	}
	
	/**
	    Adds standard library, top-level functions.
	**/
	public static function addFunctions() {
		Little.plugin.registerFunction(Little.keywords.PRINT_FUNCTION_NAME, null, [VariableDeclaration(Identifier("item"), null)], (params) -> {
			var eval = params[0].objectValue;
			Little.runtime.__print(eval.is(OBJECT) ? @:privateAccess PrettyPrinter.printInterpreterAst([eval]).split("\n").slice(1).map(s -> s.substring(6)).join("\n") : PrettyPrinter.stringifyInterpreter(eval), eval);
			return NullValue;
		}, Little.keywords.TYPE_DYNAMIC);
		Little.plugin.registerFunction(Little.keywords.RAISE_ERROR_FUNCTION_NAME, null, [VariableDeclaration(Identifier("message"), null)], (params) -> {
			Little.runtime.throwError(params[0].objectValue);
			return NullValue;
		}, Little.keywords.TYPE_DYNAMIC);
		Little.plugin.registerFunction(Little.keywords.READ_FUNCTION_NAME, null, [VariableDeclaration(Identifier("identifier"), Little.keywords.TYPE_STRING.asTokenPath())], (params) -> {
			return (Conversion.toHaxeValue(params[0].objectValue) : String).asTokenPath();
		}, Little.keywords.TYPE_DYNAMIC);
		Little.plugin.registerFunction(Little.keywords.RUN_CODE_FUNCTION_NAME, null, [VariableDeclaration(Identifier("code"), Little.keywords.TYPE_STRING.asTokenPath())], (params) -> {
			return Interpreter.run(Interpreter.convert(...Parser.parse(Lexer.lex(Conversion.toHaxeValue(params[0].objectValue)))));
		}, Little.keywords.TYPE_DYNAMIC);
	}

	/**
	    Adds standard instance properties to core types.
	**/
	public static function addProps() {
		Little.plugin.registerInstanceVariable(Little.keywords.OBJECT_TYPE_PROPERTY_NAME, Little.keywords.TYPE_STRING, Little.keywords.TYPE_DYNAMIC, 'The name of this value\'s type, as a ${Little.keywords.TYPE_STRING}', 
			(value, address) -> {
				return Characters(value.type());
			}
		);
		Little.plugin.registerInstanceVariable(Little.keywords.OBJECT_ADDRESS_PROPERTY_NAME, POINTER_SIZE == 4 ? Little.keywords.TYPE_INT : Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_DYNAMIC, 'The address of this value',
			(value:InterpTokens, address:MemoryPointer) -> {
				return POINTER_SIZE == 4 ? Number(address.rawLocation) : Decimal(address.rawLocation);
			}
		);
	}

	/**
		Adds standard library operators.
	**/
	public static function addSigns() {

		// --------------------------------------------------
		// ------------------------RHS-----------------------
		// --------------------------------------------------

		Little.plugin.registerOperator("+", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			operatorType: RHS_ONLY,
			priority: "last",
			singleSidedOperatorCallback: (rhs) -> {
				var r = Conversion.toHaxeValue(rhs);
				if (r is Int)
					return Number(r);
				return Decimal(r);
			}
		});

		Little.plugin.registerOperator("-", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			operatorType: RHS_ONLY,
			priority: "with +_",
			singleSidedOperatorCallback: (rhs) -> {
				var r = Conversion.toHaxeValue(rhs);
				if (r is Int)
					return Number(-r);
				return Decimal(-r);
			}
		});

		Little.plugin.registerOperator("√", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			operatorType: RHS_ONLY,
			priority: "first",
			singleSidedOperatorCallback: (rhs) -> {
				var r:Float = Conversion.toHaxeValue(rhs);

				return Decimal(Math.sqrt(r));
			}
		});

		Little.plugin.registerOperator("!", {
			rhsAllowedTypes: [Little.keywords.TYPE_BOOLEAN],
			operatorType: RHS_ONLY,
			priority: "with +_",
			singleSidedOperatorCallback: (rhs) -> {
				var r = Conversion.toHaxeValue(rhs);

				return r ? FalseValue : TrueValue;
			}
		});

		// --------------------------------------------------
		// ------------------------LHS-----------------------
		// --------------------------------------------------

		Little.plugin.registerOperator("!", {
			lhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			operatorType: LHS_ONLY,
			priority: "with √_",
			singleSidedOperatorCallback: (lhs) -> {
				var l = Conversion.toHaxeValue(lhs);
				var shifted = Math.pow(10, 10) * l;
				if (shifted != Math.floor(shifted)) return Number(Math.round(MathTools.factorial(l)));
				return Decimal(MathTools.factorial(l));
			}
		});

		// --------------------------------------------------
		// ----------------------STANDARD--------------------
		// --------------------------------------------------

		Little.plugin.registerOperator("+", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT, Little.keywords.TYPE_STRING],
			lhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT, Little.keywords.TYPE_STRING],
			allowedTypeCombos: [{lhs: Little.keywords.TYPE_STRING, rhs: Little.keywords.TYPE_DYNAMIC}, {lhs: Little.keywords.TYPE_DYNAMIC, rhs: Little.keywords.TYPE_STRING}],
			priority: "with +_",
			callback: (lhs, rhs) -> {
				lhs = Interpreter.evaluate(lhs); rhs = Interpreter.evaluate(rhs);
				var l = Conversion.toHaxeValue(lhs),
					r = Conversion.toHaxeValue(rhs);
				if (l is String || r is String) {
					l ??= Little.keywords.NULL_VALUE; r ??= Little.keywords.NULL_VALUE;
					return Characters("" + l + r);
				}
				if (lhs.type() == Little.keywords.TYPE_INT && rhs.type() == Little.keywords.TYPE_INT)
					return Number(cast l + r);
				return Decimal(cast l + r);
			}
		});

		Little.plugin.registerOperator("-", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			lhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			allowedTypeCombos: [{lhs: Little.keywords.TYPE_STRING, rhs: Little.keywords.TYPE_STRING}],
			priority: "with +",
			callback: (lhs, rhs) -> {
				lhs = Interpreter.evaluate(lhs); rhs = Interpreter.evaluate(rhs);
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String) {
					l ??= Little.keywords.NULL_VALUE; r ??= Little.keywords.NULL_VALUE;
					return Characters(TextTools.subtract(l, r));
				}
				if (lhs.type() == Little.keywords.TYPE_INT && rhs.type() == Little.keywords.TYPE_INT)
					return Number(cast l - r);
				return Decimal(cast l - r);
			}
		});

		Little.plugin.registerOperator("*", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			lhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			allowedTypeCombos: [{lhs: Little.keywords.TYPE_STRING, rhs: Little.keywords.TYPE_INT}],
			priority: "between + √_",
			callback: (lhs, rhs) -> {
				lhs = Interpreter.evaluate(lhs); rhs = Interpreter.evaluate(rhs);
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String) {
					l ??= Little.keywords.NULL_VALUE;
					return Characters(TextTools.multiply(l, r));
				}
				if (lhs.type() == Little.keywords.TYPE_INT && rhs.type() == Little.keywords.TYPE_INT)
					return Number(cast l * r);
				return Decimal(l * r);
			}
		});

		Little.plugin.registerOperator("/", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			lhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			priority: "with *",
			callback: (lhs, rhs) -> {
				var l = Conversion.toHaxeValue(lhs),
					r = Conversion.toHaxeValue(rhs);
				if (r == 0)
					Little.runtime.throwError(ErrorMessage('Cannot divide by 0'));
				return Decimal(l / r);
			}
		});

		Little.plugin.registerOperator("^", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			lhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			priority: "before *",
			callback: (lhs, rhs) -> {
				lhs = Interpreter.evaluate(lhs); rhs = Interpreter.evaluate(rhs);
				var l = Conversion.toHaxeValue(lhs),
					r = Conversion.toHaxeValue(rhs);
				if (lhs.type() == Little.keywords.TYPE_INT && rhs.type() == Little.keywords.TYPE_INT)
					return Number(Math.pow(l, r).int());
				return Decimal(Math.pow(l, r));
			}
		});

		Little.plugin.registerOperator("√", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			lhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			priority: "with ^",
			callback: (lhs, rhs) -> {
				var l:Float = Conversion.toHaxeValue(lhs),
					r:Float = Conversion.toHaxeValue(rhs);
				var lPositive = l >= 0;
				var oddN = r % 2 == 1;
				if (!lPositive)
					l = -l;
				return Decimal(Math.pow(l * ((!lPositive && oddN) ? -1 : 1), 1 / r));
			}
		});

		// Boolean

		Little.plugin.registerOperator("&&", {
			rhsAllowedTypes: [Little.keywords.TYPE_BOOLEAN],
			lhsAllowedTypes: [Little.keywords.TYPE_BOOLEAN],
			priority: "last",
			callback: (lhs, rhs) -> Conversion.toHaxeValue(lhs) && Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue});

		Little.plugin.registerOperator("||", {
			rhsAllowedTypes: [Little.keywords.TYPE_BOOLEAN],
			lhsAllowedTypes: [Little.keywords.TYPE_BOOLEAN],
			priority: "with &&",
			callback: (lhs, rhs) -> Conversion.toHaxeValue(lhs) || Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue});

		Little.plugin.registerOperator("==", {
			priority: "last",
			callback: (lhs, rhs) -> Conversion.toHaxeValue(lhs) == Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue
		});

		Little.plugin.registerOperator("!=", {
			priority: "with ==",
			callback: (lhs, rhs) -> Conversion.toHaxeValue(lhs) != Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue
		});

		Little.plugin.registerOperator("^^", {
			rhsAllowedTypes: [Little.keywords.TYPE_BOOLEAN],
			lhsAllowedTypes: [Little.keywords.TYPE_BOOLEAN],
			priority: "with &&",
			callback: (lhs, rhs) -> Conversion.toHaxeValue(lhs) != Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue
		});

		Little.plugin.registerOperator(">", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			lhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			allowedTypeCombos: [{lhs: Little.keywords.TYPE_STRING, rhs: Little.keywords.TYPE_STRING}],
			priority: "with ==",
			callback: (lhs, rhs) -> {
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String)
					return l.length > r.length ? TrueValue : FalseValue;
				return l > r ? TrueValue : FalseValue;
			}
		});

		Little.plugin.registerOperator(">=", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			lhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			allowedTypeCombos: [{lhs: Little.keywords.TYPE_STRING, rhs: Little.keywords.TYPE_STRING}],
			priority: "with ==",
			callback: (lhs, rhs) -> {
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String)
					return l.length >= r.length ? TrueValue : FalseValue;
				return l >= r ? TrueValue : FalseValue;
			}
		});

		Little.plugin.registerOperator("<", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			lhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			allowedTypeCombos: [{lhs: Little.keywords.TYPE_STRING, rhs: Little.keywords.TYPE_STRING}],
			priority: "with ==",
			callback: (lhs, rhs) -> {
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String)
					return l.length < r.length ? TrueValue : FalseValue;
				return l < r ? TrueValue : FalseValue;
			}
		});

		Little.plugin.registerOperator("<=", {
			rhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			lhsAllowedTypes: [Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_INT],
			allowedTypeCombos: [{lhs: Little.keywords.TYPE_STRING, rhs: Little.keywords.TYPE_STRING}],
			priority: "with ==",
			callback: (lhs, rhs) -> {
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String)
					return l.length <= r.length ? TrueValue : FalseValue;
				return l <= r ? TrueValue : FalseValue;
			}
		});
	}

	/**
	    Adds standard library top-level conditions and loops.
	**/
	public static function addConditions() {
		Little.plugin.registerCondition("while", "A loop that executes code until the condition is not met", (params, body) -> {
			var val = NullValue;
			var safetyNet = 0;
			while (safetyNet < 500000) {
				var condition:Dynamic = Conversion.toHaxeValue(Interpreter.calculate(params));
				if (condition is Bool && condition) {
					val = Interpreter.run(body);
					safetyNet++;
				}
				else if (condition is Bool && !condition) {
					return val;
				} 
				else {
					Little.runtime.throwError(ErrorMessage('While condition must be a ${Little.keywords.TYPE_BOOLEAN} or ${Little.keywords.FALSE_VALUE}'), INTERPRETER);
					return val;
				}
			}
			if (safetyNet >= 500000) {
				Little.runtime.throwError(ErrorMessage('Too much iteration (is `${PrettyPrinter.stringifyInterpreter(params)}` forever `${Little.keywords.TRUE_VALUE}`?)'), INTERPRETER);
			}

			return val;
		});

		Little.plugin.registerCondition("if", "Executes the following block of code if the given condition is true.", (params, body) -> {
			var val = NullValue;
			var cond = Conversion.toHaxeValue(Interpreter.calculate(params));
			if (cond is Bool && cond) {
				val = Interpreter.run(body);
			}
			else if (!(cond is Bool)) {
				Little.runtime.throwError(ErrorMessage('If condition must be a ${Little.keywords.TYPE_BOOLEAN}'), INTERPRETER);
			}

			return val;
		});

		Little.plugin.registerCondition("for", "A loop that executes code while changing a variable, until it meets a condition", (params:Array<InterpTokens>, body) -> {
			var val = NullValue;

			var fp = [];
			// Incase one does `from (4 + 2)` and it accidentally parses a function
			for (p in params) {
				switch p {
					case FunctionCall(_.parameter(0) == Little.keywords.FOR_LOOP_FROM => true, params): {
						fp.push(Identifier(Little.keywords.FOR_LOOP_FROM));
						fp.push(Expression(params.parameter(0), null));
					}
					case FunctionCall(_.parameter(0) == Little.keywords.FOR_LOOP_TO => true, params): {
						fp.push(Identifier(Little.keywords.FOR_LOOP_TO));
						fp.push(Expression(params.parameter(0), null));
					}
					case FunctionCall(_.parameter(0) == Little.keywords.FOR_LOOP_JUMP => true, params): {
						fp.push(Identifier(Little.keywords.FOR_LOOP_JUMP));
						fp.push(Expression(params.parameter(0), null));
					}
					case FunctionCall(_.is(BLOCK) && [Little.keywords.FOR_LOOP_FROM, Little.keywords.FOR_LOOP_TO, Little.keywords.FOR_LOOP_JUMP].contains(Interpreter.evaluate(_).parameter(0)) => true, params): {
						fp.push(Identifier(Interpreter.evaluate(p.parameter(0) /*The Block*/).parameter(0)));
						fp.push(Expression(params.parameter(0), null));
					}
					case _: fp.push(p);
				}
			}

			params = fp;

			if (!params[0].is(VARIABLE_DECLARATION)) {
				Little.runtime.throwError(ErrorMessage('`for` loop must start with a variable to count on (expected definition/block, found: `${PrettyPrinter.stringifyInterpreter(params[0])}`)'));
				return val;
			}
			var typeName = (params[0].parameter(1) : InterpTokens).asJoinedStringPath();
			if (![Little.keywords.TYPE_INT, Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_DYNAMIC, Little.keywords.TYPE_UNKNOWN].contains(typeName)) {
				Little.runtime.throwError(ErrorMessage('`for` loop\'s variable must be of type ${Little.keywords.TYPE_INT}, ${Little.keywords.TYPE_FLOAT} or ${Little.keywords.TYPE_DYNAMIC} (given: ${typeName})'));
			}

			var from:Null<Float> = null, to:Null<Float> = null, jump:Float = 1;

			var currentExpression = [];
			var currentlySet:Int = -1; // 0 for FROM, 1 for TO, 2 for JUMP
			for (i in 1...params.length) {
				switch params[i] {
					case Identifier(_ == Little.keywords.FOR_LOOP_FROM => true): {
						if (currentExpression.length > 0) {
							switch currentlySet {
								case -1: Little.runtime.throwError(ErrorMessage('Invalid `for` loop syntax: expected a `${Little.keywords.FOR_LOOP_TO}`, `${Little.keywords.FOR_LOOP_FROM}` or `${Little.keywords.FOR_LOOP_JUMP}` after the variable'));
								case 0: Little.runtime.throwError(ErrorMessage('Cannot repeat `${Little.keywords.FOR_LOOP_FROM}` tag twice in `for` loop.'));
								case 1: to = Conversion.toHaxeValue(Interpreter.calculate(currentExpression));
								case 2: jump = Conversion.toHaxeValue(Interpreter.calculate(currentExpression));
							}
						}
						currentExpression = [];
						currentlySet = 0;
					}
					case Identifier(_ == Little.keywords.FOR_LOOP_TO => true): {
						if (currentExpression.length > 0) {
							switch currentlySet {
								case -1: Little.runtime.throwError(ErrorMessage('Invalid `for` loop syntax: expected a `${Little.keywords.FOR_LOOP_TO}`, `${Little.keywords.FOR_LOOP_FROM}` or `${Little.keywords.FOR_LOOP_JUMP}` after the variable'));
								case 0: from = Conversion.toHaxeValue(Interpreter.calculate(currentExpression));
								case 1: Little.runtime.throwError(ErrorMessage('Cannot repeat `${Little.keywords.FOR_LOOP_TO}` tag twice in `for` loop.'));
								case 2: jump = Conversion.toHaxeValue(Interpreter.calculate(currentExpression));
							}
						}
						currentExpression = [];
						currentlySet = 1;
					}
					case Identifier(_ == Little.keywords.FOR_LOOP_JUMP => true): {
						if (currentExpression.length > 0) {
							switch currentlySet {
								case -1: Little.runtime.throwError(ErrorMessage('Invalid `for` loop syntax: expected a `${Little.keywords.FOR_LOOP_TO}`, `${Little.keywords.FOR_LOOP_FROM}` or `${Little.keywords.FOR_LOOP_JUMP}` after the variable'));
								case 0: from = Conversion.toHaxeValue(Interpreter.calculate(currentExpression));
								case 1: to = Conversion.toHaxeValue(Interpreter.calculate(currentExpression));
								case 2: Little.runtime.throwError(ErrorMessage('Cannot repeat `${Little.keywords.FOR_LOOP_JUMP}` tag twice in `for` loop.'));
							}
						}
						currentExpression = [];
						currentlySet = 2;
					}
					case _: currentExpression.push(params[i]);
				}
			}
			switch currentlySet {
				case -1: Little.runtime.throwError(ErrorMessage('Invalid `for` loop syntax: expected a `${Little.keywords.FOR_LOOP_TO}`, `${Little.keywords.FOR_LOOP_FROM}` or `${Little.keywords.FOR_LOOP_JUMP}` after the variable'));
				case 0: Little.runtime.throwError(ErrorMessage('Cannot repeat `${Little.keywords.FOR_LOOP_FROM}` tag twice in `for` loop.'));
				case 1: to = Conversion.toHaxeValue(Interpreter.calculate(currentExpression));
				case 2: jump = Conversion.toHaxeValue(Interpreter.calculate(currentExpression));
			}

			jump ??= 1;
			if (from < to) {
				while (from < to) {
					val = Interpreter.run([
						Write([params[0]], Conversion.toLittleValue(from))
					].concat(body));
					from += jump;
				}
			} else {
				while (from > to) {
					val = Interpreter.run([
						Write([params[0]], Conversion.toLittleValue(from))
					].concat(body));
					from -= jump;
				}
			}
			

			return val;
		});

		Little.plugin.registerCondition("after", (params:Array<InterpTokens>, body:Array<InterpTokens>) -> {
			var val = NullValue;
			var ident:String = "";
			if (params[0].is(BLOCK)) {
				var output = Interpreter.run(params[0].parameter(0));
				Interpreter.assert(output, [IDENTIFIER, PROPERTY_ACCESS], '`after` condition that starts with a code block must have it\'s code block return an identifier using the `${Little.keywords.READ_FUNCTION_NAME}` function (returned: ${PrettyPrinter.stringifyInterpreter(output)})');
				ident = output.asJoinedStringPath();
				params[0] = output;
			} else if (params[0].is(IDENTIFIER, PROPERTY_ACCESS)) {
				ident = params[0].extractIdentifier();
			} else {
				Little.runtime.throwError(ErrorMessage('`after` condition must start with a variable to watch (expected definition, found: `${PrettyPrinter.stringifyInterpreter(params[0])}`)'));
				return val;
			}

			/**
				Listens for when `ident` is written to.
			**/
			function listener(setIdentifiers:Array<String>) {
				var cond:Bool = Conversion.toHaxeValue(Interpreter.calculate(params));
				if (setIdentifiers.contains(ident) && cond) {
					Interpreter.run(body);
					Little.runtime.onWriteValue.remove(listener);
				}
			}
			
			Little.runtime.onWriteValue.push(listener);

			return val;
		});

		Little.plugin.registerCondition("whenever", (params:Array<InterpTokens>, body:Array<InterpTokens>) -> {
			var val = NullValue;
			var ident:String = "";
			if (params[0].is(BLOCK)) {
				var output = Interpreter.evaluate(params[0]);
				Interpreter.assert(output, [IDENTIFIER, PROPERTY_ACCESS], '`whenever` condition that starts with a code block must have it\'s code block return a `${Little.keywords.TYPE_STRING}` (returned: ${PrettyPrinter.stringifyInterpreter(output)})');
				ident = Conversion.toHaxeValue(output);
			} else if (params[0].is(IDENTIFIER, PROPERTY_ACCESS)) {
				ident = params[0].extractIdentifier();
			} else {
				Little.runtime.throwError(ErrorMessage('`whenever` condition must start with a variable to watch (expected definition, found: `${PrettyPrinter.stringifyInterpreter(params[0])}`)'));
				return val;
			}
			/**
				Listens for when `ident` is written to.
			**/
			function listener(setIdentifiers:Array<String>) {
				var cond:Bool = Conversion.toHaxeValue(Interpreter.calculate(params));
				if (setIdentifiers.contains(ident) && cond) {
					Interpreter.run(body);
				}
			}
			
			Little.runtime.onWriteValue.push(listener);

			return val;
		});
	}
}
