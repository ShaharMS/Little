package little.tools;

import little.interpreter.Interpreter;
import haxe.Log;
import haxe.macro.Expr;
import little.parser.Tokens.ParserTokens;
import little.Keywords.*;

using little.tools.TextTools;
using Std;

class Conversion {

    public static function toLittleValue(val:Dynamic):ParserTokens {
        var type = toLittleType(Type.typeof(val).getName().substring(1));
        return switch type {
            case (_ == TYPE_BOOLEAN => true): {
                if (val) TrueValue else FalseValue;
            }
            case (_ == TYPE_FLOAT => true): {
                Decimal(Std.string(val));
            }
            case (_ == TYPE_INT => true): {
                Number(Std.string(val));
            }
            case (_ == TYPE_STRING => true): {
                Characters(Std.string(val));
            }
            case _: NullValue;
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