package little.interpreter.memory;

import haxe.display.Display.Module;
import little.interpreter.memory.MemoryPointer;
import haxe.Int64;
import little.tools.Tree;
import haxe.ds.Either;
import haxe.exceptions.ArgumentException;
import little.interpreter.Tokens.InterpTokens;
import haxe.xml.Parser;
import haxe.io.Bytes;
import haxe.io.UInt8Array;
import vision.ds.ByteArray;

using little.tools.Extensions;
class Heap {

	public var parent:Memory;

    public function new(memory:Memory) {
        parent = memory;
    }


    /**
        stores a byte to the heap
        @param b an 8-bit number
        @return A pointer to its address on the heap. The size of this "object" is `1`.
    **/
    public function storeByte(b:Int):MemoryPointer {
        if (b == 0) return parent.constants.ZERO;
        #if !static if (b == null) return parent.constants.NULL; #end

        // Find a free spot
        var i = 0;
        while (i < parent.reserved.length && parent.reserved[i] != 0) i++;
        if (i >= parent.reserved.length) parent.increaseBuffer();
        parent.memory[i] = b;
        parent.reserved[i] = 1;

        return '$i';
    }

    /**
        Reads a byte from the heap
        @param address The address of the byte to read
        @return The byte
    **/
    public function readByte(address:MemoryPointer):Int {
        return parent.memory[address.rawLocation];
    }

    /**
        Pops a byte from the heap
        @param address The address of the byte to remove
    **/
    public function freeByte(address:MemoryPointer) {
        parent.memory[address.rawLocation] = 0;
        parent.reserved[address.rawLocation] = 0;
    }


    public function storeBytes(size:Int, ?b:ByteArray):MemoryPointer {
        // Find a free spot
        var i = 0;
		var fit = true;
		while (i < parent.reserved.length - size) {
			for (j in 0...size) {
				if (parent.reserved[i + j] != 0) {
					fit = false;
					break;
				}
			}
			if (fit) break;
			i++;
		}
		if (i >= parent.reserved.length - parent.memory.length) parent.increaseBuffer();

        for (j in 0...size - 1) {
            parent.memory[i + j] = j > b.length ? 0 : b[j];
            parent.reserved[i + j] = 1;
        }

        return '$i';
    }

    public function readBytes(address:MemoryPointer, size:Int):ByteArray {
        var bytes = new ByteArray(size);
        for (j in 0...size - 1) {
            bytes[j] = parent.memory[address.rawLocation + j];
        }

        return bytes;
    }

    public function freeBytes(address:MemoryPointer, size:Int) {
        for (j in 0...size - 1) {
            parent.memory[address.rawLocation + j] = 0;
            parent.reserved[address.rawLocation + j] = 0;
        }
    }


    public function storeInt16(b:Int):MemoryPointer {
        if (b == 0) return parent.constants.ZERO;
        #if !static if (b == null) return parent.constants.NULL; #end

        // Find a free spot
        var i = 0;
        while (i < parent.reserved.length - 1 && parent.reserved[i] != 0 && parent.reserved[i + 1] != 0) i++;
        if (i >= parent.reserved.length - 1) parent.increaseBuffer();

        for (j in 0...1) {
            parent.memory[i + j] = b & 0xFF;
            b = b >> 8;
            parent.reserved[i + j] = 1;
        }

        return '$i';
    }

    public function readInt16(address:MemoryPointer):Int {
        // Dont forget to make the number negative if needed.
        return (parent.memory[address.rawLocation] + (parent.memory[address.rawLocation + 1] << 8)) - 32767;
        
    }

    public function freeInt16(address:MemoryPointer) {
		parent.memory[address.rawLocation] = 0;
		parent.memory[address.rawLocation + 1] = 0;
        parent.reserved[address.rawLocation] = 0;
        parent.reserved[address.rawLocation + 1] = 0;
    } 


    public function storeUInt16(b:Int):MemoryPointer {
        return storeInt16(b < 0 ? b + 32767 : b);
    }

    public function readUInt16(address:MemoryPointer) {

        return (parent.memory[address.rawLocation] + (parent.memory[address.rawLocation + 1] << 8));
    }

    public function freeUInt16(address:MemoryPointer) {
        freeInt16(address);
    }

    public function storeInt32(b:Int):MemoryPointer {
        if (b == 0) return parent.constants.ZERO;
        #if !static if (b == null) return parent.constants.NULL; #end

        // Find a free spot
        var i = 0;
        while (i < parent.reserved.length - 3 && parent.reserved[i] + parent.reserved[i + 1] + parent.reserved[i + 2] + parent.reserved[i + 3] != 0) i++;
        if (i >= parent.reserved.length - 3) parent.increaseBuffer();

        for (j in 0...4) {
            parent.memory[i + j] = b & 0xFF;
            b = b >> 8;
            parent.reserved[i + j] = 1;
        }

		return '$i';
    }

    public function readInt32(address:MemoryPointer):Int {
        return (parent.memory[address.rawLocation] + (parent.memory[address.rawLocation + 1] << 8) + (parent.memory[address.rawLocation + 2] << 16) + (parent.memory[address.rawLocation + 3] << 24));
    }

    public function freeInt32(address:MemoryPointer) {
        for (j in 0...4) {
            parent.memory[address.rawLocation + j] = 0;
			parent.reserved[address.rawLocation + j] = 0;
        }
    }

    public function storeUInt32(b:UInt):MemoryPointer {
        return storeInt32(b);
    }

    public function readUInt32(address:MemoryPointer):UInt {
        return readInt32(address);
    }

    public function freeUInt32(address:MemoryPointer) {
        freeInt32(address);
    }


    public function storeDouble(b:Float):MemoryPointer {
        if (b == 0) return parent.constants.ZERO;
        #if !static if (b == null) return parent.constants.NULL; #end

        var i = 0;
        while (i < parent.reserved.length - 7 && 
            parent.reserved[i] + parent.reserved[i + 1] + parent.reserved[i + 2] + parent.reserved[i + 3] + 
            parent.reserved[i + 4] + parent.reserved[i + 5] + parent.reserved[i + 6] + parent.reserved[i + 7] != 0) i++;
        if (i >= parent.reserved.length - 7) parent.increaseBuffer();

        var bytes = Bytes.alloc(8);
		bytes.setDouble(0, b);
        for (j in 0...8) {
            parent.memory[i + j] = bytes.get(j);
            parent.reserved[i + j] = 1;
        }

        return '$i';
    }

    public function readDouble(address:MemoryPointer):Float {
        return parent.memory.getDouble(address.rawLocation);
    }

    public function freeDouble(address:MemoryPointer) {
        for (j in 0...8) {
            parent.memory[address.rawLocation + j] = 0;
			parent.reserved[address.rawLocation + j] = 0;
        }
    }


	public function storePointer(p:MemoryPointer):MemoryPointer {
		return storeInt32(p.rawLocation); // Currently, only 32-bit pointers are supported because of the memory buffer
	}

	public function readPointer(address:MemoryPointer):MemoryPointer {
		return readInt32(address);
	}

	public function freePointer(address:MemoryPointer) {
		freeInt32(address);
	}


	public function storeString(b:String):MemoryPointer {
		if (b == "") return parent.constants.ZERO;
		#if !static if (b == null) return parent.constants.NULL; #end

        // Convert the string into bytes
		var stringBytes = Bytes.ofString(b, UTF8);
		// In order to accurately keep track of the string, the first 4 bytes will be used to store the length
		var bytes = new ByteArray(4).concat(stringBytes);
		bytes.setInt32(0, stringBytes.length);

		// Find a free spot. Keep in mind that string's characters in this context are UTF-8 encoded, so each character is 1 byte
		var i = 0;
		
        while (i < parent.reserved.length && parent.reserved.getBytes(i, bytes.length).toArray().contains(1)) i++;
		if (i >= parent.reserved.length - bytes.length) parent.increaseBuffer();
		

		// Each character in this string should be UTF-8 encoded
		for (j in 0...bytes.length) {
			parent.memory[i + j] = bytes.get(j);
			parent.reserved[i + j] = 1;
		}

		return '$i';
	}

	public function readString(address:MemoryPointer):String {
		var length = parent.memory.getInt32(address.rawLocation);
		return parent.memory.getString(address.rawLocation + 4, length, UTF8);
	}

	public function freeString(address:MemoryPointer) {
		var len = parent.memory.getInt32(address.rawLocation) + 4;
		for (j in 0...len) {
			parent.memory[address.rawLocation + j] = 0;
			parent.reserved[address.rawLocation + j] = 0;
		}
	}

    public function storeCodeBlock(caller:InterpTokens):MemoryPointer {
        switch caller {
            case Block(body, _): return storeString(ByteCode.compile(FunctionCode([], caller)));
            case FunctionCode(requiredParams, body): return storeString(ByteCode.compile(caller));
            case _: throw new ArgumentException("caller", '${caller} must be a code block');
        }
    }

    public function readCodeBlock(address:MemoryPointer):InterpTokens {
        return ByteCode.decompile(readString(address.rawLocation))[0];
    }


    public function freeCodeBlock(address:MemoryPointer) {
        freeString(address);
    }


    public function storeSign(sign:String) {
        return storeString(sign);
    }

    public function readSign(address:MemoryPointer):InterpTokens {
        return Sign(readString(address));
    }

    public function freeSign(address:MemoryPointer) {
        freeString(address);
    }


	public function storeStatic(token:InterpTokens):MemoryPointer {
		switch token {
			case NullValue | TrueValue | FalseValue: return parent.constants.get(token);
			case Number(num): return storeInt32(num);
			case Decimal(num): return storeDouble(num);
			case Characters(string): return storeString(string);
            case _: throw new ArgumentException("token", '${token} cannot be statically stored to the heap');
		}
	}


    public function storeObject(object:InterpTokens):MemoryPointer {
		if (object.is(NULL_VALUE)) return parent.constants.NULL;
        if (!object.is(OBJECT)) throw new ArgumentException("object", '${object} is not a structure');
        
		/*
			We will do the same thing that python does, but simpler.
            
            Simply put, store everything in a hashtable that containes all object properties.
            that hash table will be stored as a pointer, for easy replacement when needed.
		*/

		switch object {

			case Object(toString, props, typeName): {
                var quadruplets = new Array<{key:String, keyPointer:MemoryPointer, value:MemoryPointer, type:MemoryPointer}>();

                for (k => v in props) {
                    var key = k;
                    var keyPointer = storeString(key);
                    var value = switch v {
                        case Object(_, _, _): storeObject(v);
                        case FunctionCode(_, _): storeCodeBlock(v);
                        case _: storeStatic(v);
                    }
                    var type = switch v {
                        case Number(_): parent.getTypeInformation(Little.keywords.TYPE_INT).pointer;
                        case Decimal(_): parent.getTypeInformation(Little.keywords.TYPE_FLOAT).pointer;
                        case Characters(_): parent.getTypeInformation(Little.keywords.TYPE_STRING).pointer;
                        case TrueValue | FalseValue: parent.getTypeInformation(Little.keywords.TYPE_BOOLEAN).pointer;
                        case NullValue: parent.getTypeInformation(Little.keywords.TYPE_DYNAMIC).pointer;
                        case FunctionCode(_, _): parent.getTypeInformation(Little.keywords.TYPE_FUNCTION).pointer;
                        case Object(_, _, t): parent.getTypeInformation(t).pointer;
                        case _: throw "Property value must be a static value, a code block or an object (given: `" + v + "`)";
                    }

                    quadruplets.push({key: key, keyPointer: keyPointer, value: value, type: type});
                }

                quadruplets.push({
                    key: Little.keywords.TO_STRING_PROPERTY_NAME,
                    keyPointer: storeString(Little.keywords.TO_STRING_PROPERTY_NAME), // Todo: optimize later on, storing toString as a string over and over again cant be good.
                    value: storeCodeBlock(toString),
                    type: parent.getTypeInformation(Little.keywords.TYPE_FUNCTION).pointer
                });

                quadruplets.push({
                    key: Little.keywords.OBJECT_TYPE_PROPERTY_NAME,
                    keyPointer: storeString(Little.keywords.OBJECT_TYPE_PROPERTY_NAME),
                    value: parent.getTypeInformation(typeName).pointer,
                    type: parent.getTypeInformation(Little.keywords.TYPE_STRING).pointer, //The type's name is returned as a string
                });

                var bytes = ObjectHashing.generateObjectHashTable(quadruplets);
                var bytesLength = ByteArray.from(bytes.length);

                return storeBytes(bytesLength.length + bytes.length, bytesLength.concat(bytes));
            }
			case _:
                throw new ArgumentException("object", '${object} must be an `Interpreter.Object`');
		}

        throw "How did you get here?";
    }

	public function readObject(pointer:MemoryPointer):InterpTokens {
        var hashTableBytes = readBytes(pointer.rawLocation + 4, readInt32(pointer));
        var table = ObjectHashing.readObjectHashTable(hashTableBytes, this);
        var map = new Map<String, InterpTokens>();
        for (entry in table) {
            map[entry.key] = switch parent.getTypeName(entry.type) {
                case (_ == Little.keywords.TYPE_STRING => true): Characters(readString(entry.value));
                case (_ == Little.keywords.TYPE_INT => true): Number(readInt32(entry.value));
                case (_ == Little.keywords.TYPE_FLOAT => true): Decimal(readDouble(entry.value));
                case (_ == Little.keywords.TYPE_BOOLEAN => true): readByte(entry.value) == 1 ? TrueValue : FalseValue;
                case (_ == Little.keywords.TYPE_FUNCTION => true): readCodeBlock(entry.value);
                // Because of the way we store lone nulls (as type dynamic), 
                // they might get confused with objects of type dynamic, so we need to do this:
                case (_ == Little.keywords.TYPE_DYNAMIC && parent.constants.getFromPointer(entry.value).equals(NullValue)=> true): NullValue;
                case _: readObject(entry.value);
            }
        }

        return Object(
            map[Little.keywords.TO_STRING_PROPERTY_NAME], 
            map, 
            map[Little.keywords.OBJECT_TYPE_PROPERTY_NAME].parameter(0) /* This value is a `Characters`, so it first param is a `String`.*/
        );
	}

	public function freeObject(pointer:MemoryPointer) {
		// Just free hashTableSize + 4

        var hashTableSize = readInt32(pointer);
        freeBytes(pointer, hashTableSize + 4);
	}

	public function storeType(staticFields:Array<InterpTokens>, instanceFields:Array<InterpTokens>):MemoryPointer {
		/*
			NOTE FOR LATER: type parameter support isn't implemented, will be considered in the future.

			This will be done as such:
			 - Bytes 0-7 represent the amount of bytes consumed by instance fields
			 - The Next 8-15 bytes represent the amount of bytes consumed by static fields
			 - From byte 16 until the value of bytes 0-7 + 24 are the instance fields, so, for each field:
			   - 8 bytes to represent the type of the value, using a pointer to the type.
			   - if debug mode: The string containing documentation for each field, then a null terminator
			 - after storing the non-static fields, we store the static fields, the same way as above
		*/
		var cbytes = new ByteArray(0);
		
        // Now count the amount of bytes consumed by instance & static fields
        var instanceBytes = [], staticBytes = [];

        var byteArrays = [instanceBytes, staticBytes];
        var fieldArrays = [instanceFields, staticFields];
        
        for (t in 0...2) {

            for (field in fieldArrays[t]) {
                switch field {
                    case VariableDeclaration(_, type, doc): {

						// store the type's pointer
						var typePointer = parent.getTypeInformation(type.parameter(0) /**todo**/).pointer;
                        byteArrays[t] = byteArrays[t].concat(typePointer.toArray());

						// store the documentation, if any/needed
                        if (Little.debug && doc != null) {
                            var docBytes = Bytes.ofString(doc);
							docBytes = new ByteArray(4).concat(docBytes);
							docBytes.setInt32(0, docBytes.length);
                            for (i in 0...docBytes.length) {
                                byteArrays[t].push(docBytes.get(i));
                            }
                        }
                    }
					case FunctionDeclaration(_, _, _, doc) | ConditionDeclaration(_, _, doc): {
						// Functions/conditions are always stored as strings, so we don't need to do anything type related. 8 bytes shall be reserved.
						var typePointer = parent.getTypeInformation(Little.keywords.TYPE_STRING).pointer;
                        byteArrays[t] = byteArrays[t].concat(typePointer.toArray());

						// store the documentation, if any/needed
                        if (Little.debug && doc != null) {
                            var docBytes = Bytes.ofString(doc);
							docBytes = new ByteArray(4).concat(docBytes);
							docBytes.setInt32(0, docBytes.length);
                            for (i in 0...docBytes.length) {
                                byteArrays[t].push(docBytes.get(i));
                            }
                        }
					}
                    case _: throw new ArgumentException("field", 'members of instanceFields must be of type VariableDeclaration, FunctionDeclaration, or ConditionDeclaration (got ${field})');
                }
            }
        }

        var instanceLength = Int64.make(0, instanceBytes.length);
		var ibytes = new ByteArray(8); ibytes.setInt64(0, instanceLength);
        var staticLength = Int64.make(0, staticBytes.length);
        var sbytes = new ByteArray(8); sbytes.setInt64(0, staticLength);

		var bytes = cbytes.concat(ibytes).concat(sbytes);
		for (i in 0...instanceBytes.length - 1) 
			bytes.set(i + 24, instanceBytes[i] & 0xFF);
		for (i in 0...staticBytes.length - 1) 
			bytes.set(i + 24 + instanceBytes.length, staticBytes[i] & 0xFF);

		return storeBytes(bytes.length, bytes);
	}

	public function readType(pointer:MemoryPointer):TypeBlocks {
		var handle = pointer.rawLocation;
		var sizeOfInstanceFields = readInt32(handle); // Memory buffer limitation: byte array on accepts indices of type Int32
		handle += 8;
		var sizeOfStaticFields = readInt32(handle); // Memory buffer limitation: byte array on accepts indices of type Int32
		handle += 8;

        var instanceFieldBytes = readBytes(handle, sizeOfInstanceFields);
        var staticFieldBytes = readBytes(handle + sizeOfInstanceFields, sizeOfStaticFields);
        
        var instanceFields:Array<{type:MemoryPointer, doc:Null<String>}> = [], staticFields:Array<{type:MemoryPointer, doc:Null<String>}> = [];

        var handle = 0;
        for(fieldCollector in [instanceFields, staticFields]) {
            while (true) {
                var type = readPointer(handle);
                var doc:String = null;
                handle += 8;
                if (Little.debug) {
                    var bytesLength = readInt32(handle) + 4; // String length
                    doc = readString(handle);
                    handle += bytesLength;
                }
    
                fieldCollector.push({type: type, doc: doc});
            }
        }
        

		return {
			sizeOfInstanceFields: sizeOfInstanceFields,
			sizeOfStaticFields: sizeOfStaticFields,
			instanceFieldsBytes: instanceFieldBytes,
			staticFieldsBytes: staticFieldBytes,
            instanceFields: instanceFields,
            staticFields: staticFields
		}
	}

	public function freeType(pointer:MemoryPointer) {
		var totalSize = 0;

		totalSize += 16; // Size of instance & static fields in bytes
		totalSize += readInt32(pointer.rawLocation + 8); // Instance fields
		totalSize += readInt32(pointer.rawLocation + 8 + 8); // Static fields

		freeBytes(pointer, totalSize);
	}
}

typedef TypeBlocks = {
	sizeOfInstanceFields:Int,
	sizeOfStaticFields:Int,
	instanceFieldsBytes:ByteArray,
	staticFieldsBytes:ByteArray,
    instanceFields:Array<{type:MemoryPointer, doc:Null<String>}>,
    staticFields:Array<{type:MemoryPointer, doc:Null<String>}>,
}

typedef ObjectInfo = {
    pointer:MemoryPointer,
    fields:Map<String, {keyPointer:MemoryPointer, value:MemoryPointer, type:MemoryPointer}>
}