package interpreter.types.basic;

import interpreter.constraints.Types;
import interpreter.features.MemoryTree;
import interpreter.constraints.Variable;

/**
 * The standart Minilang Number type.
 */
class NumberVar implements Variable {
    
	public var type(default, never):Types = Types.NUMBER;

	public function new(int:Int, name:String) {
		intValue = int;
		this.name = name;
		MemoryTree.pushKey(name, this);
	}
    /**
     * The variable's haxe `Int` value
     */
    public var intValue:Null<Int>;

    /**
     * The assigned name of the variable
     */
    public var name(default, set):String;

	function set_name(v:String) {
		MemoryTree.removeKey(name);
		MemoryTree.pushKey(v, this);
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

	//dispose
	public function dispose():Void {
		MemoryTree.removeKey(name);
		basicValue = null;
		valueTree = null;
		name = null;
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
			return new NumberVar(result.intValue, result.name);
		} 
		return null;
    }
}