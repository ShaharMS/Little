package little.interpreter.memory;

class Heap {

    var stack:Stack;

    public var referenceTree:Tree<{}>

    public function new(stack:Stack) {
        this.stack = stack;
    }

    public function allocate(object:Dynamic):Tree<{name:String, pointer:MemoryPointer}> {
        
    }
}