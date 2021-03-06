package little.interpreter.features;

import little.exceptions.Typo;
import little.Runtime;
using StringTools;
@:access(Runtime)
class Typer {
    
    /**
     * Gets the type of a given value.
     * @param value a string representation of the value: `1.23`, `"hello"`, `new Child()`
     */
    public static function getValueType(value:String):String {
        final instanceDetector:EReg = ~/new +([a-zA-z0-9_]+)/;
        final numberDetector:EReg = ~/([0-9.])/;
        final booleanDetector:EReg = ~/true|false/;
        value = Evaluator.getValueOf(value);

        if (instanceDetector.match(value)) return instanceDetector.matched(1);
        else if (numberDetector.match(value)) {
            if (value.indexOf(".") != -1) return "Decimal";
            else return "Number";
        } 
        else if (value.contains('"')) return "Characters";
        else if (booleanDetector.match(value)) return "Boolean";
        else if (value.contains(".")){
            //if it doesnt match any type, its probably a reference to another object/value
            //object:
            //cut the string on the first dot
            var object:String = value.substring(0, value.indexOf("."));
            value = value.substring(value.indexOf(".") + 1);
            if (value == "") {
                Runtime.safeThrow(new Typo('While trying to access a definition inside $object, you didn\'t specify a property name (the property name is the part after the dot).'));
            }
        } else {
            return getValueType(Memory.getLoadedVar(value).basicValue);
        }
        return "";
    }

    public static final basicTypeToHaxe:Map<String, String> = [
        "Number" => "Int",
        "Decimal" => "Float",
        "Characters" => "String",
        "Boolean" => "Bool"
    ];

}