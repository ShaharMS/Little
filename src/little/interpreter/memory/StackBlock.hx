package little.interpreter.memory;

import haxe.ds.StringMap;
using little.tools.Extensions;

class StackBlock {
	
	public var previous:Null<StackBlock>;

	var inner:StringMap<{?address:MemoryPointer, ?type:String, ?doc:String}>;

	public function new() {
		inner = new StringMap();
	}

	public function exists(key:String):Bool return inner.exists(key);
	public function remove(key:String) inner.remove(key);
	public function copy() return inner.copy();


	public function reference(key:String, address:MemoryPointer, type:String, doc:String) {
		inner.set(key, {address: address, type: type, doc: doc});
	}
		
	public function dereference(key:String) {
		inner.remove(key);
	}

	public function get(key:String):{address:MemoryPointer, type:String, doc:String} {
		// Do lookbehind until we find something
		var current = this;
		while (current != null) {
			if (current.exists(key)) return current.directGet(key);
			current = current.previous;
		}
		Runtime.throwError(ErrorMessage('Variable/function ${key} does not exist'));
		return { address: MemoryPointer.fromInt(0), type: Little.keywords.TYPE_DYNAMIC, doc: ''};
	}

	public function directGet(key:String):{address:MemoryPointer, type:String, doc:String} {
		return inner.get(key);
	}

	public function set(key:String, value:{?address:Null<MemoryPointer>, ?type:Null<String>, ?doc:Null<String>}) {
		// Do lookbehind until we find something
		// var current = this;
		// while (current != null) {
		// 	if (current.exists(key)) {
		// 		if (value.address != null) current.get(key).address = value.address;
		// 		if (value.type != null) current.get(key).type = value.type;
		// 		if (value.doc != null) current.get(key).doc = value.doc;
		// 	}
		// 	current = current.previous;
		// }
		inner.set(key, value);
	}


	public function keyValueIterator():KeyValueIterator<String, {?address:Null<MemoryPointer>, ?type:Null<String>, ?doc:Null<String>}> {
		var collection = this.copy();
		var current = this;
		return {
			hasNext: function() {
				return current != null || collection.keys().toArray().length > 0;
			},
			next: function() {
				if (collection.keys().toArray().length == 0) {
					current = current.previous;
					collection = current.copy();
				}
				var key = collection.keys().toArray()[0], value = collection.get(key);
				collection.remove(key);
				return {key: key, value: value};
			}
		}
	}
}