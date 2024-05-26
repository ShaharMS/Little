package little.interpreter.memory;

import haxe.io.Bytes;
import haxe.Int64;

inline var POINTER_SIZE = MemoryPointer.POINTER_SIZE;

/**
	An abstract over a 32-bit integer representing a memory address.

	Due to language limitations, we can't use an `Int64` for this. (no cross-platform support)
**/
abstract MemoryPointer(Int) {

    public static inline var POINTER_SIZE:Int = 4; //Currently, since byte array indices are 32bit.
    
    public var rawLocation(get, set):Int;

    /** MemoryPointer.rawLocation getter **/ inline function get_rawLocation() return this;
    /** MemoryPointer.rawLocation setter **/ inline function set_rawLocation(v:Int) return this = v;

    /**
		Instantiates a new `MemoryPointer`.
    **/
    public function new(address:Int) {
        this = address;
    }

	/**
		Converts an `Int` to a `MemoryPointer`.
	**/
	@:from public static function fromInt(i:Int) {
		return new MemoryPointer(i);
	}

    /**
    	Returns a string representation of this address.
    **/
    @:to public function toString() {
        return this + "";
    }

    /**
    	Converts this address to an array of bytes, representing a 64-bit number.
		The last 4 bytes are filled with zeros.
    	@return Array<Int>
    **/
    public function toArray():Array<Int> {
        var bytes = [];
        var i = rawLocation;

        for (_ in 0...4) {
            bytes.unshift(i & 0xFF);
            i = i >> 8;
        }
        for (_ in 0...4) {
            bytes.unshift(0);
        }

        return bytes;
    }

	/**
		Converts this address to an array of bytes, representing a 32-bit number.
	**/
	public function toBytes():Bytes {
		var bytes = Bytes.alloc(4);
		for (i in 0...3) {
			bytes.set(i, (rawLocation >> (i * 8)) & 0xFF);
		}
		return bytes;
	}

    public function toInt():Int {
        return this;        
    }
}
