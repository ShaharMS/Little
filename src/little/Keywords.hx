package little;

import little.interpreter.KeywordConfig;

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

    /**
        represent the "type" type:
        for example: `5` is of type `Number`, and `Number` is of type `Type`
    **/
    public static var TYPE_MODULE:String = "Type";

    /**
    	Represents the type of a sign (for example, +)
        Exists for fun, but still functional :)
    **/
    public static var TYPE_SIGN:String = "Sign";

    public static var MAIN_MODULE_NAME:String = "Main";
    public static var REGISTERED_MODULE_NAME:String = "Registered";

    public static var PRINT_FUNCTION_NAME:String = "print";
    public static var RAISE_ERROR_FUNCTION_NAME:String = "error";
    public static var READ_FUNCTION_NAME:String = "read";
    public static var RUN_CODE_FUNCTION_NAME:String = "run";

    /**
    	No need to ever change this, this is a parser-only feature
    **/
    public static var TYPE_UNKNOWN:String = "Unknown";

    public static var CONDITION_TYPES:Array<String> = [];
    public static var ELSE:String = "else";
    public static var RECOGNIZED_SIGNS:Array<String> = [];

    /**
    	When changing this to a multi-char sign (such as "->"), remember to also push that sign to `RECOGNIZED_SIGNS`, so it would be parsed correctly.
    **/
    public static var PROPERTY_ACCESS_SIGN:String = ".";
    public static var EQUALS_SIGN:String = "==";
    public static var NOT_EQUALS_SIGN:String = "!=";
	public static var LARGER_SIGN:String = ">";
	public static var SMALLER_SIGN:String = "<";
	public static var LARGER_EQUALS_SIGN:String = ">=";
	public static var SMALLER_EQUALS_SIGN:String = "<=";
    public static var XOR_SIGN:String = "^^";
    public static var OR_SIGN:String = "||";
    public static var AND_SIGN:String = "&&";

    public static var FOR_LOOP_FROM = "from";
    public static var FOR_LOOP_TO = "to";
    public static var FOR_LOOP_JUMP = "jump";

    /**
        used when converting an object to another type using a conversion function:

            define x = 3.toCharacters()
    **/
    public static var TYPE_CAST_FUNCTION_PREFIX = "to";

    public static var defaultKeywordSet:KeywordConfig = {
        VARIABLE_DECLARATION: "define",
        FUNCTION_DECLARATION: "action",
        TYPE_DECL_OR_CAST: "as",
        FUNCTION_RETURN: "return",
        NULL_VALUE: "nothing",
        TRUE_VALUE: "true",
        FALSE_VALUE: "false",
        TYPE_DYNAMIC: "Anything",
        TYPE_VOID: "Void",
        TYPE_INT: "Number",
        TYPE_FLOAT: "Decimal",
        TYPE_BOOLEAN: "Boolean",
        TYPE_STRING: "Characters",
        TYPE_MODULE: "Type",
        TYPE_SIGN: "Sign",
        MAIN_MODULE_NAME: "Main",
        REGISTERED_MODULE_NAME: "Registered",
        PRINT_FUNCTION_NAME: "print",
        RAISE_ERROR_FUNCTION_NAME: "error",
        READ_FUNCTION_NAME: "read",
        RUN_CODE_FUNCTION_NAME: "run",
        TYPE_UNKNOWN: "Unknown",
        RECOGNIZED_SIGNS: [],
        PROPERTY_ACCESS_SIGN: ".",
        EQUALS_SIGN: "==",
        NOT_EQUALS_SIGN: "!=",
		LARGER_SIGN: ">",
		SMALLER_SIGN: "<",
		LARGER_EQUALS_SIGN: ">=",
		SMALLER_EQUALS_SIGN: "<=",
        XOR_SIGN: "^^",
        OR_SIGN: "||",
        AND_SIGN: "&&",
        FOR_LOOP_FROM: "from",
        FOR_LOOP_TO: "to",
        FOR_LOOP_JUMP: "jump",
        TYPE_CAST_FUNCTION_PREFIX: "to"
    };

    public static function switchSet(set:KeywordConfig) {
        VARIABLE_DECLARATION = set.VARIABLE_DECLARATION;
        FUNCTION_DECLARATION = set.FUNCTION_DECLARATION;
        TYPE_DECL_OR_CAST = set.TYPE_DECL_OR_CAST;
        FUNCTION_RETURN = set.FUNCTION_RETURN;
        NULL_VALUE = set.NULL_VALUE;
        TRUE_VALUE = set.TRUE_VALUE;
        FALSE_VALUE = set.FALSE_VALUE;
        TYPE_DYNAMIC = set.TYPE_DYNAMIC;
        TYPE_VOID = set.TYPE_VOID;
        TYPE_INT = set.TYPE_INT;
        TYPE_FLOAT = set.TYPE_FLOAT;
        TYPE_BOOLEAN = set.TYPE_BOOLEAN;
        TYPE_STRING = set.TYPE_STRING;
        TYPE_MODULE = set.TYPE_MODULE;
        TYPE_SIGN = set.TYPE_SIGN;
        MAIN_MODULE_NAME = set.MAIN_MODULE_NAME;
        REGISTERED_MODULE_NAME = set.REGISTERED_MODULE_NAME;
        PRINT_FUNCTION_NAME = set.PRINT_FUNCTION_NAME;
        RAISE_ERROR_FUNCTION_NAME = set.RAISE_ERROR_FUNCTION_NAME;
        READ_FUNCTION_NAME = set.READ_FUNCTION_NAME;
        RUN_CODE_FUNCTION_NAME = set.RAISE_ERROR_FUNCTION_NAME;
        TYPE_UNKNOWN = set.TYPE_UNKNOWN;
        RECOGNIZED_SIGNS = set.RECOGNIZED_SIGNS;
        PROPERTY_ACCESS_SIGN = set.PROPERTY_ACCESS_SIGN;
        EQUALS_SIGN = set.EQUALS_SIGN;
        NOT_EQUALS_SIGN = set.NOT_EQUALS_SIGN;
		LARGER_SIGN = set.LARGER_SIGN;
		SMALLER_SIGN = set.SMALLER_SIGN;
		LARGER_EQUALS_SIGN = set.LARGER_EQUALS_SIGN;
		SMALLER_EQUALS_SIGN = set.SMALLER_EQUALS_SIGN;
        XOR_SIGN = set.XOR_SIGN;
        OR_SIGN = set.OR_SIGN;
        AND_SIGN = set.AND_SIGN;
        FOR_LOOP_FROM = set.FOR_LOOP_FROM;
        FOR_LOOP_TO = set.FOR_LOOP_TO;
        FOR_LOOP_JUMP = set.FOR_LOOP_JUMP;
        TYPE_CAST_FUNCTION_PREFIX = set.TYPE_CAST_FUNCTION_PREFIX;
    }
}