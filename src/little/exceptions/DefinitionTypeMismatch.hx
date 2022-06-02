package little.exceptions;

import little.interpreter.constraints.Exception;

class DefinitionTypeMismatch implements Exception {

    public function new(name:String, originalType:String, wrongType:String) {
        this.details = "You tried to set the definition "+ name +" of type " + originalType + " with a value of type " + wrongType + "Once a definition is set, it can only be set again with the same type.";
    }
	public var details:String;

	public var type:String = "Definition Type Mismatch";

    public var content(get, null):String;

	public function get_content():String {
		return '$type: $details';
	}
}