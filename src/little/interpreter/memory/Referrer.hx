package little.interpreter.memory;

import little.tools.PrettyPrinter;
using little.tools.Extensions;

class Referrer {

	public var blocks:Array<Scope> = [];

	public var parent:Memory;

	public function new(parent:Memory) {
		this.parent = parent;
		blocks.push(new Scope()); // Kick off with an empty block
	}

	public function pushScope(allowLookbehind:Bool = true) {
		var block = new Scope();
		if (allowLookbehind) block.previous = blocks[blocks.length - 1];
		blocks.push(block);
	}

	public function popScope() {
		blocks.pop();

		// Todo: Garbage collection
	}

	public function getCurrentScope():Scope {
		return blocks[blocks.length - 1];
	}
}