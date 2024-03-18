package little.tools;

import little.parser.Parser;
import little.lexer.Tokens.LexerTokens;
import little.lexer.Lexer;
import little.interpreter.Tokens.InterpTokens;
import little.interpreter.Interpreter;
import little.parser.Tokens.ParserTokens;

using little.tools.TextTools;

/**
    Contains many convenience methods to help write more elegant code.
**/
class Extensions {

	/**
	    True if `token`'s name is contained within `tokens`. False otherwise.  
	**/
	overload extern inline public static function is(token:ParserTokens, ...tokens:ParserTokensSimple) {
		return tokens.toArray().map(x -> x.getName().remove("_").toLowerCase()).contains(token.getName().toLowerCase());
	}

	/**
	    True if `token`'s name is contained within `tokens`. False otherwise.  
	**/
	overload extern inline public static function is(token:InterpTokens, ...tokens:InterpTokensSimple) {
		return tokens.toArray().map(x -> x.getName().remove("_").toLowerCase()).contains(token.getName().toLowerCase());
	}

	/**
		Converts code into an array of `InterpTokens`.
	**/
	public static function tokenize(code:String):Array<InterpTokens> {
		return Interpreter.convert(...Parser.parse(Lexer.lex(code)));
	}

	/**
		Converts code into an array of `InterpTokens`, runs them, and returns the result.
	**/
	public static function eval(code:String):InterpTokens {
		return Interpreter.run(Interpreter.convert(...Parser.parse(Lexer.lex(code))));
		
	}

	/**
	    Grabs the `index`th parameter from the enum instance `token`.
	**/
	overload extern inline public static function parameter(token:ParserTokens, index:Int):Dynamic {
		return token.getParameters()[index];
	}

	/**
	    Grabs the `index`th parameter from the enum instance `token`.
	**/
	overload extern inline public static function parameter(token:InterpTokens, index:Int):Dynamic {
		return token.getParameters()[index];
	}

	/**
	    Whether or not `token` is passed by value.
	**/
	public static inline function passedByValue(token:InterpTokens):Bool {
		return is(token, TRUE_VALUE, FALSE_VALUE, NULL_VALUE, NUMBER, DECIMAL, SIGN);
	}

	/**
	    Wether or not `token` is passed by reference.
	**/
	public static inline function passedByReference(token:InterpTokens):Bool {
		return !passedByValue(token);
	}

	/**
	    Whether or not `token` can be stored statically, taking the same amount of memory each time.  
		An exception is made for strings, that are stored a little differently.
	**/
	public static inline function staticallyStorable(token:InterpTokens):Bool {
		return passedByValue(token) || is(token, CHARACTERS);
	}

	/**
	    Grabs the string from `Identifier` or `Characters` tokens.  
		If `token` is not an `Identifier` or `Characters` token, it will use the result of `Interpreter.run([token])`.
	**/
	public static inline function extractIdentifier(token:InterpTokens):String {
		return is(token, IDENTIFIER, CHARACTERS) ? parameter(token, 0) : parameter(Interpreter.run([token]), 0);
	}

	/**
	    Converts nested `PropertyAccess` and `Identifier` tokens into a string array.
	**/
	public static function asStringPath(token:InterpTokens):Array<String> {
		var path = [];
		var current = token;
		while (current != null) {
			switch current {
				case PropertyAccess(source, property): {
					path.unshift(extractIdentifier(property));
					current = source;
				}
				case Identifier(word) | Characters(word): {
					path.unshift(word);
					current = null;
				}
				default: {
					path.unshift(extractIdentifier(current));
					current = null;
				}		
			}
		}
		
		return path;
	}

	/**
	    Converts nested `PropertyAccess` and `Identifier` tokens into a string.
	**/
	public static function asJoinedStringPath(token:InterpTokens):String {
		return asStringPath(token).join(Little.keywords.PROPERTY_ACCESS_SIGN);		
	}

	/**
	    Returns the type of `token`.
	**/
	public static function type(token:InterpTokens):String {
		switch token {
			case Characters(string): return Little.keywords.TYPE_STRING;
			case Number(number): return Little.keywords.TYPE_INT;
			case Decimal(number): return Little.keywords.TYPE_FLOAT;
			case TrueValue | FalseValue: return Little.keywords.TYPE_BOOLEAN;
			case NullValue: return Little.keywords.TYPE_DYNAMIC;
			case FunctionCode(requiredParams, body): return Little.keywords.TYPE_FUNCTION;
			case Sign(sign): return Little.keywords.TYPE_SIGN;
			case Object(_, typeName): return typeName;
			case ClassPointer(pointer): return Little.keywords.TYPE_MODULE;
			case _: throw '$token is not a simple token (given $token)';
		}
	}

	/**
	    The reverse of `asJoinedStringPath()`.
	**/
	public static function asTokenPath(string:String):InterpTokens {
		var path = string.split(Little.keywords.PROPERTY_ACCESS_SIGN);
		if (path.length == 1) return Identifier(path[0]);
		else return PropertyAccess(asTokenPath(path.slice(0, path.length - 1).join(Little.keywords.PROPERTY_ACCESS_SIGN)), Identifier(path.pop()));
	}

	/**
	    Converts nested `PropertyAccess` and `Identifier` tokens into an array of just `Identifier` tokens.
	**/
	public static function toIdentifierPath(propertyAccess:InterpTokens):Array<InterpTokens> {
		var arr = [];
		var current = propertyAccess;
		while (current != null) {
			switch current {
				case PropertyAccess(source, property): {
					arr.unshift(property);
					current = source;
				}
				case _: {
					arr.unshift(current);
					current = null;
				}
			}
		}
		return arr;
	}

	/**
	    Whether or not any element of `array` matches `func`.
	**/
	public static function containsAny<T>(array:Array<T>, func:T -> Bool):Bool {
		return array.filter(func).length > 0;
	}

	/**
	    Converts an `Iterator` to an `Array`.
	**/
	public static function toArray<T>(iter:Iterator<T>):Array<T> {
		return [for (i in iter) i];
	}
}

enum ParserTokensSimple {
	SET_LINE;
	SPLIT_LINE;
	VARIABLE;
	FUNCTION;
	CONDITION_CALL;
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
	CONDITION_DECLARATION;
	CLASS_DECLARATION;

	CONDITION_CALL;
	CONDITION_CODE;
	FUNCTION_CALL; 
	FUNCTION_CODE;   
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
	DOCUMENTATION;
	CLASS_POINTER;
	SIGN;
	NULL_VALUE;
	TRUE_VALUE;
	FALSE_VALUE;

	IDENTIFIER;
	TYPE_REFERENCE;
	
	OBJECT;
	CLASS;
	ERROR_MESSAGE;

	HAXE_EXTERN;
}