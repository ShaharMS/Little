package little.interpreter.memory;

import haxe.ds.StringMap;

@:forward(iterator, clear, keys, keyValueIterator)
class StackBlock extends StringMap<{?address:MemoryPointer, ?type:String, ?doc:String}>{
	
	public var previous:Null<StackBlock>;

	public function new() {
		super();
	}

	public function reference(key:String, address:MemoryPointer, type:String, doc:String) {
		this.set(key, {address: address, type: type, doc: doc});
	}
		
	public function dereference(key:String) {
		this.remove(key);
	}

	override public function get(key:String):{address:MemoryPointer, type:String, doc:String} {
		// Do lookbehind until we find something
		var current = this;
		while (current != null) {
			if (current.exists(key)) return current.get(key);
			current = current.previous;
		}
		Runtime.throwError(ErrorMessage('Variable/function ${key} does not exist'));
		return { address: MemoryPointer.fromInt(0), type: Little.keywords.TYPE_DYNAMIC, doc: ''};
	}

	override public function set(key:String, value:{?address:Null<MemoryPointer>, ?type:Null<String>, ?doc:Null<String>}) {
		// Do lookbehind until we find something
		var current = this;
		while (current != null) {
			if (current.exists(key)) {
				if (value.address != null) current.get(key).address = value.address;
				if (value.type != null) current.get(key).type = value.type;
				if (value.doc != null) current.get(key).doc = value.doc;
			}
		}
		super.set(key, value);
	}


	override public function keyValueIterator():KeyValueIterator<String, {?address:Null<MemoryPointer>, ?type:Null<String>, ?doc:Null<String>}> {
		var collection = this.copy();
		var current = this;
		return {
			hasNext: function() {
				return current != null || collection.keys().length > 0;
			},
			next: function() {
				if (collection.keys().length == 0) {
					current = current.previous;
					collection = current.copy();
				}
				var key = collection.keys()[0], value = collection.get(key);
				collection.remove(key);
				return {key: key, value: value};
			}
		}
	}
}