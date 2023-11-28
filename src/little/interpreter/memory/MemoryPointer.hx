package little.interpreter.memory;

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

    @:to public function toString() {
        return this;
    }
}
