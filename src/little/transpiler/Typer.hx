package little. transpiler;

/**
 * Typer is a helper class for finding out information about types.
 * 
 * Its used for strongly typing variables when only the value is present.
 * 
 * example:
 * 
 * ```
 * define x = 1
 * ```
 * 
 * With `Typer`:
 * 
 * ```haxe
 * var x:Int = 1;
 * ```
 * 
 * Without `Typer`:
 * 
 * ```haxe
 * var x = 1;
 * ```
 * 
 */
class Typer {
    
    /**
     * Gets the type of a given value.
     * @param value a string representation of the value: `1.23`, `"hello"`, `new Child()`
     */
    public static function getValueType(value:String):String {
        final instanceDetector:EReg = ~/new +([a-zA-z0-9_]+)/;
        final numberDetector:EReg = ~/([0-9.])/;
        final stringDetector:EReg = ~/"[^"]*"/;
        final booleanDetector:EReg = ~/true|false/;

        if (instanceDetector.match(value)) return instanceDetector.matched(1);
        else if (numberDetector.match(value)) {
            if (value.indexOf(".") != -1) return "Float";
            else return "Int";
        } 
        else if (stringDetector.match(value)) return "String";
        else if (booleanDetector.match(value)) return "Bool";
        return "";
    }

    public static final basicTypeToHaxe:Map<String, String> = [
        "Number" => "Int",
        "Decimal" => "Float",
        "Characters" => "String",
        "Boolean" => "Bool"
    ];

}