package little.tools;

import haxe.exceptions.NotImplementedException;
import little.interpreter.Tokens.InterpTokens;
import haxe.ds.ArraySort;
import vision.algorithms.Radix;
import little.interpreter.Operators;
import little.interpreter.Interpreter;
using StringTools;
using little.tools.TextTools;

import little.parser.Tokens;


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
			case ErrorMessage(name): return '${prefixFA(prefix)}$t$d Error: $name\n';
			case Documentation(doc): return '${prefixFA(prefix)}$t$d Documentation: ${doc.replace("\n", "\n" + prefixFA(prefix) + '│                  ')}\n';
            case Decimal(num): return '${prefixFA(prefix)}$t$d $num\n';
            case Number(num): return '${prefixFA(prefix)}$t$d $num\n';
            case FalseValue: return '${prefixFA(prefix)}$t$d ${Little.keywords.FALSE_VALUE}\n';
            case TrueValue: return '${prefixFA(prefix)}$t$d ${Little.keywords.TRUE_VALUE}\n';
            case NullValue: return '${prefixFA(prefix)}$t$d ${Little.keywords.NULL_VALUE}\n';
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
			case Class(name, superClass, doc): 
				{
					var title = '${prefixFA(prefix)}$t$d Class Creation\n';
					if (doc != null) title += getTree_PARSER(doc, prefix.copy(), level + 1, false);
					title += getTree_PARSER(name, prefix.copy(), level + 1, superClass == null);
					if (superClass != null) title += getTree_PARSER(superClass, prefix.copy(), level + 1, true);
				}
			case ConditionCall(name, exp, body):
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
            case Cast(value, type): 
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
			case Custom(name, parts): {
				if (parts.length == 0) return '${prefixFA(prefix)}$t$d $name\n';
				var strParts = ['${prefixFA(prefix)}$t$d $name\n'].concat([
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
			case TrueValue: return '${prefixFA(prefix)}$t$d ${TrueValue}\n';
			case FalseValue: return '${prefixFA(prefix)}$t$d ${FalseValue}\n';
			case Identifier(word): return '${prefixFA(prefix)}$t$d ${word}\n';
			case Documentation(doc): return '${prefixFA(prefix)}$t$d """${doc}"""\n';
			case ClassPointer(pointer): return '${prefixFA(prefix)}$t$d ClassPointer: ${pointer}\n';
			case HaxeExtern(func): return '${prefixFA(prefix)}$t$d <Haxe Extern>\n';
			case VariableDeclaration(name, type, doc):
				var title = '${prefixFA(prefix)}$t$d Variable Declaration\n';
				if (doc != null) title += getTree_INTERP(doc, prefix.copy(), level + 1, false);
				title += getTree_INTERP(name, prefix.copy(), level + 1, type == null);
				if (type != null) title += getTree_INTERP(type, prefix.copy(), level + 1, true);
				return title;
			case FunctionDeclaration(name, params, type, doc):
				var title = '${prefixFA(prefix)}$t$d Function Declaration\n';
				if (doc != null) title += getTree_INTERP(doc, prefix.copy(), level + 1, false);
				title += getTree_INTERP(name, prefix.copy(), level + 1, false);
				title += getTree_INTERP(params, prefix.copy(), level + 1, type == null);
				if (type != null) title += getTree_INTERP(type, prefix.copy(), level + 1, true);
				return title;
			case ConditionDeclaration(name, doc):
				var title = '${prefixFA(prefix)}$t$d Condition Declaration\n';
				if (doc != null) title += getTree_INTERP(doc, prefix.copy(), level + 1, false);
				title += getTree_INTERP(name, prefix.copy(), level + 1, true);
				return title;
			case ClassDeclaration(name, superClass, doc):
				var title = '${prefixFA(prefix)}$t$d Class Declaration\n';
				if (doc != null) title += getTree_INTERP(doc, prefix.copy(), level + 1, false);
				title += getTree_INTERP(superClass, prefix.copy(), level + 1, false);
				title += getTree_INTERP(name, prefix.copy(), level + 1, true);
				return title;
			case ConditionCall(name, exp, body):
				var title = '${prefixFA(prefix)}$t$d Condition Call\n';
				title += getTree_INTERP(name, prefix.copy(), level + 1, false);
				title += getTree_INTERP(exp, pushIndex(prefix, level), level + 1, false);
				title += getTree_INTERP(body, prefix.copy(), level + 1, true);
				return title;
			case FunctionCode(requiredParams, body):
				var title = '${prefixFA(prefix)}$t$d Function Code\n';
				title += getTree_INTERP(Identifier(requiredParams.toString()), prefix.copy(), level + 1, false);
				title += getTree_INTERP(body, prefix.copy(), level + 1, true);
				return title;
			case ConditionCode(callers):
				var title = '${prefixFA(prefix)}$t$d Condition Code\n';
				title += getTree_INTERP(Characters(callers.toString()), prefix.copy(), level + 1, true);
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
				title += getTree_INTERP(PartArray(assignees), pushIndex(prefix, level), level + 1, false);
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
			
			case Object(props, _): 
				var title = '${prefixFA(prefix)}$t$d Object\n';
				
				var i = 0;
				for (key => value in props) {
					i++;
					title += getTree_INTERP(Identifier(key), prefix.copy(), level + 1, i == [for (x in props.keys()) x].length);
					title += getTree_INTERP(Characters(value.documentation), i == [for (x in props.keys()) x].length ? prefix.copy() : pushIndex(prefix, level), level + 2, i == [for (x in props.keys()) x].length);
					title += getTree_INTERP(value.value, i == [for (x in props.keys()) x].length ? prefix.copy() : pushIndex(prefix, level), level + 2, true);
				}
				return title;
			case ErrorMessage(msg): return '${prefixFA(prefix)}$t$d ${root}\n';
		}
	}









	static var indent = "";

	public static function stringifyParser(?code:Array<ParserTokens>, ?token:ParserTokens) {
		if (token != null) code = [token];
		var s = "";

		for (token in code) {
			switch token {
				case SetLine(line):s += '\n$indent';
				case SplitLine: s += ", ";
				case Variable(name, type): s += '${Little.keywords.VARIABLE_DECLARATION} $name ${if (type != null) '${Little.keywords.TYPE_DECL_OR_CAST} ${stringifyParser(type)}' else ''}';
				case Function(name, params, type): s += '${Little.keywords.FUNCTION_DECLARATION} ${stringifyParser(name)}(${stringifyParser(params)}) ${if (type != null) '${Little.keywords.TYPE_DECL_OR_CAST} ${stringifyParser(type)}' else ''}';
				case Class(name, superClass): s += '${Little.keywords.CLASS_DECLARATION} ${stringifyParser(name)} ${if (superClass != null) '${Little.keywords.EXTENDS} ${stringifyParser(superClass)}' else ''}';
				case ConditionCall(name, exp, body): 
					indent += "	";
					s += '${stringifyParser(name)} (${stringifyParser(exp)}) \n${stringifyParser(body)}';
					indent = indent.subtract("	");
				case Read(name): s += stringifyParser(name);
				case Write(assignees, value): s += [assignees.concat([value]).map(t -> stringifyParser(t)).join(" = ")];
				case Identifier(word): s += word;
				case Cast(value, type): s += '${stringifyParser(value)} ${Little.keywords.TYPE_DECL_OR_CAST} ${stringifyParser(type)}';
				case FunctionCall(name, params): s += '${stringifyParser(name)}(${stringifyParser(params)})';
				case Return(value, type): s += '${Little.keywords.FUNCTION_RETURN} ${stringifyParser(value)}';
				case Expression(parts, type): s += stringifyParser(parts);
				case Block(body, type): 
					indent += "	";
					s += '{${stringifyParser(body)}} ${if (type != null) '${Little.keywords.TYPE_DECL_OR_CAST} ${stringifyParser(type)}' else ''}';
					indent = indent.subtract("	");
				case PartArray(parts): s += stringifyParser(parts);
				case PropertyAccess(name, property): s += '${stringifyParser(name)}${Little.keywords.PROPERTY_ACCESS_SIGN}${stringifyParser(property)}';
				case Sign(sign): s += " " + sign + " ";
				case Number(num): s += num;
				case Decimal(num): s += num;
				case Characters(string): s += '"' + string + '"';
				case Documentation(doc): s += '"""' + doc + '"""';
				case ErrorMessage(msg):
				case NullValue: s += Little.keywords.NULL_VALUE;
				case TrueValue: s += Little.keywords.TRUE_VALUE;
				case FalseValue: s += Little.keywords.FALSE_VALUE;
				case Custom(_, _): throw 'Custom tokens cannot be stringified, as they dont represent any output syntax (found $token)';
			}
		}

		return s;
	}

	public static function stringifyInterpreter(?code:Array<InterpTokens>, ?token:InterpTokens) {
		if (token != null) code = [token];
		var s = "";
		
		for (token in code) {
			switch token {
				case SetLine(line): s += '\n$indent';
				case SplitLine: s += ", ";
				case VariableDeclaration(name, type, doc): s += '${Little.keywords.VARIABLE_DECLARATION} ${stringifyInterpreter(name)} ${if (type != null) '${Little.keywords.TYPE_DECL_OR_CAST} ${stringifyInterpreter(type)}' else ''}';
				case FunctionDeclaration(name, params, type, doc): s += '${Little.keywords.FUNCTION_DECLARATION} ${stringifyInterpreter(name)}(${stringifyInterpreter(params)}) ${if (type != null) '${Little.keywords.TYPE_DECL_OR_CAST} ${stringifyInterpreter(type)}' else ''}';
				case ConditionDeclaration(name, doc): throw new NotImplementedException();
				case ClassDeclaration(name, superClass, doc): throw new NotImplementedException();
				case Write(assignees, value): s += assignees.concat([value]).map(t -> stringifyInterpreter(t)).join(" = ");
				case Identifier(word): s += word;
				case TypeCast(value, type): s += '${stringifyInterpreter(value)} ${Little.keywords.TYPE_DECL_OR_CAST} ${stringifyInterpreter(type)}';
				case FunctionCall(name, params): s += '${stringifyInterpreter(name)}(${stringifyInterpreter(params)})';
				case ConditionCall(name, exp, body): s += '${stringifyInterpreter(name)} (${stringifyInterpreter(exp)}) \n${stringifyInterpreter(body)}';
				case FunctionReturn(value, type): s += '${Little.keywords.FUNCTION_RETURN} ${stringifyInterpreter(value)}';
				case Expression(parts, type): s += stringifyInterpreter(parts);
				case Block(body, type): 
					indent += "	";
					s += '{${stringifyInterpreter(body)}} ${if (type != null) '${Little.keywords.TYPE_DECL_OR_CAST} ${stringifyInterpreter(type)}' else ''}';
					indent = indent.subtract("	");
				case PartArray(parts): s += stringifyInterpreter(parts);
				case PropertyAccess(name, property): s += '${stringifyInterpreter(name)}${Little.keywords.PROPERTY_ACCESS_SIGN}${stringifyInterpreter(property)}';
				case Sign(sign): s += sign;
				case Number(num): s += num;
				case Decimal(num): s += num;
				case Characters(string): s += '"' + string + '"';
				case Documentation(doc): s += '"""' + doc + '"""';
				case ErrorMessage(msg):
				case NullValue: s += Little.keywords.NULL_VALUE;
				case TrueValue: s += Little.keywords.TRUE_VALUE;
				case FalseValue: s += Little.keywords.FALSE_VALUE;
				case ClassPointer(pointer): s += Little.memory != null ? Little.memory.getTypeName(pointer) : throw "No memory for ClassPointer token " + pointer;
				case _: throw 'Stringifying token $token does not make sense, as it is represented by other tokens on parse time, and thus cannot appear in a non-manipulated InterpTokens AST';
			}
			s += " ";
		}

		return s.replaceLast(" ", "");
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