package little.tools;

import little.interpreter.Tokens.InterpTokens;
import Type.ValueType;
import little.interpreter.Interpreter;

using little.tools.TextTools;
using little.tools.Extensions;
using Std;

/**
    A class containing various functions to statically interface between Haxe and Little
    values/types.
**/
class Conversion {

    /**
        Converts a `ValueType` instance into a string, containing the type it represents.         
    **/
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

    /**
        Converts dynamic haxe values into `Little` tokens, specifically `InterpTokens`.
        Only values are supported (no functions).  
        Classes and enums are yet to be implemented.  
    **/
    public static function toLittleValue(val:Dynamic):InterpTokens {
        if (val == null) return NullValue;
        if (val is String) return Characters(val);
        var type = Type.typeof(val);
		return switch type {
			case TNull: NullValue;
			case TInt: Number(val);
			case TFloat: Decimal(val);
			case TBool: if (val) TrueValue else FalseValue;
			case TObject if (Type.getClass(val) != null): {
                var map:Map<String, {documentation:String, value:InterpTokens}> = new Map();
				for (field in Type.getInstanceFields(Type.getClass(val))) {
                    map[field] = {
                        value: toLittleValue(Reflect.getProperty(val, field)),
                        documentation: ""
                    }
                }
                map[Little.keywords.TYPE_CAST_FUNCTION_PREFIX + Little.keywords.TYPE_STRING] = {
                    value: Block(
                        [FunctionReturn(Characters(Std.string(val)), Identifier(Little.keywords.TYPE_STRING))], Identifier(Little.keywords.TYPE_STRING)),
                    documentation: "The function that will be used to convert this object to a string."
                }
                map[Little.keywords.OBJECT_TYPE_PROPERTY_NAME] = {
                    value: Characters(toLittleType(Type.getClassName(val))),
                    documentation: 'The type of this object, as a ${Little.keywords.TYPE_STRING}.'
                }
                Object(map, map[Little.keywords.OBJECT_TYPE_PROPERTY_NAME].value.parameter(0));
			}
            case TObject: {
                var objType = Little.keywords.TYPE_DYNAMIC;
                var map:Map<String, {documentation:String, value:InterpTokens}> = new Map();
				for (field in Type.getInstanceFields(Type.getClass(val))) {
                    map[field] = {
                        value: toLittleValue(Reflect.getProperty(val, field)),
                        documentation: ""
                    }
                }
                Object(map, objType);
            }
            case TFunction: {
				NullValue; // Intended Behavior
			}
			case TClass(c): {
				NullValue; // Intended Behavior
			}
			case TEnum(e): {
				NullValue; // Intended Behavior
			}
			case TUnknown: NullValue;
		}
    }

    /**
        Converts `InterpTokens` into a haxe value, depending on its type.
        `Little` functions are not supported.
    **/
    public static function toHaxeValue(val:InterpTokens):Dynamic {
        val = Interpreter.evaluate(val);
        return switch val {
            case ErrorMessage(msg): {
                trace("WARNING: " + msg + ". Returning null");
                return null;
            }
            case TrueValue: true;
            case FalseValue: false;
            case NullValue: null;
            case Decimal(num): num;
            case Number(num): num;
            case Characters(string): string;
            case Object(props, typeName): {
                var obj:Dynamic = {};
                for (key => value in props) {
                    if (key == Little.keywords.TYPE_CAST_FUNCTION_PREFIX + Little.keywords.TYPE_STRING) continue;
                    obj.key = toHaxeValue(value.value);
                }

                obj;
            }
			case ClassPointer(pointer): {
				return Little.memory.getTypeName(pointer);
			}
			case FunctionCode(_, _): {
				return null;
			}
            case _: {
                return null;
            }
        }
    }

    /**
        Converts core Haxe types into `Little` types. 
    **/
    public static function toLittleType(type:String) {
        return switch type {
            case "Bool": Little.keywords.TYPE_BOOLEAN;
            case "Int": Little.keywords.TYPE_INT;
            case "Float": Little.keywords.TYPE_FLOAT;
            case "String": Little.keywords.TYPE_STRING;
            case "Dynamic": Little.keywords.TYPE_DYNAMIC;
            case _: type;
        }
    }
}