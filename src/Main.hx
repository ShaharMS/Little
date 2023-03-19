package;

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

		// {
		// 	var cls = Math;
		// 	var fieldValues = new Map<String, Dynamic>();
		// 	var fieldFunctions = new Map<String, Dynamic>();

		// 	// Iterate over the fields of the Math class
		// 	for (field in Reflect.fields(cls)) {
		// 		// Check if the field is a static field
		// 		// Get the field value and store it in the fieldValues map
		// 		var value = Reflect.field(cls, field);
		// 		// Check if the field is a function (i.e., a method)
		// 		if (Reflect.isFunction(value)) {
		// 			// Store the function in the fieldFunctions map
		// 			fieldFunctions.set(field, value);
		// 		} else {
        // 	        fieldValues.set(field, value);
        // 	    }

		// 	}

		// 	// Test the maps by printing the values of Math.PI and Math.sqrt()
		// 	trace(fieldValues.get("PI")); // Output: 3.141592653589793
		// 	trace(fieldFunctions.get("sqrt")(9)); // Output: 3
		// }

		Conversion.wrapHaxeFunction(Math.atan2);


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
