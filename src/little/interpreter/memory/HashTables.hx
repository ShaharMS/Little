package little.interpreter.memory;

import little.interpreter.memory.MemoryPointer.POINTER_SIZE;
import haxe.Int64;
import haxe.io.Bytes;
import haxe.hash.Murmur1;
import vision.ds.ByteArray;

class HashTables {
    
    public static final OBJECT_HASH_TABLE_CELL_SIZE:Int = POINTER_SIZE * 4; 

    /**
        Returns a hash table for the given key-value-type pairs.

        Each hash-table value will be 3 pointers, first to the name 
        of the field, second to the value, and third to the type of the field.

        The hash-table's size is pre-estimated, and should provide a hash table
        with 0.5 size-to-store ratio.

        @param pairs an array of key-value-type triples 
    **/
    public static function generateObjectHashTable(pairs:Array<{key:String, keyPointer:MemoryPointer, value:MemoryPointer, type:MemoryPointer, doc:MemoryPointer}>) {
        var initialLength = (pairs.length > 1 ? pairs.length : 5) * OBJECT_HASH_TABLE_CELL_SIZE * 3; 
        // a memory pointer is 8 bytes, 3 pointers is `OBJECT_HASH_TABLE_CELL_SIZE` bytes
        // We triple the memory for a nice size-to-store ratio (0.33)

        var array = new ByteArray(initialLength);

        for (pair in pairs) {
            var keyHash = Murmur1.hash(Bytes.ofString(pair.key));
            // Since the array is `OBJECT_HASH_TABLE_CELL_SIZE` bytes per entry, We need to assure that keyIndex is divisible by `OBJECT_HASH_TABLE_CELL_SIZE`
            // What the following line does is assure the value doesn't overflow and wrap around to the negative.
            // Basically, increase the ceiling, multiply by `OBJECT_HASH_TABLE_CELL_SIZE`, take the remainder, and re-reduce the ceiling.
            var khI64 = Int64.make(0, keyHash);
            var keyIndex = ((khI64 * OBJECT_HASH_TABLE_CELL_SIZE) % array.length).low;

            if (array.getInt32(keyIndex) == 0) { // Always ok, on existing cells the first value cant be 0 because it represents `null`, and `null` fields are not creatable.
                array.setInt32(keyIndex, pair.keyPointer.rawLocation);
                array.setInt32(keyIndex + POINTER_SIZE, pair.value.rawLocation);
                array.setInt32(keyIndex + POINTER_SIZE * 2, pair.type.rawLocation);
                array.setInt32(keyIndex + POINTER_SIZE * 3, pair.doc.rawLocation);
            } else {
                // To handle collisions, we will basically move on until we find an empty slot
                // Then, fill it with the new key-value-type triplet
                var incrementation = 0;
                var i = keyIndex;
                while (array.getInt32(i) != 0) {
                    i += OBJECT_HASH_TABLE_CELL_SIZE;
                    incrementation += OBJECT_HASH_TABLE_CELL_SIZE;
                    if (i >= array.length) {
                        i = 0;
                    }
                    if (incrementation >= array.length) {
                        throw 'Object hash table did not generate. This should never happen. Initial length may be incorrect.';
                    }
                }
                array.setInt32(i, pair.keyPointer.rawLocation);
                array.setInt32(i + POINTER_SIZE, pair.value.rawLocation);
                array.setInt32(i + POINTER_SIZE * 2, pair.type.rawLocation);
                array.setInt32(i + POINTER_SIZE * 3, pair.doc.rawLocation);
            }
        }

        return array;
    }

    /**
        Reads an object hash table, optionally provides key names when the storage is given.    
    
        @param bytes the hash table's bytes
        @param storage the storage, if key names are needed. When not provided, key names are `null`.
        @return the hash table as an array.
    **/
    public static function readObjectHashTable(bytes:ByteArray, ?storage:Storage):Array<{key:Null<String>, keyPointer:MemoryPointer, value:MemoryPointer, type:MemoryPointer, doc:MemoryPointer}> {
        var arr = [];

        var i = 0;
        while (i < bytes.length) {
            var keyPointer:MemoryPointer = bytes.getInt32(i);
            var value:MemoryPointer = bytes.getInt32(i + POINTER_SIZE);
            var type:MemoryPointer = bytes.getInt32(i + POINTER_SIZE * 2);
            var doc:MemoryPointer = bytes.getInt32(i + POINTER_SIZE * 3);
            var key = null;

            if (keyPointer.rawLocation == 0) {
                i += OBJECT_HASH_TABLE_CELL_SIZE;
                continue; // Nothing to do here
            }
            if (storage != null) {
                key = storage.readString(keyPointer);
            }

            arr.push({
                key: key,
                keyPointer: keyPointer, 
                value: value, 
                type: type,
                doc: doc
            });
            i += OBJECT_HASH_TABLE_CELL_SIZE;
        }

        return arr;
    }

    /**
    	Whether a given key exists in a hash table.
    	@param hashTable The bytes of the hash table, generated using the `HashTables` class
    	@param key The key to check
    	@param storage Must be provided in order to actually access the key values in the hash table
    	@return `true` if the key exists, `false` otherwise
    **/
    public static function hashTableHasKey(hashTable:ByteArray, key:String, storage:Storage):Bool {
        var keyHash = Murmur1.hash(Bytes.ofString(key));

        var khI64 = Int64.make(0, keyHash);

        var keyIndex = ((khI64 * OBJECT_HASH_TABLE_CELL_SIZE) % hashTable.length).low;
        var incrementation = 0;
        while (true) {
            var currentKey = storage.readString(hashTable.getInt32(keyIndex));
            if (currentKey == key) {
                return true;
            }
            keyIndex += OBJECT_HASH_TABLE_CELL_SIZE;
            incrementation++;
            if (keyIndex >= hashTable.length) {
                keyIndex = 0;
            }
            if (incrementation >= hashTable.length) {
                return false;
            }
        } 
    }

    /**
		Looks up a key in a hash table.

    	@param hashTable The bytes of the hash table, generated using the `HashTables` class
    	@param key The key to check
    	@param storage Must be provided in order to actually access the keys in the hash table
    **/
    public static function hashTableGetKey(hashTable:ByteArray, key:String, storage:Storage):{key:String, keyPointer:MemoryPointer, value:MemoryPointer, type:MemoryPointer, doc:MemoryPointer} {
        var keyHash = Murmur1.hash(Bytes.ofString(key));

        var khI64 = Int64.make(0, keyHash);

        var keyIndex = ((khI64 * OBJECT_HASH_TABLE_CELL_SIZE) % hashTable.length).low;

        var incrementation = 0;
        while (true) {
            var currentKey = storage.readString(hashTable.getInt32(keyIndex));
            if (currentKey == key) {
                return {
                    key: key,
                    keyPointer: hashTable.getInt32(keyIndex),
                    value: hashTable.getInt32(keyIndex + POINTER_SIZE),
                    type: hashTable.getInt32(keyIndex + POINTER_SIZE * 2),
                    doc: hashTable.getInt32(keyIndex + POINTER_SIZE * 3)
                }
            }

            keyIndex += OBJECT_HASH_TABLE_CELL_SIZE;
            incrementation += OBJECT_HASH_TABLE_CELL_SIZE;
            if (keyIndex >= hashTable.length) {
                keyIndex = 0;
            }
            if (incrementation >= hashTable.length) {
                throw 'Key $key not found in hash table';
            }

        }

        throw 'How did you get here? 4';
    }

    /**
    	Directly accesses a specific object's memory, and adds a key-value "pair" to it's hash table.

		If the hash table is too full (70% of its size is occupied), the hash table will be rehashed with the new key, and it's size will increase.

    	@param object A pointer to an object 
    	@param key The key to add
    	@param value The key's value
    	@param type The key's type
    	@param doc The key's documentation
    	@param storage Must be provided in order to access the object.
    **/
    public static function objectAddKey(object:MemoryPointer, key:String, value:MemoryPointer, type:MemoryPointer, doc:MemoryPointer, storage:Storage) {
        var hashTableBytes = storage.readBytes(storage.readPointer(object.rawLocation + POINTER_SIZE), storage.readInt32(object.rawLocation));
        var table = HashTables.readObjectHashTable(hashTableBytes, storage);

        // Fresh objects have 0.33 size-to-fill ratio, so usually we would just need to hash and add a key.
        // In case the size-to-fill ration is grater that 0,7, we will need to rehash everything and add the key

        var tableSize = hashTableBytes.length;
        var occupied = table.length * OBJECT_HASH_TABLE_CELL_SIZE;

        if (occupied / tableSize >= 0.7) {
            // Rehash with the the key:
            table.push({
                key: key,
                keyPointer: storage.storeString(key),
                value: value,
                type: type,
                doc: doc
            });


            var newHashTable = HashTables.generateObjectHashTable(table);
            // Free the old hash table:
            storage.freeBytes(storage.readPointer(object.rawLocation + POINTER_SIZE), hashTableBytes.length);
            // Store the new one, retrieve the pointer to it:
            var tablePointer = storage.storeBytes(newHashTable.length, newHashTable);
            // Update the object's hash table pointer:
            storage.setPointer(object.rawLocation + 4, tablePointer);
            // Don't forget, the table length also needs to be replaced
            storage.setInt32(object.rawLocation, newHashTable.length); 
            return; // The object was rehashed, the given pointer is still valid and all fields are good. Done here.
        }

        var hashTablePosition = storage.readPointer(object.rawLocation + 4);

        var keyHash = Murmur1.hash(Bytes.ofString(key));
        var khI64 = Int64.make(0, keyHash);

        var keyIndex = ((khI64 * OBJECT_HASH_TABLE_CELL_SIZE) % hashTableBytes.length).low;

        var incrementation = 0;

        while (true) {
            if (hashTableBytes.getInt32(keyIndex) == 0) {
                storage.setPointer(hashTablePosition.rawLocation + keyIndex, storage.storeString(key).rawLocation);
                storage.setPointer(hashTablePosition.rawLocation + keyIndex + POINTER_SIZE, value.rawLocation);
                storage.setPointer(hashTablePosition.rawLocation + keyIndex + POINTER_SIZE * 2, type.rawLocation);
                storage.setPointer(hashTablePosition.rawLocation + keyIndex + POINTER_SIZE * 3, doc.rawLocation);
                return;
            }
            keyIndex += OBJECT_HASH_TABLE_CELL_SIZE;
            incrementation += OBJECT_HASH_TABLE_CELL_SIZE;
            if (keyIndex >= tableSize) {
                keyIndex = 0;
            }
            if (incrementation >= tableSize) {
                throw "How did you get here? 6";
            }
        }
        
    }

    /**
		Directly accesses a specific object's memory, and sets a key-value "pair" to it's hash table.

    	@param object A pointer to an object 
    	@param key The key to add
    	@param pair The key's value. Has 3 fields: value, type, doc. if a property is null, it will not modify that specific existing value of the key-value "pair"
    	@param storage Must be provided in order to access the object.
    **/
    public static function objectSetKey(object:MemoryPointer, key:String, pair:{?value:MemoryPointer, ?type:MemoryPointer, ?doc:MemoryPointer}, storage:Storage) {
        var hashTableBytesLength = storage.readInt32(object.rawLocation);
        var hashTablePosition = storage.readPointer(object.rawLocation + 4);

        var keyHash = Murmur1.hash(Bytes.ofString(key));
        var khI64 = Int64.make(0, keyHash);
		
        var keyIndex = ((khI64 * OBJECT_HASH_TABLE_CELL_SIZE) % hashTableBytesLength).low;

        var incrementation = 0;
        while (true) {
            var currentKey = storage.readString(storage.readPointer(hashTablePosition.rawLocation + keyIndex));
            if (currentKey == key) {
                if (pair.value != null)
                    storage.setInt32(hashTablePosition.rawLocation + keyIndex + POINTER_SIZE, pair.value.rawLocation);
                if (pair.type != null)
                    storage.setInt32(hashTablePosition.rawLocation + keyIndex + POINTER_SIZE * 2, pair.type.rawLocation);
                if (pair.doc != null)
                    storage.setInt32(hashTablePosition.rawLocation + keyIndex + POINTER_SIZE * 3, pair.doc.rawLocation);

                return;
            }

            keyIndex += OBJECT_HASH_TABLE_CELL_SIZE;
            incrementation += OBJECT_HASH_TABLE_CELL_SIZE;
            if (keyIndex >= hashTableBytesLength) {
                keyIndex = 0;
            }
            if (incrementation >= hashTableBytesLength) {
                throw "Cannot set a non-existing key in the object's hash table.";
            }
        }
        
    }

    /**
		Looks up a key in an object's hash table using only the object's pointer.

    	@param object A pointer to an object
    	@param key The key to look up
    	@param storage Must be provided in order to access the object.
    **/
    public static function objectGetKey(object:MemoryPointer, key:String, storage:Storage):{key:String, keyPointer:MemoryPointer, value:MemoryPointer, type:MemoryPointer, doc:MemoryPointer} {
        var hashTableBytes = storage.readBytes(storage.readPointer(object.rawLocation + POINTER_SIZE), storage.readInt32(object.rawLocation));
        return hashTableGetKey(hashTableBytes, key, storage);
    }

	/**
		Retrieves the hash table of an object, as an array of bytes.
		@param objectPointer A pointer to an object
		@param storage Must be provided in order to access the object.
	**/
	public static function getHashTableOf(objectPointer:MemoryPointer, storage:Storage):ByteArray {
		var bytesLength = storage.readInt32(objectPointer.rawLocation);
		var bytesPointer = storage.readPointer(objectPointer.rawLocation + 4);
		return storage.readBytes(bytesPointer, bytesLength);
	}
}