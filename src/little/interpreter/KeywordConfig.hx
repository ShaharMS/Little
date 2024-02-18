package little.interpreter;

@:structInit
class KeywordConfig {
    @:optional public var VARIABLE_DECLARATION:String = "define";
    @:optional public var FUNCTION_DECLARATION:String = "action";
    @:optional public var TYPE_DECL_OR_CAST:String = "as";
    @:optional public var FUNCTION_RETURN:String = "return";
    @:optional public var NULL_VALUE:String = "nothing";
    @:optional public var TRUE_VALUE:String = "true";
    @:optional public var FALSE_VALUE:String = "false";
    @:optional public var TYPE_DYNAMIC:String = "Anything";
    @:optional public var TYPE_INT:String = "Number";
    @:optional public var TYPE_FLOAT:String = "Decimal";
    @:optional public var TYPE_BOOLEAN:String = "Boolean";
    @:optional public var TYPE_STRING:String = "Characters";
    
    /**
        Represents the main function type.
        The underlying type is `TYPE_STRING`.
    **/
    @:optional public var TYPE_FUNCTION:String = "Action";

	/**
		Represents the general type of a condition.
		The underlying type is `TYPE_STRING`.
	**/
	@:optional public var TYPE_CONDITION:String = "Condition";

    /**
        represent the "type" type:
        for example: `5` is of type `Number`, and `Number` is of type `Type`
    **/
    @:optional public var TYPE_MODULE:String = "Type";

    /**
    	Represents the type of a sign (for example, +)
        Exists for fun, but still functional :)
    **/
    @:optional public var TYPE_SIGN:String = "Sign";

    @:optional public var MAIN_MODULE_NAME:String = "Main";
    @:optional public var REGISTERED_MODULE_NAME:String = "Registered";

    @:optional public var OBJECT_TYPE_PROPERTY_NAME:String = "type";
	@:optional public var OBJECT_ADDRESS_PROPERTY_NAME:String = "address";
	@:optional public var OBJECT_DOC_PROPERTY_NAME:String = "documentation";
    @:optional public var TO_STRING_PROPERTY_NAME:String = "toString";
    @:optional public var PRINT_FUNCTION_NAME:String = "print";
    @:optional public var RAISE_ERROR_FUNCTION_NAME:String = "error";
    @:optional public var READ_FUNCTION_NAME:String = "read";
    @:optional public var RUN_CODE_FUNCTION_NAME:String = "run";
	@:optional public var CONDITION_PATTERN_PARAMETER_NAME:String = "pattern";
	@:optional public var CONDITION_BODY_PARAMETER_NAME:String = "code";

    /**
    	No need to ever change this, this is a parser-only feature
    **/
    @:optional public var TYPE_UNKNOWN:String = "Unknown";

    @:optional public var CONDITION_TYPES:Array<String> = [];
    public var RECOGNIZED_SIGNS:Array<String> = [];

    /**
    	When changing this to a multi-char sign (such as "->"), remember to also push that sign to `RECOGNIZED_SIGNS`, so it would be parsed correctly.
    **/
    @:optional public var PROPERTY_ACCESS_SIGN:String = ".";
    @:optional public var EQUALS_SIGN:String = "==";
    @:optional public var NOT_EQUALS_SIGN:String = "!=";
	@:optional public var LARGER_SIGN:String = ">";
	@:optional public var SMALLER_SIGN:String = "<";
	@:optional public var LARGER_EQUALS_SIGN:String = ">=";
	@:optional public var SMALLER_EQUALS_SIGN:String = "<=";
    @:optional public var XOR_SIGN:String = "^^";
    @:optional public var OR_SIGN:String = "||";
    @:optional public var AND_SIGN:String = "&&";

    @:optional public var FOR_LOOP_FROM = "from";
    @:optional public var FOR_LOOP_TO = "to";
    @:optional public var FOR_LOOP_JUMP = "jump";

    @:optional public var TYPE_CAST_FUNCTION_PREFIX:String = "to";
}