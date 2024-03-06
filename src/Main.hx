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

	static function main() {
		#if memory_tests

		
		var memory = new Memory();
		
		trace("memory:");
		trace(memory.stringifyMemoryBytes());
		trace(memory.stringifyReservedBytes());
		
		var intPointer = memory.storage.storeInt32(-456);
		trace("int read/write", memory.storage.readInt32(intPointer));
		var floatPointer = memory.storage.storeDouble(123.456);
		trace("float read/write", memory.storage.readDouble(floatPointer));
		var stringPointer = memory.storage.storeString("hello");
		trace("string read/write", memory.storage.readString(stringPointer));
		var codePointer = memory.storage.storeCodeBlock(
			Block([
				VariableDeclaration(Identifier("z"), Identifier(Little.keywords.TYPE_INT)),
			], Identifier(Little.keywords.TYPE_INT))
		);
		trace("code read/write", memory.storage.readCodeBlock(codePointer));
		var boolPointer = memory.store(TrueValue);
		trace("bool read/write", memory.constants.getFromPointer(boolPointer));
		var nullPointer = memory.storage.storeStatic(NullValue);
		trace("null read/write", memory.constants.getFromPointer(nullPointer));
		var signPointer = memory.storage.storeSign("^&");
		trace("sign read/write", memory.storage.readSign(signPointer));

		var objectPointer = memory.storage.storeObject(
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

		trace("object read/write","\n" + PrettyPrinter.printInterpreterAst([memory.storage.readObject(objectPointer)]));

		//var classPointer = memory.storage.storeType(
		//	[VariableDeclaration(Identifier("n"), TypeReference([Little.keywords.TYPE_INT])),
		//	VariableDeclaration(Identifier("s"), TypeReference([Little.keywords.TYPE_BOOLEAN]))],
		//	[]
		//);
//
		//trace("class read/write", memory.storage.readType(classPointer));
		

		trace("memory:");
		trace(memory.stringifyMemoryBytes());
		trace(memory.stringifyReservedBytes());
		trace(memory.memory.length);
		trace(memory.reserved.toArray().filter(x -> x == 1).length);

		#elseif js
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
					}
				}
			} else {
				Little.run(input, true);
				trace(PrettyPrinter.printInterpreterAst(Interpreter.convert(...Parser.parse(Lexer.lex(input)))));
				trace(Little.runtime.stdout.output);
				Little.reset();
			}
		}
		#end
	}
}
