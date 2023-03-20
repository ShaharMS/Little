package little.tools;

import haxe.macro.Expr;
import little.parser.Tokens.ParserTokens;
import little.Keywords.*;

class Conversion {
    public static function toLittleFunction(func:Expr):Array<ParserTokens> -> ParserTokens {






        var details = Macros.inspectFunction(func);
        return null;
    }

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