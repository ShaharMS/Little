package little.interpreter.memory;

import little.tools.PrettyPrinter;
using little.tools.Extensions;

class Stack {
    
	/**
		The maximum amount of scoping this stack allows. More than this will cause a stack overflow error.

		In the future, this will change dynamically according to memory usage/constraints.
	**/
	public var maxStackSize:Int = 1000; 

	public var blocks:Array<StackBlock> = [];

	public var parent:Memory;

	public function new(parent:Memory) {
		this.parent = parent;
	}

	public function pushBlock(withPreviousReferences:Bool) {
		if (blocks.length >= maxStackSize) {
			Runtime.throwError(ErrorMessage('Too much recursion - ${PrettyPrinter.stringify(Runtime.callStack[Runtime.callStack.length - 1])} Called itself too many times (~${maxStackSize})'));
		}

		var block = new StackBlock();
		if (withPreviousReferences) {
			for (key => value in blocks[blocks.length - 1]) {
				block.reference(key, value.address, value.type);
			}
		}

		blocks.push(block);
	}

	public function popBlock() {
		blocks.pop();

		// Todo: Garbage collection
	}
}