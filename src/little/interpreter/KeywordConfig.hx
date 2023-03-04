package little.interpreter;

@:structInit
class KeywordConfig {
    public var VARIABLE_DECLARATION:String = "define";
    public var FUNCTION_DECLARATION:String = "action";
    public var TYPE_CHECK_OR_CAST:String = "as";
    public var FUNCTION_RETURN:String = "return";
    public var NULL_VALUE:String = "nothing";
    public var TRUE_VALUE:String = "true";
    public var FALSE_VALUE:String = "false";
    public var TYPE_DYNAMIC:String = "Anything";
    public var TYPE_VOID:String = "Void";
    public var TYPE_INT:String = "Number";
    public var TYPE_FLOAT:String = "Decimal";
    public var TYPE_BOOLEAN:String = "Boolean";
    public var TYPE_STRING:String = "Characters";

    public var MAIN_MODULE_NAME:String = "Main";
    public var REGISTERED_MODULE_NAME:String = "Registered";
    public var PRINT_FUNCTION_NAME:String = "print";
    public var RAISE_ERROR_FUNCTION_NAME:String = "stop";

    /**
    	No need to ever change this, this is a parser-only feature
    **/
    public var TYPE_UNKNOWN:String = "Unknown";

    public var CONDITION_TYPES:Array<String> = ["if", "while", "whenever", "for"];
}