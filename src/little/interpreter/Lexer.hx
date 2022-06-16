package little.interpreter;

import little.interpreter.features.Evaluator;
import little.exceptions.Typo;
import little.exceptions.MissingTypeDeclaration;
import little.interpreter.features.LittleDefinition;

using StringTools;
using TextTools;

class Lexer {
	/**
	 * Should detect Definitions inside:
	 * 
	 *     define x = 3
	 *     define y:Number = x
	 *     define z:Characters = "Hello"
	 *     global define a:Boolean = true
	 * 
	 * @param line a line of code
	 * @return the Definition insance, or null if it doesn't exist
	 */
	public static function detectDefinitions(line:String):LittleDefinition {
		var v:LittleDefinition = new LittleDefinition();
		line = " " + line.trim();
		if (!line.contains(" define "))
			return null;
		// replace the starting "define" with ""
		var defParts = line.split(" define ");
		//get the definition's scope and modifiers
		var modifiers = defParts[0];
		if (modifiers.contains("global")) v.scope.scope = GLOBAL;
		else {
			switch Interpreter.currentIndent {
				case 0 : v.scope.scope = MODULE;
				case _: {
					if (Interpreter.currentlyClass) v.scope.scope = CLASS;
					else v.scope.scope = Block(Interpreter.blockNumber);
				}
			}
		}
		
		// gets the Definition name, type and value.
		var valueParts = defParts[1].split("=");
		if (valueParts[0].contains(":")) {
			final type = valueParts[0].split(":")[1].replace(" ", "");
			final name = valueParts[0].split(":")[0].replace(" ", "");

			if (type == "") {
				Runtime.safeThrow(new MissingTypeDeclaration(name));
				return null;
			}

			v.name = name;
			v.type = type;
		}
		if (!valueParts[0].contains(":")) {
			v.name = valueParts[0].replace(" ", "");
			v.type = "Everything";
		}

		return v;
	}

	public static function processDefinitionValueTree(val:String):Dynamic {
		return {};
	}

	public static function detectPrint(line:String) {
		if (!line.contains("print(") && !line.endsWith(")"))
			return;
		// remove the print(
		line = line.substring(6);
		// remove the ending )
		if (!line.endsWith(")")) {
			Runtime.safeThrow(new Typo("When using the print function, you need to end it with a )"));
			return;
		}
		line = line.substring(0, line.length - 1);
		var value = Evaluator.getValueOf(line);
		Runtime.print(value);
	}

	public static function detectAction(line:String) {
		line = ' $line';
		if (!line.contains(" action ")) return;

		var titleSplit = line.split(" action ");
		var modifiers = titleSplit[0].split(" ");

		var info = titleSplit[1];
	}
}
