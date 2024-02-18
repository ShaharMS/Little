package;

import little.interpreter.memory.Memory;
import little.interpreter.Operators;
import little.tools.PrepareRun;
import little.tools.PrettyOutput;
import haxe.SysTools;
import haxe.Log;
import vision.tools.MathTools;
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
using little.tools.TextTools;

class Main {

	static function main() {
		#if memory_tests

		
		var memory = new Memory();
		
		trace("memory:");
		trace(memory.stringifyMemoryBytes());
		trace(memory.stringifyReservedBytes());
		
		var intPointer = memory.heap.storeInt32(-456);
		trace("int read/write", memory.heap.readInt32(intPointer));
		var floatPointer = memory.heap.storeDouble(123.456);
		trace("float read/write", memory.heap.readDouble(floatPointer));
		var stringPointer = memory.heap.storeString("hello");
		trace("string read/write", memory.heap.readString(stringPointer));
		var codePointer = memory.heap.storeCodeBlock(
			Block([
				VariableDeclaration(Identifier("z"), Identifier(Little.keywords.TYPE_INT)),
			], Identifier(Little.keywords.TYPE_INT))
		);
		trace("code read/write", memory.heap.readCodeBlock(codePointer));
		var boolPointer = memory.store(TrueValue);
		trace("bool read/write", memory.constants.getFromPointer(boolPointer));
		var nullPointer = memory.heap.storeStatic(NullValue);
		trace("null read/write", memory.constants.getFromPointer(nullPointer));
		var signPointer = memory.heap.storeSign("^&");
		trace("sign read/write", memory.heap.readSign(signPointer));

		var objectPointer = memory.heap.storeObject(
			Object(
				Block([FunctionReturn(Characters("hello"), Identifier(Little.keywords.TYPE_STRING))], Identifier(Little.keywords.TYPE_STRING)),
				[
					"x" => {value: Decimal(123.456), documentation: ""},
					"y" => {value: Number(456), documentation: ""},
					"Z" => {value: Characters("hello world"), documentation: ""}
				],
				Little.keywords.TYPE_DYNAMIC
			)
		);

		trace("object read/write","\n" + PrettyPrinter.printInterpreterAst([memory.heap.readObject(objectPointer)]));

		//var classPointer = memory.heap.storeType(
		//	[VariableDeclaration(Identifier("n"), TypeReference([Little.keywords.TYPE_INT])),
		//	VariableDeclaration(Identifier("s"), TypeReference([Little.keywords.TYPE_BOOLEAN]))],
		//	[]
		//);
//
		//trace("class read/write", memory.heap.readType(classPointer));
		

		trace("memory:");
		trace(memory.stringifyMemoryBytes());
		trace(memory.stringifyReservedBytes());
		trace(memory.memory.length);
		trace(memory.reserved.toArray().filter(x -> x == 1).length);

		#elseif js
		new JsExample();
		#elseif unit
		UnitTests.run();
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
						try {
							Little.run(code, true);
							trace(PrettyPrinter.printInterpreterAst(Interpreter.convert(...Parser.parse(Lexer.lex(code)))));
							trace(Runtime.stdout.output);
						} catch (e) {
							trace(Lexer.lex(code));
							trace(Parser.parse(Lexer.lex(code)));
							trace(PrettyPrinter.printInterpreterAst(Interpreter.convert(...Parser.parse(Lexer.lex(code)))));
							trace(e.details());
							trace(Runtime.stdout.output);
						}
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
					}
				}
			} else {
				try {
					Little.run(input, true);
					trace(PrettyPrinter.printInterpreterAst(Interpreter.convert(...Parser.parse(Lexer.lex(input)))));
					trace(Runtime.stdout.output);
				} catch (e) {
					trace(Lexer.lex(input));
					trace(Parser.parse(Lexer.lex(input)));
					trace(PrettyPrinter.printInterpreterAst(Interpreter.convert(...Parser.parse(Lexer.lex(input)))));
					trace(e.details());
					trace(Runtime.stdout.output);
				}
				Little.reset();
			}
		}

		// trace(Reflect.callMethod("hey", "hey".charAt, [0]));

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
