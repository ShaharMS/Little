package little.tools;

import little.interpreter.Interpreter;
using StringTools;
using little.tools.TextTools;

import little.parser.Tokens;

class PrettyPrinter {
    
    public static function printParserAst(ast:Array<ParserTokens>, ?spacingBetweenNodes:Int = 6) {
		if (ast == null) return "null (look for errors in input)";
		s = " ".multiply(spacingBetweenNodes);
		var unfilteredResult = getTree(Expression(ast, null), [], 0, true);
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

	static function getTree(root:ParserTokens, prefix:Array<Int>, level:Int, last:Bool):String {
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
			case External(haxeValue): return '${prefixFA(prefix)}$t$d External Haxe Value Identifier: [$haxeValue]\n';
			case ExternalCondition(use): return '${prefixFA(prefix)}$t$d External Haxe Condition Identifier: [$use]\n';
            case Decimal(num): return '${prefixFA(prefix)}$t$d $num\n';
            case Number(num): return '${prefixFA(prefix)}$t$d $num\n';
            case FalseValue: return '${prefixFA(prefix)}$t$d ${Keywords.FALSE_VALUE}\n';
            case TrueValue: return '${prefixFA(prefix)}$t$d ${Keywords.TRUE_VALUE}\n';
            case NullValue: return '${prefixFA(prefix)}$t$d ${Keywords.NULL_VALUE}\n';
			case Define(name, type):
				{
					return '${prefixFA(prefix)}$t$d Definition Creation\n${getTree(name, if (type == null) prefix.copy() else pushIndex(prefix, level), level + 1, type == null)}${getTree(type, prefix.copy(), level + 1, true)}';
				}
			case Action(name, params, type):
				{
					var title = '${prefixFA(prefix)}$t$d Action Creation\n';
					title += getTree(name, prefix.copy(), level + 1, false);
					title += getTree(params, prefix.copy(), level + 1, type == null);
					title += getTree(type, prefix.copy(), level + 1, true);
					return title;
				}
			case Condition(name, exp, body, type):
				{
					var title = '${prefixFA(prefix)}$t$d Condition\n';
					title += getTree(name, prefix.copy(), level + 1, false);
					title += getTree(exp, pushIndex(prefix, level), level + 1, false);
					title += getTree(body, prefix.copy(), level + 1, type == null);
					title += getTree(type, prefix.copy(), level + 1, true);
					return title;
				}
			case Read(name):
				return '${prefixFA(prefix)}$t$d Read: $name\n';
			case Write(assignees, value, type):
				{
					return'${prefixFA(prefix)}$t$d Definition Write\n${getTree(PartArray(assignees), pushIndex(prefix, level), level + 1, false)}${getTree(value, prefix.copy(), level + 1, type == null)}${getTree(type, prefix.copy(), level + 1, true)}';
				}
			case Sign(value):
				{
					return '${prefixFA(prefix)}$t$d $value\n';
				}
            case TypeDeclaration(value, type): 
				{
					return '${prefixFA(prefix)}$t$d Type Declaration\n${getTree(value, if (type == null) prefix.copy() else pushIndex(prefix, level), level + 1, type == null)}${getTree(type, prefix.copy(), level + 1, true)}';
            	}
			case Identifier(value): {
				return '${prefixFA(prefix)}$t$d $value\n';
			}
			case Expression(parts, type):
				{
					if (parts.length == 0)
						return '${prefixFA(prefix)}$t$d <empty expression>\n';
					var strParts = ['${prefixFA(prefix)}$t$d Expression\n${getTree(type, prefix.copy(), level + 1, false)}'].concat([
						for (i in 0...parts.length - 1) getTree(parts[i], pushIndex(prefix, level), level + 1, false)
					]);
					strParts.push(getTree(parts[parts.length - 1], prefix.copy(), level + 1, true));
					return strParts.join("");
				}
            case Block(body, type): {
                if (body.length == 0)
                    return '${prefixFA(prefix)}$t$d <empty block>\n';
                var strParts = ['${prefixFA(prefix)}$t$d Block\n${getTree(type, prefix.copy(), level + 1, false)}'].concat([
                    for (i in 0...body.length - 1) getTree(body[i], pushIndex(prefix, level), level + 1, false)
                ]);
                strParts.push(getTree(body[body.length - 1], prefix.copy(), level + 1, true));
                return strParts.join("");
            }
			case PartArray(body): {
                if (body.length == 0)
                    return '${prefixFA(prefix)}$t$d <empty array>\n';
                var strParts = ['${prefixFA(prefix)}$t$d Part Array\n'].concat([
                    for (i in 0...body.length - 1) getTree(body[i], pushIndex(prefix, level), level + 1, false)
                ]);
                strParts.push(getTree(body[body.length - 1], prefix.copy(), level + 1, true));
                return strParts.join("");
            }
			case ActionCall(name, params):
				{
					var title = '${prefixFA(prefix)}$t$d Action Call\n';
					title += getTree(name, pushIndex(prefix, level), level + 1, false);
					title += getTree(params, prefix.copy(), level + 1, true);
					return title;
				}
			case Return(value, type): {
				return '${prefixFA(prefix)}$t$d Return\n${getTree(value, prefix.copy(), level + 1, type == null)}${getTree(type, prefix.copy(), level + 1, true)}';
			}
			case PropertyAccess(name, property): {
				return '${prefixFA(prefix)}$t$d Property Access\n${getTree(name, pushIndex(prefix, level), level + 1, false)}${getTree(property, prefix.copy(), level + 1, true)}';
			}
		}
		return "";
	}









	public static function parseParamsString(params:Array<ParserTokens>, isExpected:Bool = true) {
		if (isExpected) {
			var str = [];
			for (param in params) {
				switch param {
					case Define(name, type): {
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
}