package little.exceptions;

import little.interpreter.constraints.Exception;

class UnknownType implements Exception {

    public function new(name:String, type:String) {
        this.details = 'You tried to set the definition $name as a${grammer(type)} $type, but that type doesnt exist';
    }
	public var details:String;

	public var type:String = "Unknown Type";

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