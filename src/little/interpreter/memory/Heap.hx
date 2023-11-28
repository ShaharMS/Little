package little.interpreter.memory;

import little.interpreter.Tokens.InterpTokens;
import little.tools.Tree;

using little.tools.Extensions;

class Heap {

    public var parent:Memory;

    public function new(memory:Memory) {
        parent = memory;
    }

	/**
		Allocate memory for a dynamic object.
		@param object The object to allocate. Has to be of type `InterpTokens.Structure`. The `InterpTokens.Structure`'s `pointer` field & `props[...].pointer` field should be null.
		@return The given `InterpTokens.Object`. Both the `InterpTokens.Object`'s `pointer` field & `props[...].pointer` are assigned.
	**/
    public function allocate(structure:InterpTokens):InterpTokens {
		if (!structure.is(STRUCTURE)) {
			Runtime.throwError(ErrorMessage('Cannot allocate non-structure objects in the heap'), MEMORY_HEAP);
			return structure;
		}

		var value, type, doc, props;
		var pointer;
		switch structure {
			case Structure(baseValue, p): {
				props = p;
				switch baseValue {
					case Value(v, t, pointer, d): {
						if (pointer != null) return structure; // already allocated
						value = v;
						type = t;
						doc = d;
					}
				}
			}
		}

		if (value.passedByValue()) {
			parent.stack.push(value);
		}
    }
}

typedef HeapItem =  {
	name:String,
	doc:String,
	pointer:String,
}