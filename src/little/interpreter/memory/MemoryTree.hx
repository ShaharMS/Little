package little.interpreter.memory;

import little.interpreter.Interpreter.*;
import little.parser.Tokens.ParserTokens;
import little.Keywords.*;

class MemoryTreeBase {
    public var map:Map<String, MemoryObject> = [];
    public var objType:String;
    public var obj:MemoryObject;

    public function new(m:MemoryObject) {
		if (m == null) m = new MemoryObject(NullValue, m);
        objType = m.valueType != null && !m.valueType.equals(NullValue) ? Interpreter.stringifyTokenValue(m.valueType) : m.value != null && !m.value.equals(NullValue) ? Interpreter.stringifyTokenValue(Interpreter.getValueType(m.value)) : TYPE_DYNAMIC;
        obj = m;
    }
}

abstract MemoryTree(MemoryTreeBase) {

    public var underlying(get, never):MemoryTreeBase;
	public var object(get, never):MemoryObject;

    function get_underlying() return this;
    function get_object() return this.obj;

    public function new(obj:MemoryObject) {
        this = new MemoryTreeBase(obj);
    }

    public function get(name:String):MemoryObject {
        return this.map[name];
    }

    public function set(name:String, value:MemoryObject) {
        this.map[name] = value;
    }

	/**
		Returns true if `key` has a mapping, false otherwise.

		If `key` is `null`, the result is unspecified.
	**/
	public inline function exists(key:String)
		return this.map.exists(key);

	/**
		Removes the mapping of `key` and returns true if such a mapping existed,
		false otherwise.

		If `key` is `null`, the result is unspecified.
	**/
	public inline function remove(key:String)
		return this.map.remove(key);

	/**
		Returns an Iterator over the keys of `this` Map.

		The order of keys is undefined.
	**/
	public inline function keys():Iterator<String> {
		return this.map.keys();
	}

	/**
		Returns an Iterator over the values of `this` Map.

		The order of values is undefined.
	**/
	public inline function iterator():Iterator<MemoryObject> {
		return this.map.iterator();
	}

	/**
		Returns an Iterator over the keys and values of `this` Map.

		The order of values is undefined.
	**/
	public inline function keyValueIterator():KeyValueIterator<String, MemoryObject> {
		return this.map.keyValueIterator();
	}

	/**
		Returns a shallow copy of `this` map.

		The order of values is undefined.
	**/
	public inline function copy():MemoryTree {
		return cast this.map.copy();
	}

	/**
		Returns a String representation of `this` Map.

		The exact representation depends on the platform and key-type.
	**/
	public inline function toString():String {
		return this.map.toString();
	}

	/**
		Removes all keys from `this` Map.
	**/
	public inline function clear():Void {
		this.map.clear();
	}

	public inline function concat(map:Map<String, MemoryObject>):MemoryTree {
		for (k => v in map.keyValueIterator()) {
			v.parent = this.obj;
			set(k, v);
		}
		return cast this;
	}

	@:noCompletion public inline function silentGet(key:String) {
		return this.map.get(key);
	}


	@:from static inline function fromMap<K, V>(map:Map<K, V>):MemoryTree {
		return new MemoryTree(new MemoryObject(NullValue));
	}
	@:from static inline function fromArray<K>(map:Array<K>):MemoryTree {
		return new MemoryTree(new MemoryObject(NullValue));
	}
}