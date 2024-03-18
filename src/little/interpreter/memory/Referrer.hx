package little.interpreter.memory;

import haxe.Int64;
import haxe.hash.Murmur1;
import little.interpreter.memory.MemoryPointer.POINTER_SIZE;
import vision.ds.ByteArray;
import little.tools.PrettyPrinter;
using little.tools.Extensions;

/**
	A tool to map variable names to their location in memory.

	It's storage method is similar to buddy-blocks with the heap, but each block points both backwards and forwards.
**/
class Referrer {

	/**
		4 bytes for the hash, 1 pointer for the string, 1 pointer for the address in memory, and 1 pointer for the type.
	**/
	public static var KEY_SIZE:Int = POINTER_SIZE * 3 + 4;

	public var parent:Memory;

	public var bytes:ByteArray;

	public var currentScopeStart(get, null):Int;
	/** Referrer.currentScopeStart getter **/ @:noCompletion function get_currentScopeStart() return bytes.getInt32(0);

	public var currentScopeLength(get, null):Int;
	/** Referrer.currentScopeLength getter **/ @:noCompletion function get_currentScopeLength() return bytes.getUInt16(bytes.getInt32(0) + 2);


	/**
		Instantiates a new `Referrer`.
	**/
	public function new(memory:Memory) {

		parent = memory;

		bytes = new ByteArray(1024); // 1mb, no need to be too big
		bytes.setInt32(0, 4); // The current scope starts at position 4.
		bytes.setUInt16(4, 0); // always 0 elements backwards, were at the start,
		bytes.setUInt16(6, 0); // Were just starting, forward is 0 and will change.
	}

	/**
		Requests 1024 bytes of extra memory for the referrer.
	**/
	function requestMemory() {
		if (bytes.length > parent.maxMemorySize) {
			Little.runtime.throwError(ErrorMessage('Too many scopes have been created, referrer\'s stack has overflown (check for infinite recursion)'), MEMORY_REFERRER);
		}
		bytes.resize(bytes.length + 1024);
	}

	/**
		Creates a new scope. Fields created after this will be added to the new scope, and won't affect fields from the previous scopes.
	**/
	public function pushScope() {
		var currentScopeLength = bytes.getUInt16(bytes.getInt32(0) + 2);
		var currentScopeStart = bytes.getInt32(0) + 4; // each header is 4 bytes long.

		var header = new ByteArray(4);
		header.setUInt16(0, currentScopeLength);
		header.setUInt16(2, 0); // Currently, 0 elements ahead.

		var writePosition = currentScopeStart + currentScopeLength * KEY_SIZE;

		if (writePosition + 2 + 2 > bytes.length) {
			requestMemory();
		}

		bytes.setBytes(writePosition, header);
		bytes.setInt32(0, writePosition); // Update the start of the scope.
	}

	/**
		Removes the last scope. TODO: Garbage collection.
	**/
	public function popScope() {
		var currentScopePosition = bytes.getInt32(0);
		var previousScopeLength = bytes.getUInt16(currentScopePosition);
		var currentScopeLength = bytes.getUInt16(currentScopePosition + 2);

		// Update the start of the scope. Also, -4 is for the header, since we need to point to its start.
		bytes.setInt32(0, currentScopePosition - previousScopeLength * KEY_SIZE - 4);

		// Todo: garbage collector.
	}

	/**
		References a variable in the current scope. If it already exists in the current scope, it will be overwritten.
		If it exists in parent scopes, they won't be affected.
		@param key The name of the variable
		@param address The address of the value
		@param type The type of the value
	**/
	public function reference(key:String, address:MemoryPointer, type:String) {
        var keyHash = Murmur1.hash(ByteArray.from(key));
        var stringName = parent.storage.storeString(key);
		
		var writePosition = currentScopeStart + 4 + currentScopeLength * KEY_SIZE;

		if (writePosition + KEY_SIZE > bytes.length) {
			requestMemory();
		}

		bytes.setUInt32(writePosition, keyHash);
		bytes.setInt32(writePosition + 4, stringName.rawLocation);
		bytes.setInt32(writePosition + 4 + POINTER_SIZE, address.rawLocation);
		bytes.setInt32(writePosition + 4 + POINTER_SIZE * 2, parent.getTypeInformation(type).pointer.rawLocation);

		bytes.setUInt16(currentScopeStart + 2, bytes.getUInt16(currentScopeStart + 2) + 1); // Increment the length of the current scope.
	}

	/**
		Removes a variable from the current scope. If it doesn't exist, throws an error.
		If it also exists in parent scopes, they won't be affected.

		@param key The name of the variable
	**/
	public function dereference(key:String) {
		var keyHash = Murmur1.hash(ByteArray.from(key));

		var writePosition = currentScopeStart + 4;

		while (true) {
			var currentKeyHash = bytes.getUInt32(writePosition);
			if (currentKeyHash == keyHash) {
				var stringName = parent.storage.readString(bytes.getInt32(writePosition + 4));
				if (stringName == key) break;
			}

			writePosition += KEY_SIZE;
			if (writePosition >= currentScopeStart + currentScopeLength * KEY_SIZE) throw 'Cannot dereference key that doesn\'t exist. (key: $key)';
		}

		bytes.setUInt16(bytes.getInt32(0) + 2, bytes.getUInt16(bytes.getInt32(0) + 2) - 1); // Decrement the length of the current scope.
	}

	/**
		Looks up a variable in the current scope.  
		If it doesn't exist in the current scope, it will look in parent scopes.

		Throws an error if it doesn't exist in any scope.

		@param key The name of the variable
		@return The address and type of the variable, in the form of an anonymous structure: `{address: MemoryPointer, type: String}` 
	**/
	public function get(key:String):{address:MemoryPointer, type:String} {
		// This one is a little more complicated, since it involves lookbehinds.
		var keyHash = Murmur1.hash(ByteArray.from(key));

		var checkingScope = currentScopeStart;
		var elementCount = bytes.getUInt16(currentScopeStart + 2);
		var nextScope = currentScopeStart - bytes.getUInt16(currentScopeStart) * KEY_SIZE - 4;

		do {
			var i = checkingScope + 4;
			while (i < (checkingScope + elementCount * KEY_SIZE)) {
				var testingHash = bytes.getUInt32(i);
				if (keyHash == testingHash) {
					var stringName = parent.storage.readString(bytes.getInt32(i + 4));
					if (stringName == key) {
						return {
							address: MemoryPointer.fromInt(bytes.getInt32(i + 4 + POINTER_SIZE)),
							type: parent.getTypeName(bytes.getInt32(i + 4 + POINTER_SIZE * 2))
						}
					}
				}

				i += KEY_SIZE;
			}
			checkingScope = nextScope;
			elementCount = bytes.getUInt16(nextScope + 2);
			nextScope = nextScope - bytes.getUInt16(nextScope) * KEY_SIZE - 4;
		} while (checkingScope != 0);

		throw 'Key $key does not exist.';
	}

	/**
		Sets the value and type of an existing variable in the current scope.  
		If it doesn't exist in the current scope, it will look in parent scopes.

		Throws an error if it doesn't exist in any scope.

		@param key The name of the variable
		@param value The new value and type of the variable. If any of these are null, the previous value/type will remain. 
	**/
	public function set(key:String, value:{?address:MemoryPointer, ?type:String}) {
		var keyHash = Murmur1.hash(ByteArray.from(key));

		var checkingScope = currentScopeStart;
		var elementCount = bytes.getUInt16(currentScopeStart + 2);
		var nextScope = currentScopeStart - bytes.getUInt16(currentScopeStart) * KEY_SIZE - 4;

		do {
			var i = checkingScope + 4;
			while (i < (checkingScope + elementCount * KEY_SIZE)) {
				var testingHash = bytes.getUInt32(i);
				if (keyHash == testingHash) {
					var stringName = parent.storage.readString(bytes.getInt32(i + 4));
					if (stringName == key) {
						if (value.address != null) bytes.setInt32(i + 4 + POINTER_SIZE, value.address.rawLocation);
						if (value.type != null) bytes.setInt32(i + 4 + POINTER_SIZE * 2, parent.getTypeInformation(value.type).pointer.rawLocation);
						return;
					}
				}

				i += KEY_SIZE;
			}
			checkingScope = nextScope;
			elementCount = bytes.getUInt16(nextScope + 2);
			nextScope = nextScope - bytes.getUInt16(nextScope) * KEY_SIZE - 4;
		} while (checkingScope != 0);

		throw 'Cannot set $key -  does not exist.';
	}

	/**
		Checks if a key exists in any scope.
		@param key The name of the variable
		@return true if the key exists, false otherwise.
	**/
	public function exists(key:String):Bool {
		var keyHash = Murmur1.hash(ByteArray.from(key));

		var checkingScope = currentScopeStart;
		var elementCount = bytes.getUInt16(currentScopeStart + 2);
		var nextScope = currentScopeStart - bytes.getUInt16(currentScopeStart) * KEY_SIZE - 4;

		do {
			var i = checkingScope + 4;
			while (i < (checkingScope + elementCount * KEY_SIZE)) {
				var testingHash = bytes.getUInt32(i);
				if (keyHash == testingHash) {
					var stringName = parent.storage.readString(bytes.getInt32(i + 4));
					if (stringName == key) {
						return true;
					}
				}

				i += KEY_SIZE;
			}
			checkingScope = nextScope;
			elementCount = bytes.getUInt16(nextScope + 2);
			nextScope = nextScope - bytes.getUInt16(nextScope) * KEY_SIZE - 4;
		} while (checkingScope != 0);

		return false;
	}

	/**
		Returns an iterator over all key/value pairs in all scopes, starting from the current scope, and going up the parent scopes.
	**/
	public function keyValueIterator():KeyValueIterator<String, {address:MemoryPointer, type:String}> {

		var map = new Map<String, {address:MemoryPointer, type:String}>();

		var checkingScope = currentScopeStart;
		var elementCount = bytes.getUInt16(currentScopeStart + 2);
		var nextScope = currentScopeStart - bytes.getUInt16(currentScopeStart) * KEY_SIZE - 4;
		do {
			var i = checkingScope;
			while (i < (checkingScope + elementCount * KEY_SIZE)) {
				var stringName = parent.storage.readString(bytes.getInt32(i + 4));
				map.set(stringName, {
					address: MemoryPointer.fromInt(bytes.getInt32(i + 4 + POINTER_SIZE)),
					type: parent.storage.readString(bytes.getInt32(i + 4 + POINTER_SIZE * 2))
				});

				i += KEY_SIZE;
			}
			checkingScope = nextScope;
			elementCount = bytes.getUInt16(nextScope + 2);
			nextScope = nextScope - bytes.getUInt16(nextScope) * KEY_SIZE - 4;
		} while (checkingScope != 0);

		return map.keyValueIterator();
	}
}