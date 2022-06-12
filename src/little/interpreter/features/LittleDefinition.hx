package little.interpreter.features;

import little.interpreter.constraints.DefinitionScope;
import little.interpreter.constraints.Types;
import little.interpreter.constraints.Definition;

class LittleDefinition implements Definition {
    
	@:isVar public var basicValue(get, set):Dynamic;

	public function get_basicValue():Dynamic {
		return basicValue;
	}

	public function set_basicValue(value:Dynamic):Dynamic {
		return basicValue = value;
	}

	public var valueTree:Map<String, Dynamic> = new Map<String, Dynamic>();

	public var type:String;

	public var name:String;

	public var scope:{?scope:DefinitionScope, ?info:String, ?initializationLine:Int} = {};

	public function toString():String {
		return '$basicValue';
	}

	public function dispose() {}

    public function new() {}
}