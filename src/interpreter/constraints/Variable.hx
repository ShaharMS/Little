package interpreter.constraints;

import interpreter.constraints.Types;

interface Variable {
    public var basicValue(get, set):Dynamic;
    public var valueTree(get, set):Dynamic;
    public var type(default, never):Types;
    public function toString():String;
    public function dispose():Void;
}