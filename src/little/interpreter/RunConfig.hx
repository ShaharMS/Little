package little.interpreter;

@:structInit
class RunConfig {
    
    public var prioritizeFunctionDeclarations:Bool = false;
    public var prioritizeVariableDeclarations:Bool = false;
    public var strictTyping:Bool = false;
    public var defaultModuleName:String = "Main";
    public var keywordConfig:KeywordConfig = null;
}