package interpreter.types.basic;

import interpreter.constraints.Types;
import interpreter.features.MemoryTree;
import interpreter.constraints.Variable;

/**
 * The standart Minilang DecimalNumber type.
 */
class DecimalVar implements Variable {
    
	public var type(default, never):Types = Types.DECIMAL_NUMBER;

	public function new(float:Float, name:String) {
		floatValue = float;
        this.name = name;
		MemoryTree.pushKey(name, this);
	}
    /**
     * The variable's haxe `Float` value
     */
    public var floatValue:Null<Float>;

    /**
     * The assigned name of the variable
     */
    public var name(default, set):String;

	function set_name(v:String) {
		MemoryTree.removeKey(name);
		MemoryTree.pushKey(v, this);
		return name = v;
	}

	/** Same as `intValue` */ public var basicValue(get, set):Dynamic;
	/** Same as `intValue` */ public var valueTree(get, set):Dynamic;

	@:noCompletion inline function get_basicValue() return floatValue;
	@:noCompletion inline function set_basicValue(value:Dynamic) return floatValue = cast value;

	@:noCompletion inline function get_valueTree() return floatValue;
	@:noCompletion inline function set_valueTree(value:Dynamic) return floatValue = cast value;

	public function toString():String {
		return  'value: $floatValue, name: $name';
	}

	public function dispose() {
		MemoryTree.removeKey(name);
		basicValue = null;
		valueTree = null;
		name = null;
		floatValue = null;
	}



    public static function process(varLine:String):DecimalVar {
		var result = {name: "", floatValue: 0.};
        var info = StringTools.replace(varLine, 'define ', '');
		if (info.length == varLine.length) return null;
		final gatherType = ~/(?:= *([+-]?[0-9]+\.?[0-9]*|\.[0-9]+))$/m;
		if (gatherType.match(info)) {
			result.floatValue = Std.parseFloat(gatherType.matched(1));
			var name = ~/^ *(\w+)/m;
			result.name = name.matched(1);
			return new DecimalVar(result.floatValue, result.name);
		} 
		return null;
    }
}