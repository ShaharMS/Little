package little.interpreter;

import little.tools.PrettyPrinter;
import eval.luv.Stream;
import little.lexer.Lexer;
import haxe.extern.EitherType;
import little.parser.Tokens.ParserTokens;

using little.tools.TextTools;

@:access(little.lexer.Lexer)
@:allow(little.interpreter.Interpreter)
@:allow(little.tools.Plugins)
class Operators {
	static var isUserDefined = true;
	static var USER_DEFINED:Array<String> = [];
	static var HIGH_PRIORITY:Array<String> = [];

	/**
		Operators that require two sides to work, for example:
		| Operator | Code |
		| :---: | :---: |
		| Add | `5 + 5` |
		| Subtract | `5 - 5` |
		| Exponentiation | `5^2` |
		| "Non-Standard" Square Root  | `3√5` |
	**/
	public static var standard:Map<String, (lhs:ParserTokens, rhs:ParserTokens) -> ParserTokens> = new Map();

	/**
		Operators that require just the right side of the equations, for example:
		| Operator | Code |
		| :---: | :---: |
		| Negate | `-5` |
		| Increment | `++5` |
		| Decrement | `--5` |
		| "Standard" Square Root  | `√5` |
	**/
	public static var rhsOnly:Map<String, (ParserTokens) -> ParserTokens> = new Map();

	/**
		Operators that require just the left side of the equations, for example:
		| Operator | Code |
		| :---: | :---: |
		| Post Increment | `5++` |
		| Post Decrement | `5--` |
		| Factorial | `5!` |
	**/
	public static var lhsOnly:Map<String, (ParserTokens) -> ParserTokens> = new Map();

	public static function add(op:String, operatorType:OperatorType,
			callback:EitherType<(ParserTokens) -> ParserTokens, (ParserTokens, ParserTokens) -> ParserTokens>) {
		for (i in 0...op.length)
			if (!Lexer.signs.contains(op.charAt(i)))
				Lexer.signs.push(op.charAt(i));
		Keywords.SPECIAL_OR_MULTICHAR_SIGNS.push(op);
		switch operatorType {
			case LHS_RHS:
				{
					standard.set(op, callback);
				}
			case LHS_ONLY:
				{
					lhsOnly.set(op, callback);
				}
			case RHS_ONLY:
				{
					rhsOnly.set(op, callback);
				}
		}
	}

	overload extern inline public static function call(lhs:ParserTokens, op:String) {
		if (lhsOnly.exists(op))
			return lhsOnly[op](lhs);
		else if (rhsOnly.exists(op))
			return ErrorMessage('Operator $op is used incorrectly - should appear after the sign ($op${PrettyPrinter.stringify(lhs)} instead of ${PrettyPrinter.stringify(lhs)}$op)');
		else if (standard.exists(op))
			return ErrorMessage('Operator $op is used incorrectly - should appear between two values (${PrettyPrinter.stringify(lhs)} $op <some value>)');
		else
			return ErrorMessage('Operator $op does not exist. did you make a typo?');
	}

	overload extern inline public static function call(op:String, rhs:ParserTokens) {
		if (rhsOnly.exists(op))
			return rhsOnly[op](rhs);
		else if (lhsOnly.exists(op))
			return ErrorMessage('Operator $op is used incorrectly - should appear before the sign (${PrettyPrinter.stringify(rhs)}$op instead of $op${PrettyPrinter.stringify(rhs)})');
		else if (standard.exists(op))
			return ErrorMessage('Operator $op is used incorrectly - should appear between two values (${PrettyPrinter.stringify(rhs)} $op <some value>)');
		else
			return ErrorMessage('Operator $op does not exist. did you make a typo?');
	}

	overload extern inline public static function call(?lhs:ParserTokens = null, op:String, ?rhs:ParserTokens = null):ParserTokens {
		if (standard.exists(op))
			return standard[op](lhs, rhs);
		else if (lhsOnly.exists(op))
			return ErrorMessage('Operator $op is used incorrectly - should not appear between two values, only to the right of one of them (${PrettyPrinter.stringify(rhs)}$op or ${PrettyPrinter.stringify(lhs)}$op)');
		else if (rhsOnly.exists(op))
			return ErrorMessage('Operator $op is used incorrectly - should not appear between two values, only to the left of one of them ($op${PrettyPrinter.stringify(rhs)} or $op${PrettyPrinter.stringify(lhs)})');
		else
			return ErrorMessage('Operator $op does not exist. did you make a typo?');
	}
}

enum OperatorType {
	LHS_RHS;
	LHS_ONLY;
	RHS_ONLY;
}
