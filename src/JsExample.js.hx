package;

import js.html.TextAreaElement;
import js.html.Document;
import little.interpreter.Runtime;
import little.Little;
import js.Browser;


class JsExample {
    
    var d = Browser.document;

    public function new() {
        var input:TextAreaElement = cast d.getElementById("input");
        var ast:TextAreaElement = cast d.getElementById("ast");
        var output:TextAreaElement = cast d.getElementById("output");
        trace(input, ast, output);
        input.addEventListener("keyup", function(_) {
			try {
				ast.value = little.tools.PrettyPrinter.printParserAst(little.parser.Parser.parse(little.lexer.Lexer.lex(input.value)));
			} catch (e) {}

			try {
				Little.run(input.value, true);
				output.value = Runtime.stdout;
			} catch (e) {}
		});

        input.onkeydown = function (e) {
            if (e.key == 'Tab') {
                e.preventDefault();
                var start = input.selectionStart;
                var end = input.selectionEnd;

                // set textarea value to: text before caret + tab + text after caret
                input.value = input.value.substring(0, start) + "\t" + input.value.substring(end);

                // put caret at right position again
                input.selectionStart = input.selectionEnd = start + 1;
            }
        }
    }

}