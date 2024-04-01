package;

import little.interpreter.memory.Memory;
import little.tools.PrepareRun;
import little.tools.PrettyOutput;
import haxe.SysTools;
import haxe.Log;
import vision.tools.MathTools;
import haxe.io.Path;
import little.tools.Plugins;
import little.tools.Conversion;
import little.Little;
import little.interpreter.Runtime;
import little.tools.PrettyPrinter;
import little.interpreter.Interpreter;
#if js
import js.Browser;
import js_example.JsExample;
#elseif sys
import sys.FileSystem;
import sys.io.File;
#end
import little.parser.Parser;
import little.lexer.Lexer;

using StringTools;
using little.tools.TextTools;

class Main {

	/**
		The main function - the entry point of the program
	**/
	static function main() {
		#if js
		new JsExample();
		#elseif unit
		UnitTests.run(true);
		#elseif sys
		while (true) {
			Sys.print("  >> ");
			var input = Sys.stdin().readLine();
			if (input == "ml!") {
				Sys.command("cls");
				Sys.print("---------MULTI-LINE MODE---------\n");
				var code = "";
				while (true) {
					Sys.print("  >> ");
					var input = Sys.stdin().readLine();
					if (input == "run!") {
						Little.run(code, true);
						trace(PrettyPrinter.printInterpreterAst(Interpreter.convert(...Parser.parse(Lexer.lex(code)))));
						trace(Little.runtime.stdout.output);
						Little.reset();
						Sys.print(code.replaceFirst("\n", "  >> ").replace("\n", "\n  >> ") + "\n");
					} else if (input == "default!") {
						Sys.command("cls");
						Sys.println("---------SINGLE-LINE MODE---------");
						break;
					} else if (input == "clear!") {
						code = "";
						Sys.command("cls");
						Sys.println("---------MULTI-LINE MODE---------");
					} else if (input == "clearLine!") {
						Sys.command("cls");
						Sys.println("---------MULTI-LINE MODE---------");
						Sys.print(code.replaceFirst("\n", "  >> ").replace("\n", "\n  >> ") + "\n");
						code = code.split("\n").slice(0, -1).join("\n");
					} else {
						code += "\n" + input;
					}
				}
			} else if (input == "ast!") {
				Sys.println("---------ABSTRACT SYNTAX TREE MODE---------");
				while (true) {
					Sys.print("  >> ");
					var input = Sys.stdin().readLine();
					if (input == "default!") {
						Sys.println("---------SINGLE-LINE MODE---------");
						break;
					}
					try {
						Sys.println(PrettyPrinter.printInterpreterAst(Interpreter.convert(...Parser.parse(Lexer.lex(input)))));
					} catch (e) {}
				}
			} else {
				Little.run(input, true);
				//trace(PrettyPrinter.printInterpreterAst(Interpreter.convert(...Parser.parse(Lexer.lex(input)))));
				trace(Little.runtime.stdout.output);
				Little.reset();
			}
		}
		#end
	}
}
