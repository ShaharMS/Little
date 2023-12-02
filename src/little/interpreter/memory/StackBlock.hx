package little.interpreter.memory;

@:forward(iterator, clear, keyValueIterator, keys)
abstract StackBlock(Map<String, {address:MemoryPointer, type:String}>) {
	
	public function new() {}

	public function reference(key:String, address:MemoryPointer, type:String) {
		this[key] = {address: address, type: type};
	}
		
	public function dereference(key:String) {
		this[key] = null;
	}

	public function get(key:String):{address:MemoryPointer, type:String} {
		return this[key];
	}
}