package little.interpreter;

import little.interpreter.memory.Stack;
import haxe.Int32;
import haxe.Rest;
import little.interpreter.Tokens.InterpTokens;
import haxe.CallStack;
import little.tools.Layer;
import little.tools.PrettyPrinter;
import little.parser.Tokens.ParserTokens;
import little.Keywords.*;

using StringTools;
using Std;
using Math;
using little.tools.TextTools;
@:access(little.interpreter.Runtime)
class Interpreter {
	public static function convert(pre:Rest<ParserTokens>):Array<InterpTokens> {
		if (pre.length == 1 && pre[0] == null) return [null];
		var post:Array<InterpTokens> = [];

		for (item in pre) {
			post.push(switch item {
				case SetLine(line): SetLine(line);
				case SplitLine: SplitLine;
				case Variable(name, type, doc): VariableDeclaration(convert(name)[0], convert(type)[0], convert(doc)[0]);
				case Function(name, params, type, doc): FunctionDeclaration(convert(name)[0], convert(params)[0], convert(type)[0], convert(doc)[0]);
				case Condition(name, exp, body): ConditionDeclaration(convert(name)[0], convert(exp)[0], convert(body)[0]);
				case Read(name): null;
				case Write(assignees, value): Write(convert(...assignees), convert(value)[0]);
				case Identifier(word): Identifier(word);
				case TypeDeclaration(value, type): TypeCast(convert(value)[0], convert(type)[0]);
				case FunctionCall(name, params): FunctionCall(convert(name)[0], convert(params)[0]);
				case Return(value, type): FunctionReturn(convert(value)[0], convert(type)[0]);
				case Expression(parts, type): Expression(convert(...parts), convert(type)[0]);
				case Block(body, type): Block(convert(...body), convert(type)[0]);
				case PartArray(parts): PartArray(convert(...parts));
				case PropertyAccess(name, property): PropertyAccess(convert(name)[0], convert(property)[0]);
				case Sign(sign): Sign(sign);
				case Number(num): num.parseFloat().abs() > 2_147_483_647 ? Decimal(num.parseFloat()) : Number(num.parseInt());
				case Decimal(num): Decimal(num.parseFloat());
				case Characters(string): Characters(string);
				case Documentation(doc): null;
				case Module(name): null;
				case External(get): null;
				case ExternalCondition(use): null;
				case ErrorMessage(msg): ErrorMessage(msg);
				case NullValue: NullValue;
				case TrueValue: TrueValue;
				case FalseValue: FalseValue;
				case NoBody: null;
			});
		}

		return post;
	}
}

