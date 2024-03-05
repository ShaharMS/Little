package little.tools;

import little.interpreter.Actions;
import little.interpreter.Tokens.InterpTokens;
import little.interpreter.Interpreter;
import little.parser.Tokens.ParserTokens;

using little.tools.TextTools;

class Extensions {

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
		return is(token, TRUE_VALUE, FALSE_VALUE, NULL_VALUE, NUMBER, DECIMAL, SIGN);
	}

	public static inline function passedByReference(token:InterpTokens):Bool {
		return !passedByValue(token);
	}

	public static inline function staticallyStorable(token:InterpTokens):Bool {
		return passedByValue(token) || is(token, CHARACTERS);
	}

	public static inline function extractIdentifier(token:InterpTokens):String {
		return is(token, IDENTIFIER, CHARACTERS) ? parameter(token, 0) : parameter(Actions.run([token]), 0);
	}

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

	public static function asJoinedStringPath(token:InterpTokens):String {
		return asStringPath(token).join(Little.keywords.PROPERTY_ACCESS_SIGN);		
	}

	public static function type(token:InterpTokens):String {
		switch token {
			case Characters(string): return Little.keywords.TYPE_STRING;
			case Number(number): return Little.keywords.TYPE_INT;
			case Decimal(number): return Little.keywords.TYPE_FLOAT;
			case TrueValue | FalseValue: return Little.keywords.TYPE_BOOLEAN;
			case NullValue: return Little.keywords.TYPE_DYNAMIC;
			case FunctionCode(requiredParams, body): return Little.keywords.TYPE_FUNCTION;
			case Sign(sign): return Little.keywords.TYPE_SIGN;
			case Object(_, _, typeName): return typeName;
			case ClassPointer(pointer): return Little.keywords.TYPE_MODULE;
			case _: throw '$token is not a simple token (given $token)';
		}
	}

	public static function asTokenPath(string:String):InterpTokens {
		var path = string.split(Little.keywords.PROPERTY_ACCESS_SIGN);
		if (path.length == 1) return Identifier(path[0]);
		else return PropertyAccess(asTokenPath(path.slice(0, path.length - 1).join(Little.keywords.PROPERTY_ACCESS_SIGN)), Identifier(path.pop()));
	}

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

	public static function containsAny<T>(array:Array<T>, func:T -> Bool):Bool {
		return array.filter(func).length > 0;
	}

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