package little.interpreter.constraints;

interface Action {
    public var startLine:Int;

    public var name:String;

    public var parameters:Array<Parameter>;

    public var returnType:String;

    public var scope:{scope:Scope, info:String, initializationLine:Int};
}

