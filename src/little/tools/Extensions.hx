package little.tools;

import little.interpreter.Tokens.InterpTokens;
import little.interpreter.Interpreter;
import little.parser.Tokens.ParserTokens;

using little.tools.TextTools;

class Extensions {

	public static function identifier(token:ParserTokens):String {
		return Interpreter.stringifyTokenIdentifier(token);
	}

	public static function value(token:ParserTokens):String {
		return Interpreter.stringifyTokenValue(token);
	}

	overload extern inline public static function is(token:ParserTokens, ...tokens:ParserTokensSimple) {
		return tokens.toArray().map(x -> x.getName().remove("_").toLowerCase()).contains(token.getName().toLowerCase());
	}

	overload extern inline public static function is(token:InterpTokens, ...tokens:InterpTokensSimple) {
		return tokens.toArray().map(x -> x.getName().remove("_").toLowerCase()).contains(token.getName().toLowerCase());
	}

	overload extern inline public static function parameter(token:ParserTokens, index:Int):Dynamic {
		return token.getParameters()[index];
	}

	overload extern inline public static function parameter(token:InterpTokens, index:Int):Dynamic {
		return token.getParameters()[index];
	}

	public static inline function passedByValue(token:InterpTokens):Bool {
		return !is(token, TRUE_VALUE, FALSE_VALUE, NULL_VALUE, NUMBER, DECIMAL, SIGN);
	}

	public static inline function passedByReference(token:InterpTokens):Bool {
		return !passedByValue(token);
	}

	public static inline function staticallyStorable(token:InterpTokens):Bool {
		return passedByValue(token) || is(token, CHARACTERS);
	}

	public static function containsAny<T>(array:Array<T>, func:T -> Bool):Bool {
		return array.filter(func).length > 0;
	}
}

enum ParserTokensSimple {
	SET_LINE;
	SPLIT_LINE;
	VARIABLE;
	FUNCTION;
	CONDITION;
	READ;
	WRITE;
	IDENTIFIER;
	TYPE_DECLARATION;
	FUNCTION_CALL;
	RETURN;
	EXPRESSION;
	BLOCK;
	PART_ARRAY;
	PROPERTY_ACCESS;
	SIGN;
	NUMBER;
	DECIMAL;
	CHARACTERS;
	DOCUMENTATION;
	MODULE;
	EXTERNAL;
	EXTERNAL_CONDITION;
	ERROR_MESSAGE;
	NULL_VALUE;
	TRUE_VALUE;
	FALSE_VALUE;
	NOBODY;
}

enum InterpTokensSimple {
	
    SET_LINE;
	SPLIT_LINE;
	VARIABLE_DECLARATION;
	FUNCTION_DECLARATION;
	CONDITION;

    READ;
	FUNCTION_CALL;    
	FUNCTION_RETURN;

    WRITE;

    TYPE_CAST;

    EXPRESSION;
    BLOCK;
    PART_ARRAY;

	PROPERTY_ACCESS;

	NUMBER;
	DECIMAL;
	CHARACTERS;
	SIGN;
	NULL_VALUE;
	TRUE_VALUE;
	FALSE_VALUE;

	IDENTIFIER;
	
	STRUCTURE;
	VALUE;
	EXTERNAL;
	EXTERNAL_CONDITION;
	ERROR_MESSAGE;

	//------------------------------------------------------------------
	// Unimplemented
	//------------------------------------------------------------------

	CONDITION_DECLARATION;
	CONDITION_EVALUATOR;
	CLASS_FIELDS;

}