package little.interpreter;

import little.tools.PrettyPrinter;
import little.lexer.Lexer;
import haxe.extern.EitherType;
import little.parser.Tokens.ParserTokens;

using little.tools.TextTools;
using StringTools;

@:access(little.lexer.Lexer)
@:allow(little.interpreter.Interpreter)
@:allow(little.tools.Plugins)
class Operators {

	/**
		A map containing the priority of each operator, sorted by index to an array of operand-position-dependent operators.
		for example:

		| Priority | Operators |
		| :---: | :---: |
		| 0 | `{sign: "+", side: STANDARD}`, `{sign: "-", side: STANDARD}` |
		| 1 | `{sign: "*", side: STANDARD}`, `{sign: "/", side: STANDARD}` |
		| 2 | `{sign: "^", side: STANDARD}`, `{sign: "√", side: RHS_ONLY}` |
	**/
	public static var priority:Map<Int, Array<{sign:String, side:OperatorType}>> = [];
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

	/**
		Format of parameter `opPriority`:
		
		| Option | Meaning | Example |
		| :--- | :--- | :---: |
		| `<index>` | Inserts the operator at the specified priority level. | `2`, `1`, `5` |
		| `first` | Inserts the operator at the first priority level (index `0`). | `first` |
		| `last` | Inserts the operator at the last priority level (index `priority.length - 1`). | `last` |
		| `before _<sign>_` | Inserts the operator before the sign. the sign is surrounded by underscores, which means the sign is of type `LHS_RHS`.| `before _+_`, `before _*_`|
		| `after <sign>` | Inserts the operator after the sign. the sign is **not** surrounded by **any underscores**, which means the sign is of type `LHS_RHS`.| `after ^`, `after /`|
		| `before _<sign>` | Inserts the operator before the sign. the sign is surrounded by underscores, which means the sign is of type `LHS_ONLY`.| `before _!`, `before _--`|
		| `after <sign>_` | Inserts the operator after the sign. the has only one underscore to the right of it, which means the sign is of type `RHS_ONLY`.| `after -_`, `after +-`|
		**/
	public static function setPriority(op:String, type:OperatorType, opPriority:String) {
		var obj = {sign: op, side: type};
		if (opPriority == "first") {
			if (priority[0] == null) priority[0] = [];
			priority[0].push(obj);
		}
		else if (opPriority == "last") {
			var i = -1;
			for (key in priority.keys()) if (i < key) i = key;
			if (priority[i] == null) priority[i + 1] = [];
			priority[i + 1].push(obj);
		} else if (~/[0-9]+/.match(opPriority)) {
			var p = Std.parseInt(opPriority);
			if (priority[p] == null) priority[p] = [];
			priority[p].push(obj);
		} else if (opPriority.startsWith("before") || opPriority.startsWith("after")) {
			var destinationOp, opSide;
			var signPos = opPriority.remove("before").remove("after").trim();
			if (signPos.countOccurrencesOf("_") != 1) {
				destinationOp = signPos.replace("_", "");
				opSide = LHS_RHS;
			} else if (signPos.startsWith("_")) {
				destinationOp = signPos.replace("_", "");
				opSide = LHS_ONLY;
			} else {
				destinationOp = signPos.replace("_", "");
				opSide = RHS_ONLY;
			}
			obj = {sign: destinationOp, side: opSide};
			
			for (key => value in priority) {
				if (value.filter(x -> x.side == opSide && x.sign == destinationOp).length > 0) {
					
					if (opPriority.startsWith("before")) {
						if (priority[key - 1] == null) priority[key - 1] = [];
						priority[key - 1].push(obj);
					} else {
						if (priority[key + 1] == null) priority[key + 1] = [];
						priority[key + 1].push(obj);
					}
					return;
				}
			}			
		}
	}

	/**
		Adds an operator to be used in the program's runtime.
		@param op the operator itself
		@param operatorType  **STANDARD** - operator that works with both sides of the equation, for example: `5 + 5` or `5 - 5`.  
		**LHS_ONLY** - operator that only works with the left side of the equation, for example: `5++` or `5--`.  
		**RHS_ONLY** - operator that only works with the right side of the equation, for example: `-5` or `++5`.  
		@param priority a string indicating the priority of the operator using positional info/actual index. see `Operators.setPriority`
		@param callback depending on the operatorType, either a function that takes two arguments (lhs, rhs) or a function that takes one argument (lhs) or (rhs).
	**/
	public static function add(op:String, operatorType:OperatorType, priority:String,
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

		setPriority(op, operatorType, priority);
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
