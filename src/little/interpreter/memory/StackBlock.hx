package little.interpreter.memory;

import haxe.ds.StringMap;

@:forward(iterator, clear, keyValueIterator, keys)
class StackBlock extends StringMap<{address:MemoryPointer, type:String}>{
	
	public var previous:Null<StackBlock>;

	public function new() {
		super();
	}

	public function reference(key:String, address:MemoryPointer, type:String) {
		this.set(key, {address: address, type: type});
	}
		
	public function dereference(key:String) {
		this.remove(key);
	}

	override public function get(key:String):{address:MemoryPointer, type:String} {
		// Do lookbehind until we find something
		var current = this;
		while (current != null) {
			if (current.exists(key)) return current.get(key);
			current = current.previous;
		}
		Runtime.throwError(ErrorMessage('Variable/function ${key} does not exist'));
		return { address: MemoryPointer.fromInt(0), type: Little.keywords.TYPE_DYNAMIC };
	}
}