package little.parser;

import little.parser.Tokens.ParserTokens;
import sys.net.Address;
import little.lexer.Tokens.LexerTokens;
import little.parser.Tokens.UnInfoedParserTokens;
import little.parser.Specifics.*;
import little.Keywords.*;

using StringTools;
using TextTools;

/**
	Converts lexer tokens into interpretable ones
**/
class Parser {
	
	public static final numberDetector:EReg = ~/([0-9]+)/;
	public static final decimalDetector:EReg = ~/([0-9\.]+)/;
	public static final booleanDetector:EReg = ~/true|false/;
	public static final stringDetector:EReg = ~/"[^"]*"/;

	/**
		evaluate expressions' types, and assign them.
	**/
	public static function typeTokens(tokens:Array<LexerTokens>):Array<UnInfoedParserTokens> {
		var unInfoedParserTokens = [];

		for (token in tokens) {
			unInfoedParserTokens.push(switch token {
				case DefinitionCreation(name, value, type): DefinitionCreation(name, typeTokens([value])[0], type);
				case ActionCreation(name, params, body, type): ActionCreation(name, typeTokens(params), typeTokens(body), type);
				case DefinitionAccess(name): DefinitionAccess(name);
				case DefinitionWrite(assignee, value): DefinitionWrite(assignee, typeTokens([value])[0], evaluateExpressionType(value));
				case Sign(sign): Sign(sign);
				case StaticValue(value): StaticValue(value, evaluateExpressionType(StaticValue(value)));
				case Expression(parts): Expression(typeTokens(parts), evaluateExpressionType(Expression(parts)));
				case Parameter(name, type, value): Parameter(name, if (type == null) evaluateExpressionType(value) else type, typeTokens([value])[0]);
				case ActionCallParameter(value): ActionCallParameter(typeTokens([value])[0], evaluateExpressionType(value));
				case ActionCall(name, params): ActionCall(name, typeTokens(params), evaluateExpressionType(params[params.length - 1]));
				case Return(value): Return(typeTokens([value])[0], evaluateExpressionType(value));
				case InvalidSyntax(string): InvalidSyntax(string);
				case Condition(type, c, body): Condition(type, typeTokens([c])[0], typeTokens(body));
				case SetLine(line): SetLine(line);
			});
		}

		return unInfoedParserTokens;
	}

	public static function assignNesting(tokens:Array<UnInfoedParserTokens>, ?currentNestingLevel:Int = 0):Array<ParserTokens> {
		return tokens.map(token -> convertSingleToken(token, 0));
	}

	public static function convertSingleToken(t:UnInfoedParserTokens, nesting:Int):ParserTokens {
		return switch t {
			case SetLine(line): SetLine(line, nesting);
			case DefinitionCreation(name, value, type): DefinitionCreation(name, convertSingleToken(value, nesting), type, nesting);
			case ActionCreation(name, params, body, type): ActionCreation(name, [for (param in params) convertSingleToken(param, nesting + 1)], [for (value in body) convertSingleToken(value, nesting + 1)], type, nesting);
			case DefinitionAccess(name): DefinitionAccess(name, nesting);
			case DefinitionWrite(assignee, value, valueType): DefinitionWrite(assignee, convertSingleToken(value, nesting), valueType, nesting);
			case Sign(sign): Sign(sign, nesting);
			case StaticValue(value, type): StaticValue(value, type, nesting);
			case Expression(parts, type): Expression([for (value in parts) convertSingleToken(value, nesting + 1)], type, nesting);
			case Parameter(name, type, value): Parameter(name, type, convertSingleToken(value, nesting), nesting);
			case ActionCallParameter(value, type): ActionCallParameter(convertSingleToken(value, nesting), type, nesting);
			case ActionCall(name, params, returnType): ActionCall(name, [for (param in params) convertSingleToken(param, nesting + 1)], returnType, nesting);
			case Return(value, type): Return(convertSingleToken(value, nesting), type, nesting);
			case Error(title, reason): Error(title, reason, nesting);
			case InvalidSyntax(string): InvalidSyntax(string, nesting);
			case Condition(type, c, body): Condition(type, convertSingleToken(c, nesting + 1), [for (value in body) convertSingleToken(value, nesting + 1)], nesting);
		} 
	}

	public static function signWithModule(tokens:Array<ParserTokens>, moduleName:String):Array<ParserTokens> {
		return [
			for (token in tokens) {
				switch token {
					case SetLine(line, nestingLevel, _): SetLine(line, nestingLevel, moduleName);
					case DefinitionCreation(name, value, type, nestingLevel, _): DefinitionCreation(name, value, type, nestingLevel, moduleName);
					case ActionCreation(name, params, body, type, nestingLevel, _): ActionCreation(name, params, body, type, nestingLevel, moduleName);
					case DefinitionAccess(name, nestingLevel, _): DefinitionAccess(name, nestingLevel, moduleName);
					case DefinitionWrite(assignee, value, valueType, nestingLevel, _): DefinitionWrite(assignee, value, valueType, nestingLevel, moduleName);
					case Sign(sign, nestingLevel, _): Sign(sign, nestingLevel, moduleName);
					case StaticValue(value, type, nestingLevel, _): StaticValue(value, type, nestingLevel, moduleName);
					case Expression(parts, type, nestingLevel, _): Expression(parts, type, nestingLevel, moduleName);
					case Parameter(name, type, value, nestingLevel, _): Parameter(name, type, value, nestingLevel, moduleName);
					case ActionCallParameter(value, type, nestingLevel, _): ActionCallParameter(value, type, nestingLevel, moduleName);
					case ActionCall(name, params, returnType, nestingLevel, _): ActionCall(name, params, returnType, nestingLevel, moduleName);
					case Return(value, type, nestingLevel, _): Return(value, type, nestingLevel, moduleName);
					case Error(title, reason, nestingLevel, _): Error(title, reason, nestingLevel, moduleName);
					case InvalidSyntax(string, nestingLevel, _): InvalidSyntax(string, nestingLevel, moduleName);
					case Condition(type, c, body, nestingLevel, _): Condition(type, c, body, nestingLevel, moduleName);
				}
			}
		];
	}

	public static function prettyPrintAst(ast:Array<UnInfoedParserTokens>, ?spacingBetweenNodes:Int = 6) {
		s = " ".multiply(spacingBetweenNodes);
		var unfilteredResult = getTree(Expression(ast, ""), [], 0, true);
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

	static function getTree(root:UnInfoedParserTokens, prefix:Array<Int>, level:Int, last:Bool):String {
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
						'${prefixFA(prefix)}$t$d Definition Creation\n${getTree(StaticValue(name, ""), prefix.copy(), level + 1, false)}${getTree(StaticValue(type, ""), prefix.copy(), level + 1, false)}${getTree(value, prefix.copy(), level + 1, true)}';
				}
			case ActionCreation(name, params, body, type):
				{
					var title = '${prefixFA(prefix)}$t$d Action Creation\n';
					title += getTree(StaticValue(name, ""), prefix.copy(), level + 1, false);
					title += getTree(StaticValue(type, ""), prefix.copy(), level + 1, false);
					title += getTree(Expression(params, ""), pushIndex(prefix, level), level + 1, false);
					title += getTree(Expression(body, ""), prefix.copy(), level + 1, true);
					return title;
				}
			case Condition(type, exp, body):
				{
					var title = '${prefixFA(prefix)}$t$d Condition\n';
					title += getTree(StaticValue(type, ""), prefix.copy(), level + 1, false);
					title += getTree(exp, pushIndex(prefix, level), level + 1, false);
					title += getTree(Expression(body, ""), prefix.copy(), level + 1, true);
					return title;
				}
			case DefinitionAccess(name):
				return '${prefixFA(prefix)}$t$d $name\n';
			case DefinitionWrite(assignee, value, type):
				{
					var addon = type != "" ? ' ($type)' : "";
					return'${prefixFA(prefix)}$t$d Definition Write$addon\n${getTree(StaticValue(assignee, ""), prefix.copy(), level + 1, false)}${getTree(value, prefix.copy(), level + 1, true)}';
				}
			case Sign(value):
				{
					return '${prefixFA(prefix)}$t$d $value\n';
				}
			case StaticValue(value, type): {
				var addon = type != "" ? ' ($type)' : "";
				return '${prefixFA(prefix)}$t$d $value$addon\n';
			}
			case Expression(parts, type):
				{
					if (parts.length == 0)
						return '${prefixFA(prefix)}$t$d <empty expression>\n';
					var addon = type != "" ? ' ($type)' : "";
					var strParts = ['${prefixFA(prefix)}$t$d Expression$addon\n'].concat([
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
					var addon = type != "" ? ' ($type)' : "";
					return
						'${prefixFA(prefix)}$t$d Parameter$addon\n${getTree(StaticValue(name, ""), prefix.copy(), level + 1, false)}${getTree(value, prefix.copy(), level + 1, true)}';
				}
			case ActionCallParameter(value, type):
				{
					var addon = type != "" ? ' ($type)' : "";
					return '${prefixFA(prefix)}$t$d Parameter$addon\n${getTree(value, prefix.copy(), level + 1, true)}';
				}
			case ActionCall(name, params, type):
				{
					var addon = type != "" ? ' ($type)' : "";
					var strParts = [
						'${prefixFA(prefix)}$t$d Action Call$addon\n${getTree(StaticValue(name, ""), prefix.copy(), level + 1, false)}'
					].concat([
						for (i in 0...params.length - 1) getTree(params[i], pushIndex(prefix, level), level + 1, false)
					]);
					if (params.length == 0)
						return strParts.join("");
					strParts.push(getTree(params[params.length - 1], prefix.copy(), level + 1, true));
					return strParts.join("");
				}
			case Return(value, type): {
				var addon = type != "" ? ' ($type)' : "";
				return '${prefixFA(prefix)}$t$d Return$addon\n${getTree(value, prefix.copy(), level + 1, true)}';
			}
			case Error(title, reason): {
				return '${prefixFA(prefix)}$t$d Error - $title:\n${getTree(StaticValue(reason, ""), prefix.copy(), level + 1, true)}';
			}
			case InvalidSyntax(s):
				return '${prefixFA(prefix)}$t$d INVALID SYNTAX: $s\n';
		}
		return "";
	}
}