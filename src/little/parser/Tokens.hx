package little.parser;

import haxe.xml.Parser;

enum ParserTokens {
    SetLine(line:Int);

    DefinitionCreation(name:String, value:ParserTokens, type:String);   
    ActionCreation(name:String, params:Array<ParserTokens>, body:Array<ParserTokens>, type:String);
    DefinitionAccess(name:String);
    DefinitionWrite(assignee:String, value:ParserTokens, valueType:String);
    Sign(sign:String);
    StaticValue(value:String, type:String);
    Expression(parts:Array<ParserTokens>, type:String);
    Parameter(name:String, type:String, value:ParserTokens);
    ActionCallParameter(value:ParserTokens, type:String);
    ActionCall(name:String, params:Array<ParserTokens>, returnType:String);
    Return(value:ParserTokens, type:String);
    Error(title:String, reason:String);
    InvalidSyntax(string:String);
    Condition(type:String, condition:ParserTokens, body:Array<ParserTokens>);
}