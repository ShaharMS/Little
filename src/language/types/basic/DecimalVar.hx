package language.types.basic;

import language.features.MemoryTree;
import language.features.Variable;

/**
 * The standart Minilang DecimalNumber type.
 */
class DecimalVar implements Variable {
    

	public function new(float:Float, name:String) {
		floatValue = float;
		MemoryTree.pushKey(name, float);
	}
    /**
     * The variable's haxe `Float` value
     */
    public var floatValue(default, set):Float;

	function set_floatValue(v:Float) {
		MemoryTree.removeKey(name);
		MemoryTree.pushKey(name, v);
		return floatValue = v;
	}

    /**
     * The assigned name of the variable
     */
    public var name(default, set):String;

	function set_name(v:String) {
		MemoryTree.removeKey(name);
		MemoryTree.pushKey(v, floatValue);
		return name = v;
	}

	/**
	 * Same as `intValue`
	 */
	public var basicValue(get, set):Dynamic;

	/**
	 * Same as `intValue`
	 */
	public var valueTree(get, set):Dynamic;

	public function toString():String {
		return  'value: $floatValue, name: $name';
	}

	function get_basicValue():Dynamic {
		return floatValue;
	}

	function set_basicValue(value:Dynamic):Dynamic {
        floatValue = cast value;
		return floatValue;
	}

	function get_valueTree():Dynamic {
		return floatValue;
	}

	function set_valueTree(value:Dynamic):Dynamic {
        floatValue = cast value;
		return value;
	}

    public static function readIsolate(varLine:String):DecimalVar {
		var result = {name: "", floatValue: 0.};
        var info = StringTools.replace(varLine, 'define ', '');
		if (info.length == varLine.length) return null;
		final gatherType = ~/(?:= *[+-]?([0-9]+\.?[0-9]*|\.[0-9]+))$/m;
		if (gatherType.match(info)) {
			result.floatValue = Std.parseFloat(gatherType.matched(1));
            #if cpp if (gatherType.matched(0).indexOf('-') != -1) result.floatValue = -result.floatValue; #end
			var name = ~/^ *(\w+)/m;
			trace(name.match(info));
			result.name = name.matched(1);
			return new DecimalVar(result.floatValue, result.name);
		} 
		return null;
    }
}