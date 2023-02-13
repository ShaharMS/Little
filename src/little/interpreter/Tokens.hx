package little.interpreter;

enum Token {
    SetLine(line:Int, nestingLevel:Int, ?module:String);
    DefinitionCreation(name:String, value:Token, type:String, nestingLevel:Int, ?module:String);
    ActionCreation(name:String, params:Array<Token>, body:Array<Token>, type:String, nestingLevel:Int, ?module:String);
    DefinitionAccess(name:String, nestingLevel:Int, ?module:String);
    DefinitionWrite(assignee:String, value:Token, valueType:String, nestingLevel:Int, ?module:String);
    Sign(sign:String, nestingLevel:Int, ?module:String);
    StaticValue(value:String, type:String, nestingLevel:Int, ?module:String);
    Expression(parts:Array<Token>, type:String, nestingLevel:Int, ?module:String);
    Parameter(name:String, type:String, value:Token, nestingLevel:Int, ?module:String);
    ActionCallParameter(value:Token, type:String, nestingLevel:Int, ?module:String);
    ActionCall(name:String, params:Array<Token>, returnType:String, nestingLevel:Int, ?module:String);
    Return(value:Token, type:String, nestingLevel:Int, ?module:String);
    Error(title:String, reason:String, nestingLevel:Int, ?module:String);
    InvalidSyntax(string:String, nestingLevel:Int, ?module:String);
    Condition(type:String, condition:Token, body:Array<Token>, nestingLevel:Int, ?module:String);
}