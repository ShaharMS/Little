package little.interpreter.memory;

import little.tools.Tree;
import haxe.ds.Either;
import little.interpreter.Tokens.InterpTokens;
import vision.ds.ByteArray;

using little.tools.Extensions;

class Memory {
    
	public var memory:ByteArray;
	public var reserved:ByteArray;

    public var heap:Heap;
	public var stack:Stack;
    public var constants:ConstantPool;

	public var memoryChunkSize:Int = 128; // 128 bytes, 512 bits

	public function new() {
		memory = new ByteArray(memoryChunkSize);
		reserved = new ByteArray(memoryChunkSize);
		reserved.fill(0, memoryChunkSize, 0);

		heap = new Heap(this);
		stack = new Stack(this);
		constants = new ConstantPool(this);
		
	}


	public function increaseBuffer() {
		memory.resize(memory.length + memoryChunkSize);
		reserved.resize(memory.length);
		reserved.fill(memory.length - memoryChunkSize, memory.length, 0);
	}

	public function sizeOf(token:InterpTokens):Int {
		switch token {
			case Condition(_, _, _) | Read(_) | FunctionCall(_, _) | Expression(_, _) | PropertyAccess(_, _) | Identifier(_): return sizeOf(Actions.evaluate(token));
			case Write(_, v): return sizeOf(v);
			case TypeCast(v, _): return sizeOf(v);
			case Block(body, type): // Todo: block condensing
			case Number(num): return 4;
			case Decimal(num): return 8;
			case Characters(string) | Sign(string): return string.length; // 8 bit
			case NullValue | FalseValue | TrueValue: return 1;
			case ErrorMessage(msg): return msg.length * 2;
			case _: 
		}

		Runtime.throwError(ErrorMessage('Unable to get size of token `$token`'), MEMORY_SIZE_EVALUATOR);
		return -1;
	}

	/**
		General-purpose memory allocation:

		- if `token` is `true`, `false`, `0`, or `null`, it pulls a pointer from the constant pool
		- if `token` is a string, a number, a sign or a decimal, it pulls a pointer from the stack.
		- if `token` is a structure, it returns an allocated structure, with pointers marked.
	**/
	public function allocate(token:InterpTokens):Either<MemoryPointer, Tree<{key:String, address:MemoryPointer}>> {
		if (token.is(TRUE_VALUE, FALSE_VALUE, NULL_VALUE)) {
			return Left(constants.get(token));
		} else if (token.staticallyStorable()) {
			return Left(heap.storeStatic(token));
		} else if (token.is(STRUCTURE)) {
			return Right(heap.storeStructure(token));
		}

		Runtime.throwError(ErrorMessage('Unable to allocate memory for token `$token`.'), MEMORY_HEAP);

		return Left(constants.NULL);
	}
}
