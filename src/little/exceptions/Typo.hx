package little.exceptions;

import little.interpreter.constraints.Exception;

class Typo implements Exception
{

	public var details:String;

	public var type:String = 'Typo';

	public var content(get, null):String;

	public function get_content():String {
		return '$type: $details';
	}

    public function new(details:String) {
        this.details = details;
    }
}