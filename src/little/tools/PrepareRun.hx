package little.tools;

import little.interpreter.memory.MemoryPointer;
import little.interpreter.memory.MemoryPointer.POINTER_SIZE;
import little.interpreter.Operators;
import haxe.Json;
import haxe.xml.Access;
import little.interpreter.Actions;
import vision.tools.MathTools;
import little.lexer.Lexer;
import little.parser.Parser;
import little.interpreter.Interpreter;
import little.interpreter.Runtime;
import little.interpreter.Tokens;

using Std;
using little.tools.TextTools;
using little.tools.Extensions;

import little.Keywords.*;


@:access(little.interpreter.Operators)
@:access(little.interpreter.Runtime)
class PrepareRun {
	public static var prepared:Bool = false;

	public static function addTypes() {}
		
	public static function addFunctions() {
		Little.plugin.registerFunction(PRINT_FUNCTION_NAME, null, [VariableDeclaration(Identifier("item"), null)], (params) -> {
			var eval = Actions.evaluate(params[0]);
			Runtime.__print(PrettyPrinter.stringifyInterpreter(eval), eval);
			return NullValue;
		}, Little.keywords.TYPE_DYNAMIC);
		Little.plugin.registerFunction(RAISE_ERROR_FUNCTION_NAME, null, [VariableDeclaration(Identifier("message"), null)], (params) -> {
			Runtime.throwError(params[0]);
			return NullValue;
		}, Little.keywords.TYPE_DYNAMIC);
		Little.plugin.registerFunction(READ_FUNCTION_NAME, null, [VariableDeclaration(Identifier("identifier"), Identifier(TYPE_STRING))], (params) -> {
			return Identifier(Conversion.toHaxeValue(params[0]));
		}, Little.keywords.TYPE_DYNAMIC);
		Little.plugin.registerFunction(RUN_CODE_FUNCTION_NAME, null, [VariableDeclaration(Identifier("code"), Identifier(TYPE_STRING))], (params) -> {
			return Actions.run(Interpreter.convert(...Parser.parse(Lexer.lex(Conversion.toHaxeValue(params[0])))));
		}, Little.keywords.TYPE_DYNAMIC);
	}

	public static function addProps() {
		Little.plugin.registerInstanceVariable(OBJECT_TYPE_PROPERTY_NAME, TYPE_DYNAMIC, 'The name of this value\'s type, as a $TYPE_STRING', 
			(value, address) -> {
				return Characters(value.type());
			}
		);
		Little.plugin.registerInstanceVariable(OBJECT_ADDRESS_PROPERTY_NAME, TYPE_DYNAMIC, 'The address of this value',
			(value:InterpTokens, address:MemoryPointer) -> {
				return POINTER_SIZE == 4 ? Number(address.rawLocation) : Decimal(address.rawLocation);
			}
		);
	}

	public static function addSigns() {

		// --------------------------------------------------
		// ------------------------RHS-----------------------
		// --------------------------------------------------

		Little.plugin.registerSign("+", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			operatorType: RHS_ONLY,
			priority: "last",
			singleSidedOperatorCallback: (rhs) -> {
				var r = Conversion.toHaxeValue(rhs);
				if (r is Int)
					return Number(r);
				return Decimal(r);
			}
		});

		Little.plugin.registerSign("-", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			operatorType: RHS_ONLY,
			priority: "with +_",
			singleSidedOperatorCallback: (rhs) -> {
				var r = Conversion.toHaxeValue(rhs);
				if (r is Int)
					return Number(-r);
				return Decimal(-r);
			}
		});

		Little.plugin.registerSign("√", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			operatorType: RHS_ONLY,
			priority: "first",
			singleSidedOperatorCallback: (rhs) -> {
				var r:Float = Conversion.toHaxeValue(rhs);

				return Decimal(Math.sqrt(r));
			}
		});

		Little.plugin.registerSign("!", {
			rhsAllowedTypes: [TYPE_BOOLEAN],
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

		Little.plugin.registerSign("!", {
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
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

		Little.plugin.registerSign("+", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT, TYPE_STRING],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT, TYPE_STRING],
			allowedTypeCombos: [{lhs: TYPE_STRING, rhs: TYPE_DYNAMIC}, {lhs: TYPE_DYNAMIC, rhs: TYPE_STRING}],
			priority: "with +_",
			callback: (lhs, rhs) -> {
				lhs = Actions.evaluate(lhs); rhs = Actions.evaluate(rhs);
				var l = Conversion.toHaxeValue(lhs),
					r = Conversion.toHaxeValue(rhs);
				if (l is String || r is String) {
					l ??= Little.keywords.NULL_VALUE; r ??= Little.keywords.NULL_VALUE;
					return Characters("" + l + r);
				}
				if (lhs.type() == TYPE_INT && rhs.type() == TYPE_INT)
					return Number(cast l + r);
				return Decimal(cast l + r);
			}
		});

		Little.plugin.registerSign("-", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			allowedTypeCombos: [{lhs: TYPE_STRING, rhs: TYPE_STRING}],
			priority: "with +",
			callback: (lhs, rhs) -> {
				lhs = Actions.evaluate(lhs); rhs = Actions.evaluate(rhs);
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String) {
					l ??= Little.keywords.NULL_VALUE; r ??= Little.keywords.NULL_VALUE;
					return Characters(TextTools.subtract(l, r));
				}
				if (lhs.type() == TYPE_INT && rhs.type() == TYPE_INT)
					return Number(cast l - r);
				return Decimal(cast l - r);
			}
		});

		Little.plugin.registerSign("*", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			allowedTypeCombos: [{lhs: TYPE_STRING, rhs: TYPE_INT}],
			priority: "between + √_",
			callback: (lhs, rhs) -> {
				lhs = Actions.evaluate(lhs); rhs = Actions.evaluate(rhs);
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String) {
					l ??= Little.keywords.NULL_VALUE;
					return Characters(TextTools.multiply(l, r));
				}
				if (lhs.type() == TYPE_INT && rhs.type() == TYPE_INT)
					return Number(cast l * r);
				return Decimal(l * r);
			}
		});

		Little.plugin.registerSign("/", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			priority: "with *",
			callback: (lhs, rhs) -> {
				var l = Conversion.toHaxeValue(lhs),
					r = Conversion.toHaxeValue(rhs);
				if (r == 0)
					Runtime.throwError(ErrorMessage('Cannot divide by 0'));
				return Decimal(l / r);
			}
		});

		Little.plugin.registerSign("^", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			priority: "before *",
			callback: (lhs, rhs) -> {
				lhs = Actions.evaluate(lhs); rhs = Actions.evaluate(rhs);
				var l = Conversion.toHaxeValue(lhs),
					r = Conversion.toHaxeValue(rhs);
				if (lhs.type() == TYPE_INT && rhs.type() == TYPE_INT)
					return Number(Math.pow(l, r).int());
				return Decimal(Math.pow(l, r));
			}
		});

		Little.plugin.registerSign("√", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
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

		Little.plugin.registerSign("&&", {
			rhsAllowedTypes: [TYPE_BOOLEAN],
			lhsAllowedTypes: [TYPE_BOOLEAN],
			priority: "last",
			callback: (lhs, rhs) -> Conversion.toHaxeValue(lhs) && Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue});

		Little.plugin.registerSign("||", {
			rhsAllowedTypes: [TYPE_BOOLEAN],
			lhsAllowedTypes: [TYPE_BOOLEAN],
			priority: "with &&",
			callback: (lhs, rhs) -> Conversion.toHaxeValue(lhs) || Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue});

		Little.plugin.registerSign("==", {
			priority: "last",
			callback: (lhs, rhs) -> Conversion.toHaxeValue(lhs) == Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue
		});

		Little.plugin.registerSign("!=", {
			priority: "with ==",
			callback: (lhs, rhs) -> Conversion.toHaxeValue(lhs) != Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue
		});

		Little.plugin.registerSign("^^", {
			rhsAllowedTypes: [TYPE_BOOLEAN],
			lhsAllowedTypes: [TYPE_BOOLEAN],
			priority: "with &&",
			callback: (lhs, rhs) -> Conversion.toHaxeValue(lhs) != Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue
		});

		Little.plugin.registerSign(">", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			allowedTypeCombos: [{lhs: TYPE_STRING, rhs: TYPE_STRING}],
			priority: "with ==",
			callback: (lhs, rhs) -> {
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String)
					return l.length > r.length ? TrueValue : FalseValue;
				return l > r ? TrueValue : FalseValue;
			}
		});

		Little.plugin.registerSign(">=", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			allowedTypeCombos: [{lhs: TYPE_STRING, rhs: TYPE_STRING}],
			priority: "with ==",
			callback: (lhs, rhs) -> {
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String)
					return l.length >= r.length ? TrueValue : FalseValue;
				return l >= r ? TrueValue : FalseValue;
			}
		});

		Little.plugin.registerSign("<", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			allowedTypeCombos: [{lhs: TYPE_STRING, rhs: TYPE_STRING}],
			priority: "with ==",
			callback: (lhs, rhs) -> {
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String)
					return l.length < r.length ? TrueValue : FalseValue;
				return l < r ? TrueValue : FalseValue;
			}
		});

		Little.plugin.registerSign("<=", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			allowedTypeCombos: [{lhs: TYPE_STRING, rhs: TYPE_STRING}],
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

	public static function addConditions() {
		Little.plugin.registerCondition("while", "A loop that executes code until the condition is not met", (params, body) -> {
			var val = NullValue;
			var safetyNet = 0;
			while (safetyNet < 500000) {
				var condition:Dynamic = Conversion.toHaxeValue(Actions.calculate(params));
				if (condition is Bool && condition) {
					val = Actions.run(body);
					safetyNet++;
				}
				else if (condition is Bool && !condition) {
					return val;
				} 
				else {
					Runtime.throwError(ErrorMessage('While condition must be a ${Little.keywords.TYPE_BOOLEAN} or ${Little.keywords.FALSE_VALUE}'), INTERPRETER);
					return val;
				}
			}
			if (safetyNet >= 500000) {
				Runtime.throwError(ErrorMessage('Too much iteration (is `${PrettyPrinter.stringifyInterpreter(params)}` forever `${Little.keywords.TRUE_VALUE}`?)'), INTERPRETER);
			}

			return val;
		});

		Little.plugin.registerCondition("if", "Executes the following block of code if the given condition is true.", (params, body) -> {
			var val = NullValue;
			var cond = Conversion.toHaxeValue(Actions.calculate(params));
			if (cond is Bool && cond) {
				val = Actions.run(body);
			}
			else if (!(cond is Bool)) {
				Runtime.throwError(ErrorMessage('If condition must be a ${Little.keywords.TYPE_BOOLEAN}'), INTERPRETER);
			}

			return val;
		});

		Little.plugin.registerCondition("for", "A loop that executes code while changing a variable, until it meets a condition", (params:Array<InterpTokens>, body) -> {
			var val = NullValue;

			var fp = [];
			// Incase one does `from (4 + 2)` and it accidentally parses a function
			for (p in params) {
				switch p {
					case FunctionCall(_.parameter(0) == FOR_LOOP_FROM => true, params): {
						fp.push(Identifier(FOR_LOOP_FROM));
						fp.push(Expression(params.parameter(0), null));
					}
					case FunctionCall(_.parameter(0) == FOR_LOOP_TO => true, params): {
						fp.push(Identifier(FOR_LOOP_TO));
						fp.push(Expression(params.parameter(0), null));
					}
					case FunctionCall(_.parameter(0) == FOR_LOOP_JUMP => true, params): {
						fp.push(Identifier(FOR_LOOP_JUMP));
						fp.push(Expression(params.parameter(0), null));
					}
					case FunctionCall(_.is(BLOCK) && [FOR_LOOP_FROM, FOR_LOOP_TO, FOR_LOOP_JUMP].contains(Actions.evaluate(_).parameter(0)) => true, params): {
						fp.push(Identifier(Actions.evaluate(p.parameter(0) /*The Block*/).parameter(0)));
						fp.push(Expression(params.parameter(0), null));
					}
					case _: fp.push(p);
				}
			}

			params = fp;

			if (!params[0].is(VARIABLE_DECLARATION)) {
				Runtime.throwError(ErrorMessage('`for` loop must start with a variable to count on (expected definition/block, found: `${PrettyPrinter.stringifyInterpreter(params[0])}`)'));
				return val;
			}
			var typeName = (params[0].parameter(1) : InterpTokens).asJoinedStringPath();
			if (![Little.keywords.TYPE_INT, Little.keywords.TYPE_FLOAT, Little.keywords.TYPE_DYNAMIC].contains(typeName)) {
				Runtime.throwError(ErrorMessage('`for` loop\'s variable must be of type ${Little.keywords.TYPE_INT}, ${Little.keywords.TYPE_FLOAT} or ${Little.keywords.TYPE_DYNAMIC} (given: ${typeName})'));
			}

			var from:Null<Float> = null, to:Null<Float> = null, jump:Float = 1;

			var currentExpression = [];
			var currentlySet:Int = -1; // 0 for FROM, 1 for TO, 2 for JUMP
			for (i in 1...params.length) {
				switch params[i] {
					case Identifier(_ == FOR_LOOP_FROM => true): {
						if (currentExpression.length > 0) {
							switch currentlySet {
								case -1: Runtime.throwError(ErrorMessage('Invalid `for` loop syntax: expected a `${Little.keywords.FOR_LOOP_TO}`, `${Little.keywords.FOR_LOOP_FROM}` or `${Little.keywords.FOR_LOOP_JUMP}` after the variable'));
								case 0: Runtime.throwError(ErrorMessage('Cannot repeat `$FOR_LOOP_FROM` tag twice in `for` loop.'));
								case 1: to = Conversion.toHaxeValue(Actions.calculate(currentExpression));
								case 2: jump = Conversion.toHaxeValue(Actions.calculate(currentExpression));
							}
						}
						currentExpression = [];
						currentlySet = 0;
					}
					case Identifier(_ == FOR_LOOP_TO => true): {
						if (currentExpression.length > 0) {
							switch currentlySet {
								case -1: Runtime.throwError(ErrorMessage('Invalid `for` loop syntax: expected a `${Little.keywords.FOR_LOOP_TO}`, `${Little.keywords.FOR_LOOP_FROM}` or `${Little.keywords.FOR_LOOP_JUMP}` after the variable'));
								case 0: from = Conversion.toHaxeValue(Actions.calculate(currentExpression));
								case 1: Runtime.throwError(ErrorMessage('Cannot repeat `$FOR_LOOP_TO` tag twice in `for` loop.'));
								case 2: jump = Conversion.toHaxeValue(Actions.calculate(currentExpression));
							}
						}
						currentExpression = [];
						currentlySet = 1;
					}
					case Identifier(_ == FOR_LOOP_JUMP => true): {
						if (currentExpression.length > 0) {
							switch currentlySet {
								case -1: Runtime.throwError(ErrorMessage('Invalid `for` loop syntax: expected a `${Little.keywords.FOR_LOOP_TO}`, `${Little.keywords.FOR_LOOP_FROM}` or `${Little.keywords.FOR_LOOP_JUMP}` after the variable'));
								case 0: from = Conversion.toHaxeValue(Actions.calculate(currentExpression));
								case 1: to = Conversion.toHaxeValue(Actions.calculate(currentExpression));
								case 2: Runtime.throwError(ErrorMessage('Cannot repeat `$FOR_LOOP_JUMP` tag twice in `for` loop.'));
							}
						}
						currentExpression = [];
						currentlySet = 2;
					}
					case _: currentExpression.push(params[i]);
				}
			}
			switch currentlySet {
				case -1: Runtime.throwError(ErrorMessage('Invalid `for` loop syntax: expected a `${Little.keywords.FOR_LOOP_TO}`, `${Little.keywords.FOR_LOOP_FROM}` or `${Little.keywords.FOR_LOOP_JUMP}` after the variable'));
				case 0: Runtime.throwError(ErrorMessage('Cannot repeat `$FOR_LOOP_FROM` tag twice in `for` loop.'));
				case 1: to = Conversion.toHaxeValue(Actions.calculate(currentExpression));
				case 2: jump = Conversion.toHaxeValue(Actions.calculate(currentExpression));
			}

			jump ??= 1;
			if (from < to) {
				while (from < to) {
					val = Actions.run([
						Write([params[0]], Conversion.toLittleValue(from))
					].concat(body));
					from += jump;
				}
			} else {
				while (from > to) {
					val = Actions.run([
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
				var output = Actions.evaluate(params[0]);
				Actions.assert(output, CHARACTERS, '`after` condition that starts with a code block must have it\'s code block return a `${Little.keywords.TYPE_STRING}` (returned: ${PrettyPrinter.stringifyInterpreter(output)})');
				ident = Conversion.toHaxeValue(output);
			} else if (params[0].is(IDENTIFIER, PROPERTY_ACCESS)) {
				ident = params[0].extractIdentifier();
			} else {
				Runtime.throwError(ErrorMessage('`after` condition must start with a variable to watch (expected definition, found: `${PrettyPrinter.stringifyInterpreter(params[0])}`)'));
				return val;
			}

			function listener(setIdentifiers:Array<String>) {
				var cond:Bool = Conversion.toHaxeValue(Actions.calculate(params));
				if (setIdentifiers.contains(ident) && cond) {
					Actions.run(body);
					Runtime.onWriteValue.remove(listener);
				}
			}
			
			Runtime.onWriteValue.push(listener);

			return val;
		});

		Little.plugin.registerCondition("whenever", (params:Array<InterpTokens>, body:Array<InterpTokens>) -> {
			var val = NullValue;
			var ident:String = "";
			if (params[0].is(BLOCK)) {
				var output = Actions.evaluate(params[0]);
				Actions.assert(output, CHARACTERS, '`whenever` condition that starts with a code block must have it\'s code block return a `${Little.keywords.TYPE_STRING}` (returned: ${PrettyPrinter.stringifyInterpreter(output)})');
				ident = Conversion.toHaxeValue(output);
			} else if (params[0].is(IDENTIFIER, PROPERTY_ACCESS)) {
				ident = params[0].extractIdentifier();
			} else {
				Runtime.throwError(ErrorMessage('`whenever` condition must start with a variable to watch (expected definition, found: `${PrettyPrinter.stringifyInterpreter(params[0])}`)'));
				return val;
			}

			function listener(setIdentifiers:Array<String>) {
				var cond:Bool = Conversion.toHaxeValue(Actions.calculate(params));
				if (setIdentifiers.contains(ident) && cond) {
					Actions.run(body);
				}
			}
			
			Runtime.onWriteValue.push(listener);

			return val;
		});
	}
}
