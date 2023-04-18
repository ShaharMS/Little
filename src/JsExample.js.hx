package;

import js.html.Document;
import little.interpreter.Runtime;
import little.Little;
import js.Browser;


class JsExample {
    
    var d = Browser.document;

    public function new() {
        d.body.innerHTML = '';
        var input = d.createTextAreaElement();
        input.placeholder = "Code here...";
        input.id = "input";
        var ast = d.createTextAreaElement();
        ast.id = "output-parser";
        var output = d.createTextAreaElement();
        output.id = "output";
        var div = d.createDivElement();
        div.appendChild(input);
        div.appendChild(output);
        div.appendChild(ast);
        
        div.style.display = "flex";
        div.style.flexDirection = "column";
        
        d.body.appendChild(div);
        d.body.style.margin = d.body.style.padding = "0px";
        
        for (element in [input, output, ast]) {
            element.style.height = "33vh";
            element.style.width = "500px";
            element.style.display = "inline-block";
        }
        output.wrap = ast.wrap = "off";
        output.style.overflowX = ast.style.overflowX = "scroll";

        input.innerHTML = 'define x = 3, print(x)';
        input.onkeyup = function(_) {
			try {
				ast.innerHTML = little.tools.PrettyPrinter.printParserAst(little.parser.Parser.parse(little.lexer.Lexer.lex(input.value)));
			} catch (e) {}

			try {
				Little.run(input.value, true);
				output.innerHTML = Runtime.stdout;
			} catch (e) {}
		}

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
        input.onkeyup();
    }

}