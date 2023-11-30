package little.interpreter.memory;

import haxe.ds.Either;
import haxe.exceptions.ArgumentException;
import little.interpreter.Tokens.InterpTokens;
import haxe.xml.Parser;
import haxe.io.Bytes;
import haxe.io.UInt8Array;
import vision.ds.ByteArray;

using little.tools.Extensions;
class Heap {

	public var parent:Memory;

    public function new(memory:Memory) {
        parent = memory;
    }


    /**
        storees a byte to the heap
        @param b an 8-bit number
        @return A pointer to its address on the heap. The size of this "object" is `1`.
    **/
    public function storeByte(b:Int):MemoryPointer {
        if (b == 0) return parent.constants.ZERO;
        #if !static if (b == null) return parent.constants.NULL; #end

        // Find a free spot
        var i = 0;
        while (i < parent.reserved.length && parent.reserved[i] != 0) i++;
        if (i >= parent.reserved.length) parent.increaseBuffer();
        parent.memory[i] = b;
        parent.reserved[i] = 1;

        return '$i';
    }

    /**
        Reads a byte from the heap
        @param address The address of the byte to read
        @return The byte
    **/
    public function readByte(address:MemoryPointer):Int {
        return parent.memory[address.rawLocation];
    }

    /**
        Pops a byte from the heap
        @param address The address of the byte to remove
    **/
    public function freeByte(address:MemoryPointer) {
        parent.memory[address.rawLocation] = 0;
        parent.reserved[address.rawLocation] = 0;
    }


    public function storeInt16(b:Int):MemoryPointer {
        if (b == 0) return parent.constants.ZERO;
        #if !static if (b == null) return parent.constants.NULL; #end

        // Find a free spot
        var i = 0;
        while (i < parent.reserved.length - 1 && parent.reserved[i] != 0 && parent.reserved[i + 1] != 0) i++;
        if (i >= parent.reserved.length - 1) parent.increaseBuffer();

        for (j in 0...1) {
            parent.memory[i + j] = b & 0xFF;
            b = b >> 8;
            parent.reserved[i + j] = 1;
        }

        return '$i';
    }

    public function readInt16(address:MemoryPointer):Int {
        // Dont forget to make the number negative if needed.
        return (parent.memory[address.rawLocation] + (parent.memory[address.rawLocation + 1] << 8)) - 32767;
        
    }

    public function freeInt16(address:MemoryPointer) {
		parent.memory[address.rawLocation] = 0;
		parent.memory[address.rawLocation + 1] = 0;
        parent.reserved[address.rawLocation] = 0;
        parent.reserved[address.rawLocation + 1] = 0;
    } 


    public function storeUInt16(b:Int):MemoryPointer {
        return storeInt16(b < 0 ? b + 32767 : b);
    }

    public function readUInt16(address:MemoryPointer) {

        return (parent.memory[address.rawLocation] + (parent.memory[address.rawLocation + 1] << 8));
    }

    public function freeUInt16(address:MemoryPointer) {
        freeInt16(address);
    }

    public function storeInt32(b:Int):MemoryPointer {
        if (b == 0) return parent.constants.ZERO;
        #if !static if (b == null) return parent.constants.NULL; #end

        // Find a free spot
        var i = 0;
        while (i < parent.reserved.length - 3 && parent.reserved[i] + parent.reserved[i + 1] + parent.reserved[i + 2] + parent.reserved[i + 3] != 0) i++;
        if (i >= parent.reserved.length - 3) parent.increaseBuffer();

        for (j in 0...3) {
            parent.memory[i + j] = b & 0xFF;
            b = b >> 8;
            parent.reserved[i + j] = 1;
        }

		return '$i';
    }

    public function readInt32(address:MemoryPointer):Int {
        return (parent.memory[address.rawLocation] + (parent.memory[address.rawLocation + 1] << 8) + (parent.memory[address.rawLocation + 2] << 16) + (parent.memory[address.rawLocation + 3] << 24));
    }

    public function freeInt32(address:MemoryPointer) {
        for (j in 0...3) {
            parent.memory[address.rawLocation + j] = 0;
			parent.reserved[address.rawLocation + j] = 0;
        }
    }

    public function storeUInt32(b:UInt):MemoryPointer {
        return storeInt32(b);
    }

    public function readUInt32(address:MemoryPointer):UInt {
        return readInt32(address);
    }

    public function freeUInt32(address:MemoryPointer) {
        freeInt32(address);
    }


    public function storeDouble(b:Float):MemoryPointer {
        if (b == 0) return parent.constants.ZERO;
        #if !static if (b == null) return parent.constants.NULL; #end

        var i = 0;
        while (i < parent.reserved.length - 7 && 
            parent.reserved[i] + parent.reserved[i + 1] + parent.reserved[i + 2] + parent.reserved[i + 3] + 
            parent.reserved[i + 4] + parent.reserved[i + 5] + parent.reserved[i + 6] + parent.reserved[i + 7] != 0) i++;
        if (i >= parent.reserved.length - 7) parent.increaseBuffer();

        var bytes = Bytes.alloc(8);
		bytes.setDouble(0, b);
        for (j in 0...7) {
            parent.memory[i + j] = bytes.get(j);
        }

        return '$i';
    }

    public function readDouble(address:MemoryPointer):Float {
        return parent.memory.getDouble(address.rawLocation);
    }

    public function freeDouble(address:MemoryPointer) {
        for (j in 0...7) {
            parent.memory[address.rawLocation + j] = 0;
			parent.reserved[address.rawLocation + j] = 0;
        }
    }

    public function storeStructure(struct:InterpTokens):Map<String, MemoryPointer> {
        if (!struct.is(STRUCTURE)) throw new ArgumentException("struct", '${struct} is not a structure');
        // We will take the java approach - values are stored with types, functions are stored elsewhere

        var value:InterpTokens, props:Map<String, InterpTokens>, doc:InterpTokens;

        switch struct {
            case Structure(base, props): {
                switch base {
                    case Value(v, _, d): {
                        value = v;
                        doc = d;
                    }
                    case _:
                }
            }
            case _:
        }
        props[""] = value;

        // THis map will consist of all references to 
        var map = new Map<String, MemoryPointer>();
        // Assign base value, use key "".
        map[""] = store(value);

        return null;
    }

	public function storeStatic(token:InterpTokens):MemoryPointer {
		switch token {
			case NullValue | TrueValue | FalseValue: return parent.constants.get(token);
			case Number(num): return storeInt32(num);
			case Decimal(num): return storeDouble(num);
            case _: throw new ArgumentException("token", '${token} cannot be statically stored to the heap');
		}
	}
}