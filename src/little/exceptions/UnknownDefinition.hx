package little.exceptions;

import little.interpreter.constraints.Exception;

class UnknownDefinition implements Exception {
    

	public var details:String;

	public var type:String = "Unknown Definition";

	public var content(get, null):String;

	public function get_content():String {
		return '$type: $details';
	}

    public function new(name:String) {
        details = 'There isn\'t any known definition for\n\t\t$name\n\tDid you forget to declare it?';
    }
}