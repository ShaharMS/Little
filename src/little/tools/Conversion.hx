package little.tools;

import little.interpreter.Tokens.InterpTokens;
import Type.ValueType;
import little.interpreter.Interpreter;
import haxe.Log;
import haxe.macro.Expr;
import little.parser.Tokens.ParserTokens;
import little.Keywords.*;

using little.tools.TextTools;
using Std;

class Conversion {

    public static function extractHaxeType(type:ValueType):String {
        return switch type {
            case TNull: "Dynamic";
            case TInt: "Int";
            case TFloat: "Float";
            case TBool: "Bool";
            case TObject: "Dynamic";
            case TFunction: "Dynamic"; // Todo: Change this?
            case TClass(c): Type.getClassName(c).split(".").pop(); // Todo: Should I remove the path or nah?
            case TEnum(e): e.getName().split(".").pop(); // Todo: Should I remove the path or nah?
            case TUnknown: "Dynamic";
        }
    }

    public static function toLittleValue(val:Dynamic):ParserTokens {
        if (val == null) return NullValue;
        var type = Type.typeof(val);
		return switch type {
			case TNull: NullValue;
			case TInt: Number(val);
			case TFloat: Decimal(val);
			case TBool: if (val) TrueValue else FalseValue;
			case TObject: {
				NullValue; // Todo: Structures
			}
			case TFunction: {
				NullValue; // Todo: Functions (or maybe intended behavior?)
			}
			case TClass(c): {
				NullValue; // Todo: Classes
			}
			case TEnum(e): {
				NullValue; // Todo: Enums
			}
			case TUnknown: NullValue;
		}
    }

    public static function toHaxeValue(val:ParserTokens):Dynamic {
        val = Interpreter.evaluate(val);
        return switch val {
            case ErrorMessage(msg): {
                trace("WARNING: " + msg + ". Returning null");
                return null;
            }
            case TrueValue: true;
            case FalseValue: false;
            case NullValue: null;
            case Decimal(num): num.parseFloat();
            case Number(num): num.parseInt();
            case Characters(string): string;
            case _: {
                trace("WARNING: Unparsable token: " + val + ". Returning null");
                return null;
            }
        }
    }

    public static function toLittleType(type:String) {
        return switch type {
            case "Bool": TYPE_BOOLEAN;
            case "Int": TYPE_INT;
            case "Float": TYPE_FLOAT;
            case "String": TYPE_STRING;
            case _: TYPE_DYNAMIC;
        }
    }
}