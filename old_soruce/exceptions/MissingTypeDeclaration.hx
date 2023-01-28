package little.exceptions;

import little.interpreter.constraints.Exception;

class MissingTypeDeclaration implements Exception {


	public var details:String;

	public var type:String = "Missing Type Declaration";

	public var content(get, null):String;

    public function new(varName:String) {
        details = 'When initializing $varName, you left the type after the : empty.\n\tIf you don\'t want to specify a type, remove the : after the definition\'s name.';
    }

	public function get_content():String {
		return '$type: $details';
	}
} 