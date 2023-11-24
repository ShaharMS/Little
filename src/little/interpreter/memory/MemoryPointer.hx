package little.interpreter.memory;

abstract MemoryPointer(String) {
    public var type(get, set):MemoryPointerType;
    public var rawLocation(get, set):Int;

    function get_type() return this.charAt(0);
    function set_type(v:MemoryPointerType) this = v + this.substring(1);

    function get_rawLocation() return this.substring(1).toInt();
    function set_rawLocation(v:Int) this = this.charAt(0) + v.toString();

    
    public function new(type:MemoryPointerType, address:String) {
        this = type + address;
    }

    @:from public static function fromString(s:String) {
        return new MemoryPointer(s.charAt(0), s.substring(1));
    }

    @:to public function toString() {
        return this;
    }
}

enum abstract MemoryPointerType(String) from String to String {
    var CONSTANT_POOL = 'a';
    var STACK = 'b';
    var HEAP = 'c';
}