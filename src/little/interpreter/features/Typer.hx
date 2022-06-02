package little.interpreter.features;

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
            if (value.indexOf(".") != -1) return "Decimal";
            else return "Number";
        } 
        else if (stringDetector.match(value)) return "Letters";
        else if (booleanDetector.match(value)) return "Boolean";
        return "";
    }

    public static final basicTypeToHaxe:Map<String, String> = [
        "Number" => "Int",
        "Decimal" => "Float",
        "Letters" => "String",
        "Boolean" => "Bool"
    ];

}