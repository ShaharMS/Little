package;

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
		var output = Browser.document.getElementById("output");
		trace(text, output);
		text.addEventListener("keyup", (_) -> {
			try {
				output.innerHTML = little.tools.PrettyPrinter.printParserAst(little.parser.Parser.parse(little.lexer.Lexer.lex(untyped text.value)));
			} catch (e) {
            }
		});
		output.innerHTML = little.tools.PrettyPrinter.printParserAst(little.parser.Parser.parse(little.lexer.Lexer.lex(untyped text.value)));
		text.innerHTML = code;
		#else
		trace(little.tools.PrettyPrinter.printParserAst(little.parser.Parser.parse(little.lexer.Lexer.lex(code))));
		#end
	}
}
