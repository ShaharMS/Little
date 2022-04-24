package language.features;

interface Variable {
    public var basicValue(get, set):Dynamic;
    public var valueTree(get, set):Dynamic;
    public function toString():String;
}