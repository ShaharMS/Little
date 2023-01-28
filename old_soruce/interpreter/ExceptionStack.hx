package little.interpreter;

import little.interpreter.constraints.Exception;

class ExceptionStack {

    public var last:Exception;
    public var first:Exception;
    public var stack:Array<Exception> = [];

    public function new() {
        
    }

    //push function
    public function push(e:Exception) {
        if (last == null) {
            last = e;
        } 
        if (first == null) {
            first = e;
        }
        last = e;
        stack.push(e);
    }
}