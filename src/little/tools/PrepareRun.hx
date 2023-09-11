package little.tools;

import vision.tools.MathTools;
import little.interpreter.memory.MemoryTree;
import little.lexer.Lexer;
import little.parser.Parser;
import little.interpreter.Interpreter;
import little.interpreter.Runtime;
import little.parser.Tokens;
import little.interpreter.memory.MemoryObject;

using Std;
using little.tools.TextTools;

import little.Keywords.*;

class PrepareRun {
	public static var prepared:Bool = false;

	public static function addTypes() {
		Little.plugin.registerHaxeClass(Data.getClassInfo("Math"));
		Little.plugin.registerHaxeClass(Data.getClassInfo("String"), TYPE_STRING);
		Little.plugin.registerHaxeClass(Data.getClassInfo("Array"), "Array"); // Experimental
		Interpreter.memory.set(TYPE_DYNAMIC, new MemoryObject(Module(TYPE_DYNAMIC), [], null, Identifier(TYPE_MODULE), true));
		Interpreter.memory.set(TYPE_INT, new MemoryObject(Module(TYPE_INT), [], null, Identifier(TYPE_MODULE), true));
		Interpreter.memory.set(TYPE_FLOAT, new MemoryObject(Module(TYPE_FLOAT), [], null, Identifier(TYPE_MODULE), true));
		Interpreter.memory.set(TYPE_BOOLEAN, new MemoryObject(Module(TYPE_INT), [], null, Identifier(TYPE_BOOLEAN), true));
	}

	public static function addProps() {
		Little.plugin.registerProperty("type", TYPE_DYNAMIC, true, null, {
			valueGetter: parent -> {
				trace(parent.value);
				return Characters(Interpreter.stringifyTokenIdentifier(if (parent.value != null && !parent.value.equals(NullValue))
					Interpreter.getValueType(parent.value) else if (parent.type != null
					|| !parent.type.equals(NullValue)) parent.type else Identifier(TYPE_VOID)));
			},
			allowWriting: false
		});

		Little.plugin.registerProperty("documentation", TYPE_DYNAMIC, true, null, {
			valueGetter: parent -> {
				return Characters(parent.documentation);
			},
			allowWriting: false
		});

		// Froms & Tos:

		// Int
		Little.plugin.registerProperty('$TO$TYPE_FLOAT', TYPE_INT, true, {
			expectedParameters: [],
			callback: (parent, params) -> {
				var val = parent.value;
				switch val {
					case NullValue: TypeDeclaration(NullValue, Identifier(TYPE_FLOAT));
					case _: Decimal(val.getParameters()[0]);
				}
			}
		});
		Little.plugin.registerProperty('$TO$TYPE_BOOLEAN', TYPE_INT, true, {
			expectedParameters: [],
			callback: (parent, params) -> {
				var val = parent.value;
				switch val {
					case NullValue | Number(_.parseInt() == 0 => true): FalseValue;
					case _: TrueValue;
				}
			}
		});
		Little.plugin.registerProperty('$TO$TYPE_STRING', TYPE_INT, true, {
			expectedParameters: [],
			callback: (parent, params) -> {
				var val = parent.value;
				trace(val);
				switch val {
					case NullValue: TypeDeclaration(NullValue, Identifier(TYPE_STRING));
					case _: Characters(val.getParameters()[0]);
				}
			}
		});
	}

	public static function addFunctions() {
		Little.plugin.registerFunction(PRINT_FUNCTION_NAME, null, [Variable(Identifier("item"), null)], (params) -> {
			var t = if (params[0].getParameters()[0].length == 1) params[0].getParameters()[0][0] else params[0];
			Runtime.print(Interpreter.stringifyTokenValue(Interpreter.evaluate(t)));
			return NullValue;
		});
		Little.plugin.registerFunction(RAISE_ERROR_FUNCTION_NAME, null, [Variable(Identifier("message"), null)], (params) -> {
			Runtime.throwError(Interpreter.evaluate(params[0]));
			return NullValue;
		});
		Little.plugin.registerFunction(READ_FUNCTION_NAME, null, [Variable(Identifier("string"), Identifier(TYPE_STRING))], (params) -> {
			return Read(Identifier(Interpreter.stringifyTokenValue(params[0])));
		});
		Little.plugin.registerFunction(RUN_CODE_FUNCTION_NAME, null, [Variable(Identifier("code"), Identifier(TYPE_STRING))], (params) -> {
			return Interpreter.interpret(Parser.parse(Lexer.lex(params[0].getParameters()[0])), Interpreter.currentConfig);
		});
	}

	public static function addSigns() {
		// --------------------------------------------------
		// ------------------------RHS-----------------------
		// --------------------------------------------------

		Little.plugin.registerSign("+", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			operatorType: RHS_ONLY,
			singleSidedOperatorCallback: (rhs) -> {
				var r = Conversion.toHaxeValue(rhs);
				if (r is Int)
					return Number(r + "");
				return Decimal(r + "");
			}
		});

		Little.plugin.registerSign("-", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			operatorType: RHS_ONLY,
			singleSidedOperatorCallback: (rhs) -> {
				var r = Conversion.toHaxeValue(rhs);
				if (r is Int)
					return Number(-r + "");
				return Decimal(-r + "");
			}
		});

		Little.plugin.registerSign("√", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			operatorType: RHS_ONLY,
			singleSidedOperatorCallback: (rhs) -> {
				var r:Float = Conversion.toHaxeValue(rhs);

				return Decimal(Math.sqrt(r) + "");
			}
		});

		// --------------------------------------------------
		// ------------------------LHS-----------------------
		// --------------------------------------------------

		Little.plugin.registerSign("!", {
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			operatorType: LHS_ONLY,
			singleSidedOperatorCallback: (lhs) -> {
				var l = Conversion.toHaxeValue(lhs);

				return Decimal(MathTools.factorial(l) + "");
			}
		});

		// --------------------------------------------------
		// ----------------------STANDARD--------------------
		// --------------------------------------------------

		Little.plugin.registerSign("+", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT, TYPE_STRING],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT, TYPE_STRING],
			callback: (rhs, lhs) -> {
				var l = Conversion.toHaxeValue(lhs),
					r = Conversion.toHaxeValue(rhs);
				if (l is String || r is String)
					return Characters(cast(l + r));
				if (l is Int && r is Int)
					return Number(l + r + "");
				return Decimal(l + r + "");
			}
		});

		Little.plugin.registerSign("-", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			allowedTypeCombos: [{lhs: TYPE_STRING, rhs: TYPE_STRING}],
			callback: (rhs, lhs) -> {
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String)
					return Characters(TextTools.subtract(l, r));
				if (l is Int && r is Int)
					return Number(l - r + "");
				return Decimal(l - r + "");
			}
		});

		Little.plugin.registerSign("*", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			allowedTypeCombos: [{lhs: TYPE_STRING, rhs: TYPE_INT}],
			callback: (rhs, lhs) -> {
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String)
					return Characters(TextTools.multiply(l, r));
				if (l is Int && r is Int)
					return Number(l * r + "");
				return Decimal(l * r + "");
			}
		});

		Little.plugin.registerSign("/", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			callback: (rhs, lhs) -> {
				var l = Conversion.toHaxeValue(lhs),
					r = Conversion.toHaxeValue(rhs);
				if (r == 0)
					Runtime.throwError(ErrorMessage('Cannot divide by 0 ${if (rhs.getName() == "Number" || rhs.getName() == "Decimal") "" else '(${PrettyPrinter.stringify(rhs)} is 0)'}'));
				return Decimal(l / r + "");
			}
		});

		Little.plugin.registerSign("^", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			callback: (rhs, lhs) -> {
				var l = Conversion.toHaxeValue(lhs),
					r = Conversion.toHaxeValue(rhs);
				if (l is Int && r is Int)
					return Number(Math.pow(l, r) + "");
				return Decimal(Math.pow(l, r) + "");
			}
		});

		Little.plugin.registerSign("√", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			callback: (rhs, lhs) -> {
				var l:Float = Conversion.toHaxeValue(lhs),
					r:Float = Conversion.toHaxeValue(rhs);
				var lPositive = l >= 0;
				var oddN = r % 2 == 1;
				if (!lPositive)
					l = -l;
				return Decimal(Math.pow(l * ((!lPositive && oddN) ? -1 : 1), 1 / r) + "");
			}
		});

		// Boolean

		Little.plugin.registerSign("&&", {
			rhsAllowedTypes: [TYPE_BOOLEAN],
			lhsAllowedTypes: [TYPE_BOOLEAN],
			callback: (rhs, lhs) -> Conversion.toHaxeValue(lhs) && Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue});

		Little.plugin.registerSign("||", {
			rhsAllowedTypes: [TYPE_BOOLEAN],
			lhsAllowedTypes: [TYPE_BOOLEAN],
			callback: (rhs, lhs) -> Conversion.toHaxeValue(lhs) || Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue});

		Little.plugin.registerSign("==", {
			callback: (rhs, lhs) -> Conversion.toHaxeValue(lhs) == Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue
		});

		Little.plugin.registerSign("!=", {
			callback: (rhs, lhs) -> Conversion.toHaxeValue(lhs) != Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue
		});

		Little.plugin.registerSign("^^", {
			rhsAllowedTypes: [TYPE_BOOLEAN],
			lhsAllowedTypes: [TYPE_BOOLEAN],
			callback: (rhs, lhs) -> Conversion.toHaxeValue(lhs) != Conversion.toHaxeValue(rhs) ? TrueValue : FalseValue
		});

		Little.plugin.registerSign(">", {
			rhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			lhsAllowedTypes: [TYPE_FLOAT, TYPE_INT],
			allowedTypeCombos: [{lhs: TYPE_STRING, rhs: TYPE_STRING}],
			callback: (rhs, lhs) -> {
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
			callback: (rhs, lhs) -> {
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
			callback: (rhs, lhs) -> {
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
			callback: (rhs, lhs) -> {
				var l:Dynamic = Conversion.toHaxeValue(lhs),
					r:Dynamic = Conversion.toHaxeValue(rhs);
				if (l is String)
					return l.length <= r.length ? TrueValue : FalseValue;
				return l <= r ? TrueValue : FalseValue;
			}
		});
	}

	public static function addConditions() {
		Little.plugin.registerCondition("while", [Variable(Identifier("rule"), Identifier(Keywords.TYPE_BOOLEAN))], (params, body) -> {
			var val = NullValue;
			var safetyNet = 0;
			while (Conversion.toHaxeValue(Interpreter.evaluateExpressionParts(params)) && safetyNet < 500000) {
				val = Interpreter.interpret(body, Interpreter.currentConfig);
				safetyNet++;
			}
			if (safetyNet >= 500000) {
				Runtime.throwError(ErrorMessage('Too much iteration (is `${PrettyPrinter.stringify(params)}` forever `$TRUE_VALUE`?)'), INTERPRETER);
			}
			return val;
		});

		Little.plugin.registerCondition("if", [Variable(Identifier("rule"), Identifier(Keywords.TYPE_BOOLEAN))], (params, body) -> {
			var val = NullValue;
			trace(params, body);
			if (Conversion.toHaxeValue(Interpreter.evaluateExpressionParts(params))) {
				val = Interpreter.interpret(body, Interpreter.currentConfig);
			}

			return val;
		});

		Little.plugin.registerCondition("for", (params:Array<ParserTokens>, body) -> {
			var val = NullValue;

			var fp = [];

			// Incase one does `from (4 + 2)` and it accidentally parses a function
			for (p in params) {
				switch p {
					case FunctionCall(_.getParameters()[0] == FOR_LOOP_IDENTIFIERS.FROM => true, params): {
							fp.push(Identifier(FOR_LOOP_IDENTIFIERS.FROM));
							fp.push(Expression(params.getParameters()[0], null));
						}
					case FunctionCall(_.getParameters()[0] == FOR_LOOP_IDENTIFIERS.TO => true, params): {
							fp.push(Identifier(FOR_LOOP_IDENTIFIERS.TO));
							fp.push(Expression(params.getParameters()[0], null));
						}
					case FunctionCall(_.getParameters()[0] == FOR_LOOP_IDENTIFIERS.JUMP => true, params): {
							fp.push(Identifier(FOR_LOOP_IDENTIFIERS.JUMP));
							fp.push(Expression(params.getParameters()[0], null));
						}
					case _: fp.push(p);
				}
			}

			params = fp;

			var handle = Interpreter.accessObject(params[0]);
			if (handle == null) {
				Runtime.throwError(ErrorMessage('`for` loop must start with a variable to count on (expected definition/block, found: `${params[0]}`)'));
				return val;
			}

			var from:Null<Float> = null, to:Null<Float> = null, jump:Float = 1;

			function parserForLoop(token:ParserTokens, next:ParserTokens) {
				switch token {
					case Identifier(_ == FOR_LOOP_IDENTIFIERS.FROM => true):
						{
							var val = Conversion.toHaxeValue(Interpreter.evaluate(next));
							if (val is Float || val is Int) {
								from = val;
							} else {
								Runtime.throwError(ErrorMessage('`for` loop\'s `${FOR_LOOP_IDENTIFIERS.FROM}` argument must be of type $TYPE_INT/$TYPE_FLOAT (given: ${Interpreter.stringifyTokenValue(next)} as ${Interpreter.evaluate(next).getName()})'));
							}
						}
					case Identifier(_ == FOR_LOOP_IDENTIFIERS.TO => true):
						{
							var val = Conversion.toHaxeValue(Interpreter.evaluate(next));
							if (val is Float || val is Int) {
								to = val;
							} else {
								Runtime.throwError(ErrorMessage('`for` loop\'s `${FOR_LOOP_IDENTIFIERS.TO}` argument must be of type $TYPE_INT/$TYPE_FLOAT (given: ${Interpreter.stringifyTokenValue(next)} as ${Interpreter.evaluate(next).getName()})'));
							}
						}
					case Identifier(_ == FOR_LOOP_IDENTIFIERS.JUMP => true):
						{
							var val = Conversion.toHaxeValue(Interpreter.evaluate(next));
							if (val is Float || val is Int) {
								if (val < 0) {
									Runtime.throwError(ErrorMessage('`for` loop\'s `${FOR_LOOP_IDENTIFIERS.JUMP}` argument must be positive (given: ${Interpreter.stringifyTokenValue(next)}). Notice - the usage of the `${FOR_LOOP_IDENTIFIERS.JUMP}` argument switches from increasing to decreasing the value of `${params[0].getParameters()[0]}` if `${FOR_LOOP_IDENTIFIERS.FROM}` is larger than `${FOR_LOOP_IDENTIFIERS.TO}`. Defaulting to 1'));
								} else
									jump = val;
							} else {
								Runtime.throwError(ErrorMessage('`for` loop\'s `${FOR_LOOP_IDENTIFIERS.JUMP}` argument must be of type $TYPE_INT/$TYPE_FLOAT (given: ${Interpreter.stringifyTokenValue(next)} as ${Interpreter.evaluate(next).getName()}). Defaulting to `1`'));
							}
						}
					case Block(_):
						{
							var ident = Interpreter.evaluate(token);
							parserForLoop(ident.getName() == "Characters" ? Identifier(ident.getParameters()[0]) : ident, next);
						}
					case _:
				}
			}

			var i = 1;

			while (i < fp.length) {
				var token = fp[i];
				var next = [];

				var lookahead = fp[i + 1];
				while (!Type.enumEq(lookahead, Identifier(FOR_LOOP_IDENTIFIERS.TO))
					&& !Type.enumEq(lookahead, Identifier(FOR_LOOP_IDENTIFIERS.JUMP))) {
					next.push(lookahead);
					lookahead = fp[++i + 1];
					if (lookahead == null)
						break;
				}
				i--;

				// trace(token, next);
				parserForLoop(token, Expression(next, null));
				i += 2;
			}

			if (from == null) {
				Runtime.throwError(ErrorMessage('`for` loop must contain a `${FOR_LOOP_IDENTIFIERS.FROM}` argument.'));
				return val;
			}
			if (from == null) {
				Runtime.throwError(ErrorMessage('`for` loop must contain a `${FOR_LOOP_IDENTIFIERS.TO}` argument.'));
				return val;
			}

			if (from < to) {
				while (from < to) {
					val = Interpreter.interpret([
						Write([params[0]], if (from == from.int()) Number("" + from) else Decimal("" + from), null)
					].concat(body), Interpreter.currentConfig);
					from += jump;
				}
			} else {
				while (from > to) {
					val = Interpreter.interpret([
						Write([params[0]], if (from == from.int()) Number("" + from) else Decimal("" + from), null)
					].concat(body), Interpreter.currentConfig);
					from -= jump;
				}
			}

			return val;
		});

		Little.plugin.registerCondition("after", [Variable(Identifier("rule"), Identifier(TYPE_BOOLEAN))], (params, body) -> {
			var val = NullValue;

			var handle = Interpreter.accessObject(params[0].getParameters()[0][0]);
			if (handle == null) {
				Runtime.throwError(ErrorMessage('`after` condition must start with a variable to watch (expected definition, found: `${params[0].getParameters()[0][0]}`)'));
				return val;
			}

			function dispatchAndRemove(set:ParserTokens) {
				if (Conversion.toHaxeValue(Interpreter.evaluateExpressionParts(params))) {
					Interpreter.interpret(body, Interpreter.currentConfig);
					handle.setterListeners.remove(dispatchAndRemove);
				}
			}
			handle.setterListeners.push(dispatchAndRemove);

			return val;
		});

		Little.plugin.registerCondition("whenever", [Variable(Identifier("rule"), Identifier(TYPE_BOOLEAN))], (params, body) -> {
			var val = NullValue;

			var handle = Interpreter.accessObject(params[0].getParameters()[0][0]);
			if (handle == null) {
				Runtime.throwError(ErrorMessage('`whenever` condition must start with a variable to watch (expected definition, found: `${params[0].getParameters()[0][0]}`)'));
				return val;
			}

			function dispatchAndRemove(set:ParserTokens) {
				if (Conversion.toHaxeValue(Interpreter.evaluateExpressionParts(params))) {
					Interpreter.interpret(body, Interpreter.currentConfig);
				}
			}
			handle.setterListeners.push(dispatchAndRemove);

			return val;
		});
	}
}
