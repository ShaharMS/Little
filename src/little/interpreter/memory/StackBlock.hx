package little.interpreter.memory;

@:forward(iterator, clear, keyValueIterator, keys)
abstract StackBlock(Map<String, {address:MemoryPointer, type:String}>) {
	
	public function new() {
		this = new Map<String, {address:MemoryPointer, type:String}>();
	}

	public function reference(key:String, address:MemoryPointer, type:String) {
		this[key] = {address: address, type: type};
	}
		
	public function dereference(key:String) {
		this.remove(key);
	}

	public function get(key:String):{address:MemoryPointer, type:String} {
		trace('StackBlock.get: ${key}');
		trace(this);
		if (!this.exists(key)) 
			Runtime.throwError(ErrorMessage('Variable/function ${key} does not exist'));
		return this[key];
	}
}