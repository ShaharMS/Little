package little.tools;

import little.interpreter.memory.MemoryPointer;
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
		return is(token, TRUE_VALUE, FALSE_VALUE, NULL_VALUE, NUMBER, DECIMAL, SIGN, CHARACTERS);
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
		return is(token, IDENTIFIER) ? parameter(token, 0) : parameter(Interpreter.run([token]), 0);
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
				case Identifier(word): {
					path.unshift(word);
					current = null;
				}
				case Characters(string):
					path.unshift('"$string"');
					current = null;
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

	public static function asObjectToken(o:Map<String, InterpTokens>, typeName:String):InterpTokens {
		var map = [for (k => v in o) k => {documentation: "", value: v}];
		map[Little.keywords.OBJECT_TYPE_PROPERTY_NAME] = {documentation: 'The type of this object, as a ${Little.keywords.TYPE_STRING}.', value: InterpTokens.Characters(typeName)};
		return Object(map, typeName);
	}

	public static function asEmptyObject(a:Array<Dynamic>, typeName:String):InterpTokens {
		return Object([Little.keywords.OBJECT_TYPE_PROPERTY_NAME => {value: Characters(typeName), documentation: 'The type of this object, as a ${Little.keywords.TYPE_STRING}.'}], typeName);
	}

	/**
	    The reverse of `asJoinedStringPath()`.
	**/
	public static function asTokenPath(string:String):InterpTokens {
		var path = string.split(Little.keywords.PROPERTY_ACCESS_SIGN);
		if (path.length == 1) return Identifier(path[0]);
		else return PropertyAccess(asTokenPath(path.slice(0, path.length - 1).join(Little.keywords.PROPERTY_ACCESS_SIGN)), Identifier(path.pop()));
	}

	public static function extractValue(address:MemoryPointer, type:String):InterpTokens {
		return switch type {
			case (_ == Little.keywords.TYPE_STRING => true): Characters(Little.memory.storage.readString(address));
			case (_ == Little.keywords.TYPE_INT => true): Number(Little.memory.storage.readInt32(address));
			case (_ == Little.keywords.TYPE_FLOAT => true): Decimal(Little.memory.storage.readDouble(address));
			case (_ == Little.keywords.TYPE_BOOLEAN => true): Little.memory.constants.getFromPointer(address);
			case (_ == Little.keywords.TYPE_FUNCTION => true): Little.memory.storage.readCodeBlock(address);
			case (_ == Little.keywords.TYPE_CONDITION => true): Little.memory.storage.readCondition(address);
			case (_ == Little.keywords.TYPE_MODULE => true): ClassPointer(address);
			// Because of the way we store lone nulls (as type dynamic), 
			// they might get confused with objects of type dynamic, so we need to do this:
			case ((_ == Little.keywords.TYPE_DYNAMIC || _ == Little.keywords.TYPE_UNKNOWN) && Little.memory.constants.hasPointer(address) && Little.memory.constants.getFromPointer(address).equals(NullValue) => true): NullValue;
			case (_ == Little.keywords.TYPE_SIGN => true): Little.memory.storage.readSign(address);
			case (_ == Little.keywords.TYPE_UNKNOWN => true): throw 'Cannot extract value of unknown type';
				// Not sure how someone can even get to the error above, but it's better to be safe than sorry - maybe a developer generates an extern field of type Unknown or something...
			case _: Little.memory.storage.readObject(address);
		}
	}

	public static function writeInPlace(address:MemoryPointer, value:InterpTokens) {
		var type = type(value);
		switch type {
			case (_ == Little.keywords.TYPE_STRING => true): Little.memory.storage.setString(address, parameter(value, 0));
			case (_ == Little.keywords.TYPE_INT => true): Little.memory.storage.setInt32(address, parameter(value, 0));
			case (_ == Little.keywords.TYPE_FLOAT => true): Little.memory.storage.setDouble(address, parameter(value, 0));
			case (_ == Little.keywords.TYPE_FUNCTION => true): Little.memory.storage.setCodeBlock(address, parameter(value, 0));
			case (_ == Little.keywords.TYPE_CONDITION => true): Little.memory.storage.setCondition(address, parameter(value, 0));
			case (_ == Little.keywords.TYPE_MODULE => true): Little.memory.storage.setPointer(address, parameter(value, 0));
			case (_ == Little.keywords.TYPE_SIGN => true): Little.memory.storage.setSign(address, parameter(value, 0));
			case (_ == Little.keywords.TYPE_UNKNOWN => true): throw 'Cannot extract value of unknown type';
			case _: Little.memory.storage.setObject(address, parameter(value, 0));
		}
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
	SET_MODULE;
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
	SET_MODULE;
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