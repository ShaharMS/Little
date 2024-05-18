package;

import haxe.Resource;
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

		var preDefInput:String = null;

		Sys.print("Little Interpreter v" + Little.version + "\n\n" + "Type \"ml!\" for multi-line mode, \"default!\" for single-line mode, or \"ast!\" for abstract syntax tree mode.\nPress `Ctrl`+`C` to exit at any time.\n\n");
		Sys.print("If You're new to the language, type \"printSample!\" to print a file of sample code.\n\n");
		Sys.println("-------------SINGLE-LINE MODE--------------\n");
		while (true) {
			if (preDefInput == null) Sys.print("  >> ");
			var input = preDefInput ?? Sys.stdin().readLine();
			if (input == "ml!") {
				Sys.command("cls");
				Sys.print("--------------MULTI-LINE MODE--------------\n");
				Sys.println("Commands:\n\t- \"run!\": runs the code\n\t- \"clear!\": resets the code\n\t- \"clearLine!\": deletes the last line\n");
				Sys.println("Command \"printSample!\" is temporarily disabled. return to single-line or ast mode to use it again\n");
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
						Sys.println("-------------SINGLE-LINE MODE--------------\n");
						break;
					} else if (input == "ast!") {
						Sys.command("cls");
						preDefInput = "ast!";
						break;	
					} else if (input == "clear!") {
						code = "";
						Sys.command("cls");
						Sys.println("--------------MULTI-LINE MODE--------------\n");
					} else if (input == "clearLine!") {
						Sys.command("cls");
						Sys.println("--------------MULTI-LINE MODE--------------\n");
						Sys.print(code.replaceFirst("\n", "  >> ").replace("\n", "\n  >> ") + "\n");
						code = code.split("\n").slice(0, -1).join("\n");
					} else {
						code += "\n" + input;
					}
				}
				if (preDefInput == "ast!") continue; // A little hacky, i don't mind though
			} else if (input == "ast!") {
				Sys.println('${preDefInput == "ast!" ? "" : "\n"}---------ABSTRACT SYNTAX TREE MODE---------\n');
				while (true) {
					Sys.print("  >> ");
					var input = Sys.stdin().readLine();
					if (input == "default!") {
						Sys.println("\n-------------SINGLE-LINE MODE--------------\n");
						break;
					} else if (input == "printSample!") {
						Sys.println("\n---------------SAMPLE CODE-----------------\n");
						Sys.println(Resource.getString("sample"));
						Sys.println("\n---------ABSTRACT SYNTAX TREE MODE---------\n");
						continue;
					}
					try {
						Sys.println(PrettyPrinter.printInterpreterAst(Interpreter.convert(...Parser.parse(Lexer.lex(input)))));
					} catch (e) {}
				}
			} else if (input == "printSample!") {
				Sys.println("\n---------------SAMPLE CODE-----------------\n");
				Sys.println(Resource.getString("sample"));
				Sys.println("\n-------------SINGLE-LINE MODE--------------\n");
			} else {
				Little.run(input, true);
				//trace(PrettyPrinter.printInterpreterAst(Interpreter.convert(...Parser.parse(Lexer.lex(input)))));
				trace(Little.runtime.stdout.output);
				Little.reset();
			}
			preDefInput = null;
		}
		#end
	}
}
