package little.interpreter.memory;

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

        for (j in 0...3) {
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
        for (j in 0...3) {
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
        for (j in 0...7) {
            parent.memory[i + j] = bytes.get(j);
        }

        return '$i';
    }

    public function readDouble(address:MemoryPointer):Float {
        return parent.memory.getDouble(address.rawLocation);
    }

    public function freeDouble(address:MemoryPointer) {
        for (j in 0...7) {
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

		var bytes = Bytes.ofString(b, UTF8);

		// Find a free spot. Keep in mind that string's characters in this context are UTF-8 encoded, so each character is 1 byte
		var i = 0;
		var fit = true;
		while (i < parent.reserved.length - (bytes.length + 1)) {
			for (j in 0...bytes.length) {
				if (parent.reserved[i + j] != 0) {
					fit = false;
					break;
				}
			}
			if (fit) break;
			i++;
		}
		if (i >= parent.reserved.length - bytes.length) parent.increaseBuffer();
		

		// Each character in this string should be UTF-8 encoded
		for (j in 0...bytes.length - 1) {
			parent.memory[i + j] = bytes.get(j);
			parent.reserved[i + j] = 1;
		}
        parent.memory[i + bytes.length] = 0; // Null terminator
        parent.reserved[i + bytes.length] = 1;

		return '$i';
	}

	public function readString(address:MemoryPointer):String {
		var length = 0;
		while (parent.memory[address.rawLocation + length] != 0) length++;

		return parent.memory.getString(address.rawLocation, length, UTF8);
	}

	public function freeString(address:MemoryPointer) {
		var len = 0;
		while (parent.memory.get(address.rawLocation + len) != 0) len++; // until we get to the null terminator
		for (j in 0...len) {
			parent.memory[address.rawLocation + j] = 0;
			parent.reserved[address.rawLocation + j] = 0;
		}
	}


    public function storeStructure(struct:InterpTokens):MemoryPointer {
		if (struct.is(NULL_VALUE)) return parent.constants.NULL;
        if (!struct.is(STRUCTURE)) throw new ArgumentException("struct", '${struct} is not a structure');
        
		/*
			We will take this approach:
			First, store information about the structure's type.
			Then, try and store everything thats statically storable one right after the other. 
			If the property is not statically storable, we will store it elsewhere, and within the structure's memory, a pointer to it.

			That makes reading it much easier, since positional information about the position of each field can be stored
			elsewhere, probably in a separate structure containing the object's type info.
		*/
		var potentialBytes:Array<Int>;

		switch struct {

			case Structure(baseValue, props): {

				switch baseValue {

					case Value(value, type, doc): {

						switch value {

							case FunctionCaller(params, body): {
								return storeString(ByteCode.compile(value));
							}
							case ClassFields(staticFields, instanceFields, superClass): {
								// TODO, type declaration
							}
							case ConditionEvaluator(conditionFieldName, bodyFieldName, caller): {
								// TODO, condition declaration
							}
							case _: throw '`$value` is not a valid parameter for Structure(Value(...)) (expected FunctionCaller, ClassFields, ConditionEvaluator or NullValue)';
						}

						var typeInfo = parent.getTypeInformation(type);
						potentialBytes = potentialBytes.concat(typeInfo.pointer.toArray());
					}
					case _:
				}

				for (value in props) {
					if (value.is(STRUCTURE)) {
						var pointer = storeStructure(value);
						potentialBytes = potentialBytes.concat(pointer.toArray());
					} else if (value.is(CHARACTERS)) {
						potentialBytes = potentialBytes.concat(storeString(value.parameter(0)).toArray());
					} else if (value.staticallyStorable()) {
						potentialBytes = potentialBytes.concat(storeStatic(value).toArray());
					} else {
						throw 'entry $value in structure\'s properties is not statically storable, and not a structure';
					}
				}
			}

			case _:
		}

		var byteArray = new ByteArray(potentialBytes.length);
		for (i in 0...potentialBytes.length - 1) {
			byteArray[i] = potentialBytes[i] & 0xFF;
		}

		return storeBytes(potentialBytes.length, byteArray);
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

	public function storeType(properties:InterpTokens):MemoryPointer {
		switch properties {
			case ClassFields(staticFields, instanceFields, superClass): {
				/*
					This will be done as such:
					 - Bytes 0-7 are reserved for a pointer to the type's super class, or `0 0 0 0 0 0 0 0` if there is no super class
					 - Next, bytes 8-15 represent the amount of bytes consumed by instance fields
					 - The Next 16-23 bytes represent the amount of bytes consumed by static fields
					 - From byte 24 until the value of bytes 8-15 + 24 are the instance fields, so, for each field:
					   - 1 bytes to represent the size in memory of it, in bytes (max is 8, for double and pointer values)
					   - if debug mode: The string containing documentation for each field, then a null terminator
					 - after storing the non-static fields, we store the static fields, the same way as above
				*/
				var cbytes = new ByteArray(8);
                if (superClass == null) cbytes.fill(0, 8, 0);
                else cbytes = cbytes.concat(parent.getTypeInformation(superClass).pointer.toBytes());
			
                // Now count the amount of bytes consumed by instance & static fields
                var instanceBytes = [], staticBytes = [];

                var byteArrays = [instanceBytes, staticBytes];
                var fieldArrays = [instanceFields, staticFields];
                
                for (t in 0...2) {

                    for (field in fieldArrays[t]) {
                        switch field {
                            case VariableDeclaration(_, type, doc): {

								// store the type's size
								var typeInfo = parent.getTypeInformation(type);
								if (typeInfo.isStatic && typeInfo.typeName != Little.keywords.TYPE_STRING) byteArrays[t].push(typeInfo.instanceByteSize);
								else byteArrays[t].push(8);

								// store the documentation, if any/needed
                                if (Little.debug && doc != null) {
                                    var docBytes = Bytes.ofString(doc);
                                    for (i in 0...docBytes.length) {
                                        byteArrays[t].push(docBytes.get(i));
                                    }
                                    byteArrays[t].push(0);
                                }
                            }
    
                            case _: throw new ArgumentException("field", 'members of instanceFields must be of type VariableDeclaration (got ${field})');
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

			case _: throw new ArgumentException("properties", '${properties} must be of type ClassFields');
		}
		
		return null;
	}

	public function readType(pointer:MemoryPointer):{ /* TODO */} {
		var handle = pointer.rawLocation;
		var superClass = readPointer(handle);
		handle += 8;
		var sizeOfInstanceFields = readInt32(handle); // Memory buffer limitation: byte array on accepts indices of type Int32
		handle += 8;
		var sizeOfStaticFields = readInt32(handle); // Memory buffer limitation: byte array on accepts indices of type Int32
		handle += 8;

		for (i in handle...handle + sizeOfInstanceFields) {
			// TODO
		}
		handle += sizeOfInstanceFields;
		for (i in handle...handle + sizeOfStaticFields) {
			// TODO
		}

		return null;
	}
}