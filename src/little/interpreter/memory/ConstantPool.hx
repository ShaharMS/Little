package little.interpreter.memory;

import haxe.exceptions.ArgumentException;
import little.interpreter.Tokens;
import vision.ds.ByteArray;

class ConstantPool {

    public var NULL:MemoryPointer = "0";
    public var FALSE:MemoryPointer = "1";
    public var TRUE:MemoryPointer = "2";
    public var ZERO:MemoryPointer = "3"; // size: 8 bytes.

    public function new(memory:Memory) {
        for (i in 0...11) memory.reserved[i] = 1; // Contains "Core" values
    }

	public function get(token:InterpTokens) {
		switch (token) {
			case NullValue: return NULL;
			case FalseValue: return FALSE;
			case TrueValue: return TRUE;
			case Number(0) | Decimal(0.): return ZERO;
			case _: throw new ArgumentException("token", '${token} does not exist in the constant pool');
		}
	}

	public function getFromPointer(pointer:MemoryPointer) {
		return switch pointer.rawLocation {
			case 0x00: NullValue;
			case 0x01: FalseValue;
			case 0x02: TrueValue;
			case 0x03: Number(0);
			case _: throw "not in constant pool";
		}
	}
}