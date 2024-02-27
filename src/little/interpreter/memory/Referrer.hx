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
	@:noCompletion function get_currentScopeStart() return bytes.getInt32(0);

	public var currentScopeLength(get, null):Int;
	@:noCompletion function get_currentScopeLength() return bytes.getUInt16(bytes.getInt32(0) + 2);

	public function new(memory:Memory) {

		parent = memory;

		bytes = new ByteArray(1024); // 1mb, no need to be too big
		bytes.setInt32(0, 4); // The current scope starts at position 4.
		bytes.setUInt16(4, 0); // always 0 elements backwards, were at the start,
		bytes.setUInt16(6, 0); // Were just starting, forward is 0 and will change.
	}

	function requestMemory() {
		bytes.resize(bytes.length + 1024);
	}

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

	public function popScope() {
		var currentScopePosition = bytes.getInt32(0);
		var previousScopeLength = bytes.getUInt16(currentScopePosition);
		var currentScopeLength = bytes.getUInt16(currentScopePosition + 2);

		// Update the start of the scope. Also, -4 is for the header, since we need to point to its start.
		bytes.setInt32(0, currentScopePosition - previousScopeLength * KEY_SIZE - 4);

		// Todo: garbage collector.
	}

	
	public function reference(key:String, address:MemoryPointer, type:String) {
		trace(key);
        var keyHash = Murmur1.hash(ByteArray.from(key));
        var stringName = parent.storage.storeString(key);
		
		var writePosition = currentScopeStart + 4 + currentScopeLength * KEY_SIZE;

		if (writePosition + KEY_SIZE > bytes.length) {
			requestMemory();
		}

		bytes.setInt32(writePosition, keyHash);
		bytes.setInt32(writePosition + 4, stringName.rawLocation);
		bytes.setInt32(writePosition + 4 + POINTER_SIZE, address.rawLocation);
		bytes.setInt32(writePosition + 4 + POINTER_SIZE * 2, parent.getTypeInformation(type).pointer.rawLocation);

		bytes.setUInt16(bytes.getInt32(0) + 2, bytes.getUInt16(bytes.getInt32(0) + 2) + 1); // Increment the length of the current scope.
	}

	public function dereference(key:String) {
		var keyHash = Murmur1.hash(ByteArray.from(key));

		var writePosition = currentScopeStart + 4;

		while (true) {
			var currentKeyHash = bytes.getInt32(writePosition);
			if (currentKeyHash == keyHash) {
				var stringName = parent.storage.readString(bytes.getInt32(writePosition + 4));
				if (stringName == key) break;
			}

			writePosition += KEY_SIZE;
			if (writePosition >= currentScopeStart + currentScopeLength * KEY_SIZE) throw 'Cannot dereference key that doesn\'t exist. (key: $key)';
		}

		bytes.setUInt16(bytes.getInt32(0) + 2, bytes.getUInt16(bytes.getInt32(0) + 2) - 1); // Decrement the length of the current scope.
	}

	public function get(key:String):{address:MemoryPointer, type:String} {
		// This one is a little more complicated, since it involves lookbehinds.
		var keyHash = Murmur1.hash(ByteArray.from(key));

		var checkingScope = currentScopeStart;
		var elementCount = bytes.getUInt16(currentScopeStart + 2);
		var nextScope = currentScopeStart - bytes.getUInt16(currentScopeStart) * KEY_SIZE - 4;

		while (nextScope != 0) {
			var i = checkingScope + 4;
			while (i < (checkingScope + elementCount * KEY_SIZE)) {
				var testingHash = bytes.getInt32(i);
				if (keyHash == testingHash) {
					var stringName = parent.storage.readString(bytes.getInt32(i + 4));
					if (stringName == key) {
						trace(key, bytes.toHex());
						return {
							address: MemoryPointer.fromInt(bytes.getInt32(i + 4 + POINTER_SIZE)),
							type: parent.storage.readString(bytes.getInt32(i + 4 + POINTER_SIZE * 2))
						}
					}
				}

				i += KEY_SIZE;
			}
			checkingScope = nextScope;
			elementCount = bytes.getUInt16(nextScope + 2);
			nextScope = nextScope - bytes.getUInt16(nextScope) * KEY_SIZE - 4;
		}

		throw 'Key $key does not exist.';
	}

	public function set(key:String, value:{?address:MemoryPointer, ?type:String}) {
		var keyHash = Murmur1.hash(ByteArray.from(key));

		var checkingScope = currentScopeStart;
		var elementCount = bytes.getUInt16(currentScopeStart + 2);
		var nextScope = currentScopeStart - bytes.getUInt16(currentScopeStart) * KEY_SIZE - 4;

		while (nextScope != 0) {
			var i = checkingScope;
			while (i < (checkingScope + elementCount * KEY_SIZE)) {
				var testingHash = bytes.getInt32(i);
				if (keyHash == testingHash) {
					var stringName = parent.storage.readString(bytes.getInt32(i + 4));
					if (stringName == key) {
						if (value.address != null) bytes.setInt32(i + 4 + POINTER_SIZE, value.address.rawLocation);
						if (value.type != null) bytes.setInt32(i + 4 + POINTER_SIZE * 2, parent.getTypeInformation(value.type).pointer.rawLocation);
					}
				}

				i += KEY_SIZE;
			}
			checkingScope = nextScope;
			elementCount = bytes.getUInt16(nextScope + 2);
			nextScope = nextScope - bytes.getUInt16(nextScope) * KEY_SIZE - 4;
		}

		throw 'Cannot set $key -  does not exist.';
	}

	public function exists(key:String):Bool {
		var keyHash = Murmur1.hash(ByteArray.from(key));

		var checkingScope = currentScopeStart;
		var elementCount = bytes.getUInt16(currentScopeStart + 2);
		var nextScope = currentScopeStart - bytes.getUInt16(currentScopeStart) * KEY_SIZE - 4;

		while (nextScope != 0) {
			var i = checkingScope;
			while (i < (checkingScope + elementCount * KEY_SIZE)) {
				var testingHash = bytes.getInt32(i);
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
		}

		return false;
	}

	public function keyValueIterator():KeyValueIterator<String, {address:MemoryPointer, type:String}> {

		var map = new Map<String, {address:MemoryPointer, type:String}>();

		var checkingScope = currentScopeStart;
		var elementCount = bytes.getUInt16(currentScopeStart + 2);
		var nextScope = currentScopeStart - bytes.getUInt16(currentScopeStart) * KEY_SIZE - 4;
		while (nextScope != 0) {
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
		}

		return map.keyValueIterator();
	}
}