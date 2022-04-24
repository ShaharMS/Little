package language.types.basic;

import language.features.Variable;

/**
 * The standart Minilang Number type.
 */
class NumberVar implements Variable {
    

	public function new(int:Int) {
		intValue = int;
	}
    /**
     * The variable's haxe `Int` value
     */
    public var intValue:Int;

    /**
     * The assigned name of the variable
     */
    public var name:String;

	/**
	 * Same as `intValue`
	 */
	public var basicValue(get, set):Dynamic;

	/**
	 * Same as `intValue`
	 */
	public var valueTree(get, set):Dynamic;

	public function ToString():String {
		return intValue + '';
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

    public static function readIsolate(varLine:String) {
		var result:NumberVar = new NumberVar(0);
        var info = StringTools.replace(varLine, 'variable ', '');
    }
}