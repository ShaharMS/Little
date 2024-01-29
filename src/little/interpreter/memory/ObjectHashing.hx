package little.interpreter.memory;

import haxe.Int64;
import haxe.io.Bytes;
import haxe.hash.Murmur1;
import vision.ds.ByteArray;

class ObjectHashing {
    
    public static final CELL_SIZE:Int = 24; 

    /**
        Returns a hash table for the given key-value-type pairs.

        Each hash-table value will be 3 pointers, first to the name 
        of the field, second to the value, and third to the type of the field.

        The hash-table's size is pre-estimated, and should provide a hash table
        with 0.5 size-to-store ratio.

        @param pairs an array of key-value-type triples 
    **/
    public static function generateObjectHashTable(pairs:Array<{key:String, keyPointer:MemoryPointer, value:MemoryPointer, type:MemoryPointer}>) {
        var initialLength = pairs.length * CELL_SIZE * 3; 
        // a memory pointer is 8 bytes, 3 pointers is `CELL_SIZE` bytes
        // We double the memory for a nice size-to-store ratio (0.5)

        var array = new ByteArray(initialLength);

        for (pair in pairs) {
            var keyHash = Murmur1.hash(Bytes.ofString(pair.key));
            // Since the array is `CELL_SIZE` bytes per entry, We need to assure that keyIndex is divisible by `CELL_SIZE`
            // What the following line does is assure the value doesn't overflow and wrap around to the negative.
            // Basically, increase the ceiling, multiply by `CELL_SIZE`, take the remainder, and re-reduce the ceiling.
            // Also, we need to make sure that the keyIndex is not negative, since the hash may very well be.
            // THis is done by just adding the 32bit signed int limit, so -1 becomes 2.147b + 1.
            var khI64 = Int64.make(0, keyHash);
            if (keyHash < 0) {
                khI64 = 2_147_483_647; // 32bit signed int limit
                khI64 += -keyHash;
            }
            var keyIndex = ((khI64 * CELL_SIZE) % array.length).low;

            if (array.getInt32(keyIndex) == 0) {
                array.setInt32(keyIndex, pair.keyPointer.rawLocation);
                array.setInt32(keyIndex + 8, pair.value.rawLocation);
                array.setInt32(keyIndex + 16, pair.type.rawLocation);
                // trace('key ${pair.key} stored at ${keyIndex}');
            } else {
                // To handle collisions, we will basically move on until we find an empty slot
                // Then, fill it with the new key-value-type triplet
                // trace ('key ${pair.key} collided at ${keyIndex}');
                var incrementation = 0; // Todo - revisit
                var i = keyIndex;
                while (array.getInt32(i) != 0) {
                    i += CELL_SIZE;
                    incrementation += CELL_SIZE;
                    if (i >= array.length) {
                        i = 0;
                    }
                    if (incrementation >= array.length) {
                        throw 'Object hash table did not generate. This should never happen. Initial length may be incorrect.';
                    }
                }
                array.setInt32(i, pair.keyPointer.rawLocation);
                array.setInt32(i + 8, pair.value.rawLocation);
                array.setInt32(i + 16, pair.type.rawLocation);
                // trace ('key ${pair.key} stored at ${i}');
            }
        }

        return array;
    }

    /**
        Reads an object hash table, optionally provides key names when the heap is given.    
    
        @param bytes the hash table's bytes
        @param heap the heap, if key names are needed. When not provided, key names are `null`.
        @return the hash table as an array.
    **/
    public static function readObjectHashTable(bytes:ByteArray, ?heap:Heap):Array<{key:Null<String>, keyPointer:MemoryPointer, value:MemoryPointer, type:MemoryPointer}> {
        var arr = [];

        var i = 0;
        while (i < bytes.length) {
            var keyPointer = MemoryPointer.fromInt(bytes.getInt32(i));
            var value = MemoryPointer.fromInt(bytes.getInt32(i + 8));
            var type = MemoryPointer.fromInt(bytes.getInt32(i + 16));
            var key = null;

            if (keyPointer.rawLocation == 0) {
                i += CELL_SIZE;
                continue; // Nothing to do here
            }
            if (heap != null) {
                key = heap.readString(keyPointer);
            }

            arr.push({
                key: key,
                keyPointer: keyPointer, 
                value: value, 
                type: type
            });

            i += CELL_SIZE;
        }

        return arr;
    }

    public static function hashTableHasKey(hashTable:ByteArray, key:String, heap:Heap):Bool {
        var keyHash = Murmur1.hash(Bytes.ofString(key));

        var khI64 = Int64.make(0, keyHash);
        if (keyHash < 0) {
            khI64 = 2_147_483_647; // 32bit signed int limit
            khI64 += -keyHash;
        }

        var keyIndex = (khI64 * CELL_SIZE % hashTable.length).low;
        var incrementation = 0;
        while (true) {
            var currentKey = heap.readString(keyIndex);
            if (currentKey == key) {
                return true;
            }
            keyIndex += CELL_SIZE;
            incrementation++;
            if (keyIndex >= hashTable.length) {
                keyIndex = 0;
            }
            if (incrementation >= hashTable.length) {
                return false;
            }
        } 
    }

    public static function hashTableGetKey(hashTable:ByteArray, key:String, heap:Heap):{key:String, keyPointer:MemoryPointer, value:MemoryPointer, type:MemoryPointer} {
        var keyHash = Murmur1.hash(Bytes.ofString(key));

        var keyIndex = (Int64.mul(keyHash, CELL_SIZE) % hashTable.length).low;

        var incrementation = 0;
        while (true) {
            var currentKey = heap.readString(keyIndex);
            if (currentKey == key) {
                return {
                    key: key,
                    keyPointer: MemoryPointer.fromInt(keyIndex),
                    value: MemoryPointer.fromInt(keyIndex + 8),
                    type: MemoryPointer.fromInt(keyIndex + 16)
                }
            }

            keyIndex += CELL_SIZE;
            incrementation += CELL_SIZE;
            if (keyIndex >= hashTable.length) {
                keyIndex = 0;
            }
            if (incrementation >= hashTable.length) {
                throw 'Key $key not found in hash table';
            }

        }

        throw 'How did you get here? 4';
    }

    public static function objectAddKey(object:MemoryPointer, key:String, value:MemoryPointer, type:MemoryPointer, heap:Heap) {
        var hashTableBytes = heap.readBytes(heap.readPointer(object.rawLocation + 4), heap.readInt32(object.rawLocation));
        var table = ObjectHashing.readObjectHashTable(hashTableBytes, heap);

        // Fresh objects have 0.33 size-to-fill ratio, so usually we would just need to hash and add a key.
        // In case the size-to-fill ration is grater that 0,7, we will need to rehash everything and add the key

        var tableSize = hashTableBytes.length;
        var occupied = table.length * CELL_SIZE;

        if (occupied / tableSize >= 0.7) {
            // Rehash with the the key:
            table.push({
                key: key,
                keyPointer: heap.storeString(key),
                value: value,
                type: type
            });
            var newHashTable = ObjectHashing.generateObjectHashTable(table);
            // Free the old hash table:
            heap.freeBytes(heap.readPointer(object.rawLocation + 4), hashTableBytes.length);
            // Store the new one, retrieve the pointer to it:
            var tablePointer = heap.storeBytes(newHashTable.length, newHashTable);
            // Update the object's hash table pointer:
            heap.setPointer(object.rawLocation + 4, tablePointer);
            // Don't forget, the table length also needs to be replaced
            heap.setInt32(object.rawLocation, newHashTable.length); 
            return; // The object was rehashed, the given pointer is still valid and all fields are good. Done here.
        }

        var hashTablePosition = heap.readPointer(object.rawLocation + 4);

        var keyHash = Murmur1.hash(Bytes.ofString(key));
        var khI64 = Int64.make(0, keyHash);
        if (keyHash < 0) {
            khI64 = 2_147_483_647;
            khI64 += -keyHash;
        }
        var keyIndex = (Int64.mul(khI64, CELL_SIZE) % tableSize).low;

        var incrementation = 0;

        while (true) {
            if (hashTableBytes.getInt32(keyIndex) == 0) {
                heap.setInt32(hashTablePosition.rawLocation + keyIndex, heap.storeString(key).rawLocation);
                heap.setInt32(hashTablePosition.rawLocation + keyIndex + 8, value.rawLocation);
                heap.setInt32(hashTablePosition.rawLocation + keyIndex + 16, type.rawLocation);
                return;
            }
            keyIndex += CELL_SIZE;
            incrementation += CELL_SIZE;
            if (keyIndex >= tableSize) {
                keyIndex = 0;
            }
            if (incrementation >= tableSize) {
                throw "How did you get here? 6";
            }
        }
        
    }

    public static function objectSetKey(object:MemoryPointer, key:String, pair:{value:MemoryPointer, type:MemoryPointer}, heap:Heap) {
        var hashTableBytes = heap.readBytes(heap.readPointer(object.rawLocation + 4), heap.readInt32(object.rawLocation));
        var hashTablePosition = heap.readPointer(object.rawLocation + 4);
        var keyHash = Murmur1.hash(Bytes.ofString(key));
        var khI64 = Int64.make(0, keyHash);
        if (keyHash < 0) {
            khI64 = 2_147_483_647;
            khI64 += -keyHash;
        }
        var keyIndex = (Int64.mul(khI64, CELL_SIZE) % hashTableBytes.length).low;

        var incrementation = 0;
        while (true) {
            var currentKey = heap.readString(heap.readPointer(hashTablePosition.rawLocation + keyIndex));
            if (currentKey == key) {
                if (pair.value != null)
                    heap.setInt32(hashTablePosition.rawLocation + keyIndex + 8, pair.value.rawLocation);
                if (pair.type != null)
                    heap.setInt32(hashTablePosition.rawLocation + keyIndex + 16, pair.type.rawLocation);
            }

            keyIndex += CELL_SIZE;
            incrementation += CELL_SIZE;
            if (keyIndex >= hashTableBytes.length) {
                keyIndex = 0;
            }
            if (incrementation >= hashTableBytes.length) {
                throw "How did you get here? 7";
            }
        }
        
    }
}