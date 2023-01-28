package little.exceptions;

import little.interpreter.constraints.Exception;

class DefinitionTypeMismatch implements Exception {

    public function new(name:String, originalType:String, wrongType:String) {
        this.details = "You tried to set the definition: \n\n\t\t"+ name +"\n\n\tof type: \n\n\t\t" + originalType + "\n\n\twith a value of type: \n\n\t\t" + wrongType + "\n\n\tOnce a definition is set, it's value can only be set again with the same type.";
    }
	public var details:String;

	public var type:String = "Definition Type Mismatch";

    public var content(get, null):String;

	public function get_content():String {
		return '$type: $details';
	}
}