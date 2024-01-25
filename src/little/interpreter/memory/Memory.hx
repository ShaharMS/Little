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
		Reads an object, a value, or a property of an object from memory.
		
		This is done by building a string from the initial object, using its scope, object name and accessed properties.

		 - When accessing static fields, the scope is already provided (SomeClass.field), and the extraction is easier
		   (Stored as `SomeClass_field`)
		 - When accessing instance fields it gets a little more complicated, as the scope is not provided, and recursion capabilities
		   Makes everything complicated.
		This data is accessible via the object's type information.
		@param initial the value/object
	**/
	public function read(path:Array<String>):InterpTokens {
		var stackBlock = stack.getCurrentBlock();
		var data = stackBlock.get(path[0]);
		

		return null;
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