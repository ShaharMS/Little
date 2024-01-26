package little.interpreter.memory;

import little.tools.PrettyPrinter;
using little.tools.Extensions;

class Stack {

	public var blocks:Array<StackBlock> = [];

	public var parent:Memory;

	public function new(parent:Memory) {
		this.parent = parent;
		blocks.push(new StackBlock()); // Kick off with an empty block
	}

	public function pushBlock(withPreviousReferences:Bool = true) {
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

	public function getCurrentBlock():StackBlock {
		return blocks[blocks.length - 1];
	}
}