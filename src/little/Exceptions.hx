package little;

import little.interpreter.constraints.Exception;

class DefinitionTypeMismatch implements Exception {

    public function new(details:String) {
        this.details = details;
    }
	public var details:String;

	public var type:String = "Definition Type Mismatch";
}

class ExceptionStack {
    public function new() {
        
    }
}
