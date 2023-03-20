package;

import little.tools.Plugins;
import little.tools.Conversion;
import little.Little;
import little.interpreter.Runtime;
import little.tools.PrettyPrinter;
import little.interpreter.Interpreter;
#if js
import js.Browser;
#end
import little.parser.Parser;
import little.lexer.Lexer;

using StringTools;

class Main {
	static var code = '
a() = define {define i = 5; i = i + 1; ("num" + i)} = hello() = 6
action a(define h as String = 8; define a = 3; define xe) {
    if (h == a) {
        return a + 1
    }
    nothing; return h + a + xe + {define a = 1; (a + 1)}
}
define x as Number = define y as Decimal = 6
    ';

	static function main() {
		#if js
		var text = Browser.document.getElementById("input");
		var output = Browser.document.getElementById("output-parser");
		var stdout = Browser.document.getElementById("output");
		trace(text, output);
		text.addEventListener("keyup", (_) -> {
			try {
				output.innerHTML = little.tools.PrettyPrinter.printParserAst(little.parser.Parser.parse(little.lexer.Lexer.lex(untyped text.value)));
			} catch (e) {
            }

			try {
				Little.run(untyped text.value);
				stdout.innerHTML = Runtime.stdout;
			} catch (e) {}
		});
		output.innerHTML = little.tools.PrettyPrinter.printParserAst(little.parser.Parser.parse(little.lexer.Lexer.lex(untyped text.value)));
		text.innerHTML = code;
		#elseif sys

		while (true) {
			Sys.print("  >> ");
			Little.run(Sys.stdin().readLine(), true);
			trace(Runtime.stdout);
		}
		
		// trace(PrettyPrinter.printParserAst(Interpreter.forceCorrectOrderOfOperations(Parser.parse(Lexer.lex('1 + 1 * 3')))));
		// trace(Parser.parse(Lexer.lex('define x as String')));
		#end
	}
}
