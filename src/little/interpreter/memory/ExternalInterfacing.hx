package little.interpreter.memory;

import haxe.Exception;
import little.tools.Conversion;
import little.tools.Tree;
import little.interpreter.Tokens.InterpTokens;
import haxe.Constraints.Function;

class ExternalInterfacing {
	
	public var pool:Tree<{key:String, data:ExternData}> = new Tree({key: "", data: {haxeValue: null}});


	/**
		@param path The path to the external variable. for example: MyClass, utils, myValue 
	**/
	public function getValue(...path:String):InterpTokens {

		var finalTree = pool;
		var currentPath = "";
		for (key in path) {
			finalTree = finalTree.children.filter(child -> child.value.key == key)[0];
			currentPath += Little.keywords.PROPERTY_ACCESS_SIGN + key;
			if (finalTree == null) Runtime.throwError(ErrorMessage('External variable `${currentPath}` does not exist'), MEMORY_EXTERNAL_INTERFACING);
		}
		
		var data:ExternData = finalTree.value.data;

		if (data == null) Runtime.throwError(ErrorMessage('External variable `${path.toArray().join(Little.keywords.PROPERTY_ACCESS_SIGN)}` does not exist'), MEMORY_EXTERNAL_INTERFACING);

		if (data.haxeValueSetter != null) return Conversion.toLittleValue(data.haxeValueGetter());
		if (data.haxeValue != null) return Conversion.toLittleValue(data.haxeValue);

		Runtime.throwError(ErrorMessage('External variable `${path.toArray().join(Little.keywords.PROPERTY_ACCESS_SIGN)}` is valueless'), MEMORY_EXTERNAL_INTERFACING);
		return NullValue;
	}

	/**
		@param parameters An array of parameters of type InterpTokens. Values should be passed as separate items in the array. SplitLines/SetLines are not allowed. 
		@param path The path to the external function. for example: MyClass, utils, myFunction 
	**/
	public function callFunction(parameters:Array<InterpTokens>, ...path:String):InterpTokens {

		var finalTree = pool;
		var currentPath = "";
		for (key in path) {
			finalTree = finalTree.children.filter(child -> child.value.key == key)[0];
			currentPath += Little.keywords.PROPERTY_ACCESS_SIGN + key;
			if (finalTree == null) Runtime.throwError(ErrorMessage('External variable `${currentPath}` does not exist'), MEMORY_EXTERNAL_INTERFACING);
		}

		var data:ExternData = finalTree.value.data;

		if (data == null) Runtime.throwError(ErrorMessage('External function `${path.toArray().join(Little.keywords.PROPERTY_ACCESS_SIGN)}` does not exist'), MEMORY_EXTERNAL_INTERFACING);
		if (data.requiredParameters == null) Runtime.throwError(ErrorMessage('External variable `${path.toArray().join(Little.keywords.PROPERTY_ACCESS_SIGN)}` is not a function, cannot be called'), MEMORY_EXTERNAL_INTERFACING);
		switch Type.typeof(data.haxeValue){
			case TFunction: {
				// The function should accept a single variable of type Array<InterpTokens>, and return a single variable of type InterpTokens
				var func:Function = data.haxeValue;
				try {
					var result = func(parameters);
					if (!result is InterpTokens) ErrorMessage('External function `${path.toArray().join(Little.keywords.PROPERTY_ACCESS_SIGN)}` is registered incorrectly: The function should return an `InterpTokens`.');
					return Conversion.toLittleValue(result);
				} catch (e:Exception) {
					Runtime.throwError(ErrorMessage('External function `${path.toArray().join(Little.keywords.PROPERTY_ACCESS_SIGN)}` is registered incorrectly: It must have one parameter of type `Array<InterpTokens>`'), MEMORY_EXTERNAL_INTERFACING);
				}
			}
			case _: Runtime.throwError(ErrorMessage('External function `${path.toArray().join(Little.keywords.PROPERTY_ACCESS_SIGN)}` is registered incorrectly: parameters are provided, but the external value is not a function.'), MEMORY_EXTERNAL_INTERFACING);
		}

		return NullValue;
	}

	/**
	    Notice - this function does not store the value in little's memory. This is for extern registration only. 
		Make sure the paths here don't intersect with other paths accessible via little's memory.
		Otherwise, the values here will shadow the little values, and would make all other values under the root
		defined via little code inaccessible.
	    @param value The external value 
	    @param path The path to the external variable. for example: MyClass, utils, myValue
	**/
	public function register(value:ExternData, ...path:String) {
		var finalTree = pool;
		for (key in path) {
			if (finalTree.children.filter(child -> child.value.key == key).length == 0) {
				finalTree.children.push(new Tree<{key:String, data:ExternData}>({key: key, data: {haxeValue: null}}));
			}
			finalTree = finalTree.children.filter(child -> child.value.key == key)[0];
		}
		finalTree.value.data = value;	
	
	}
}

typedef ExternData = {
	?haxeValue:Dynamic,
	?requiredParameters:Array<InterpTokens>,

	?haxeValueGetter:() -> Dynamic,
	?haxeValueSetter:(Dynamic) -> Void
}