package little.interpreter.memory.storage;

import vision.tools.MathTools;
import vision.ds.ByteArray;

/**
    Values in the heap must have 5 bytes of data before each item:
	 - Bytes 0-4: The item's length, not including the 5-byte header.
	 - Byte 5: Whether this memory is in use or not.
	
	The headers purpose is in easier memory allocation & freeing:

	 - **When looking to store something, we start at the first byte, and read its header. If its taken, we jump it's length bytes, and try again.**
	 	- The heap always starts with, and ends with a header. The last header has no length, and is not taken.
	 - **When actually storing something, There are two cases:**
	    1. Were storing it in a larger amount of freed data, when `large_amount > size + header`:
		  	- We first change the header's length to the new object, but keep its old value
		  	- We set it as used memory
		  	- We than append the new object with a new header, with the remaining length, and set as not used
	    2. Were storing it at the end of the heap:
		  	- We change the header's length attribute from `0` to the new object's size
		  	- We set it as used memory
	 - **When freeing something, we only denote in the header that the following memory is not used.**
**/
class Heap {
    
    var parent:Memory;

    var bytes:ByteArray;

    /**
        Creates a heap. The heap works in a buddy-blocks-like method, so the first 5 bytes are always a header.
        @param memory 
    **/
    public function new(memory:Memory) {
        bytes = new ByteArray(memory.memoryChunkSize);
        
        // No need to set a header:
        // When a header isn't set, or a function encounters the end of the heap, 
        // it can just calculate the remaining space, and assume it's unused.
    }

    public function requestMemory() {
        if (bytes.length > parent.maxMemorySize) {
			Little.runtime.throwError(ErrorMessage('Out of memory'), MEMORY_HEAP);
		}
		var size = MathTools.min(bytes.length + parent.memoryChunkSize, parent.maxMemorySize);
		var delta = size - bytes.length;
		bytes.resize(size);

        // We dont place/modify the last header, the function that calls this is responsible for that.
    }

    /**
        Reads a header at the given pointer.
    **/
    public function readHeader(pointer:MemoryPointer):HeapHeader {
        return {
            length: bytes.getInt32(pointer.rawLocation),
            used: bytes.get(pointer.rawLocation + 4) == 1
        }
    }

    /**
        Finds the first position in the heap that allows storage of `size` bytes,
        and returns its header. If the given size doesnt perfectly fit the header,
        another header is returned along-side, to place after the value. When it is null, it means
        one of 3 things:
         - The heap is full, and the function gave you space at the end of the heap, 
           and also generated one at the end, matching the size of your object
         - The given header is a perfect fit for your object size, in which case it just sets the header's used value to true
         - the given header is less than 5 bytes larger than your object size, in which case an extra header 
           doesn't fit/makes sense, so you get some extra bytes unknowingly. You shouldn't rely on there being extra bytes.
    **/
    public function requestSpace(size:Int):{pointer:MemoryPointer, ?nextHeader:HeapHeader} {
        var header:HeapHeader;
        var pointer = 0;
        do {
            header = readHeader(pointer);
            pointer += 5 + header.length;
        } while ((header.length == 0 && header.used == false) || (header.length >= size && header.used == false));

        if (header.length == 0) { // At the end of the heap
            //var remainingSpace = 
        }
    }
}

typedef HeapHeader = {length:Int, used:Bool};