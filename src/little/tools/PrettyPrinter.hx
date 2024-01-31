package little.tools;

import little.interpreter.Tokens.InterpTokens;
import haxe.ds.ArraySort;
import vision.algorithms.Radix;
import little.interpreter.Operators;
import little.interpreter.Interpreter;
using StringTools;
using little.tools.TextTools;

import little.parser.Tokens;

import little.Keywords.*;

class PrettyPrinter {
    
    public static function printParserAst(ast:Array<ParserTokens>, ?spacingBetweenNodes:Int = 6) {
		if (ast == null) return "null (look for errors in input)";
		s = " ".multiply(spacingBetweenNodes);
		var unfilteredResult = getTree_PARSER(Expression(ast, null), [], 0, true);
		var filtered = "";
		for (line in unfilteredResult.split("\n")) {
			if (line == "└─── Expression")
				continue;
			filtered += line.substring(spacingBetweenNodes - 1) + "\n";
		}
		return "\nAst\n" + filtered;
	}

	public static function printInterpreterAst(ast:Array<InterpTokens>, ?spacingBetweenNodes:Int = 6) {
		if (ast == null) return "null (look for errors in input)";
		s = " ".multiply(spacingBetweenNodes);
		var unfilteredResult = getTree_INTERP(Expression(ast, null), [], 0, true);
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

	static function getTree_PARSER(root:ParserTokens, prefix:Array<Int>, level:Int, last:Bool):String {
		l = level;
		var t = if (last) "└" else "├";
		var c = "├";
		var d = "───";
		if (root == null)
			return ''; //'${prefixFA(prefix)}$t$d SetLine($line)\n'
		switch root {
			case SetLine(line): return '${prefixFA(prefix)}$t$d SetLine($line)\n';
            case SplitLine: return '${prefixFA(prefix)}$t$d SplitLine\n';
            case Characters(string): return '${prefixFA(prefix)}$t$d "$string"\n';
			case Module(name): return '${prefixFA(prefix)}$t$d Module: $name\n';
			case ErrorMessage(name): return '${prefixFA(prefix)}$t$d Error: $name\n';
			case Documentation(doc): return '${prefixFA(prefix)}$t$d Documentation: ${doc.replace("\n", "\n" + prefixFA(prefix) + '│                  ')}\n';
			case NoBody:  return '${prefixFA(prefix)}$t$d <no body>\n';
			case External(haxeValue): return '${prefixFA(prefix)}$t$d External Haxe Value Identifier: [$haxeValue]\n';
			case ExternalCondition(use): return '${prefixFA(prefix)}$t$d External Haxe Condition Identifier: [$use]\n';
            case Decimal(num): return '${prefixFA(prefix)}$t$d $num\n';
            case Number(num): return '${prefixFA(prefix)}$t$d $num\n';
            case FalseValue: return '${prefixFA(prefix)}$t$d ${Keywords.FALSE_VALUE}\n';
            case TrueValue: return '${prefixFA(prefix)}$t$d ${Keywords.TRUE_VALUE}\n';
            case NullValue: return '${prefixFA(prefix)}$t$d ${Keywords.NULL_VALUE}\n';
			case Variable(name, type, doc):
				{
					var title = '${prefixFA(prefix)}$t$d Variable Creation\n';
					if (doc != null) title += getTree_PARSER(doc, prefix.copy(), level + 1, false);
					title += getTree_PARSER(name, prefix.copy(), level + 1, type == null);
					if (type != null) title += getTree_PARSER(type, prefix.copy(), level + 1, true);
					return title;
				}
			case Function(name, params, type, doc):
				{
					var title = '${prefixFA(prefix)}$t$d Function Creation\n';
					if (doc != null) title += getTree_PARSER(doc, prefix.copy(), level + 1, false);
					title += getTree_PARSER(name, prefix.copy(), level + 1, false);
					title += getTree_PARSER(params, prefix.copy(), level + 1, type == null);
					if (type != null) title += getTree_PARSER(type, prefix.copy(), level + 1, true);
					return title;
				}
			case Condition(name, exp, body):
				{
					var title = '${prefixFA(prefix)}$t$d Condition\n';
					title += getTree_PARSER(name, prefix.copy(), level + 1, false);
					title += getTree_PARSER(exp, pushIndex(prefix, level), level + 1, false);
					title += getTree_PARSER(body, prefix.copy(), level + 1, true);
					return title;
				}
			case Read(name):
				return '${prefixFA(prefix)}$t$d Read: $name\n';
			case Write(assignees, value):
				{
					return'${prefixFA(prefix)}$t$d Variable Write\n${getTree_PARSER(PartArray(assignees), pushIndex(prefix, level), level + 1, false)}${getTree_PARSER(value, prefix.copy(), level + 1, true)}';
				}
			case Sign(value):
				{
					return '${prefixFA(prefix)}$t$d $value\n';
				}
            case TypeDeclaration(value, type): 
				{
					return '${prefixFA(prefix)}$t$d Type Declaration\n${getTree_PARSER(value, if (type == null) prefix.copy() else pushIndex(prefix, level), level + 1, type == null)}${getTree_PARSER(type, prefix.copy(), level + 1, true)}';
            	}
			case Identifier(value): {
				return '${prefixFA(prefix)}$t$d $value\n';
			}
			case Expression(parts, type):
				{
					if (parts.length == 0)
						return '${prefixFA(prefix)}$t$d <empty expression>\n';
					var strParts = ['${prefixFA(prefix)}$t$d Expression\n${getTree_PARSER(type, prefix.copy(), level + 1, false)}'].concat([
						for (i in 0...parts.length - 1) getTree_PARSER(parts[i], pushIndex(prefix, level), level + 1, false)
					]);
					strParts.push(getTree_PARSER(parts[parts.length - 1], prefix.copy(), level + 1, true));
					return strParts.join("");
				}
            case Block(body, type): {
                if (body.length == 0)
                    return '${prefixFA(prefix)}$t$d <empty block>\n';
                var strParts = ['${prefixFA(prefix)}$t$d Block\n${getTree_PARSER(type, prefix.copy(), level + 1, false)}'].concat([
                    for (i in 0...body.length - 1) getTree_PARSER(body[i], pushIndex(prefix, level), level + 1, false)
                ]);
                strParts.push(getTree_PARSER(body[body.length - 1], prefix.copy(), level + 1, true));
                return strParts.join("");
            }
			case PartArray(body): {
                if (body.length == 0)
                    return '${prefixFA(prefix)}$t$d <empty array>\n';
                var strParts = ['${prefixFA(prefix)}$t$d Part Array\n'].concat([
                    for (i in 0...body.length - 1) getTree_PARSER(body[i], pushIndex(prefix, level), level + 1, false)
                ]);
                strParts.push(getTree_PARSER(body[body.length - 1], prefix.copy(), level + 1, true));
                return strParts.join("");
            }
			case FunctionCall(name, params):
				{
					var title = '${prefixFA(prefix)}$t$d Function Call\n';
					title += getTree_PARSER(name, pushIndex(prefix, level), level + 1, false);
					title += getTree_PARSER(params, prefix.copy(), level + 1, true);
					return title;
				}
			case Return(value, type): {
				return '${prefixFA(prefix)}$t$d Return\n${getTree_PARSER(value, prefix.copy(), level + 1, type == null)}${getTree_PARSER(type, prefix.copy(), level + 1, true)}';
			}
			case PropertyAccess(name, property): {
				return '${prefixFA(prefix)}$t$d Property Access\n${getTree_PARSER(name, pushIndex(prefix, level), level + 1, false)}${getTree_PARSER(property, prefix.copy(), level + 1, true)}';
			}
		}
		return "";
	}

	static function getTree_INTERP(root:InterpTokens, prefix:Array<Int>, level:Int, last:Bool):String {
		l = level;
		var t = if (last) "└" else "├";
		var c = "├";
		var d = "───";
		if (root == null)
			return '';
		
		switch root {
			case SetLine(line): return '${prefixFA(prefix)}$t$d SetLine($line)\n';
			case SplitLine: return '${prefixFA(prefix)}$t$d SplitLine\n';
			case Number(num): return '${prefixFA(prefix)}$t$d ${num}\n';
			case Decimal(num): return '${prefixFA(prefix)}$t$d ${num}\n';
			case Characters(string): return '${prefixFA(prefix)}$t$d "${string}"\n';
			case Sign(sign): return '${prefixFA(prefix)}$t$d ${sign}\n';
			case NullValue: return '${prefixFA(prefix)}$t$d ${NullValue}\n';
			case VoidValue: return '${prefixFA(prefix)}$t$d ${VoidValue}\n';
			case TrueValue: return '${prefixFA(prefix)}$t$d ${TrueValue}\n';
			case FalseValue: return '${prefixFA(prefix)}$t$d ${FalseValue}\n';
			case Identifier(word): return '${prefixFA(prefix)}$t$d ${word}\n';
			case VariableDeclaration(name, type, doc):
				var title = '${prefixFA(prefix)}$t$d Variable Declaration\n';
				if (doc != null) title += getTree_INTERP(Characters(doc), prefix.copy(), level + 1, false);
				title += getTree_INTERP(name, prefix.copy(), level + 1, type == null);
				if (type != null) title += getTree_INTERP(type, prefix.copy(), level + 1, true);
				return title;
			case FunctionDeclaration(name, params, type, doc):
				var title = '${prefixFA(prefix)}$t$d Function Declaration\n';
				if (doc != null) title += getTree_INTERP(Characters(doc), prefix.copy(), level + 1, false);
				title += getTree_INTERP(name, prefix.copy(), level + 1, false);
				title += getTree_INTERP(params, prefix.copy(), level + 1, type == null);
				if (type != null) title += getTree_INTERP(type, prefix.copy(), level + 1, true);
				return title;
			case ConditionDeclaration(name, conditionType, doc):
				var title = '${prefixFA(prefix)}$t$d Condition Declaration\n';
				if (doc != null) title += getTree_INTERP(Characters(doc), prefix.copy(), level + 1, false);
				title += getTree_INTERP(name, prefix.copy(), level + 1, false);
				title += getTree_INTERP(conditionType, prefix.copy(), level + 1, true);
				return title;
			case ClassDeclaration(name, doc):
				var title = '${prefixFA(prefix)}$t$d Class Declaration\n';
				if (doc != null) title += getTree_INTERP(Characters(doc), prefix.copy(), level + 1, false);
				title += getTree_INTERP(name, prefix.copy(), level + 1, true);
				return title;
			case ConditionCall(name, exp, body):
				var title = '${prefixFA(prefix)}$t$d Condition Call\n';
				title += getTree_INTERP(name, pushIndex(prefix, level), level + 1, false);
				title += getTree_INTERP(exp, prefix.copy(), level + 1, false);
				title += getTree_INTERP(body, prefix.copy(), level + 1, true);
				return title;
			case FunctionCode(requiredParams, body):
				var title = '${prefixFA(prefix)}$t$d Function Code\n';
				title += getTree_INTERP(Identifier(requiredParams.toString()), prefix.copy(), level + 1, false);
				title += getTree_INTERP(body, prefix.copy(), level + 1, true);
				return title;
			case FunctionCall(name, params):
				var title = '${prefixFA(prefix)}$t$d Function Call\n';
				title += getTree_INTERP(name, pushIndex(prefix, level), level + 1, false);
				title += getTree_INTERP(params, prefix.copy(), level + 1, true);
				return title;
			case FunctionReturn(value, type):
				var title = '${prefixFA(prefix)}$t$d Function Return\n';
				title += getTree_INTERP(value, prefix.copy(), level + 1, type == null);
				if (type != null) title += getTree_INTERP(type, prefix.copy(), level + 1, true);
				return title;
			case Write(assignees, value):
				var title = '${prefixFA(prefix)}$t$d Write\n';
				title += getTree_INTERP(PartArray(assignees), prefix.copy(), level + 1, false);
				title += getTree_INTERP(value, prefix.copy(), level + 1, true);
				return title;
			case TypeCast(value, type):
				var title = '${prefixFA(prefix)}$t$d Type Cast\n';
				title += getTree_INTERP(value, prefix.copy(), level + 1, false);
				title += getTree_INTERP(type, prefix.copy(), level + 1, true);
				return title;
			case Expression(parts, type):
				if (parts.length == 0)
					return '${prefixFA(prefix)}$t$d <empty expression>\n';
				var strParts = ['${prefixFA(prefix)}$t$d Expression\n${getTree_INTERP(type, prefix.copy(), level + 1, false)}'].concat([
					for (i in 0...parts.length - 1) getTree_INTERP(parts[i], pushIndex(prefix, level), level + 1, false)
				]);
				strParts.push(getTree_INTERP(parts[parts.length - 1], prefix.copy(), level + 1, true));
				return strParts.join("");
			case Block(body, type): 
				if (body.length == 0)
					return '${prefixFA(prefix)}$t$d <empty block>\n';
				var strParts = ['${prefixFA(prefix)}$t$d Block\n${getTree_INTERP(type, prefix.copy(), level + 1, false)}'].concat([
					for (i in 0...body.length - 1) getTree_INTERP(body[i], pushIndex(prefix, level), level + 1, false)
				]);
				strParts.push(getTree_INTERP(body[body.length - 1], prefix.copy(), level + 1, true));
				return strParts.join("");
			
			case PartArray(parts):
				var title = '${prefixFA(prefix)}$t$d Part Array\n';
				for (part in parts) {
					title += getTree_INTERP(part, prefix.copy(), level + 1, part == parts[parts.length - 1]);
				}
				return title;
			case PropertyAccess(name, property):
				var title = '${prefixFA(prefix)}$t$d Property Access\n';
				title += getTree_INTERP(name, prefix.copy(), level + 1, false);
				title += getTree_INTERP(property, prefix.copy(), level + 1, true);
				return title;
			
			case Object(toString, props, _): 
				var title = '${prefixFA(prefix)}$t$d Object\n';
				
				var i = 0;
				for (key => value in props) {
					i++;
					title += getTree_INTERP(Identifier(key), prefix.copy(), level + 1, i == [for (x in props.keys()) x].length);
					title += getTree_INTERP(Characters(value.documentation), i == [for (x in props.keys()) x].length ? prefix.copy() : pushIndex(prefix, level), level + 2, i == [for (x in props.keys()) x].length);
					title += getTree_INTERP(value.value, i == [for (x in props.keys()) x].length ? prefix.copy() : pushIndex(prefix, level), level + 2, true);
				}
				return title;
			case Class(name, instanceFields, staticFields):
				var title = '${prefixFA(prefix)}$t$d Class\n';
				title += getTree_INTERP(Identifier(name), prefix.copy(), level + 1, false);
				title += getTree_INTERP(Identifier(instanceFields.toString()), prefix.copy(), level + 1, false);
				title += getTree_INTERP(Identifier(staticFields.toString()), prefix.copy(), level + 1, true);
				return title;
			case ErrorMessage(msg): return '${prefixFA(prefix)}$t$d ${root}\n';
		}
	}









	public static function parseParamsString(params:Array<ParserTokens>, isExpected:Bool = true) {
		if (isExpected) {
			var str = [];
			for (param in params) {
				switch param {
					case Variable(name, type): {
						str.push('${Interpreter.stringifyTokenValue(name)} ${Keywords.TYPE_DECL_OR_CAST} ${Interpreter.stringifyTokenValue(type != null ? type : Identifier(Keywords.TYPE_DYNAMIC))}');
					}
					case _:
				}
			}
			if (str.length == 0) return "no parameters";
			return str.join(", ");
		} else {
			var str = [];
			for (param in params) {
				str.push(Interpreter.stringifyTokenIdentifier(param));
			}
			if (str.length == 0) return "no parameters";
			return str.join(", ");
		}
	}


	static var indent = "";

	public static  function stringify(?code:Array<ParserTokens>, ?token:ParserTokens) {
		if (token != null) code = [token];
		var s = "";

		for (token in code) {
			switch token {
				case SetLine(line):s += '\n$indent';
				case SplitLine: s += ", ";
				case Variable(name, type): s += '$VARIABLE_DECLARATION $name ${if (type != null) '$TYPE_DECL_OR_CAST ${stringify(type)}' else ''}';
				case Function(name, params, type): s += '$FUNCTION_DECLARATION ${stringify(name)}(${stringify(params)}) ${if (type != null) '$TYPE_DECL_OR_CAST ${stringify(type)}' else ''}';
				case Condition(name, exp, body): 
					indent += "	";
					s += '${stringify(name)} (${stringify(exp)}) \n${stringify(body)}';
					indent = indent.subtract("	");
				case Read(name): s += stringify(name);
				case Write(assignees, value): s += [assignees.concat([value]).map(t -> stringify(t)).join(" = ")];
				case Identifier(word): s += word;
				case TypeDeclaration(value, type): s += '$TYPE_DECL_OR_CAST ${stringify(type)}';
				case FunctionCall(name, params): s += '${stringify(name)}(${stringify(params)})';
				case Return(value, type): s += '$FUNCTION_RETURN ${stringify(value)}';
				case Expression(parts, type): s += stringify(parts);
				case Block(body, type): 
					indent += "	";
					s += '{${stringify(body)}} ${if (type != null) '$TYPE_DECL_OR_CAST ${stringify(type)}' else ''}';
					indent = indent.subtract("	");
				case PartArray(parts): s += stringify(parts);
				case PropertyAccess(name, property): s += '${stringify(name)}$PROPERTY_ACCESS_SIGN${stringify(property)}';
				case Sign(sign): s += " " + sign + " ";
				case Number(num): s += num;
				case Decimal(num): s += num;
				case Characters(string): s += '"' + string + '"';
				case Documentation(doc): s += '"""' + doc + '"""';
				case Module(name): 
				case External(get):
				case ExternalCondition(use):
				case ErrorMessage(msg):
				case NullValue: s += NULL_VALUE;
				case TrueValue: s += TRUE_VALUE;
				case FalseValue: s += FALSE_VALUE;
				case NoBody:
			}
		}

		return s;
	}

	public static function prettyPrintOperatorPriority(priority:Map<Int, Array<{sign:String, side:OperatorType}>>) {
		var sortedKeys = [for (x in priority.keys()) x];
		ArraySort.sort(sortedKeys, (x, y) -> x - y);
		
		var string = "";

		for (key in sortedKeys) {
			string += '$key: (';
			for (obj in priority[key]) {
				if (obj.side == LHS_RHS) string += '_${obj.sign}_';
				else if (obj.side == LHS_ONLY) string += '_${obj.sign}';
				else if (obj.side == RHS_ONLY) string += '${obj.sign}_';

				string += ', ';
			}
			string = string.replaceLast(', ', ')') + '\n';
		}

		return string;
	}
}