package little.interpreter.features;

import little.interpreter.constraints.VariableScope;
import little.interpreter.constraints.Types;
import little.interpreter.constraints.Variable;

class LittleVariable implements Variable {
    
	public var basicValue(get, set):Dynamic;

	public function get_basicValue():Dynamic {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function set_basicValue(value:Dynamic):Dynamic {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function get_valueTree():Dynamic {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function set_valueTree(value:Dynamic):Dynamic {
		throw new haxe.exceptions.NotImplementedException();
	}

	public var valueTree(get, set):Dynamic;

	public var type:String;

	public var name:String;

	public var scope:{scope:VariableScope, info:String};

	public function toString():String {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function dispose() {}

    public function new() {}
}