package;

import little.interpreter.Interpreter;
import little.interpreter.Tokens.InterpTokens;
import sys.io.File;
import sys.FileSystem;
import little.tools.PrettyPrinter;
import eval.luv.Stream;
import little.Little;
import little.interpreter.Runtime;
import little.lexer.Lexer;
import little.parser.Parser;
import little.tools.Layer;

using StringTools;
using little.tools.TextTools;
using little.tools.Extensions;

typedef UnitTestResult = {
	testName:String,
	success:Bool,
	returned:InterpTokens,
	expected:InterpTokens,
	code:String
}

class UnitTests {
	
	// ANSI colors

	static var RED = "\033[31m";
	static var GREEN = "\033[32m";
	static var YELLOW = "\033[33m";
	static var BLUE = "\033[34m";
	static var MAGENTA = "\033[35m";
	static var CYAN = "\033[36m";
	static var WHITE = "\033[37m";
	static var RESET = "\033[0m";

	static var BOLD = "\033[1m";
	static var ITALIC = "\033[3m";
	static var UNDERLINE = "\033[4m";

	public static function run(bulk:Bool = false) {
		var testFunctions = [test1, test2, test3, test4, test5, test6, test7, test8, test9, test10, test11, test12, test13];

		var i = 1;
		for (func in testFunctions) {
			var result = func();
			Sys.println('$CYAN$BOLD Unit Test $i:$RESET $BOLD$ITALIC${if (result.success) GREEN else RED}${result.testName}$RESET');
			Sys.println('    - $RESET$BOLD$WHITE Result: $ITALIC${if (result.success) GREEN else RED}${if (result.success) "Success" else "Failure"}$RESET');
			if (!result.success) {
				Sys.println('        - $RESET$BOLD$WHITE Expected:$RESET $ITALIC$GREEN${result.expected}$RESET');
				Sys.println('        - $RESET$BOLD$WHITE Returned:$RESET $ITALIC$RED${result.returned}$RESET');
				Sys.print('        - $RESET$BOLD$WHITE Code:$RESET \n            ${result.code.replace("\n", "\n            ")}$RESET\n');
				Sys.print('        - $RESET$BOLD$WHITE Abstract Syntax Tree:$RESET\n            ${PrettyPrinter.printParserAst(Parser.parse(Lexer.lex(result.code))).replace("\n", "\n            ")}$RESET\n');
				Sys.print('        - $RESET$BOLD$WHITE Stdout:$RESET\n            ${Little.runtime.stdout.output.replace("\n", "\n            ")}$RESET\n');
			}

			if (!result.success && !bulk) {
				Sys.exit(1);
			}
			Sys.sleep(bulk ? 0.02 : 0.2);
			Little.reset();
			i++;
		}

		//File.saveContent('unit_tests.md');
	}



	public static function test1():UnitTestResult {
		var code = "print((5 + (3 - 2)) * 5^2 + 3 * 4 / 4 + 4! + 8 + -2)";
		Little.run(code);
		var result = Little.runtime.stdout.stdoutTokens.pop();
		return {
			testName: "Basic Math",
			success: result.equals(Decimal(183)),
			returned: result,
			expected: Decimal(183),
			code: code
		}
	}

	public static function test2():UnitTestResult {
		var code = 'define x as Number = 3, define y as Decimal, define z\nprint(x + ", " + y.type + ", " + z.type + ", " + z)';
		Little.run(code);
		var result = Little.runtime.stdout.stdoutTokens.pop();
		return {
			testName: "Variable declaration",
			success: result.equals(Characters("3, Decimal, Anything, nothing")),
			returned: result,
			expected: Characters("3, Decimal, Anything, nothing"),
			code: code

		}
	}

	public static function test3():UnitTestResult {
		var code = "action x1() = { print(1) }\naction x2(define x as Number) = { print(x) }\naction x21(define x as Number) = { return x }\naction x3() = { print(1 + x21(5)) }\n\nx1(), x2(5), x3()";
		Little.run(code);
		var result = PartArray(Little.runtime.stdout.stdoutTokens);
		var exp = PartArray([Number(1), Number(5), Number(6)]);
		return {
			testName: "Function declaration",
			success: !Lambda.has([for (i in 0...3) Type.enumEq(result.parameter(0)[i], exp.parameter(0)[i])], false),
			returned: result,
			expected: Characters("1, 5, 6"),
			code: code
		}
	}

	public static function test4():UnitTestResult {
		var code = "define x = Object.create(), define x.value as Number = 3\ndefine x.y = Object.create(), define x.y.value = 5\ndefine x.y.z = x.y.value\nprint(x.y.z + x.y.value + x.value)";
		Little.run(code);
		var result = Little.runtime.stdout.stdoutTokens.pop();
		return {
			testName: "Property access",
			success: result.equals(Number(13)),
			returned: result,
			expected: Number(13),
			code: code
		};
	}

	public static function test5():UnitTestResult {
		var code = "define i = 0\nwhile (i <= 5) { print (i); i = i + 1}\nfor (define j from 0 to 10 jump 3) print(j)";
		Little.run(code);
		var result = PartArray(Little.runtime.stdout.stdoutTokens);
		var exp = PartArray([Number(0), Number(1), Number(2), Number(3), Number(4), Number(5), Number(0), Number(3), Number(6), Number(9)]);
		return {
			testName: "Loops",
			success: !Lambda.has([for (i in 0...10) Type.enumEq(exp.parameter(0)[i], result.parameter(0)[i])], false),
			returned: result,
			expected: exp,
			code: code
		};
	}

	public static function test6():UnitTestResult {
		var code = 'define i = 4, if (i != 0) print(true)\nafter (i == 6) print("i is 6"), whenever (i == i) print("i has changed")\ni = i + 1, i = i + 1';
		Little.run(code);
		var result = PartArray(Little.runtime.stdout.stdoutTokens);
		var exp = PartArray([TrueValue, Characters("i has changed"), Characters("i is 6"), Characters("i has changed")]);
		return {
			testName: "Events and conditionals",
			success: !Lambda.has([for (i in 0...4) Type.enumEq(exp.parameter(0)[i], result.parameter(0)[i])], false),
			returned: result,
			expected: exp,
			code: code
		}
	}

	public static function test7():UnitTestResult {
		var code = "define x = {define y = 0; y = y + 5; (6^2 * y)}, print(x)";
		Little.run(code);
		var result = Little.runtime.stdout.stdoutTokens.pop();
		return {
			testName: "Code blocks",
			success: result.equals(Number(180)),
			returned: result,
			expected: Number(180),
			code: code
		};
	}

	public static function test8():UnitTestResult {
		var code = '\ndefine x = 1.2\nx = (x + 2 * x) / x\nprint(x)';
		Little.run(code);
		var result = Interpreter.evaluate(Little.runtime.stdout.stdoutTokens.pop());
		return {
			testName: "Self assignment",
			success: result.equals(Decimal(3)),
			returned: result,
			expected: Decimal(3),
			code: code
		}
	}

	public static function test9():UnitTestResult {
		var code = 'if (false) print("Wrong") else if (false && true) print("Also Wrong") else { print("Right") }';
		Little.run(code);
		var result = Little.runtime.stdout.stdoutTokens.pop();
		return {
			testName: "If-Else",
			success: result.equals(Characters("Right")),
			returned: result,
			expected: Characters("Right"),
			code: code
		}
	}
	
	public static function test10():UnitTestResult {
		var code = 'define i = 3\n{{define i = 5, print(i)}}\nprint(i)';
		Little.run(code);
		var result = PartArray(Little.runtime.stdout.stdoutTokens);
		var exp = PartArray([Number(5), Number(3)]);
		return {
			testName: "Nested code blocks",
			success: !Lambda.has([for (i in 0...2) Type.enumEq(exp.parameter(0)[i], result.parameter(0)[i])], false),
			returned: result,
			expected: exp,
			code: code
		}
	}

	public static function test11():UnitTestResult {
		var code = 'define a = {define b = 3, (b * 10)}, print({a = a + 3, a})';
		Little.run(code);
		var result = Little.runtime.stdout.stdoutTokens.pop();
		return {
			testName: "Inline Blocks",
			success: result.equals(Number(33)),
			returned: result,
			expected: Number(33),
			code: code
		}
	}

	public static function test12():UnitTestResult {
		var code = 'define a = nothing, define b = nothing, define c = 0, define d = 0.0, print(a.address == b.address), print(c.address == d.address)';
		Little.run(code);
		var result = PartArray(Little.runtime.stdout.stdoutTokens);
		var exp = PartArray([TrueValue, TrueValue]);
		return {
			testName: "Constant pool",
			success: !Lambda.has([for (i in 0...2) Type.enumEq(exp.parameter(0)[i], result.parameter(0)[i])], false),
			returned: result,
			expected: exp,
			code: code
		}
	}

	public static function test13():UnitTestResult {
		var code = 'print(5.type + 5.5.type + true.type + nothing.type + +.type + Number.type)';
		Little.run(code);
		var result = Little.runtime.stdout.stdoutTokens.pop();
		var exp = Characters("NumberDecimalBooleanAnythingSignType");
		return {
			testName: "Type Name Property",
			success: result.equals(exp),
			returned: result,
			expected: exp,
			code: code
		}
	}
}