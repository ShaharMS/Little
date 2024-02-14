package little.interpreter.memory;

import haxe.exceptions.ArgumentException;
import little.interpreter.Tokens;
import vision.ds.ByteArray;

class ConstantPool {

    public var NULL:MemoryPointer = "0";
    public var FALSE:MemoryPointer = "1";
    public var TRUE:MemoryPointer = "2";
    public var ZERO:MemoryPointer = "3"; // size: 8 bytes.
	
	public var INT:MemoryPointer = "11"; // Int primitive type
	public var FLOAT:MemoryPointer = "12"; // Float primitive type
	public var BOOL:MemoryPointer = "13"; // Bool primitive type
	public var DYNAMIC:MemoryPointer = "14"; // Dynamic type
	public var ERROR:MemoryPointer = "15"; // A thrown error has this pointer

    public function new(memory:Memory) {
        for (i in 0...16) memory.reserved[i] = 1; // Contains "Core" values
		memory.memory[2] = 1; // TRUE
    }

	public function get(token:InterpTokens) {
		switch (token) {
			case NullValue: return NULL;
			case FalseValue: return FALSE;
			case TrueValue: return TRUE;
			case Number(0) | Decimal(0.): return ZERO;
			case (_.equals(Identifier(Little.keywords.TYPE_INT)) => true): return INT;
			case (_.equals(Identifier(Little.keywords.TYPE_FLOAT)) => true): return FLOAT;
			case (_.equals(Identifier(Little.keywords.TYPE_BOOLEAN)) => true): return BOOL;
			case (_.equals(Identifier(Little.keywords.TYPE_DYNAMIC)) => true): return DYNAMIC;
			case ErrorMessage(_): return ERROR;
			case _: throw new ArgumentException("token", '${token} does not exist in the constant pool');
		}
	}

	public function getFromPointer(pointer:MemoryPointer) {
		return switch pointer.rawLocation {
			case 0x00: NullValue;
			case 0x01: FalseValue;
			case 0x02: TrueValue;
			case 0x03: Number(0);
			case 0x11: Identifier(Little.keywords.TYPE_INT);
			case 0x12: Identifier(Little.keywords.TYPE_FLOAT);
			case 0x13: Identifier(Little.keywords.TYPE_BOOLEAN);
			case 0x14: Identifier(Little.keywords.TYPE_DYNAMIC);
			case 0x15: ErrorMessage("Default value for error message");
			case _: throw "not in constant pool";
		}
	}
}