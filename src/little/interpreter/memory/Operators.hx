package little.interpreter.memory;

import haxe.ds.ArraySort;
import vision.algorithms.Radix;
import little.tools.PrettyPrinter;
import haxe.extern.EitherType;
import little.interpreter.Tokens.InterpTokens;

using little.tools.TextTools;
using StringTools;

/**
	An extension of `little.interpreter.memory.ExternalInterfacing`, that adds support for external operators.
**/
@:access(little.lexer.Lexer)
@:allow(little.interpreter.Interpreter)
@:allow(little.tools.Plugins)
class Operators {

	/**
		Instantiates the `Little.memory.operators` class.
	**/
	public function new() {}

	/**
		A map containing the priority of each operator, sorted by index to an array of operand-position-dependent operators.
		for example:

		| Priority | Little.memory.operators |
		| :---: | :---: |
		| 0 | `{sign: "+", side: STANDARD}`, `{sign: "-", side: STANDARD}` |
		| 1 | `{sign: "*", side: STANDARD}`, `{sign: "/", side: STANDARD}` |
		| 2 | `{sign: "^", side: STANDARD}`, `{sign: "√", side: RHS_ONLY}` |
	**/
	public var priority:Map<Int, Array<{sign:String, side:OperatorType}>> = [];

	/**
		Little.memory.operators that require two sides to work, for example:
		| Operator | Code |
		| :---: | :---: |
		| Add | `5 + 5` |
		| Subtract | `5 - 5` |
		| Exponentiation | `5^2` |
		| "Non-Standard" Square Root  | `3√5` |
	**/
	public var standard:Map<String, (lhs:InterpTokens, rhs:InterpTokens) -> InterpTokens> = new Map();

	/**
		Little.memory.operators that require just the right side of the equations, for example:
		| Operator | Code |
		| :---: | :---: |
		| Negate | `-5` |
		| Increment | `++5` |
		| Decrement | `--5` |
		| "Standard" Square Root  | `√5` |
	**/
	public var rhsOnly:Map<String, (InterpTokens) -> InterpTokens> = new Map();

	/**
		Little.memory.operators that require just the left side of the equations, for example:
		| Operator | Code |
		| :---: | :---: |
		| Post Increment | `5++` |
		| Post Decrement | `5--` |
		| Factorial | `5!` |
	**/
	public var lhsOnly:Map<String, (InterpTokens) -> InterpTokens> = new Map();

	/**
		Format of parameter `opPriority`:

		### Notice
		 - When using relative (`before`/`after`) positions, make sure the referenced operator exists. otherwise, it won't be inserted at all...

		| Option | Meaning | Example |
		| :--- | :--- | :---: |
		| `<index>` | Inserts the operator at the specified priority level. | `2`, `1`, `5` |
		| `first` | Inserts the operator at the first priority level (index `0`). | `first` |
		| `last` | Inserts the operator at the last priority level (index `priority.length - 1`). | `last` |
		| `with _<sign>_` | Inserts the operator at the same priority level as the given sign. The sign is surrounded by underscores, which means the sign is of type `LHS_RHS`.| `with _+_`, `with _*_`|
		| `between <sign1> <sign2>` | Inserts the operator between the two signs. the signs are **not** surrounded by **any underscores**, which means these signs are of type `LHS_RHS`.| `between ^ +_`, ` between _*_ -`|
		| `before _<sign>` | Inserts the operator before the sign. the sign is surrounded by underscores, which means the sign is of type `LHS_ONLY`.| `before _!`|
		| `after <sign>_` | Inserts the operator after the sign. the has only one underscore to the right of it, which means the sign is of type `RHS_ONLY`.| `after -_`, `after +_`|

	**/
	public function setPriority(op:String, type:OperatorType, opPriority:String) {
		var obj = {sign: op, side: type};
		if (opPriority == "first") {
			if (priority[-1] == null)
				priority[-1] = [];
			priority[-1].push(obj);
		} else if (opPriority == "last") {
			var i = -1;
			for (key in priority.keys())
				if (i < key)
					i = key;
			if (priority[i + 1] == null)
				priority[i + 1] = [];
			priority[i + 1].push(obj);
		} else if (~/[0-9]+/.match(opPriority)) {
			var p = Std.parseInt(opPriority);
			if (priority[p] == null)
				priority[p] = [];
			priority[p].push(obj);
		} else if (opPriority.startsWith("before") || opPriority.startsWith("after") || opPriority.startsWith("with")) {
			var destinationOp, opSide;
			var signPos = opPriority.remove("before").remove("after").remove("with").trim();
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

			for (key => value in priority) {
				if (value.filter(x -> x.side == opSide && x.sign == destinationOp).length > 0) {
					if (opPriority.startsWith("before")) {
						if (priority[key - 1] == null)
							priority[key - 1] = [];
						priority[key - 1].push(obj);
					} else if (opPriority.startsWith("after")) {
						if (priority[key + 1] == null)
							priority[key + 1] = [];
						priority[key + 1].push(obj);
					} else {
						// if inserted on the same priority level, and a priority level already exists since the
						// sign was found on it, we can assume priority[key] already exists
						priority[key].push(obj);
					}
					break;
				}
			}
		} else if (opPriority.startsWith("between")) {
			var signPos = opPriority.remove("between").trim();
			var signs = signPos.split(" ").map(x -> x.trim());
			var sign1Data = signPosToObject(signs[0]);
			var sign2Data = signPosToObject(signs[1]);

			var sign1Level = -1, sign2Level = -1;
			for (key => value in priority) {
				if (value.filter(x -> x.side == sign1Data.side && x.sign == sign1Data.sign).length > 0) {
					sign1Level = key;
				}
				if (value.filter(x -> x.side == sign2Data.side && x.sign == sign2Data.sign).length > 0) {
					sign2Level = key;
				}
			}

			if (sign1Level != -1 && sign2Level != -1 && sign1Level != sign2Level && Math.abs(sign1Level - sign2Level) <= 2) {
				if (Math.abs(sign1Level - sign2Level) == 2) {
					var key = Std.int((sign1Level + sign2Level) / 2);
					if (priority[key] == null)
						priority[key] = [];
					priority[key].push(obj);
				} else {
					// We need to create a new level between sign1Level and sign2Level, and push everything
					// after the sign were inserting now backwards
					var insert = Std.int(Math.max(sign1Level, sign2Level));
					var newMap = new Map<Int, Array<{sign:String, side:OperatorType}>>();
					for (k => v in priority) {
						if (k < insert) {
							newMap[k] = v;
						} else {
							newMap[k + 1] = v;
						}
					}
					newMap[insert] = [obj];
					priority = newMap;
				}
			}
		}

		// We're working on a map, and negative indices can be used as keys. we need to make sure that
		// all indices are positive, while keeping the order.
		// More than that, we need the list to start at 0, so if theres no 0 in the list, we need to move everything downwards.

		
		var a = [for (x in priority.keys()) x];
		if (a.length == 0) return;
		ArraySort.sort(a, (x, y) -> x - y);
		var minimumKey = a[0];
		if (minimumKey != 0) {
			var diff = 0 - minimumKey;
			var priorityCopy = new Map<Int, Array<{sign:String, side:OperatorType}>>();
			for (key => value in priority) {
				priorityCopy[key + diff] = value;
			}
			priority = priorityCopy;
		}
		
	}

	/**
		Returns the 0-based priority of the given operator.
		@param op The operator
		@param type The side of the operator - `LHS_ONLY`, `RHS_ONLY` or `LHS_RHS`
		@return The operator's priority
	**/
	public function getPriority(op:String, type:OperatorType):Int {
		for (index => key in priority)
			if (key.filter(x -> x.sign == op && x.side == type).length > 0) return index;
		throw 'Operator $op not found';
	}

	/**
		Iterates over the operators in arrays ordered by their priority, from `0` to `n`.
	**/
	public function iterateByPriority():Iterator<Array<{sign:String, side:OperatorType}>> {
		var a = [for (x in priority.keys()) x];
		ArraySort.sort(a, (x, y) -> x - y);
		var b = [for (x in a) priority[x]];
		var i = 0;
		return {
			next: () -> b[i++],
			hasNext: () -> i < b.length
		}
	}

	/**
		Adds an operator to be used in the program's runtime.
		@param op the operator itself
		@param operatorType  **STANDARD** - operator that works with both sides of the equation, for example: `5 + 5` or `5 - 5`.  
		**LHS_ONLY** - operator that only works with the left side of the equation, for example: `5++` or `5--`.  
		**RHS_ONLY** - operator that only works with the right side of the equation, for example: `-5` or `++5`.  
		@param priority a string indicating the priority of the operator using positional info/actual index. see `Little.memory.operators.setPriority`
		@param callback depending on the operatorType, either a function that takes two arguments (lhs, rhs) or a function that takes one argument (lhs) or (rhs).
	**/
	public function add(op:String, operatorType:OperatorType, priority:String,
			callback:EitherType<(InterpTokens) -> InterpTokens, (InterpTokens, InterpTokens) -> InterpTokens>) {
		for (i in 0...op.length)
			if (!KeywordConfig.recognizedOperators.contains(op.charAt(i)))
				KeywordConfig.recognizedOperators.push(op.charAt(i));
		Little.keywords.RECOGNIZED_SIGNS.push(op);
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

	/**
		Calls the operator `op` with the argument `lhs` to the left side of the equation. 
	**/
	overload extern inline public function call(lhs:InterpTokens, op:String) {
		if (lhsOnly.exists(op))
			return lhsOnly[op](lhs);
		else if (rhsOnly.exists(op))
			return
				ErrorMessage('Operator $op is used incorrectly - should appear after the sign ($op${PrettyPrinter.stringifyInterpreter(lhs)} instead of ${PrettyPrinter.stringifyInterpreter(lhs)}$op)');
		else if (standard.exists(op))
			return ErrorMessage('Operator $op is used incorrectly - should appear between two values (${PrettyPrinter.stringifyInterpreter(lhs)} $op <some value>)');
		else
			return ErrorMessage('Operator $op does not exist. did you make a typo?');
	}

	/**
		Calls the operator `op` with the argument `rhs` to the right side of the equation.
	**/
	overload extern inline public function call(op:String, rhs:InterpTokens) {
		if (rhsOnly.exists(op))
			return rhsOnly[op](rhs);
		else if (lhsOnly.exists(op))
			return
				ErrorMessage('Operator $op is used incorrectly - should appear before the sign (${PrettyPrinter.stringifyInterpreter(rhs)}$op instead of $op${PrettyPrinter.stringifyInterpreter(rhs)})');
		else if (standard.exists(op))
			return ErrorMessage('Operator $op is used incorrectly - should appear between two values (${PrettyPrinter.stringifyInterpreter(rhs)} $op <some value>)');
		else
			return ErrorMessage('Operator $op does not exist. did you make a typo?');
	}

	/**
		Calls the operator `op` with the arguments `lhs` and `rhs` to the left and right side of the equation respectively.
	**/
	overload extern inline public function call(?lhs:InterpTokens = null, op:String, ?rhs:InterpTokens = null):InterpTokens {
		if (standard.exists(op))
			return standard[op](lhs, rhs);
		else if (lhsOnly.exists(op))
			return
				ErrorMessage('Operator $op is used incorrectly - should not appear between two values, only to the right of one of them (${PrettyPrinter.stringifyInterpreter(rhs)}$op or ${PrettyPrinter.stringifyInterpreter(lhs)}$op)');
		else if (rhsOnly.exists(op))
			return
				ErrorMessage('Operator $op is used incorrectly - should not appear between two values, only to the left of one of them ($op${PrettyPrinter.stringifyInterpreter(rhs)} or $op${PrettyPrinter.stringifyInterpreter(lhs)})');
		else
			return ErrorMessage('Operator $op does not exist. did you make a typo?');
	}

	/**
		Converts shortened `_+_` syntax that includes both the operator and it's side to a sign-`OperatorType` pair.
		@param signPos a string containing the operator and it's sides. see `Little.memory.operators.setPriority` for syntax
		@return a sign-`OperatorType` pair
	**/
	function signPosToObject(signPos:String):{sign:String, side:OperatorType} {
		var destinationOp, opSide;
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
		return {sign: destinationOp, side: opSide};
	}
}

/**
	Types of operators. Rhs means the operand is on the right hand side, 
	while Lhs means the operand is on the left hand side.
**/
enum OperatorType {
	LHS_RHS;
	LHS_ONLY;
	RHS_ONLY;
}
