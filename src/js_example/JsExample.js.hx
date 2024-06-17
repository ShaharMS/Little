package js_example;

import js.html.Event;
import little.KeywordConfig;
import js.html.SpanElement;
import js.html.TableColElement;
import js.html.Node;
import js.Syntax;
import haxe.display.Display.Keyword;
import js.html.TableRowElement;
import js.html.TableElement;
import js.html.TextAreaElement;
import js.html.Document;
import little.interpreter.Runtime;
import little.Little;
import js.Browser;

using js_example.JsExample;
using StringTools;
class JsExample {
	var d = Browser.document;

	public function new() {
		var input:TextAreaElement = cast d.getElementById("input");
		var ast:TextAreaElement   = cast d.getElementById("ast");
		var output:TextAreaElement = cast d.getElementById("output");

		var version:SpanElement = cast d.getElementById("version");
		// var buildDate:SpanElement = cast d.getElementById("build-date");
		// var buildNumber:SpanElement = cast d.getElementById("build-number");

		version.innerText = Little.version;
        if (Little.version.endsWith("f")) d.getElementById("casing").innerHTML += " (f - Functional programming only)";

		input.addEventListener("keyup", function(_) {
			try {
				ast.value = little.tools.PrettyPrinter.printInterpreterAst(little.interpreter.Interpreter.convert(...little.parser.Parser.parse(little.lexer.Lexer.lex(input.value))));
			} catch (e) {}

			try {
				Little.reset();
				Little.run(input.value, true);
				output.value = Little.runtime.stdout.output;
			} catch (e) {}
		});

		input.onkeydown = function(e) {
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

		var keywordTable:TableElement = cast d.getElementById("k-table-body");

		/**
		    Update tables
		**/
		function update() {
			var firstRow = true;
			for (row in keywordTable.rows) {
				if (firstRow) {
					firstRow = false;
					continue;
				}
				var p = row.getElementsByTagName("p")[0];
				var input = row.getElementsByTagName("input")[0];
				p.innerText = getCodeExample(input.id);
				p.onchange();
			}
            input.dispatchEvent(new Event("keyup"));
		}

		for (keyword in Type.getInstanceFields(KeywordConfig)) {
			if (keyword == "change")
				continue;
            if (getCodeExample(keyword) == "irrelevant") continue;
			var row = d.createTableRowElement();

			var usage = d.createTextNode(keyword.snakeToTitleCase());

			var input = d.createInputElement();
			input.id = keyword;
			input.placeholder = "single word, e.g. " + Reflect.field(Little.keywords, keyword);
			input.onchange = () -> {
				Reflect.setField(Little.keywords, keyword,
					input.value != null ? (input.value != "" ? input.value : Reflect.field(Little.keywords,
						keyword)) : Reflect.field(Little.keywords, keyword));
				update();
			}

			var p = d.createParagraphElement();

			var td1 = d.createTableCellElement();
			td1.appendChild(usage);
			var td2 = d.createTableCellElement();
			td2.appendChild(input);
			var td3 = d.createTableCellElement();
			td3.appendChild(p);

			row.appendChild(td1);
			row.appendChild(td2);
			row.appendChild(td3);

			keywordTable.appendChild(row);
		}

		Syntax.plainCode("Highlighter.registerOnParagraphs()");
		Syntax.plainCode('document.getElementById("input").dispatchEvent(new Event("keyup"));');

		update();
	}

	public function getCodeExample(keyword:String) {
		var ret = switch keyword {
			case "VARIABLE_DECLARATION": '${Little.keywords.VARIABLE_DECLARATION} x ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_INT} = 8';
			case "FUNCTION_DECLARATION": '${Little.keywords.FUNCTION_DECLARATION} y(${Little.keywords.VARIABLE_DECLARATION} parameter, ${Little.keywords.VARIABLE_DECLARATION} times ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_INT}) ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_STRING} =  {\n&nbsp;&nbsp;&nbsp;&nbsp;${Little.keywords.FUNCTION_RETURN} parameter ${Little.keywords.MULTIPLY_SIGN} times\n}\n${Little.keywords.PRINT_FUNCTION_NAME}(y("Hey", 3))';
			case "NULL_VALUE": 'if (x ${Little.keywords.EQUALS_SIGN} ${Little.keywords.NULL_VALUE}) {}\n${Little.keywords.VARIABLE_DECLARATION} x = ${Little.keywords.NULL_VALUE}';
			case "RUN_CODE_FUNCTION_NAME": '${Little.keywords.RUN_CODE_FUNCTION_NAME}("${Little.keywords.PRINT_FUNCTION_NAME}(5 ${Little.keywords.ADD_SIGN} 3)")';
			case "RAISE_ERROR_FUNCTION_NAME": '${Little.keywords.RAISE_ERROR_FUNCTION_NAME}("My Own Custom Error! :D")';
			case "PRINT_FUNCTION_NAME": '${Little.keywords.PRINT_FUNCTION_NAME}("Hello World")';
			case "TYPE_DECL_OR_CAST": '${Little.keywords.VARIABLE_DECLARATION} x ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_STRING}\nx = ${Little.keywords.TRUE_VALUE} ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_STRING} """ "${Little.keywords.TRUE_VALUE}" """';
			case "TYPE_CAST_FUNCTION_PREFIX": 'if (1${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.TYPE_CAST_FUNCTION_PREFIX}${Little.keywords.TYPE_BOOLEAN}()) {\n&nbsp;&nbsp;&nbsp;&nbsp;${Little.keywords.PRINT_FUNCTION_NAME}("${Little.keywords.TRUE_VALUE}"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.TYPE_CAST_FUNCTION_PREFIX}${Little.keywords.TYPE_BOOLEAN}()${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.TYPE_CAST_FUNCTION_PREFIX}${Little.keywords.TYPE_INT}())\n}';
			case "TYPE_FLOAT": '${Little.keywords.VARIABLE_DECLARATION} x ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_FLOAT} = 8.8';
			case "TYPE_INT": '${Little.keywords.VARIABLE_DECLARATION} x ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_INT} = 8';
			case "TYPE_BOOLEAN": '${Little.keywords.VARIABLE_DECLARATION} x ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_BOOLEAN} = ${Little.keywords.TRUE_VALUE} || ${Little.keywords.FALSE_VALUE}';
			case "TYPE_STRING": '${Little.keywords.VARIABLE_DECLARATION} x ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_STRING} = "Hey There!"';
			case "TYPE_MODULE": '${Little.keywords.VARIABLE_DECLARATION} x ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_MODULE} = ${Little.keywords.TYPE_BOOLEAN}';
			case "TYPE_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_SIGN} = ${Little.keywords.ADD_SIGN}';
			case "TYPE_OBJECT": '${Little.keywords.VARIABLE_DECLARATION} x ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_OBJECT} = ${Little.keywords.TYPE_OBJECT}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.INSTANTIATE_FUNCTION_NAME}()\n${Little.keywords.VARIABLE_DECLARATION} x${Little.keywords.PROPERTY_ACCESS_SIGN}y = 4\n${Little.keywords.PRINT_FUNCTION_NAME}(x${Little.keywords.PROPERTY_ACCESS_SIGN}y) """4"""';
			case "TYPE_MEMORY": '${Little.keywords.VARIABLE_DECLARATION} x = ${Little.keywords.TYPE_MEMORY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__MEMORY_allocate}(amount)\n${Little.keywords.TYPE_MEMORY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__MEMORY_write}(x, myNumericArray)\n${Little.keywords.TYPE_MEMORY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__MEMORY_free}(x, arrayByteAmount)\n${Little.keywords.PRINT_FUNCTION_NAME}(${Little.keywords.TYPE_MEMORY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__MEMORY_size} ${Little.keywords.DIVIDE_SIGN} ${Little.keywords.TYPE_MEMORY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__MEMORY_maxSize})';
			case "TYPE_UNKNOWN": '${Little.keywords.VARIABLE_DECLARATION} x, ${Little.keywords.PRINT_FUNCTION_NAME}(x${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.OBJECT_TYPE_PROPERTY_NAME}) """ ${Little.keywords.TYPE_UNKNOWN} """';
			case "TYPE_ARRAY": '${Little.keywords.VARIABLE_DECLARATION} array ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_ARRAY} = ${Little.keywords.TYPE_ARRAY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.INSTANTIATE_FUNCTION_NAME}(${Little.keywords.TYPE_STRING}, 3)\narray${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__ARRAY_set}(1, "Hey!")\n${Little.keywords.PRINT_FUNCTION_NAME}(array${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__ARRAY_get}(1)) """ "Hey!" """\n${Little.keywords.PRINT_FUNCTION_NAME}(array${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__ARRAY_length}) """ 3 """';
			case "TYPE_FUNCTION": '${Little.keywords.FUNCTION_DECLARATION} x() = {}\n${Little.keywords.PRINT_FUNCTION_NAME}(x${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.OBJECT_TYPE_PROPERTY_NAME}) """ ${Little.keywords.TYPE_FUNCTION} """';
			case "TYPE_CONDITION": '${Little.keywords.PRINT_FUNCTION_NAME}(${Little.keywords.CONDITION__IF}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.OBJECT_TYPE_PROPERTY_NAME}) """ ${Little.keywords.TYPE_CONDITION} """';
			case "FUNCTION_RETURN": '${Little.keywords.FUNCTION_DECLARATION} y() = {\n&nbsp;&nbsp;&nbsp;&nbsp;${Little.keywords.FUNCTION_RETURN} 8\n}';
			case "READ_FUNCTION_NAME": '${Little.keywords.VARIABLE_DECLARATION} x = 3\n${Little.keywords.READ_FUNCTION_NAME}("x")';
			case "TYPE_DYNAMIC": '${Little.keywords.VARIABLE_DECLARATION} x ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_DYNAMIC} = nothing';
			case "PROPERTY_ACCESS_SIGN": '${Little.keywords.VARIABLE_DECLARATION} len = 8${Little.keywords.PROPERTY_ACCESS_SIGN}type${Little.keywords.PROPERTY_ACCESS_SIGN}length\n${Little.keywords.PRINT_FUNCTION_NAME}(len${Little.keywords.PROPERTY_ACCESS_SIGN}type) """ ${Little.keywords.TYPE_INT} """';
			case "TRUE_VALUE": '${Little.keywords.VARIABLE_DECLARATION} x ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_BOOLEAN} = ${Little.keywords.TRUE_VALUE} ${Little.keywords.OR_SIGN} ${Little.keywords.FALSE_VALUE}\nif (${Little.keywords.TRUE_VALUE}) {}';
			case "FALSE_VALUE": '${Little.keywords.VARIABLE_DECLARATION} x ${Little.keywords.TYPE_DECL_OR_CAST} ${Little.keywords.TYPE_BOOLEAN} = ${Little.keywords.TRUE_VALUE} ${Little.keywords.AND_SIGN} ${Little.keywords.FALSE_VALUE}\nif (${Little.keywords.FALSE_VALUE}) {}';
			case "EQUALS_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = ${Little.keywords.TRUE_VALUE} ${Little.keywords.EQUALS_SIGN} ${Little.keywords.TRUE_VALUE}\nif (x ${Little.keywords.EQUALS_SIGN} ${Little.keywords.TRUE_VALUE}) {}';
			case "NOT_EQUALS_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = ${Little.keywords.TRUE_VALUE} ${Little.keywords.NOT_EQUALS_SIGN} ${Little.keywords.TRUE_VALUE}\nif (x ${Little.keywords.NOT_EQUALS_SIGN} ${Little.keywords.TRUE_VALUE}) {}';
			case "LARGER_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = 5\nif (x ${Little.keywords.LARGER_SIGN} 1) {}';
			case "SMALLER_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = ${Little.keywords.NEGATE_SIGN}5\nif (x ${Little.keywords.SMALLER_SIGN} 1) {}';
			case "LARGER_EQUALS_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = 5\nif (x ${Little.keywords.LARGER_EQUALS_SIGN} 1 ${Little.keywords.ADD_SIGN} 4) {}';
			case "SMALLER_EQUALS_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = 5\nif (x ${Little.keywords.SMALLER_EQUALS_SIGN} ${Little.keywords.NEGATE_SIGN}(1 ${Little.keywords.ADD_SIGN} 4)) {}';
			case "XOR_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = ${Little.keywords.TRUE_VALUE} ${Little.keywords.XOR_SIGN} ${Little.keywords.TRUE_VALUE}\nif (x ${Little.keywords.XOR_SIGN} ${Little.keywords.TRUE_VALUE}) {}';
			case "OR_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = ${Little.keywords.TRUE_VALUE} ${Little.keywords.OR_SIGN} ${Little.keywords.TRUE_VALUE}\nif (x ${Little.keywords.OR_SIGN} ${Little.keywords.TRUE_VALUE}) {}';
			case "AND_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = ${Little.keywords.TRUE_VALUE} ${Little.keywords.AND_SIGN} ${Little.keywords.TRUE_VALUE}\nif (x ${Little.keywords.AND_SIGN} ${Little.keywords.TRUE_VALUE}) {}';
			case "NOT_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = ${Little.keywords.NOT_SIGN}${Little.keywords.TRUE_VALUE}\nif (${Little.keywords.NOT_SIGN}x) {}';
			case "ADD_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = 1 ${Little.keywords.ADD_SIGN} 2\n${Little.keywords.PRINT_FUNCTION_NAME}(x) """ 3 """';
			case "SUBTRACT_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = 1 ${Little.keywords.SUBTRACT_SIGN} 2\n${Little.keywords.PRINT_FUNCTION_NAME}(x) """ ${Little.keywords.NEGATE_SIGN}1 """';
			case "MULTIPLY_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = 1 ${Little.keywords.MULTIPLY_SIGN} 2\n${Little.keywords.PRINT_FUNCTION_NAME}(x) """ 2 """';
			case "DIVIDE_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = 1 ${Little.keywords.DIVIDE_SIGN} 2\n${Little.keywords.PRINT_FUNCTION_NAME}(x) """ 0.5 """';
			case "MOD_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = 1 ${Little.keywords.MOD_SIGN} 2\n${Little.keywords.PRINT_FUNCTION_NAME}(x) """ 1 """';
			case "POW_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = 1 ${Little.keywords.POW_SIGN} 2\n${Little.keywords.PRINT_FUNCTION_NAME}(x) """ 1 """';
			case "FACTORIAL_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = 1 ${Little.keywords.FACTORIAL_SIGN}\n${Little.keywords.PRINT_FUNCTION_NAME}(x) """ 1 """';
			case "SQRT_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = 3${Little.keywords.SQRT_SIGN}8 ${Little.keywords.ADD_SIGN} ${Little.keywords.SQRT_SIGN}25 \n${Little.keywords.PRINT_FUNCTION_NAME}(x) """ 7 """';
			case "NEGATE_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = ${Little.keywords.NEGATE_SIGN}1 \n${Little.keywords.PRINT_FUNCTION_NAME}(x) """ ${Little.keywords.NEGATE_SIGN}1 """';
			case "POSITIVE_SIGN": '${Little.keywords.VARIABLE_DECLARATION} x = ${Little.keywords.POSITIVE_SIGN}1 \n${Little.keywords.PRINT_FUNCTION_NAME}(x) """ 1 """';
			case "OBJECT_TYPE_PROPERTY_NAME": '${Little.keywords.PRINT_FUNCTION_NAME}(1${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.OBJECT_TYPE_PROPERTY_NAME}) """ ${Little.keywords.TYPE_INT} """';
			case "OBJECT_ADDRESS_PROPERTY_NAME": '${Little.keywords.PRINT_FUNCTION_NAME}(0${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.OBJECT_ADDRESS_PROPERTY_NAME}) """ ${Little.memory.constants.ZERO.rawLocation} """';
			case "CONDITION__FOR_LOOP": '${Little.keywords.CONDITION__FOR_LOOP} (${Little.keywords.FOR_LOOP_FROM} 0 ${Little.keywords.FOR_LOOP_TO} 10 ${Little.keywords.FOR_LOOP_JUMP} 2) { ${Little.keywords.PRINT_FUNCTION_NAME}(x) """ 0, 2, 4, 6, 8 """ }';
			case "CONDITION__WHILE_LOOP": '${Little.keywords.CONDITION__WHILE_LOOP} (${Little.keywords.TRUE_VALUE}) {\n&nbsp;&nbsp;&nbsp;&nbsp;${Little.keywords.PRINT_FUNCTION_NAME}(x), x = x ${Little.keywords.ADD_SIGN} 1 """ 0, 1, 2, 3, 4... """\n}';
			case "CONDITION__IF": '${Little.keywords.CONDITION__IF} (${Little.keywords.TRUE_VALUE}) { ${Little.keywords.PRINT_FUNCTION_NAME}(0) """ 0 """ }';
			case "CONDITION__ELSE": '${Little.keywords.CONDITION__IF} (${Little.keywords.FALSE_VALUE}) {}\n${Little.keywords.CONDITION__ELSE} ${Little.keywords.CONDITION__IF} (0${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.TYPE_CAST_FUNCTION_PREFIX}${Little.keywords.TYPE_BOOLEAN}) {}\n${Little.keywords.CONDITION__ELSE} { ${Little.keywords.PRINT_FUNCTION_NAME}(1) """ 1 """ }';
			case "CONDITION__WHENEVER": '${Little.keywords.CONDITION__WHENEVER} (value ${Little.keywords.EQUALS_SIGN} ${Little.keywords.TRUE_VALUE}) { ${Little.keywords.PRINT_FUNCTION_NAME}(0) """ 0 Every time this is true. """ }';
			case "CONDITION__AFTER": '${Little.keywords.CONDITION__AFTER} (value ${Little.keywords.EQUALS_SIGN} ${Little.keywords.TRUE_VALUE}) { ${Little.keywords.PRINT_FUNCTION_NAME}(0) """ 0 Only once. """ }';
			case "STDLIB__FLOAT_isWhole": '5.6${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__FLOAT_isWhole}()';
			case "STDLIB__STRING_length": '"Hey There"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_length}';
			case "STDLIB__STRING_toLowerCase": '"HEY THERE"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_toLowerCase}()';
			case "STDLIB__STRING_toUpperCase": '"hey there"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_toUpperCase}()';
			case "STDLIB__STRING_trim": '"  Hey There  "${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_trim}()';
			case "STDLIB__STRING_substring": '"Hey There erowih"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_substring}(0, 10)';
			case "STDLIB__STRING_charAt": '"Hey ! There"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_charAt}(4)';
			case "STDLIB__STRING_split": '""${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_split}(" ")';
			case "STDLIB__STRING_replace": '"Hey There"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_replace}("There", "You!")';
			case "STDLIB__STRING_remove": '"Hey, You There"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_remove}(", You ")';
			case "STDLIB__STRING_contains": '"Hey There"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_contains}("There")';
			case "STDLIB__STRING_indexOf": '"Hey There"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_indexOf}("The")';
			case "STDLIB__STRING_lastIndexOf": '"Hey There"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_lastIndexOf}("e")';
			case "STDLIB__STRING_startsWith": '"Hey There"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_startsWith}("Hey")';
			case "STDLIB__STRING_endsWith": '"Hey There"${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_endsWith}("ere")';
			case "STDLIB__STRING_fromCharCode": '${Little.keywords.TYPE_STRING}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__STRING_fromCharCode}(72)';
			case "STDLIB__ARRAY_length": 'myArray${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__ARRAY_length}';
			case "STDLIB__ARRAY_elementType": 'myArray${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__ARRAY_elementType} """ An Array of Strings will return `${Little.keywords.TYPE_STRING}`"""';
			case "STDLIB__ARRAY_get": 'myArray${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__ARRAY_get}(0)';
			case "STDLIB__ARRAY_set": 'myArray${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__ARRAY_set}(0, "Hey")';
			case "STDLIB__MEMORY_allocate": '${Little.keywords.VARIABLE_DECLARATION} address = ${Little.keywords.TYPE_MEMORY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__MEMORY_allocate}(byteAmount)';
			case "STDLIB__MEMORY_free": '${Little.keywords.TYPE_MEMORY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__MEMORY_free}(address, byteAmount)';
			case "STDLIB__MEMORY_read": '${Little.keywords.TYPE_MEMORY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__MEMORY_read}(address, valueType """`${Little.keywords.TYPE_INT}`, `${Little.keywords.TYPE_BOOLEAN}`...""")';
			case "STDLIB__MEMORY_write": '${Little.keywords.TYPE_MEMORY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__MEMORY_write}(address, myNumericOrBooleanArray)';
			case "STDLIB__MEMORY_size": '${Little.keywords.TYPE_MEMORY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__MEMORY_size}';
			case "STDLIB__MEMORY_maxSize": '${Little.keywords.TYPE_MEMORY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.STDLIB__MEMORY_maxSize}';
			case "FOR_LOOP_FROM": '${Little.keywords.CONDITION__FOR_LOOP} (${Little.keywords.FOR_LOOP_FROM} 0 ${Little.keywords.FOR_LOOP_TO} 10 ${Little.keywords.FOR_LOOP_JUMP} 2) { ${Little.keywords.PRINT_FUNCTION_NAME}(x) """ 0, 2, 4, 6, 8 """ }';
			case "FOR_LOOP_TO": '${Little.keywords.CONDITION__FOR_LOOP} (${Little.keywords.FOR_LOOP_FROM} 0 ${Little.keywords.FOR_LOOP_TO} 10 ${Little.keywords.FOR_LOOP_JUMP} 2) { ${Little.keywords.PRINT_FUNCTION_NAME}(x) """ 0, 2, 4, 6, 8 """ }';
			case "FOR_LOOP_JUMP": '${Little.keywords.CONDITION__FOR_LOOP} (${Little.keywords.FOR_LOOP_FROM} 0 ${Little.keywords.FOR_LOOP_TO} 10 ${Little.keywords.FOR_LOOP_JUMP} 2) { ${Little.keywords.PRINT_FUNCTION_NAME}(x) """ 0, 2, 4, 6, 8 """ }';
			case "INSTANTIATE_FUNCTION_NAME": '${Little.keywords.VARIABLE_DECLARATION} x = ${Little.keywords.TYPE_OBJECT}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.INSTANTIATE_FUNCTION_NAME}()\n${Little.keywords.VARIABLE_DECLARATION} a = ${Little.keywords.TYPE_ARRAY}${Little.keywords.PROPERTY_ACCESS_SIGN}${Little.keywords.INSTANTIATE_FUNCTION_NAME}(${Little.keywords.TYPE_STRING}, 10)';
			case "RECOGNIZED_SIGNS": "irrelevant";
			case "CONDITION_PATTERN_PARAMETER_NAME": "irrelevant";
			case "CONDITION_BODY_PARAMETER_NAME": "irrelevant";
			case "MAIN_MODULE_NAME": "irrelevant";
			case "REGISTERED_MODULE_NAME": "irrelevant";
			case _: '""" No Example Yet! Stay tuned... """';
		}

        return ret == '' ? '""" No Example Yet! Stay tuned... """' : ret;
	}

	static function snakeToTitleCase(str:String):String {
		var words = str.split("_");
		for (i in 0...words.length) {
			var word = words[i];
			if (word.length > 0) {
				var firstChar = word.charAt(0);
				var rest = word.substr(1);
				words[i] = firstChar.toUpperCase() + rest.toLowerCase();
			}
		}
		return words.join(" ");
	}
}
