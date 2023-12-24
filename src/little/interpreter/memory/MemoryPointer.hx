package little.interpreter.memory;

import haxe.io.Bytes;
import haxe.Int64;

abstract MemoryPointer(String) {
    public var rawLocation(get, set):Int;

    inline function get_rawLocation() return Std.parseInt(this);
    inline function set_rawLocation(v:Int) return Std.parseInt({this = "" + v; this;});

    
    public function new(address:String) {
        this = address;
    }

    @:from public static function fromString(s:String) {
        return new MemoryPointer(s);
    }

	@:from public static function fromInt(i:Int) {
		return new MemoryPointer(i + "");
	}

    @:to public function toString() {
        return this;
    }
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

	public function toBytes():Bytes {
		var bytes = Bytes.alloc(4);
		for (i in 0...3) {
			bytes.set(i, (rawLocation >> (i * 8)) & 0xFF);
		}
		return bytes;
	}
}
