package refactored_little;

class Keywords {
    public static var VARIABLE_DECLARATION:String = "define";
    public static var FUNCTION_DECLARATION:String = "action";
    public static var TYPE_DECL_OR_CAST:String = "as";
    public static var FUNCTION_RETURN:String = "return";
    public static var NULL_VALUE:String = "nothing";
    public static var TRUE_VALUE:String = "true";
    public static var FALSE_VALUE:String = "false";
    public static var TYPE_DYNAMIC:String = "Anything";
    public static var TYPE_VOID:String = "Void";
    public static var TYPE_INT:String = "Number";
    public static var TYPE_FLOAT:String = "Decimal";
    public static var TYPE_BOOLEAN:String = "Boolean";
    public static var TYPE_STRING:String = "Characters";

    public static var MAIN_MODULE_NAME:String = "Main";
    public static var REGISTERED_MODULE_NAME:String = "Registered";
    public static var PRINT_FUNCTION_NAME:String = "print";
    public static var RAISE_ERROR_FUNCTION_NAME:String = "error";

    /**
    	No need to ever change this, this is a parser-only feature
    **/
    public static var TYPE_UNKNOWN:String = "Unknown";

    public static var CONDITION_TYPES:Array<String> = ["if", "while", "whenever", "for"];
    public static var SPECIAL_OR_MULTICHAR_SIGNS:Array<String> = ["++", "--", "**", "+=", "-=", ">=", "<=", "=="];

    
}