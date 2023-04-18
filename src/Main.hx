package;

import haxe.io.Path;
import little.tools.Data;
import little.tools.Plugins;
import little.tools.Conversion;
import little.Little;
import little.interpreter.Runtime;
import little.tools.PrettyPrinter;
import little.interpreter.Interpreter;
#if js
import js.Browser;
#elseif sys 
import sys.FileSystem;
import sys.io.File;
#end
import little.parser.Parser;
import little.lexer.Lexer;

using StringTools;

class Main {
	static var code = 'action הדפס() = {print(5)}, הדפס()';

	static function main() {
		#if js
		// var text = Browser.document.getElementById("input");
		// var output = Browser.document.getElementById("output-parser");
		// var stdout = Browser.document.getElementById("output");
		// trace(text, output);
		// text.addEventListener("keyup", (_) -> {
		// 	try {
		// 		output.innerHTML = little.tools.PrettyPrinter.printParserAst(little.parser.Parser.parse(little.lexer.Lexer.lex(untyped text.value)));
		// 	} catch (e) {}

		// 	try {
		// 		Little.run(untyped text.value, true);
		// 		stdout.innerHTML = Runtime.stdout;
		// 	} catch (e) {}
		// });
		// output.innerHTML = little.tools.PrettyPrinter.printParserAst(little.parser.Parser.parse(little.lexer.Lexer.lex(untyped text.value)));
		// text.innerHTML = code;
		new JsExample();
		#elseif sys
		while (true) {
			Sys.print("  >> ");
			var input = Sys.stdin().readLine();
			try {
				Little.run(input, true);
				trace(Runtime.stdout);
			} catch (e) {
				trace(Lexer.lex(input));
				trace(PrettyPrinter.printParserAst(Parser.parse(Lexer.lex(input))));
				trace(e.details());
				trace(Runtime.stdout);
			}
		}

		//trace(Reflect.callMethod("hey", "hey".charAt, [0]));

		// var path = FileSystem.absolutePath(Path.join([Sys.getCwd(), "test", "input.txt"]));
		// var output = FileSystem.absolutePath(Path.join([Sys.getCwd(), "test", "output.txt"]));
		// var ast = FileSystem.absolutePath(Path.join([Sys.getCwd(), "test", "ast.txt"]));
		// var compilerError = FileSystem.absolutePath(Path.join([Sys.getCwd(), "test", "compiler_error.txt"]));
		// trace(path, FileSystem.exists(path), output, FileSystem.exists(output), ast, FileSystem.exists(ast), compilerError, FileSystem.exists(compilerError));
		// var lastModified = 0.;
		// while (true) {
		// 	var fileStats = FileSystem.stat(path);
		// 	var currentModified = fileStats.mtime.getTime();
		// 	if (currentModified != lastModified) {
		// 		lastModified = currentModified;
		// 		// Call your function here
		// 		var code = File.getContent(path);
		// 		if (code.endsWith("stop!")) {
		// 			File.saveContent(path, code.substr(0, code.length - 6));
		// 			break;
		// 		}
		// 		try {
		// 			File.saveContent(ast, little.tools.PrettyPrinter.printParserAst(little.parser.Parser.parse(little.lexer.Lexer.lex(code))));
		// 			File.saveContent(compilerError, "");
		// 		} catch (e) {File.saveContent(compilerError, e.details());}
	
		// 		try {
		// 			Little.run(code);
		// 			File.saveContent(output, Runtime.stdout);
		// 			File.saveContent(compilerError, "");
		// 		} catch (e) {File.saveContent(compilerError, e.details());}
				
		// 	}

		// 	// Sleep for some time before checking again
		// 	Sys.sleep(1);
		// }

		// trace(PrettyPrinter.printParserAst(Interpreter.forceCorrectOrderOfOperations(Parser.parse(Lexer.lex('1 + 1 * 3')))));
		// trace(Parser.parse(Lexer.lex('define x as String')));
		#end
	}
}
