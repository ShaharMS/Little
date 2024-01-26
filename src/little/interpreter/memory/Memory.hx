package little.interpreter.memory;

import little.tools.TextTools;
import vision.ds.Color;
import little.tools.Tree;
import haxe.ds.Either;
import little.interpreter.Tokens.InterpTokens;
import vision.ds.ByteArray;

using little.tools.Extensions;
using vision.tools.MathTools;

class Memory {
    
	public var memory:ByteArray;
	public var reserved:ByteArray;

    public var heap:Heap;
	public var stack:Stack;
	public var externs:ExternalInterfacing;
    public var constants:ConstantPool;

	@:noCompletion public var memoryChunkSize:Int = 512; // 512 bytes

	/**
		The maximum amount of memory that can be allocated, by bytes.
		By default, this is 2GB.
	**/
	public var maxMemorySize:Int = 1024 * 1024 * 2;

	/**
		The current amount of memory allocated, in bytes.
	**/
	public var currentMemorySize(get, never):Int;
	@:noCompletion function get_currentMemorySize() {
		var initialSize = reserved.length;
		var i = reserved.length - 1;
		while (i >= 0 && reserved[i] == 0) {
			i--;
			initialSize--;
		}

		return initialSize;
	}

	public function new() {
		memory = new ByteArray(memoryChunkSize);
		reserved = new ByteArray(memoryChunkSize);
		reserved.fill(0, memoryChunkSize, 0);

		heap = new Heap(this);
		stack = new Stack(this);
		constants = new ConstantPool(this);
		
	}


	public function increaseBuffer() {
		if (memory.length > maxMemorySize) {
			Runtime.throwError(ErrorMessage('Out of memory'), MEMORY);
		}
		var size = MathTools.min(memory.length + memoryChunkSize, maxMemorySize);
		var delta = size - memory.length;
		memory.resize(size);
		reserved.resize(size);
		reserved.fill(memory.length - delta, memory.length, 0);
	}
	/**
		General-purpose memory allocation for objects:

		- if `token` is `true`, `false`, `0`, or `null`, it pulls a pointer from the constant pool
		- if `token` is a string, a number, a sign or a decimal, it stores & pulls a pointer from the heap.
		- if `token` is a structure, it stores it on the heap, and returns a pointer to it.
	**/
	public function store(token:InterpTokens):MemoryPointer {
		if (token.is(TRUE_VALUE, FALSE_VALUE, NULL_VALUE)) {
			return constants.get(token);
		} else if (token.staticallyStorable()) {
			return heap.storeStatic(token);
		} else if (token.is(OBJECT)) {
			return heap.storeObject(token);
		}

		Runtime.throwError(ErrorMessage('Unable to allocate memory for token `$token`.'), MEMORY_HEAP);

		return constants.NULL;
	}

	/**
	**/
	public function read(...path:String):{objectValue:InterpTokens, objectTypeName:String, objectAddress:MemoryPointer} {

		// Before anything, global external values are prioritized
		if (externs.hasGlobal(...path)) {
			var object = externs.getGlobal(...path);
			var typeName = switch object.objectValue {
				case Object(_, _, type): type;
				case Number(_): Little.keywords.TYPE_INT;
				case Decimal(_): Little.keywords.TYPE_FLOAT;
				case Characters(_): Little.keywords.TYPE_STRING;
				case TrueValue | FalseValue: Little.keywords.TYPE_BOOLEAN;
				case NullValue: Little.keywords.TYPE_DYNAMIC;
				case FunctionCode(_, _): Little.keywords.TYPE_FUNCTION;
				case _: throw "How did we get here? 3";
			}
			return {
				objectValue: object.objectValue,
				objectTypeName: typeName,
				objectAddress: object.objectAddress
			}
		}

		// If we didnt find anything on the externs, we look in the stack.
		// We don't care if the field is found or not, since its supposed
		// To throw a runtime error that a variable was not found.
		var stackBlock = stack.getCurrentBlock();
		var data = stackBlock.get(path[0]);
		var current:InterpTokens = switch getTypeName(data.type) {
			case (_ == Little.keywords.TYPE_STRING => true): Characters(heap.readString(data.address));
			case (_ == Little.keywords.TYPE_INT => true): Number(heap.readInt32(data.address));
			case (_ == Little.keywords.TYPE_FLOAT => true): Decimal(heap.readDouble(data.address));
			case (_ == Little.keywords.TYPE_BOOLEAN => true): heap.readByte(data.address) == 1 ? TrueValue : FalseValue;
			case (_ == Little.keywords.TYPE_FUNCTION => true): heap.readCodeBlock(data.address);
            // Because of the way we store lone nulls (as type dynamic), 
            // they might get confused with objects of type dynamic, so we need to do this:
            case (_ == Little.keywords.TYPE_DYNAMIC && constants.getFromPointer(data.address).equals(NullValue) => true): NullValue;
            case _: heap.readObject(data.address);
		}
		var currentAddress:MemoryPointer = data.address;
		var currentType:String = data.type;
		
		var processed = path.toArray();
		var wentThroughPath = [];
		wentThroughPath.push(processed.shift()); // We already went through with it in the code above
		while (processed.length > 0) {
			// Get the current field, and the type of that field as well
			var identifier = processed.shift();
			wentThroughPath.push(identifier);
			var typeName = switch current {
				case Object(_, _, type): type;
				case Number(_): Little.keywords.TYPE_INT;
				case Decimal(_): Little.keywords.TYPE_FLOAT;
				case Characters(_): Little.keywords.TYPE_STRING;
				case TrueValue | FalseValue: Little.keywords.TYPE_BOOLEAN;
				case NullValue: Little.keywords.TYPE_DYNAMIC;
				case FunctionCode(_, _): Little.keywords.TYPE_FUNCTION;
				case _: throw "How did we get here? 3";
			}
			// By design, the only other way properties are accessible on non-object
			// values is through externs. So, after the object checks, we only need to look there.
			// We should notice that, like before, externs are prioritized, so externs are evaluated first.
		
			// Property check:
			if (externs.instanceProperties.properties.exists(typeName)) {
				var classProperties = externs.instanceProperties.properties.get(typeName);
				if (classProperties.properties.exists(identifier)) {
					var newCurrent = classProperties.properties.get(identifier).getter(current, currentAddress);
					current = newCurrent.objectValue;
					currentAddress = newCurrent.objectAddress;
				}
			}
			// Method check:
			// Also note that external properties & methods can't overlap, so using an `else` is valid
			else if (externs.instanceMethods.properties.exists(typeName)) {
				var classMethods = externs.instanceMethods.properties.get(typeName);
				if (classMethods.properties.exists(identifier)) {
					var newCurrent = classMethods.properties.get(identifier).getter(current, currentAddress);
					current = newCurrent.objectValue;
					currentAddress = newCurrent.objectAddress;
				}
			}
			
			// Then, we check the object's hash table for that field
			if (current.is(OBJECT)) {
				var objectHashTableBytesLength = heap.readInt32(currentAddress);
				var objectHashTableBytes = heap.readBytes(currentAddress.rawLocation + 4, objectHashTableBytesLength);
				
				if (ObjectHashing.hashTableHasKey(objectHashTableBytes, identifier, heap)) {
					var keyData = ObjectHashing.hashTableGetKey(objectHashTableBytes, identifier, heap);
					
					switch getTypeName(keyData.type) {
						case (_ == Little.keywords.TYPE_STRING => true): current = Characters(heap.readString(keyData.value));
						case (_ == Little.keywords.TYPE_INT => true): current = Number(heap.readInt32(keyData.value));
						case (_ == Little.keywords.TYPE_FLOAT => true): current = Decimal(heap.readDouble(keyData.value));
						case (_ == Little.keywords.TYPE_BOOLEAN => true): current = heap.readByte(keyData.value) == 1 ? TrueValue : FalseValue;
						case (_ == Little.keywords.TYPE_FUNCTION => true): current = heap.readCodeBlock(keyData.value);
						case (keyData.value == constants.NULL => true): current = NullValue;
						case _: current = heap.readObject(keyData.value);
					}

					currentAddress = keyData.value;
					
				}
			}

			// If we still don't have a value, we throw an error, cause that means that field doesnt exist.
			Runtime.throwError(ErrorMessage('Field $identifier does not exist on ${wentThroughPath.join(Little.keywords.PROPERTY_ACCESS_SIGN)}'));
		}


		return {
			objectValue: current,
			objectAddress: currentAddress,
			objectTypeName: switch current {
				case Object(_, _, type): type;
				case Number(_): Little.keywords.TYPE_INT;
				case Decimal(_): Little.keywords.TYPE_FLOAT;
				case Characters(_): Little.keywords.TYPE_STRING;
				case TrueValue | FalseValue: Little.keywords.TYPE_BOOLEAN;
				case NullValue: Little.keywords.TYPE_DYNAMIC;
				case FunctionCode(_, _): Little.keywords.TYPE_FUNCTION;
				case _: throw "How did we get here? 3";
			}
		}
	}

	/**
		Allocate `size` bytes of memory.
	    @param size The number of bytes to allocate
	    @return A pointer to the allocated memory
	**/
	public function allocate(size:Int):MemoryPointer {
		if (size <= 0) Runtime.throwError(ErrorMessage('Cannot allocate ${size} bytes'));
		return heap.storeBytes(size);
	}


	public function getTypeInformation(name:String):TypeInfo {

		var block = stack.getCurrentBlock();
		var reference = block.get(name);
		var typeInfo:Heap.TypeBlocks = heap.readType(reference.address);

		return {
			pointer: reference.address,
			typeName: name,
			isStaticType: [Little.keywords.TYPE_BOOLEAN, Little.keywords.TYPE_INT, Little.keywords.TYPE_FLOAT].contains(name), // massive TODO, what about post-defined static types? maybe a developer defines a special static type...
			instanceByteSize: typeInfo.sizeOfInstanceFields,
			staticByteSize: typeInfo.sizeOfStaticFields,
			instanceFields: typeInfo.instanceFields,
			staticFields: typeInfo.staticFields,
			classByteSize: 8 /**indicator of instance field size**/ + 8 /**same for statics**/ + typeInfo.sizeOfInstanceFields + typeInfo.sizeOfStaticFields /**total size of object**/,
		}
	}

	public function getTypeName(pointer:MemoryPointer):String {
		var block = stack.getCurrentBlock();

		for (key => value in block) {
			if (value.address == pointer) {
				return key;
			}
		}

		throw 'Cannot retrieve name of type at $pointer';
	}

	public function stringifyMemoryBytes():String {
		var s = "\n";
		for (i in 0...memory.length) {
			s += StringTools.hex(memory[i], 2) + " ";
		}

		return s;
	}
	public function stringifyReservedBytes():String {
		var s = "\n";
		for (i in 0...reserved.length) {
			s += TextTools.multiply(reserved[i] + "", 2) + " ";
		}
		return s;
	}
}

typedef TypeInfo = {
	pointer:MemoryPointer,
	typeName:String,
	isStaticType:Bool,
	instanceByteSize:Int,
	staticByteSize:Int,
	instanceFields:Array<{type:MemoryPointer, doc:Null<String>}>,
	staticFields:Array<{type:MemoryPointer, doc:Null<String>}>,
	classByteSize:Int,
}