package little.interpreter.memory;

import haxe.ds.StringMap;
using little.tools.Extensions;

@:forward(iterator, clear, keys)
class StackBlock extends StringMap<{?address:MemoryPointer, ?type:String, ?doc:String}>{
	
	public var previous:Null<StackBlock>;

	public function new() {
		super();
	}

	public function reference(key:String, address:MemoryPointer, type:String, doc:String) {
		this.directSet(key, {address: address, type: type, doc: doc});
	}
		
	public function dereference(key:String) {
		this.remove(key);
	}

	override public function get(key:String):{address:MemoryPointer, type:String, doc:String} {
		// Do lookbehind until we find something
		var current = this;
		while (current != null) {
			if (current.directExists(key)) return current.directGet(key);
			current = current.previous;
		}
		Little.runtime.throwError(ErrorMessage('Variable/function ${key} does not exist'));
		return { address: MemoryPointer.fromInt(0), type: Little.keywords.TYPE_DYNAMIC, doc: ''};
	}

	override function exists(key:String):Bool {
		var current = this;
		while (current != null) {
			if (current.directExists(key)) return true;
			current = current.previous;
		}
		return false;
	}

	public function directGet(key:String):{address:MemoryPointer, type:String, doc:String} {
		return super.get(key);
	}

	public function directSet(key:String, value:{address:MemoryPointer, type:String, doc:String}) {
		super.set(key, value);
	}

	public function directExists(key:String) {
		return super.exists(key);
	}

	override public function set(key:String, value:{?address:Null<MemoryPointer>, ?type:Null<String>, ?doc:Null<String>}) {
		// Do lookbehind until we find something
		var current = this;
		while (current != null) {
			if (current.directExists(key)) {
				var obj = {address: value.address, type: value.type, doc: value.doc};
				if (value.address == null) obj.address = current.directGet(key).address;
				if (value.type == null) obj.type = current.directGet(key).type;
				if (value.doc == null) obj.doc = current.directGet(key).doc;
				current.directSet(key, obj);
				return;
			}
			current = current.previous;
		}
	}


	public function iterate():KeyValueIterator<String, {?address:Null<MemoryPointer>, ?type:Null<String>, ?doc:Null<String>}> {
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