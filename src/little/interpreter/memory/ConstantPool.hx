package little.interpreter.memory;

import haxe.exceptions.ArgumentException;
import little.interpreter.Tokens;
import vision.ds.ByteArray;

using little.tools.Extensions;

/**
	A class allowing access to static constants in Little, without having to allocate memory for them.
**/
class ConstantPool {

	/**
		The amount of bytes the constant pool takes up.
	**/
	public var capacity(default, null):Int = 24;

    public var NULL:MemoryPointer = 0;
    public var FALSE:MemoryPointer = 1;
    public var TRUE:MemoryPointer = 2;
    public var ZERO:MemoryPointer = 3; // size: 8 bytes.
	
	public var INT:MemoryPointer = 11; // Int primitive type
	public var FLOAT:MemoryPointer = 12; // Float primitive type
	public var BOOL:MemoryPointer = 13; // Bool primitive type
	public var DYNAMIC:MemoryPointer = 14; // Dynamic type
	public var TYPE:MemoryPointer = 15;
	public var UNKNOWN:MemoryPointer = 16; // Unknown type, used for in-place type inference
	public var ERROR:MemoryPointer = 17; // A thrown error has this pointer
	public var EXTERN:MemoryPointer = 18; // An extern function pointer, uses a haxeExtern token and thus cant be stored normally.
	public var EMPTY_STRING:MemoryPointer = 19; // size: 4 bytes

    /**
		Instantiates a new `ConstantPool`
    **/
    public function new(memory:Memory) {
        for (i in 0...capacity) memory.storage.reserved[i] = 1; // Contains "Core" values
		memory.storage.setByte(TRUE, 1); // TRUE
    }

	/**
		Converts an `InterpTokens` into a `MemoryPointer`, or throws an `ArgumentException` if it doesn't exist in the constant pool.
		@param token The token to convert
		@return The converted `MemoryPointer`
		@throws ArgumentException If the token can't be represented using the constant pool
	**/
	public function get(token:InterpTokens):MemoryPointer {
		switch (token) {
			case NullValue: return NULL;
			case FalseValue: return FALSE;
			case TrueValue: return TRUE;
			case Number(0) | Decimal(0.): return ZERO;
			case Characters(""): return EMPTY_STRING;
			case (_.equals(Identifier(Little.keywords.TYPE_INT)) => true): return INT;
			case (_.equals(Identifier(Little.keywords.TYPE_FLOAT)) => true): return FLOAT;
			case (_.equals(Identifier(Little.keywords.TYPE_BOOLEAN)) => true): return BOOL;
			case (_.equals(Identifier(Little.keywords.TYPE_DYNAMIC)) => true): return DYNAMIC;
			case (_.equals(Identifier(Little.keywords.TYPE_MODULE)) => true): return TYPE;
			case (_.equals(Identifier(Little.keywords.TYPE_UNKNOWN)) => true): return UNKNOWN;
			case ErrorMessage(_): return ERROR;
			case FunctionCode(p, _.parameter(0).filter(x -> x.is(HAXE_EXTERN)) => true): return EXTERN;
			case _: throw new ArgumentException("token", '${token} does not exist in the constant pool');
		}
	}

	/**
		Converts a `MemoryPointer` into an `InterpTokens`, or throws an `ArgumentException` if it doesn't exist in the constant pool.
		@param pointer The pointer to convert
		@return The converted `InterpTokens`
		@throws ArgumentException If the pointer doesn't exist in the constant pool
	**/
	public function getFromPointer(pointer:MemoryPointer):InterpTokens {
		return switch pointer.rawLocation {
			case 0x00: NullValue;
			case 0x01: FalseValue;
			case 0x02: TrueValue;
			case 0x03: Number(0);
			case 0x0B: Identifier(Little.keywords.TYPE_INT);
			case 0x0C: Identifier(Little.keywords.TYPE_FLOAT);
			case 0x0D: Identifier(Little.keywords.TYPE_BOOLEAN);
			case 0x0E: Identifier(Little.keywords.TYPE_DYNAMIC);
			case 0x0F: Identifier(Little.keywords.TYPE_MODULE);
			case 0x10: Identifier(Little.keywords.TYPE_UNKNOWN);
			case 0x11: ErrorMessage("Default value for error message");
			case 0x12: HaxeExtern(() -> Characters("Default value for external haxe code"));
			case 0x13: Characters("");
			case _: throw 'pointer ${pointer} not in constant pool';
		}
	}

	/**
		Checks if a `MemoryPointer` exists in the constant pool.
		@param pointer The pointer to check
		@return `true` if the pointer exists, `false` otherwise
	**/
	public function hasPointer(pointer:MemoryPointer):Bool {
		return pointer.rawLocation < capacity && pointer.rawLocation >= 0;
	}
}