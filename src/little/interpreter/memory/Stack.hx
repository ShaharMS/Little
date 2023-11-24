package little.interpreter.memory;

import haxe.io.Bytes;
import haxe.io.UInt8Array;
import vision.ds.ByteArray;

class Stack {

    public var stack:ByteArray;

    public var reserved:ByteArray;

    public var resizeChunkSize = 128;

    public function new() {
        stack = new ByteArray(resizeChunkSize);
    }

    public function increaseSize() {
        stack.resize(stack.length + resizeChunkSize);
        reserved.resize(stack.length);
    }

    /**
        Pushes a byte to the stack
        @param b an 8-bit number
        @return A pointer to its address on the stack. The size of this "object" is `1`.
    **/
    public function pushByte(b:Int):MemoryPointer {
        if (b == 0) return Memory.constants.ZERO;
        #if !static if (b == null) return Memory.constants.NULL; #end

        // Find a free spot
        var i = 0;
        while (i < reserved.length && reserved[i] != 0) i++;
        if (i >= reserved.length) increaseSize();
        stack[i] = b;
        reserved[i] = 1;

        return 'b$i';
    }

    /**
        Reads a byte from the stack
        @param address The address of the byte to read
        @return The byte
    **/
    public function readByte(address:MemoryPointer):Int {
        if (address.type != STACK) return 0; //only possible case

        return stack[address.rawLocation];
    }

    /**
        Pops a byte from the stack
        @param address The address of the byte to pop
    **/
    public function freeByte(address:MemoryPointer) {
        if (address.type != STACK) return;
        stack[address.rawLocation] = 0;
        reserved[address.rawLocation] = 0;
    }


    public function pushInt16(b:Int):MemoryObject {
        if (b == 0) return Memory.constants.ZERO;
        #if !static if (b == null) return Memory.constants.NULL; #end

        // Find a free spot
        var i = 0;
        while (i < reserved.length - 1 && reserved[i] != 0 && reserved[i + 1] != 0) i++;
        if (i >= reserved.length - 1) increaseSize();

        for (j in 0...1) {
            stack[i + j] = b & 0xFF;
            b = b >> 8;
            reserved[i + j] = 1;
        }

        return 'b$i';
    }

    public function readInt16(address:MemoryPointer):Int {
        // Dont forget to make the number negative if needed.

        if (address.type != STACK) return 0;

        return (stack[address.rawLocation] + (stack[address.rawLocation + 1] << 8)) - 32767;
        
    }

    public function freeInt16(address:MemoryPointer) {
        if (address.type != STACK) return;
        stack[address.rawLocation] = reserved[address.rawLocation] = 0;
        stack[address.rawLocation + 1] = reserved[address.rawLocation + 1] = 0;
    } 


    public function pushUInt16(b:Int):MemoryObject {
        pushInt16(b < 0 ? b + 32767 : b);
    }

    public function readUInt16() {
        if (address.type != STACK) return 0;

        return (stack[address.rawLocation] + (stack[address.rawLocation + 1] << 8));
    }

    public function freeUInt16(address:MemoryObject) {
        freeInt16(address);
    }

    public function pushInt32(b:Int):MemoryObject {
        if (b == 0) return Memory.constants.ZERO;
        #if !static if (b == null) return Memory.constants.NULL; #end

        // Find a free spot
        var i = 0;
        while (i < reserved.length - 3 && reserved[i] + reserved[i + 1] + reserved[i + 2] + reserved[i + 3] != 0) i++;
        if (i >= reserved.length - 3) increaseSize();

        for (j in 0...3) {
            stack[i + j] = b & 0xFF;
            b = b >> 8;
            reserved[i + j] = 1;
        }
    }

    public function readInt32(address:MemoryPointer):Int {
        if (address.type != STACK) return 0;

        return (stack[address.rawLocation] + (stack[address.rawLocation + 1] << 8) + (stack[address.rawLocation + 2] << 16) + (stack[address.rawLocation + 3] << 24));
    }

    public function freeInt32(address:MemoryPointer) {
        if (address.type != STACK) return;
        
        for (j in 0...3) {
            stack[address.rawLocation + j] = reserved[address.rawLocation + j] = 0;
        }
    }

    public function pushUInt32(b:UInt):MemoryPointer {
        return pushInt32(b);
    }

    public function readUInt32(address:MemoryPointer):UInt {
        return readInt32(address);
    }

    public function freeUInt32(address:MemoryPointer) {
        freeInt32(address);
    }


    public function pushDouble(b:Float):MemoryObject {
        if (b == 0) return Memory.constants.ZERO;
        #if !static if (b == null) return Memory.constants.NULL; #end

        var i = 0;
        while (i < reserved.length - 7 && 
            reserved[i] + reserved[i + 1] + reserved[i + 2] + reserved[i + 3] + 
            reserved[i + 4] + reserved[i + 5] + reserved[i + 6] + reserved[i + 7] != 0) i++;
        if (i >= reserved.length - 7) increaseSize();

        var bytes = Bytes.alloc(8).setDouble(0, b);
        for (j in 0...7) {
            stack[i + j] = bytes[j];
        }

        return 'b$i';
    }

    public function readDouble(address:MemoryPointer):Float {
        if (address.type != STACK) return 0;

        return stack.getDouble(address.rawLocation);
    }

    public function freeDouble(address:MemoryPointer) {
        if (address.type != STACK) return;

        for (j in 0...7) {
            stack[address.rawLocation + j] = reserved[address.rawLocation + j] = 0;
        }
    }
}