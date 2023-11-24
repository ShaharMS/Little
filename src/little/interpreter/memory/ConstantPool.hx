package little.interpreter.memory;

import vision.ds.ByteArray;

class ConstantPool {

    public var NULL:MemoryPointer = "a0";
    public var FALSE:MemoryPointer = "a1";
    public var TRUE:MemoryPointer = "a2";
    public var ZERO:MemoryPointer = "a3"; // size: 8 bytes.

    var byteArray = new ByteArray(11, 0);

    public function new() {
        byteArray[2] = 1;
    }
}