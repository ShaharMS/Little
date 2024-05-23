package little;

import little.lexer.Lexer;
import haxe.exceptions.ArgumentException;

using StringTools;
using little.tools.TextTools;

/**
	Represents a set of keys to use for different keywords/features in `Little`.
**/
@:structInit
class KeywordConfig {
	/**
		The default keyword configuration. Here incase you want to reset keywords, or just have a reference to the original ones.
	**/
	public static var defaultConfig(default, never):KeywordConfig = {};
	
	/**
	    every single character in this array will be recognized as an operator.
		If you register an operator, it should automatically exist here too.

		IMPORTANT - this is not the same as the field RECOGNIZED_SIGNS - this is 
		used strictly for lexing purposes.
	**/
	public static var recognizedOperators:Array<String> = ["!", "#", "$", "%", "&", "'", "(", ")", "*", "+", "-", ".", "/", ":", "<", "=", ">", "?", "@", "[", "\\", "]", "^", "_", "`", "{", "|", "}", "~", "^", "√"];

	/**
		Creates a new keyword config, using an existing config, made using the anonymous structure syntax.

		@param config The config to use. Not all fields have to be referenced - those that aren't referenced are set 
		to their default value. For the default configuration, don't provide parameters.
		@param nullifyDefaults 
	**/
	public function new(?config:KeywordConfig, nullifyDefaults:Bool = true) {
		if (config == null)
			return;
		if (nullifyDefaults) {
			var fields = Type.getInstanceFields(KeywordConfig);
			fields.remove("defaultConfig");
			for (field in fields) {
				var configValue = (Reflect.field(config, field) : String);

				if (configValue.length == 0)
					throw new ArgumentException('config.$field', "Keywords of length 0 are not allowed.");
				if (configValue.contains(" "))
					throw new ArgumentException('config.$field', "Keywords cannot contain whitespaces.");
				if (configValue.containsAny(recognizedOperators))
					throw new ArgumentException('config.$field', "Keywords cannot contain operators/signs.");
				if (~/[0-9]/.match(configValue.charAt(0)))
					throw new ArgumentException('config.$field', "Keywords cannot start with numbers.");

				if (configValue == Reflect.field(defaultConfig, field))
					Reflect.setField(this, field, null);
				else
					Reflect.setField(this, field, configValue);
			}
		}
	}

	/**
		Applies a different set of keywords onto this one. If it contains nulls, they are skipped.
		Any other value is not skipped. 
		@param config the configuration to apply.
	**/
	public function change(config:KeywordConfig) {
		var fields = Type.getInstanceFields(KeywordConfig);
		fields.remove("defaultConfig");
		for (field in fields) {
			var configValue = (Reflect.field(config, field) : String);
			if (configValue == null)
				continue;
			Reflect.setField(this, field, configValue);
		}
	}

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
	@:optional public var TYPE_OBJECT:String = "Object";
	@:optional public var TYPE_MEMORY:String = "Memory";
	@:optional public var TYPE_ARRAY:String = "Array";
	
	

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

	@:optional public var PRINT_FUNCTION_NAME:String = "print";
	@:optional public var RAISE_ERROR_FUNCTION_NAME:String = "error";
	@:optional public var READ_FUNCTION_NAME:String = "read";
	@:optional public var RUN_CODE_FUNCTION_NAME:String = "run";

	@:optional public var CONDITION_PATTERN_PARAMETER_NAME:String = "pattern";
	@:optional public var CONDITION_BODY_PARAMETER_NAME:String = "code";

	@:optional public var CONDITION__FOR_LOOP:String = "for";
	@:optional public var CONDITION__WHILE_LOOP:String = "while";
	@:optional public var CONDITION__IF:String = "if";
	@:optional public var CONDITION__ELSE:String = "else";
	@:optional public var CONDITION__WHENEVER:String = "whenever";
	@:optional public var CONDITION__AFTER:String = "after";
	/**
		No need to ever change this, this is a parser-only feature
	**/
	@:optional public var TYPE_UNKNOWN:String = "Unknown";

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
	@:optional public var NOT_SIGN:String = "!"; //on the left side
	@:optional public var ADD_SIGN:String = "+";
	@:optional public var SUBTRACT_SIGN:String = "-";
	@:optional public var MULTIPLY_SIGN:String = "*";
	@:optional public var DIVIDE_SIGN:String = "/";
	@:optional public var MOD_SIGN:String = "%";
	@:optional public var POW_SIGN:String = "^";
	@:optional public var FACTORIAL_SIGN:String = "!"; //on the right side
	@:optional public var SQRT_SIGN:String = "√";
	@:optional public var NEGATE_SIGN:String = "-";
	@:optional public var POSITIVE_SIGN:String = "+";

	// Cast functions are done using the `to` keyword and type. They are not here.

	//Float: DONE
	@:optional public var STDLIB__FLOAT_isWhole = "isWhole";

	//String: DONE
	@:optional public var STDLIB__STRING_length = "length";
	@:optional public var STDLIB__STRING_toLowerCase = "toLowerCase";
	@:optional public var STDLIB__STRING_toUpperCase = "toUpperCase";
	@:optional public var STDLIB__STRING_trim = "trim";
	@:optional public var STDLIB__STRING_substring = "substring";
	@:optional public var STDLIB__STRING_charAt = "charAt";
	@:optional public var STDLIB__STRING_split = "split";
	@:optional public var STDLIB__STRING_replace = "replace";
	@:optional public var STDLIB__STRING_remove = "remove";
	@:optional public var STDLIB__STRING_contains = "contains";
	@:optional public var STDLIB__STRING_indexOf = "indexOf";
	@:optional public var STDLIB__STRING_lastIndexOf = "lastIndexOf";
	@:optional public var STDLIB__STRING_startsWith = "startsWith";
	@:optional public var STDLIB__STRING_endsWith = "endsWith";
	@:optional public var STDLIB__STRING_fromCharCode = "fromCharCode";

	//Array: DONE
	@:optional public var STDLIB__ARRAY_length = "length";
	@:optional public var STDLIB__ARRAY_elementType = "elementType";
	@:optional public var STDLIB__ARRAY_get = "get";
	@:optional public var STDLIB__ARRAY_set = "set";


	@:optional public var STDLIB__MEMORY_allocate = "allocate";
	@:optional public var STDLIB__MEMORY_free = "free";
	@:optional public var STDLIB__MEMORY_read = "read";
	@:optional public var STDLIB__MEMORY_write = "write";
	@:optional public var STDLIB__MEMORY_size = "size";
	@:optional public var STDLIB__MEMORY_maxSize = "maxSize";

	@:optional public var FOR_LOOP_FROM = "from";
	@:optional public var FOR_LOOP_TO = "to";
	@:optional public var FOR_LOOP_JUMP = "jump";

	@:optional public var TYPE_CAST_FUNCTION_PREFIX:String = "to";
	@:optional public var INSTANTIATE_FUNCTION_NAME:String = "create";


}
