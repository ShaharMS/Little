package little.tools;

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

	public static function is(token:ParserTokens, ...tokens:ParserTokensSimple) {
		return tokens.toArray().map(x -> x.getName().remove("_").toLowerCase()).contains(token.getName().toLowerCase());
	}

	public static function parameter(token:ParserTokens, index:Int):Dynamic {
		return token.getParameters()[index];
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
