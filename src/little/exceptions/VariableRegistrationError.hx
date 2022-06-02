package little.exceptions;

import little.interpreter.constraints.Exception;

class VariableRegistrationError implements Exception {

    public function new(name:String, registeredType:String) {
        this.details = 'You tried to register the variable $name as a${grammer(registeredType)} $registeredType, but that type dosn\'t have a non-Haxe counterpart.';
    }
	public var details:String;

	public var type:String = "Variable Registration Error";

	public var content(get, null):String;

	public function get_content():String {
		return '$type: $details';
	}

	inline function grammer(t:String):String {
		if (~/aeiou/g.replace(t.charAt(0), "").length == 0) {
			return "n";
		}
		return "";
	}
}