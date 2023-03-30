package;

import little.tools.Data;
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
import texter.general.Char;

import texter.general.CharTools;


using StringTools;

class Main {
	static var code = 'action הדפס() = {print(5)}, הדפס()';

	static function main() {
		#if js
		var text = Browser.document.getElementById("input");
		var output = Browser.document.getElementById("output-parser");
		var stdout = Browser.document.getElementById("output");
		trace(text, output);
		text.addEventListener("keyup", (_) -> {
			try {
				output.innerHTML = little.tools.PrettyPrinter.printParserAst(little.parser.Parser.parse(little.lexer.Lexer.lex(untyped text.value)));
			} catch (e) {}

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
			var input = Sys.stdin().readLine();
			Little.run(input, true);
			trace(Runtime.stdout);
		}

		
		// trace(PrettyPrinter.printParserAst(Interpreter.forceCorrectOrderOfOperations(Parser.parse(Lexer.lex('1 + 1 * 3')))));
		// trace(Parser.parse(Lexer.lex('define x as String')));
		#end
	}
}
