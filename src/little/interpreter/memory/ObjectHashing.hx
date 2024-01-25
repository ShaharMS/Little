package little.interpreter.memory;

import haxe.Int64;
import haxe.io.Bytes;
import haxe.hash.Murmur1;
import vision.ds.ByteArray;

class ObjectHashing {
    
    /**
        Returns a hash table for the given key-value-type pairs.

        Each hash-table value will be 3 pointers, first to the name 
        of the field, second to the value, and third to the type of the field.

        The hash-table's size is pre-estimated, and should provide a hash table
        with 0.5 size-to-store ratio.

        @param pairs an array of key-value-type triples 
    **/
    public static function generateObjectHashTable(pairs:Array<{key:String, keyPointer:MemoryPointer, value:MemoryPointer, type:MemoryPointer}>) {
        var initialLength = pairs.length * 3 * 8 * 2; 
        // a memory pointer is 8 bytes, 3 pointers is 24 bytes
        // We double the memory for a reasonal size-to-store ratio (0.5)

        var array = new ByteArray(initialLength);

        for (pair in pairs) {
            var keyHash = Murmur1.hash(Bytes.ofString(pair.key));
            // Since the array is 24 bytes per entry, We need to assure that keyIndex is divisible by 24
            var keyIndex = (Int64.mul(keyHash, 24) % array.length).low;

            if (array.getDouble(keyIndex) == 0) {
                array.setDouble(keyIndex, pair.keyPointer.rawLocation);
                array.setDouble(keyIndex + 8, pair.value.rawLocation);
                array.setDouble(keyIndex + 16, pair.type.rawLocation);
            } else {
                // To handle collisions, we will basically move on until we find an empty slot
                // Then, fill it with the new key-value-type triplet

                var originalKeyIndex = keyIndex;
                var i = keyIndex + 24;
                while (array.getDouble(i) != 0) {
                    i += 24;
                    if (i >= array.length) {
                        i = 0;
                    }
                    if (i == originalKeyIndex) {
                        throw 'Object hash table did not generate. This should never happen. Initial length may be incorrect.';
                    }
                }
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
            if (heap != null) {
                var key = heap.readString(keyPointer);
            }
            arr.push({
                key: key,
                keyPointer: keyPointer, 
                value: value, 
                type: type
            });
        }

        return arr;
    }
}