package little.interpreter.memory;

import little.tools.PrettyPrinter;
using little.tools.Extensions;

class Referrer {

	public var scopes:Array<Scope> = [];

	public var parent:Memory;

	public function new(parent:Memory) {
		this.parent = parent;
		scopes.push(new Scope()); // Kick off with an empty block
	}

	public function pushScope(allowLookbehind:Bool = true) {
		var scope = new Scope();
		if (allowLookbehind) scope.previous = scopes[scopes.length - 1];
		scopes.push(scope);
	}

	public function popScope() {
		scopes.pop();

		// Todo: Garbage collection
	}

	public function getCurrentScope():Scope {
		return scopes[scopes.length - 1];
	}
}