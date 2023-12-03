package little.interpreter.memory;

import little.interpreter.Tokens.InterpTokens;
import haxe.Constraints.Function;

class ExternalInterfacing {
	
	public var pool:Map<String, ExternData> = [];


	public function getValue(name:String) {
		var data = pool[name];
		if (data == null) Runtime.throwError(ErrorMessage('External variable `$name` does not exist'), MEMORY_EXTERNAL_INTERFACING);
	}
}

typedef ExternData = {
	type:FieldType,
	haxeValue:Dynamic,
	requiredParameters:Array<InterpTokens>,

	haxeValueGetter:() -> Dynamic,
	haxeValueSetter:(Dynamic) -> Void
}

enum abstract FieldType(String) {
	var VARIABLE;
	var FUNCTION;
	var CONSTANT;
}