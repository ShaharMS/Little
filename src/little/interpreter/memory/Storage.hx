package little.interpreter.memory;

import little.tools.OrderedMap;
import little.interpreter.memory.Memory.TypeInfo;
import haxe.hash.Murmur1;
import vision.tools.MathTools;
import haxe.display.Display.Module;
import little.interpreter.memory.MemoryPointer;
import haxe.Int64;
import haxe.ds.Either;
import haxe.exceptions.ArgumentException;
import little.interpreter.Tokens.InterpTokens;
import haxe.xml.Parser;
import haxe.io.Bytes;
import haxe.io.UInt8Array;
import vision.ds.ByteArray;


using little.tools.Extensions;


class Storage {

	public var parent:Memory;

	public var reserved:ByteArray;
	public var storage:ByteArray;

    /**
		Instantiates a new `Storage` 
    **/
    public function new(memory:Memory) {
        parent = memory;
		
		storage = new ByteArray(parent.memoryChunkSize);
		reserved = new ByteArray(parent.memoryChunkSize);
		reserved.fill(0, parent.memoryChunkSize, 0);

    }
	
	/**
		Requests more memory if needed
	**/
	function requestMemory() {
		if (storage.length > parent.maxMemorySize) {
			trace(storage.length, parent.maxMemorySize);
			Little.runtime.throwError(ErrorMessage('Out of memory'), MEMORY_STORAGE);
		}
		storage.resize(storage.length + parent.memoryChunkSize);
		reserved.resize(reserved.length + parent.memoryChunkSize);
	}

    /**
        stores a byte to the storage
        @param b an 8-bit number
        @return A pointer to its address on the storage. The size of this "object" is `1`.
    **/
    public function storeByte(b:Int):MemoryPointer {
        if (b == 0) return parent.constants.ZERO;
        #if !static if (b == null) return parent.constants.NULL; #end

        // Find a free spot
        var i = parent.constants.capacity;
        while (i < reserved.length && reserved[i] != 0) i++;
        if (i >= reserved.length) requestMemory();
        storage[i] = b;
        reserved[i] = 1;

        return i;
    }

    /**
		stores a byte to the storage, at the given address. Can overwrite bytes at any address.
    	@param address The address to store the byte
    	@param b an 8-bit number
    **/
    public function setByte(address:MemoryPointer, b:Int) {
        storage[address.rawLocation] = b;
        reserved[address.rawLocation] = 1;
    }

    /**
        Reads a byte from the storage
        @param address The address of the byte to read
        @return The byte
    **/
    public function readByte(address:MemoryPointer):Int {
        return storage[address.rawLocation];
    }

    /**
        Frees a byte from the storage
        @param address The address of the byte to remove
    **/
    public function freeByte(address:MemoryPointer) {
        storage[address.rawLocation] = 0;
        reserved[address.rawLocation] = 0;
    }

    /**
		Stores an array of bytes.
    	@param size The number of bytes to store
    	@param b An optional array of bytes
    	@return The address of the first byte
    **/
    public function storeBytes(size:Int, ?b:ByteArray):MemoryPointer {
        var i = parent.constants.capacity;
		
        while (i < reserved.length - size && !reserved.getBytes(i, size).isEmpty()) i++;
		if (i >= reserved.length - size) {
            requestMemory();
            i += size; // Will leave some empty space, Todo.
			while (i + size > reserved.length) requestMemory();
        }

        for (j in 0...size) {
            storage[i + j] = j > b.length ? 0 : b[j];
            reserved[i + j] = 1;
        }

        return i;
    }

    /**
    	Sets an array of bytes at the given address. Can overwrite bytes at any address.
    	@param address The address to store the bytes at
    	@param bytes An array of bytes to write
    **/
    public function setBytes(address:MemoryPointer, bytes:ByteArray) {
        for (j in 0...bytes.length) {
            storage[address.rawLocation + j] = bytes[j];
            reserved[address.rawLocation + j] = 1;
        }
    }

    /**
		Reads an array of bytes from the storage.
    	@param address The address of the first byte
    	@param size The number of bytes to read
    	@return The resulting byte array
    **/
    public function readBytes(address:MemoryPointer, size:Int):ByteArray {
        if (address == parent.constants.NULL) return null;
        var bytes = new ByteArray(size);
        for (j in 0...size) {
            bytes[j] = storage[address.rawLocation + j];
        }

        return bytes;
    }

    /**
    	Frees an array of bytes from the storage, starting at the given address
    	@param address The address of the first byte
    	@param size The number of bytes to remove
    **/
    public function freeBytes(address:MemoryPointer, size:Int) {
        for (j in 0...size) {
            storage[address.rawLocation + j] = 0;
            reserved[address.rawLocation + j] = 0;
        }
    }

    /**
		Stores an array of elements of a specific size.

    	@param length The number of elements
    	@param elementSize The size of each element
    	@param defaultElement An optional default element to store at each index
		@return The address of the array.
    **/
    public function storeArray(length:Int, elementSize:Int, ?defaultElement:ByteArray):MemoryPointer {
        var size = elementSize * length;
        var bytes = new ByteArray(size + 4 + 4); // First 4 bytes are the length of the array, the other 4 bytes are for element size.
        if (defaultElement != null) {
            for (i in 0...length) {
                bytes.setBytes(i + 4, defaultElement);
            }
        }

        bytes.setInt32(0, length);
		bytes.setInt32(4, elementSize);

        return storeBytes(bytes.length, bytes);
    }

    /**
		Sets an array of elements of a specific size. Can overwrite bytes at any address.
    	@param address The address of the array
    	@param length The number of elements
    	@param elementSize The size of each element
    	@param defaultElement An optional default element to store at each index
    **/
    public function setArray(address:MemoryPointer, length:Int, elementSize:Int, ?defaultElement:ByteArray) {
        var size = elementSize * length;
        var bytes = new ByteArray(size + 4 + 4); // First 4 bytes are the length of the array, next 4 bytes are for element size.
        if (defaultElement != null) {
            for (i in 0...length) {
                bytes.setBytes(i + 8, defaultElement);
            }
        }

        bytes.setInt32(0, length);
        bytes.setInt32(4, elementSize);

        setBytes(address, bytes);
    }

    /**
		Reads an array of elements of a specific size.
    	@param address The address of the array
    	@return An array of elements, each element being an array of bytes.
    **/
    public function readArray(address:MemoryPointer):Array<ByteArray> {
        if (address == parent.constants.NULL) return null;
        var length = readInt32(address);
        var elementSize = readInt32(address.rawLocation + 4);
        address.rawLocation += 8;

        var array = [];

        for (i in 0...length) {
            array.push(readBytes(address, elementSize));
            address.rawLocation += elementSize;
        }

        return array;
    }

    /**
		Frees an array of elements.
    	@param address The address of the array
    **/
    public function freeArray(address:MemoryPointer) {
        var length = readInt32(address);
        var elementSize = readInt32(address.rawLocation + 4);
        freeBytes(address, length * elementSize + 8);
    }

    /**
		Stores a 16-bit integer.
    	@param b The 16-bit integer
    	@return The address of the integer
    **/
    public function storeInt16(b:Int):MemoryPointer {
        if (b == 0) return parent.constants.ZERO;
        #if !static if (b == null) return parent.constants.NULL; #end

        // Find a free spot
        var i = parent.constants.capacity;
        while (i < reserved.length - 1 && reserved[i] != 0 && reserved[i + 1] != 0) i++;
        if (i >= reserved.length - 1) {
            requestMemory();
            i += 2; // leaves empty byte Todo.
        }

        for (j in 0...1) {
            storage[i + j] = b & 0xFF;
            b = b >> 8;
            reserved[i + j] = 1;
        }

        return i;
    }

    /**
		Sets a 16-bit integer. Can overwrite bytes at any address.
    	@param address The address of the integer
    	@param b The 16-bit integer
    **/
    public function setInt16(address:MemoryPointer, b:Int) {
        storage[address.rawLocation] = b & 0xFF;
        storage[address.rawLocation + 1] = (b >> 8) & 0xFF;
        reserved[address.rawLocation] = 1;
        reserved[address.rawLocation + 1] = 1;
    }

    /**
		Reads a 16-bit integer.
    	@param address The address of the integer
    	@return The 16-bit integer as a 32 bit haxe integer
    **/
    public function readInt16(address:MemoryPointer):Int {
        if (address == parent.constants.NULL) return #if static 0 #else null #end;
        // Dont forget to make the number negative if needed.
        return (storage[address.rawLocation] + (storage[address.rawLocation + 1] << 8)) - 32767;
        
    }

    /**
		Frees a 16-bit integer.
    	@param address The address of the integer
    **/
    public function freeInt16(address:MemoryPointer) {
		storage[address.rawLocation] = 0;
		storage[address.rawLocation + 1] = 0;
        reserved[address.rawLocation] = 0;
        reserved[address.rawLocation + 1] = 0;
    } 

    /**
		Stores an unsigned 16-bit integer.
    	@param b  The unsigned 16-bit integer as a 32 bit haxe integer
    	@return The address of the integer
    **/
    public function storeUInt16(b:Int):MemoryPointer {
        return storeInt16(b < 0 ? b + 32767 : b);
    }

    /**
		Sets an unsigned 16-bit integer. Can overwrite bytes at any address.
    	@param address The address of the integer
    	@param b The unsigned 16-bit integer
    **/
    public function setUInt16(address:MemoryPointer, b:Int) {
        setInt16(address, b < 0 ? b + 32767 : b);
    }

    /**
		Reads an unsigned 16-bit integer.
    	@param address The address of the integer
    **/
    public function readUInt16(address:MemoryPointer) {
        if (address == parent.constants.NULL) return null;
        return (storage[address.rawLocation] + (storage[address.rawLocation + 1] << 8));
    }

    /**
		Frees an unsigned 16-bit integer.
    	@param address The address of the integer
    **/
    public function freeUInt16(address:MemoryPointer) {
        freeInt16(address);
    }

    /**
		Stores an 32-bit integer.
    	@param b The 32-bit integer
    	@return The address of the integer
    **/
    public function storeInt32(b:Int):MemoryPointer {
        if (b == 0) return parent.constants.ZERO;
        #if !static if (b == null) return parent.constants.NULL; #end

        // Find a free spot
        var i = parent.constants.capacity;
        while (i < reserved.length - 3 && reserved[i] + reserved[i + 1] + reserved[i + 2] + reserved[i + 3] != 0) i++;
        if (i >= reserved.length - 3) {
            requestMemory();
            i += 4; // leaves empty bytes Todo.
        }

        for (j in 0...4) {
            storage[i + j] = b & 0xFF;
            b = b >> 8;
            reserved[i + j] = 1;
        }

		return i;
    }

    /**
		Sets an 32-bit integer. Can overwrite bytes at any address.
    	@param address The address of the integer
    	@param b The 32-bit integer
    **/
    public function setInt32(address:MemoryPointer, b:Int) {
        storage[address.rawLocation] = b & 0xFF;
        storage[address.rawLocation + 1] = (b >> 8) & 0xFF;
        storage[address.rawLocation + 2] = (b >> 16) & 0xFF;
        storage[address.rawLocation + 3] = (b >> 24) & 0xFF;
        reserved[address.rawLocation] = 1;
        reserved[address.rawLocation + 1] = 1;
        reserved[address.rawLocation + 2] = 1;
        reserved[address.rawLocation + 3] = 1;
    }

	/**
		Reads an 32-bit integer.
		@param address The address of the integer
		@return The 32-bit integer
	**/
    public function readInt32(address:MemoryPointer):Int {
        if (address == parent.constants.NULL) return #if static 0 #else null #end;
        return (storage[address.rawLocation] + (storage[address.rawLocation + 1] << 8) + (storage[address.rawLocation + 2] << 16) + (storage[address.rawLocation + 3] << 24));
    }

	/**
		Frees an 32-bit integer.
		@param address The address of the integer
	**/
    public function freeInt32(address:MemoryPointer) {
        for (j in 0...4) {
            storage[address.rawLocation + j] = 0;
			reserved[address.rawLocation + j] = 0;
        }
    }

    /**
		Stores an unsigned 32-bit integer.
    	@param b The unsigned 32-bit integer
    	@return The address of the integer
    **/
    public function storeUInt32(b:UInt):MemoryPointer {
        return storeInt32(b);
    }

    /**
		Sets an unsigned 32-bit integer. Can overwrite bytes at any address.
    	@param address The address of the integer
    	@param b The unsigned 32-bit integer
    **/
    public function setUInt32(address:MemoryPointer, b:UInt) {
        setInt32(address, b);
    }

    /**
		Reads an unsigned 32-bit integer.
    	@param address The address of the integer
    	@return The unsigned 32-bit integer
    **/
    public function readUInt32(address:MemoryPointer):UInt {
        return readInt32(address);
    }

    /**
		Frees an unsigned 32-bit integer.
    	@param address The address of the integer
    **/
    public function freeUInt32(address:MemoryPointer) {
        freeInt32(address);
    }

    /**
		Stores a 64-bit floating point number.
    	@param b The 64-bit floating point number
    	@return The address of the floating point number
    **/
    public function storeDouble(b:Float):MemoryPointer {
        if (b == 0) return parent.constants.ZERO;
        #if !static if (b == null) return parent.constants.NULL; #end

        var i = parent.constants.capacity;
        while (i < reserved.length - 7 && 
            reserved[i] + reserved[i + 1] + reserved[i + 2] + reserved[i + 3] + 
            reserved[i + 4] + reserved[i + 5] + reserved[i + 6] + reserved[i + 7] != 0) i++;
        if (i >= reserved.length - 7) {
            requestMemory();
            i += 8; // leaves empty bytes Todo.
        }

        var bytes = Bytes.alloc(8);
		bytes.setDouble(0, b);
        for (j in 0...8) {
            storage[i + j] = bytes.get(j);
            reserved[i + j] = 1;
        }

        return i;
    }

    /**
		Sets a 64-bit floating point number. Can overwrite bytes at any address.
    	@param address The address of the floating point number
    	@param b The 64-bit floating point number
    **/
    public function setDouble(address:MemoryPointer, b:Float) {
        storage.setDouble(address.rawLocation, b);
        for (j in 0...8) {
            reserved[address.rawLocation + j] = 1;
        }
    }

    /**
		Reads a 64-bit floating point number.
    	@param address The address of the floating point number
    	@return The 64-bit floating point number
    **/
    public function readDouble(address:MemoryPointer):Float {
        if (address == parent.constants.NULL) return #if static 0.0 #else null #end;
        return storage.getDouble(address.rawLocation);
    }

    /**
		Frees a 64-bit floating point number.
    	@param address The address of the floating point number
    **/
    public function freeDouble(address:MemoryPointer) {
        for (j in 0...8) {
            storage[address.rawLocation + j] = 0;
			reserved[address.rawLocation + j] = 0;
        }
    }

	/**
		Stores a memory pointer.
		@param p The memory pointer to store
		@return the address at which the pointer is stored
	**/
	public function storePointer(p:MemoryPointer):MemoryPointer {
		return storeInt32(p.rawLocation); // Currently, only 32-bit pointers are supported because of the memory buffer
	}

    /**
		Sets a memory pointer. Can overwrite bytes at any address.
    	@param address The address of the memory pointer
    	@param p The memory pointer
    **/
    public function setPointer(address:MemoryPointer, p:MemoryPointer) {
        setInt32(address, p.rawLocation);
    }

	/**
		Reads a memory pointer.
		@param address The address of the memory pointer
		@return The memory pointer
	**/
	public function readPointer(address:MemoryPointer):MemoryPointer {
		return readInt32(address);
	}

	/**
		Frees a memory pointer.
		@param address The address of the memory pointer
	**/
	public function freePointer(address:MemoryPointer) {
		freeInt32(address);
	}

	/**
		Stores a string.
		@param b The string
		@return The address at which the string is stored
	**/
	public function storeString(b:String):MemoryPointer {
		if (b == "") return parent.constants.EMPTY_STRING;
		if (b == null) return parent.constants.NULL;

        // Convert the string into bytes
		var stringBytes = Bytes.ofString(b, UTF8);
		// In order to accurately keep track of the string, the first 4 bytes will be used to store the length *of the bytes*
		var bytes = ByteArray.from(stringBytes.length).concat(stringBytes);

		// Find a free spot. Keep in mind that string's characters in this context are UTF-8 encoded, so each character is 1 byte
		var i = parent.constants.capacity;
		
        while (i < reserved.length - bytes.length && !reserved.getBytes(i, bytes.length).isEmpty()) i++;
		if (i >= reserved.length - bytes.length) {
            requestMemory();
            i += bytes.length; // leaves empty bytes, intentional.
			while (i + bytes.length > reserved.length) requestMemory();
        }

		// Each character in this string should be UTF-8 encoded
		storage.setBytes(i, bytes);
        reserved.setBytes(i, new ByteArray(bytes.length, 1));

		return i;
	}

    /**
		Sets a string. Can overwrite bytes at any address.
    	@param address The address of the string
    	@param b The string
    **/
    public function setString(address:MemoryPointer, b:String) {
        // Gets a bit tricky, we need to change the string length too
        var stringBytes = Bytes.ofString(b, UTF8);
        var bytes = ByteArray.from(stringBytes.length).concat(stringBytes);
        for (j in 0...bytes.length) {
            storage[address.rawLocation + j] = bytes.get(j);
            reserved[address.rawLocation + j] = 1;
        }
    }

	/**
		Reads a string.
		@param address The address of the string
		@return The string
	**/
	public function readString(address:MemoryPointer):String {
        if (address == parent.constants.NULL) return null;
		var length = readInt32(address.rawLocation);
		return storage.getString(address.rawLocation + 4, length, UTF8);
	}

	/**
		Frees a string.
		@param address The address of the string
	**/
	public function freeString(address:MemoryPointer) {
		var len = storage.getInt32(address.rawLocation) + 4;
		for (j in 0...len) {
			storage[address.rawLocation + j] = 0;
			reserved[address.rawLocation + j] = 0;
		}
	}

    /**
		Stores a code block, which represents function code.
    	@param caller The code block
    	@return The address at which the code block is stored
    **/
    public function storeCodeBlock(caller:InterpTokens):MemoryPointer {
        switch caller {
            case Block(body, _): return storeString(ByteCode.compile(FunctionCode(new OrderedMap(), caller)));
            case FunctionCode(requiredParams, body): return storeString(ByteCode.compile(caller));
            case _: throw new ArgumentException("caller", '${caller} must be a code block');
        }
    }

    /**
		Sets a code block, which represents function code. Can overwrite bytes at any address.
    	@param address The address of the code block
    	@param caller The code block
    **/
    public function setCodeBlock(address:MemoryPointer, caller:InterpTokens) {
        switch caller {
            case Block(body, _): 
                setString(address, ByteCode.compile(FunctionCode(new OrderedMap(), caller)));
            case FunctionCode(requiredParams, body): 
                setString(address, ByteCode.compile(caller));
            case _: throw new ArgumentException("caller", '${caller} must be a code block');
        }
    }

    /**
		Reads a code block, which represents function code.
    	@param address The address of the code block
    	@return The code block
    **/
    public function readCodeBlock(address:MemoryPointer):InterpTokens {
        return ByteCode.decompile(readString(address.rawLocation))[0];
    }

	/**
	    Frees a function value.
        @param address The address of the function value
	**/
    public function freeCodeBlock(address:MemoryPointer) {
        freeString(address);
    }

	/**
		Stores a condition code, which represents a condition.
		@param caller The condition
		@return The address at which the condition is stored
	**/
	public function storeCondition(caller:InterpTokens):MemoryPointer {
        switch caller {
            case ConditionCode(_): return storeString(ByteCode.compile(caller));
            case _: throw new ArgumentException("caller", '${caller} must be a token of type ${ConditionCode(null).getName()}');
        }
    }

    /**
		Sets a condition code, which represents a condition. Can overwrite bytes at any address.
    	@param address The address of the condition
    	@param caller The condition
    **/
    public function setCondition(address:MemoryPointer, caller:InterpTokens) {
        switch caller {
            case ConditionCode(_):
                setString(address, ByteCode.compile(caller));
            case _: throw new ArgumentException("caller", '${caller} must be a token of type ${ConditionCode(null).getName()}');
        }
    }

    /**
		Reads a `ConditionCode`, which represents a condition.
    	@param address The address of the condition
    	@return The condition
    **/
    public function readCondition(address:MemoryPointer):InterpTokens {
        return ByteCode.decompile(readString(address.rawLocation))[0];
    }

    /**
		Frees a condition code.
    	@param address The address of the condition
    **/
    public function freeCondition(address:MemoryPointer) {
        freeString(address);
    }

    /**
		Stores an operator.
    	@param sign The operator
    **/
    public function storeSign(sign:String) {
        return storeString(sign);
    }

    /**
		Sets an operator. Can overwrite bytes at any address.
    	@param address The address of the operator
    	@param sign The operator
    **/
    public function setSign(address:MemoryPointer, sign:String) {
        setString(address, sign);
    }

    /**
		Reads an operator.
    	@param address The address of the operator
    	@return The operator
    **/
    public function readSign(address:MemoryPointer):InterpTokens {
        if (address == parent.constants.NULL) return null;
        return Sign(readString(address));
    }

    /**
		Frees an operator.
    	@param address The address of the operator
    **/
    public function freeSign(address:MemoryPointer) {
        freeString(address);
    }

	/**
		A helper function that stores tokens of a static length in memory, and strings.
		@param token The token
		@return The address at which the token is stored
	**/
	public function storeStatic(token:InterpTokens):MemoryPointer {
		switch token {
			case NullValue | TrueValue | FalseValue: return parent.constants.get(token);
			case Number(num): return storeInt32(num);
			case Decimal(num): return storeDouble(num);
			case Characters(string): return storeString(string);
            case Sign(sign): return storeSign(sign);
			case ClassPointer(pointer): return pointer;
            case _: throw new ArgumentException("token", '${token} cannot be statically stored to the storage');
		}
	}


    /**
		Stores an object using 3 parts:
		
		- POINTER_SIZE + 4 Bytes directly at the site of storage, including:
		  - Byte 0 to 4: The length of the object's hashtable
		  - Byte 4 to POINTER_SIZE + 4: A pointer to the object's hashtable
		- The object's hashtable, at another location. The hashtable can be moved around, and when this
		  is done, the data at the object's address changes.
		
    **/
    public function storeObject(object:InterpTokens):MemoryPointer {
		if (object.is(NULL_VALUE)) return parent.constants.NULL;
        if (!object.is(OBJECT)) throw new ArgumentException("object", '${object} is not a dynamic object');
        
		/*
			We will do the same thing that python does, but simpler.
            
            Simply put, store everything in a hash-table that contains all object properties.
            that hash table will be stored as a pointer, for easy replacement when needed.
		*/

		switch object {
			case Object(props, typeName): {
                var quintuples = new Array<{key:String, keyPointer:MemoryPointer, value:MemoryPointer, type:MemoryPointer, doc:MemoryPointer}>();

                var propsC = props.copy();

                propsC[Little.keywords.OBJECT_TYPE_PROPERTY_NAME] = {
                    value: Characters(typeName),
                    documentation: 'The type of this object, as a ${Little.keywords.TYPE_STRING}.',
                }

                for (k => v in propsC) {
                    var key = k;
                    var keyPointer = storeString(key);
                    var value = switch v.value {
                        case Object(_, _): storeObject(v.value);
                        case FunctionCode(_, _): storeCodeBlock(v.value);
                        case _: storeStatic(v.value);
                    }
                    var type = switch v.value {
                        case Number(_): parent.getTypeInformation(Little.keywords.TYPE_INT).pointer;
                        case Decimal(_): parent.getTypeInformation(Little.keywords.TYPE_FLOAT).pointer;
                        case Characters(_): parent.getTypeInformation(Little.keywords.TYPE_STRING).pointer;
                        case TrueValue | FalseValue: parent.getTypeInformation(Little.keywords.TYPE_BOOLEAN).pointer;
                        case NullValue: parent.getTypeInformation(Little.keywords.TYPE_DYNAMIC).pointer;
                        case FunctionCode(_, _): parent.getTypeInformation(Little.keywords.TYPE_FUNCTION).pointer;
						case ClassPointer(_): parent.getTypeInformation(Little.keywords.TYPE_MODULE).pointer;
                        case Object(_, t): parent.getTypeInformation(t).pointer;
                        case _: throw "Property value must be a static value, a code block or an object (given: `" + v + "`)";
                    }

                    quintuples.push({key: key, keyPointer: keyPointer, value: value, type: type, doc: storeString(v.documentation) /*Todo, not a good solution, docs will some out of classes most of the time.*/});
                }

                var bytes = HashTables.generateObjectHashTable(quintuples);
                var bytesLength = ByteArray.from(bytes.length);
                var bytesPointer = storeBytes(bytes.length, bytes);

                return storeBytes(4 + POINTER_SIZE , ByteArray.from(bytes.length).concat(ByteArray.from(bytesPointer.rawLocation)));
            }
			case _:
                throw new ArgumentException("object", '${object} must be an `Interpreter.Object`');
		}

        throw "How did you get here?";
    }

	/**
		Stores an object at a specific address using 3 parts:
		
		- POINTER_SIZE + 4 Bytes directly at the site of storage, including:
		  - Byte 0 to 4: The length of the object's hashtable
		  - Byte 4 to POINTER_SIZE + 4: A pointer to the object's hashtable
		- The object's hashtable, at another location. The hashtable can be moved around, and when this
		  is done, the data at the object's address changes.
		
    **/
	public function setObject(address:MemoryPointer, object:InterpTokens) {
		if (object.is(NULL_VALUE)) return parent.constants.NULL;
        if (!object.is(OBJECT)) throw new ArgumentException("object", '${object} is not a dynamic object');

		switch object {
			case Object(props, typeName): {
                var quintuples = new Array<{key:String, keyPointer:MemoryPointer, value:MemoryPointer, type:MemoryPointer, doc:MemoryPointer}>();

                var propsC = props.copy();

                propsC[Little.keywords.OBJECT_TYPE_PROPERTY_NAME] = {
                    value: Characters(typeName),
                    documentation: 'The type of this object, as a ${Little.keywords.TYPE_STRING}.',
                }

                for (k => v in propsC) {
                    var key = k;
                    var keyPointer = storeString(key);
                    var value = switch v.value {
                        case Object(_, _): storeObject(v.value);
                        case FunctionCode(_, _): storeCodeBlock(v.value);
                        case _: storeStatic(v.value);
                    }
                    var type = switch v.value {
                        case Number(_): parent.getTypeInformation(Little.keywords.TYPE_INT).pointer;
                        case Decimal(_): parent.getTypeInformation(Little.keywords.TYPE_FLOAT).pointer;
                        case Characters(_): parent.getTypeInformation(Little.keywords.TYPE_STRING).pointer;
                        case TrueValue | FalseValue: parent.getTypeInformation(Little.keywords.TYPE_BOOLEAN).pointer;
                        case NullValue: parent.getTypeInformation(Little.keywords.TYPE_DYNAMIC).pointer;
                        case FunctionCode(_, _): parent.getTypeInformation(Little.keywords.TYPE_FUNCTION).pointer;
						case ClassPointer(_): parent.getTypeInformation(Little.keywords.TYPE_MODULE).pointer;
                        case Object(_, t): parent.getTypeInformation(t).pointer;
                        case _: throw "Property value must be a static value, a code block or an object (given: `" + v + "`)";
                    }

                    quintuples.push({key: key, keyPointer: keyPointer, value: value, type: type, doc: storeString(v.documentation) /*Todo, not a good solution, docs will some out of classes most of the time.*/});
                }

                var bytes = HashTables.generateObjectHashTable(quintuples);
                var bytesLength = ByteArray.from(bytes.length);
                var bytesPointer = storeBytes(bytes.length, bytes);

                setBytes(address, ByteArray.from(bytes.length).concat(ByteArray.from(bytesPointer.rawLocation)));
            }
			case _:
                throw new ArgumentException("object", '${object} must be an `Interpreter.Object`');
		}

        throw "How did you get here?";
	}

	/**
		Reads an object.
		@param pointer The address of the object
		@return A token representing the object (of type `InterpTokens.Object`)
	**/
	public function readObject(pointer:MemoryPointer):InterpTokens {
        if (pointer == parent.constants.NULL) return null;
		if (parent.constants.hasPointer(readPointer(pointer.rawLocation + 4))) throw "HashTable pointer is not valid";
        var hashTableBytes = readBytes(readPointer(pointer.rawLocation + 4), readInt32(pointer));
        var table = HashTables.readObjectHashTable(hashTableBytes, this);
        var map = new Map<String, {value:InterpTokens, documentation:String}>();
        for (entry in table) {
			map[entry.key] = 
            map[entry.key] = {
                value: @:privateAccess parent.valueFromType(entry.value, parent.getTypeName(entry.type), ["<object>"]),
                documentation: readString(entry.doc) 
            }
        }
        return Object(
            map, 
            map[Little.keywords.OBJECT_TYPE_PROPERTY_NAME].value.parameter(0) /* This value is a `Characters`, so it first param is a `String`.*/
        );
	}

	/**
		Free an object
		@param pointer The address of the object 
	**/
	public function freeObject(pointer:MemoryPointer) {
		// Just free pointer size (4) + int32 size (4)

        var hashTableSize = readInt32(pointer);
        var hashTablePointer = readPointer(pointer.rawLocation + 4);
        freeBytes(hashTablePointer, hashTableSize);
        freeBytes(pointer, POINTER_SIZE + 4);
	}

	/**
		stores a type, and all its statics and instance fields.
		@param name The name of the type
		@param statics It's static fields
		@param instances It's instance fields
	**/
	public function storeType(name:String, statics:Map<String, {value:InterpTokens, documentation:String, type:String}>, instances:Map<String, {documentation:String, type:String}>) {
		var bytes = ByteArray.from(storeString(name).rawLocation);
		var cellSize = POINTER_SIZE * 4;

		// We'll create each map with some extra space to avoid frequent collisions. more overhead? yes. faster? also probably yes.
		cellSize = POINTER_SIZE * 4;
		var staticsLength = statics.keys().toArray().length;
		var staticHashMap = new ByteArray(MathTools.floor(staticsLength * cellSize /*field name, value, type, doc*/ * 3 / 2));

		var instancesLength = instances.keys().toArray().length;
		var instancesHashMap = new ByteArray(MathTools.floor(instancesLength * (cellSize - POINTER_SIZE) /*field name, type, doc*/ * 3 / 2));

		for (__item in [{a: staticsLength, b: staticHashMap, c:statics }, {a: instancesLength, b: instancesHashMap, c:instances}]) {
			var elements = __item.a;
			var hashTable = __item.b;
			var fields:Map<String, Dynamic> = __item.c;

			for (k => v in fields) {
				var keyHash = Murmur1.hash(Bytes.ofString(k));
				// Make sure divisibility by cellSize is possible. see HashTables.generateObjectHashTable for more info
				var khI64 = Int64.make(0, keyHash);
				var keyIndex = ((khI64 * cellSize) % elements).low;
	
				if (hashTable.getInt32(keyIndex) == 0) {
					var address = keyIndex;
					hashTable.setInt32(address, storeString(k).rawLocation);
					address += POINTER_SIZE;
					if (fields == statics) {
						hashTable.setInt32(address, parent.store(v.value).rawLocation);
						address += POINTER_SIZE;
					}
					hashTable.setInt32(address, parent.getTypeInformation(v.type).pointer.rawLocation);
					address += POINTER_SIZE;
					hashTable.setInt32(keyIndex, storeString(v.documentation).rawLocation);
				} else {
					
					var incrementation = 0;
					var i = keyIndex;
					while (hashTable.getInt32(i) != 0) {
						i += cellSize;
						incrementation += cellSize;
						if (i >= hashTable.length) {
							i = 0;
						}
						if (incrementation >= hashTable.length) {
							throw 'Object hash table did not generate. This should never happen. Initial length may be incorrect.';
						}
					}
					var address = keyIndex;
					hashTable.setInt32(address, storeString(k).rawLocation);
					address += POINTER_SIZE;
					if (fields == statics) {
						hashTable.setInt32(address, parent.store(v.value).rawLocation);
						address += POINTER_SIZE;
					}
					hashTable.setInt32(address, parent.getTypeInformation(v.type).pointer.rawLocation);
					address += POINTER_SIZE;
					hashTable.setInt32(keyIndex, storeString(v.documentation).rawLocation);
				}
			}

			cellSize -= POINTER_SIZE;
		}
		staticHashMap = ByteArray.from(staticHashMap.length).concat(staticHashMap);
		instancesHashMap = ByteArray.from(instancesHashMap.length).concat(instancesHashMap);
		bytes = bytes.concat(staticHashMap).concat(instancesHashMap);
		return storeBytes(bytes.length, bytes);
	}


	/**
		stores a type, and all its statics and instance fields at a specific address.
		@param address The address of the type
		@param name The name of the type
		@param statics It's static fields
		@param instances It's instance fields
	**/
	public function setType(address:MemoryPointer, name:String, statics:Map<String, {value:InterpTokens, documentation:String, type:String}>, instances:Map<String, {documentation:String, type:String}>) {
		var bytes = ByteArray.from(storeString(name).rawLocation);
		var cellSize = POINTER_SIZE * 4;

		// We'll create each map with some extra space to avoid frequent collisions. more overhead? yes. faster? also probably yes.
		cellSize = POINTER_SIZE * 4;
		var staticsLength = statics.keys().toArray().length;
		var staticHashMap = new ByteArray(MathTools.floor(staticsLength * cellSize /*field name, value, type, doc*/ * 3 / 2));

		var instancesLength = instances.keys().toArray().length;
		var instancesHashMap = new ByteArray(MathTools.floor(instancesLength * (cellSize - POINTER_SIZE) /*field name, type, doc*/ * 3 / 2));

		for (__item in [{a: staticsLength, b: staticHashMap, c:statics }, {a: instancesLength, b: instancesHashMap, c:instances}]) {
			var elements = __item.a;
			var hashTable = __item.b;
			var fields:Map<String, Dynamic> = __item.c;

			for (k => v in fields) {
				var keyHash = Murmur1.hash(Bytes.ofString(k));
				// Make sure divisibility by cellSize is possible. see HashTables.generateObjectHashTable for more info
				var khI64 = Int64.make(0, keyHash);
				var keyIndex = ((khI64 * cellSize) % elements).low;
	
				if (hashTable.getInt32(keyIndex) == 0) {
					var address = keyIndex;
					hashTable.setInt32(address, storeString(k).rawLocation);
					address += POINTER_SIZE;
					if (fields == statics) {
						hashTable.setInt32(address, parent.store(v.value).rawLocation);
						address += POINTER_SIZE;
					}
					hashTable.setInt32(address, parent.getTypeInformation(v.type).pointer.rawLocation);
					address += POINTER_SIZE;
					hashTable.setInt32(keyIndex, storeString(v.documentation).rawLocation);
				} else {
					
					var incrementation = 0;
					var i = keyIndex;
					while (hashTable.getInt32(i) != 0) {
						i += cellSize;
						incrementation += cellSize;
						if (i >= hashTable.length) {
							i = 0;
						}
						if (incrementation >= hashTable.length) {
							throw 'Object hash table did not generate. This should never happen. Initial length may be incorrect.';
						}
					}
					var address = keyIndex;
					hashTable.setInt32(address, storeString(k).rawLocation);
					address += POINTER_SIZE;
					if (fields == statics) {
						hashTable.setInt32(address, parent.store(v.value).rawLocation);
						address += POINTER_SIZE;
					}
					hashTable.setInt32(address, parent.getTypeInformation(v.type).pointer.rawLocation);
					address += POINTER_SIZE;
					hashTable.setInt32(keyIndex, storeString(v.documentation).rawLocation);
				}
			}

			cellSize -= POINTER_SIZE;
		}
		staticHashMap = ByteArray.from(staticHashMap.length).concat(staticHashMap);
		instancesHashMap = ByteArray.from(instancesHashMap.length).concat(instancesHashMap);
		bytes = bytes.concat(staticHashMap).concat(instancesHashMap);
		return setBytes(address, bytes);
	}

	/**
		Reads a type.
		@param pointer The address of the type 
		@return A runtime type information object
	**/
	public function readType(pointer:MemoryPointer):TypeInfo {
        if (pointer == parent.constants.NULL) return null;
		var className = readString(readPointer(pointer.rawLocation));

		var cellSize = POINTER_SIZE * 4;
		// Statics:
		var statics:Map<String, {value:MemoryPointer, type:MemoryPointer, doc:MemoryPointer}> = [];
		var staticsLength = readInt32(pointer.rawLocation + POINTER_SIZE);

        var i = pointer.rawLocation + POINTER_SIZE;
        while (i < pointer.rawLocation + POINTER_SIZE + staticsLength) {
            var keyPointer = MemoryPointer.fromInt(readInt32(i));
            var value = MemoryPointer.fromInt(readInt32(i + POINTER_SIZE));
            var type = MemoryPointer.fromInt(readInt32(i + POINTER_SIZE * 2));
            var doc = MemoryPointer.fromInt(readInt32(i + POINTER_SIZE * 3));

            if (keyPointer.rawLocation == 0) {
                i += cellSize;
                continue; // Nothing to do here
            }

            statics[readString(keyPointer)] = {
				value: value,
				type: type,
				doc: doc
			}

            i += cellSize;
        }

		cellSize -= POINTER_SIZE;

		// Instances:
		var instances:Map<String, {type:MemoryPointer, doc:MemoryPointer}> = [];
		var instancesLength = readInt32(i + POINTER_SIZE);

		while (i < i + POINTER_SIZE + instancesLength) {
			var keyPointer = readPointer(i);
			var type = readPointer(i + POINTER_SIZE);
			var doc = readPointer(i + POINTER_SIZE * 2);

			if (keyPointer.rawLocation == 0) {
				i += cellSize;
				continue; // Nothing to do here
			}

			instances[readString(keyPointer)] = {
				type: type,
				doc: doc
			}

			i += cellSize;
		}

		return {
			typeName: className,
			pointer: pointer,
			passedByReference: true, // Final decision: static types cannot be created at runtime, only externally
			isExternal: false,
			instanceFields: instances,
			staticFields: statics,
			defaultInstanceSize: 4 + POINTER_SIZE, // Objects take 8 bytes in-place
		}
	}

	/**
		Frees a type.
		@param pointer The address of the type 
	**/
	public function freeType(pointer:MemoryPointer) {
		freeString(pointer);
		var byteCount = readInt32(pointer.rawLocation + POINTER_SIZE);
		byteCount += readInt32(pointer.rawLocation + POINTER_SIZE + byteCount);
		byteCount += 4 + 4;
		freeBytes(pointer, byteCount);
	}
}