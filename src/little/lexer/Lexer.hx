package little.lexer;

import haxe.extern.EitherType;
import texter.general.math.MathAttribute;
import texter.general.math.MathLexer;
import little.lexer.Tokens.TokenLevel1;
import little.lexer.Tokens.ComplexToken;
import little.Keywords.*;

using StringTools;
using TextTools;

class Lexer {
	public static final numberDetector:EReg = ~/([0-9\.])/;
	public static final booleanDetector:EReg = ~/true|false/;
	public static final nameDetector:EReg = ~/(\w+)/;
	public static final typeDetector:EReg = ~/(\w+)/;
	public static final assignmentDetector:EReg = ~/(?:\w|\.)+ *(?:=[^=]+)+/;
	public static final conditionDetector:EReg = ~/^(\w+) *\(([^\n]+)\) *(?:\{{0,})/;

	/**
		Parses little source code into complex tokens. complex tokens don't handle logic, but they do handle flow.
	**/
	public static function lexIntoComplex(code:String, ?disableSkips:Bool = false):Array<ComplexToken> {
		// Replace each == with ⩵ to not confuse the assignment ereg
		code = code.replace("==", "⩵");
		// To allow writing multiple lines of code in the same line:
		code = code.replace(";", "\n");

		var tokens:Array<ComplexToken> = [];

		var l = 1;
		while (l < code.split("\n").length + 1) {
			var line = code.split("\n")[l - 1];
			// Empty lines
			if (line.replace("\t", " ").trim() == "") {
				l++;
				continue;
			}

			/* definitions:
				define x
				define x = 5
				define x as Number
				define x as Number = 5 + welcome
				define x as Number = nothing
			 */
			if (line.replace("\t", " ").trim().startsWith(VARIABLE_DECLARATION)) {
				var items = line.split(" ").filter(s -> s != "" && s != "define");
				if (items.length == 0)
					throw "Definition name and value are missing at line " + l + ".";
				if (items.length == 1) {
					if (~/[0-9\.]/g.replace(items[0], "").length == 0)
						throw "Definition name must contain at least one non-numerical character"
					else
						tokens.push(DefinitionCreationDetails(l, items[0], NULL_VALUE, TYPE_DYNAMIC));
					continue;
				}
				var _defAndVal = line.split("=");
				var defValSplit = [_defAndVal[0].split(" ").filter(s -> s != "" && s != VARIABLE_DECLARATION)];
				var defName = "", val = "", type = TYPE_DYNAMIC;
				var nameSet = false, typeSet = false;
				for (i in 0...defValSplit[0].length) {
					// name, type?
					if (defValSplit[0][i] == TYPE_CHECK_OR_CAST
						&& defValSplit[0][i + 1] != null
						&& typeDetector.replace(defValSplit[0][i + 1], "").length == 0) {
						if (!typeSet)
							type = defValSplit[0][i + 1];
						typeSet = true;
					} else if (nameDetector.replace(defValSplit[0][i], "").length == 0) {
						if (!nameSet)
							defName = defValSplit[0][i];
						nameSet = true;
					}
				}
				if (_defAndVal.length == 1) {
					val = NULL_VALUE;
					tokens.push(DefinitionCreationDetails(l, defName, val, type));
				} else {
					val = _defAndVal[1].trim();
					tokens.push(DefinitionCreationDetails(l, defName, val, type));
				}
			}

			/* assignments:
				x = something
				x = y = something
			 */
			else if (assignmentDetector.replace(line.trim().replace("\t", " "), "").length == 0) {
				var items = line.split("=");
				var value = items[items.length - 1].trim();
				var assignees = {	items.pop();	items = items.map(item -> item.trim());	items;};
				tokens.push(Assignment(l, value, assignees));

			} else if (conditionDetector.replace(line.replace("\t", " ").trim(), "").length == 0 && 
				[for (condition in CONDITION_TYPES) line.replace("\t", " ").trim().startsWith(condition)].contains(true)) {
					
				conditionDetector.match(line.replace("\t", " ").trim());
				var cWord = conditionDetector.matched(1),
					condition = conditionDetector.matched(2);

				var rawBody = Specifics.extractActionBody(Specifics.cropCode(code, l));
				var body = Lexer.lexIntoComplex("\n".multiply(l) + rawBody.body, true);
				tokens.push(ConditionStatement(l, cWord, condition, body));
				l += rawBody.lineCount;

			}

			/* actions
				action x() {}
				action x() as Decimal {}
				action x(p, a as String) {
					// Action body
				}
			 */
			else if (line.replace("\t", " ").trim().startsWith(FUNCTION_DECLARATION)) {
				var trimmed = line.replace("\t", " ").trim();
				var name = {
					var nameExtractor = new EReg(FUNCTION_DECLARATION + " +(\\w+)", "");
					nameExtractor.match(trimmed);
					nameExtractor.matched(1);
				};
				var paramsBody = trimmed.substring(trimmed.indexOf("(") + 1, trimmed.lastIndexOf(")"));

				// Extract optional type declaration by:
				// - removing the name & params body from the string
				// - removing the curly brackets, if found
				// - extracting the word after `as`
				var containsOptionalType = trimmed.substring(trimmed.lastIndexOf(")") + 1);
				if (containsOptionalType.contains("{")) {
					containsOptionalType = containsOptionalType.substring(0, containsOptionalType.lastIndexOf("{"));
				}
				containsOptionalType = containsOptionalType.trim();

				var type = if (containsOptionalType.contains(TYPE_CHECK_OR_CAST)) {
					var typeExtractor = new EReg(TYPE_CHECK_OR_CAST + " +(\\w+)", "");
					typeExtractor.match(containsOptionalType);
					try {
						typeExtractor.matched(1);
					} catch (e) {
						null;
					}
				} else null;

				var rawBody = Specifics.extractActionBody(Specifics.cropCode(code, l));
				var body = Lexer.lexIntoComplex("\n".multiply(l) + rawBody.body, true);
				tokens.push(ActionCreationDetails(l, name, paramsBody, body, type));
				l += rawBody.lineCount;
			} else {
				tokens.push(GenericExpression(l, line.replace("\t", " ").trim()));
			}
			l++;
		}

		return tokens;
	}

	static var staticValueString = '[0-9\\.]+|"[^"]+"|$TRUE_VALUE|$FALSE_VALUE|$NULL_VALUE';
	public static final staticValueDetector:EReg = new EReg(staticValueString, "");
	public static final actionCallDetector:EReg = ~/\w+ *\(.*\)$/;
	public static final definitionAccessDetector:EReg = ~/^[^0-9]\w*$/;
	public static final calculationDetection:EReg = new EReg('^(?:$staticValueString|[^ ]+\\(.*\\))+(?:[\\+\\-\\/\\*\\^%÷\\(\\) ]+(?:$staticValueString|[^ ]+\\(.*\\)))*$',
		"");

	/**
		Expects output from `lexIntoComplex()`, and returns a "simplified" version of that output.

		Use `Lexer.prettyPrintAst` to get a debugging friendly version of the ast generated by this function
	**/
	public static function splitBlocks1(complexTokens:Array<ComplexToken>):Array<TokenLevel1> {
		var tokens:Array<TokenLevel1> = [];
		for (complex in complexTokens) {
			switch complex {
				case DefinitionCreationDetails(line, name, complexValue, type):
					{
						tokens.push(SetLine(line));

						var defName = name,
							defType = type,
							defValue:TokenLevel1 = Specifics.complexValueIntoTokenLevel1(complexValue);
						tokens.push(DefinitionCreation(defName, defValue, defType));
					}
				case Assignment(line, value, assignees):
					{
						tokens.push(SetLine(line));
						final parsedValue = Specifics.complexValueIntoTokenLevel1(value);
						assignees.reverse(); // The first assignee needs to be the rightmost one
						for (assignee in assignees) {
							tokens.push(DefinitionWrite(assignee, parsedValue));
						}
					}
				case ActionCreationDetails(line, name, parameterBody, actionBody, type):
					{
						tokens.push(SetLine(line));
						var params = [for (p in parameterBody.split(",")) Specifics.extractParamForActionCreation(p)];
						var body = splitBlocks1(actionBody);
						tokens.push(ActionCreation(name, params, body, type));
					}

				case ConditionStatement(line, type, conditionExpression, conditionBody):
					{
						tokens.push(SetLine(line));
						var condition = Specifics.complexValueIntoTokenLevel1(conditionExpression);
						var body = splitBlocks1(conditionBody);
						tokens.push(Condition(type, condition, body));
					}

				case GenericExpression(line, exp):
					{
						tokens.push(SetLine(line));
						// First case: return statements
						if (exp.startsWith(FUNCTION_RETURN)) {
							tokens.push(Return(Specifics.complexValueIntoTokenLevel1(exp.replaceFirst("return", "").trim())));
						} else { // Generic cases: action calls, lone values...
							tokens.push(Specifics.complexValueIntoTokenLevel1(exp));
						}
					}
			}
		}

		return tokens;
	}

	public static function prettyPrintAst(ast:Array<TokenLevel1>, ?spacingBetweenNodes:Int = 6) {
		s = " ".multiply(spacingBetweenNodes);
		var unfilteredResult = getTree(Expression(ast), [], 0, true);
		var filtered = "";
		for (line in unfilteredResult.split("\n")) {
			if (line == "└─── Expression")
				continue;
			filtered += line.substring(spacingBetweenNodes - 1) + "\n";
		}
		return "\nAst\n" + filtered;
	}

	static function prefixFA(pArray:Array<Int>) {
		var prefix = "";
		for (i in 0...l) {
			if (pArray[i] == 1) {
				prefix += "│" + s.substring(1);
			} else {
				prefix += s;
			}
		}
		return prefix;
	}

	static function pushIndex(pArray:Array<Int>, i:Int) {
		var arr = pArray.copy();
		arr[i + 1] = 1;
		return arr;
	}

	static var s = "";
	static var l = 0;

	static function getTree(root:TokenLevel1, prefix:Array<Int>, level:Int, last:Bool):String {
		l = level;
		var t = if (last) "└" else "├";
		var c = "├";
		var d = "───";
		if (root == null)
			return "";
		switch root {
			case SetLine(line):
				return '${prefixFA(prefix)}$t$d SetLine($line)\n';
			case DefinitionCreation(name, value, type):
				{
					return
						'${prefixFA(prefix)}$t$d Definition Creation\n${getTree(StaticValue(name), prefix.copy(), level + 1, false)}${getTree(StaticValue(type), prefix.copy(), level + 1, false)}${getTree(value, prefix.copy(), level + 1, true)}';
				}
			case ActionCreation(name, params, body, type):
				{
					var title = '${prefixFA(prefix)}$t$d Action Creation\n';
					title += getTree(StaticValue(name), prefix.copy(), level + 1, false);
					title += getTree(StaticValue(type), prefix.copy(), level + 1, false);
					title += getTree(Expression(params), pushIndex(prefix, level), level + 1, false);
					title += getTree(Expression(body), prefix.copy(), level + 1, true);
					return title;
				}
			case Condition(type, exp, body):
				{
					var title = '${prefixFA(prefix)}$t$d Condition\n';
					title += getTree(StaticValue(type), prefix.copy(), level + 1, false);
					title += getTree(exp, pushIndex(prefix, level), level + 1, false);
					title += getTree(Expression(body), prefix.copy(), level + 1, true);
					return title;
				}
			case DefinitionAccess(name):
				return '${prefixFA(prefix)}$t$d $name\n';
			case DefinitionWrite(assignee, value):
				{
					return
						'${prefixFA(prefix)}$t$d Definition Write\n${getTree(StaticValue(assignee), prefix.copy(), level + 1, false)}${getTree(value, prefix.copy(), level + 1, true)}';
				}
			case StaticValue(value) | Sign(value):
				{
					return '${prefixFA(prefix)}$t$d $value\n';
				}
			case Expression(parts):
				{
					if (parts.length == 0)
						return '${prefixFA(prefix)}$t$d <empty expression>\n';
					var strParts = ['${prefixFA(prefix)}$t$d Expression\n'].concat([
						for (i in 0...parts.length - 1) getTree(parts[i], pushIndex(prefix, level), level + 1, false)
					]);
					strParts.push(getTree(parts[parts.length - 1], prefix.copy(), level + 1, true));
					return strParts.join("");
				}
			case Parameter(name, type, value):
				{
					if (name == "")
						name = "<unnamed>";
					if (type == "")
						type = "<untyped>";
					return
						'${prefixFA(prefix)}$t$d Parameter\n${getTree(StaticValue(name), prefix.copy(), level + 1, false)}${getTree(StaticValue(type), prefix.copy(), level + 1, false)}${getTree(value, prefix.copy(), level + 1, true)}';
				}
			case ActionCallParameter(value):
				{
					return '${prefixFA(prefix)}$t$d Parameter\n${getTree(value, prefix.copy(), level + 1, true)}';
				}
			case ActionCall(name, params):
				{
					var strParts = [
						'${prefixFA(prefix)}$t$d Action Call\n${getTree(StaticValue(name), prefix.copy(), level + 1, false)}'
					].concat([
						for (i in 0...params.length - 1) getTree(params[i], pushIndex(prefix, level), level + 1, false)
					]);
					if (params.length == 0)
						return strParts.join("");
					strParts.push(getTree(params[params.length - 1], prefix.copy(), level + 1, true));
					return strParts.join("");
				}
			case Return(value):
				return return '${prefixFA(prefix)}$t$d Return\n${getTree(value, prefix.copy(), level + 1, true)}';
			case InvalidSyntax(s):
				return '${prefixFA(prefix)}$t$d INVALID SYNTAX: $s\n';
		}
		return "";
	}
}
