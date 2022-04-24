package language.types.basic;

import language.features.MemoryTree;
import language.features.Variable;

/**
 * The standart Minilang Number type.
 */
class NumberVar implements Variable {
    

	public function new(int:Int, name:String) {
		intValue = int;
		this.name = name;
		MemoryTree.pushKey(name, int, this);
	}
    /**
     * The variable's haxe `Int` value
     */
    public var intValue(default, set):Int;

	function set_intValue(v:Int) {
		MemoryTree.removeKey(name);
		MemoryTree.pushKey(name, v, this);
		return intValue = v;
	}

    /**
     * The assigned name of the variable
     */
    public var name(default, set):String;

	function set_name(v:String) {
		MemoryTree.removeKey(name);
		MemoryTree.pushKey(v, intValue, this);
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
		return  'value: $intValue, name: $name';
	}

	function get_basicValue():Dynamic {
		return intValue;
	}

	function set_basicValue(value:Dynamic):Dynamic {
        intValue = cast value;
		return intValue;
	}

	function get_valueTree():Dynamic {
		return intValue;
	}

	function set_valueTree(value:Dynamic):Dynamic {
        intValue = cast value;
		return value;
	}

    public static function process(varLine:String):NumberVar {
		var result = {name: "", intValue: 0};
        var info = StringTools.replace(varLine, 'define ', '');
		if (info.length == varLine.length) return null;
		final gatherType = ~/(?:= *([+-]?[0-9]+) *)$/m;
		if (gatherType.match(info)) {
			result.intValue = Std.parseInt(gatherType.matched(1));
			var name = ~/^ *(\w+)/m;
			name.match(info);
			result.name = name.matched(1);
			trace(result.name);
			return new NumberVar(result.intValue, result.name);
		} 
		return null;
    }
}