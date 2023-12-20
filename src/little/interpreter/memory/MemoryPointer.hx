package little.interpreter.memory;

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
}
