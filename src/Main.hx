package;

#if js
import js.Browser;
#end
import little.parser.Parser;
import little.expressions.Expressions;
import little.lexer.Specifics;
import texter.general.math.MathLexer;
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
				output.innerHTML = refactored_little.tools.PrettyPrinter.printParserAst(refactored_little.parser.Parser.parse(refactored_little.lexer.Lexer.separateBooleanIdentifiers(refactored_little.lexer.Lexer.lex(untyped text.value))));
			} catch (e) {
            }
		});
		output.innerHTML = refactored_little.tools.PrettyPrinter.printParserAst(refactored_little.parser.Parser.parse(refactored_little.lexer.Lexer.separateBooleanIdentifiers(refactored_little.lexer.Lexer.lex(code))));
		text.innerHTML = code;
		#else
		trace(refactored_little.tools.PrettyPrinter.printParserAst(refactored_little.parser.Parser.parse(refactored_little.lexer.Lexer.separateBooleanIdentifiers(refactored_little.lexer.Lexer.lex(code)))));
		#end
	}
}
