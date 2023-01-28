package little.interpreter.constraints;

interface Exception {
    public var details:String;
    public var type:String;

    public var content(get, null):String;
}