package little.parser;

import haxe.xml.Parser;

enum UnInfoedParserTokens {
    SetLine(line:Int);

    DefinitionCreation(name:String, value:UnInfoedParserTokens, type:String);   
    ActionCreation(name:String, params:Array<UnInfoedParserTokens>, body:Array<UnInfoedParserTokens>, type:String);
    DefinitionAccess(name:String);
    DefinitionWrite(assignee:String, value:UnInfoedParserTokens, valueType:String);
    Sign(sign:String);
    StaticValue(value:String, type:String);
    Expression(parts:Array<UnInfoedParserTokens>, type:String);
    Parameter(name:String, type:String, value:UnInfoedParserTokens);
    ActionCallParameter(value:UnInfoedParserTokens, type:String);
    ActionCall(name:String, params:Array<UnInfoedParserTokens>, returnType:String);
    Return(value:UnInfoedParserTokens, type:String);
    Error(title:String, reason:String);
    InvalidSyntax(string:String);
    Condition(type:String, condition:UnInfoedParserTokens, body:Array<UnInfoedParserTokens>);
}

enum ParserTokens {
    SetLine(line:Int, nestingLevel:Int, ?module:String);
    DefinitionCreation(name:String, value:ParserTokens, type:String, nestingLevel:Int, ?module:String);
    ActionCreation(name:String, params:Array<ParserTokens>, body:Array<ParserTokens>, type:String, nestingLevel:Int, ?module:String);
    DefinitionAccess(name:String, nestingLevel:Int, ?module:String);
    DefinitionWrite(assignee:String, value:ParserTokens, valueType:String, nestingLevel:Int, ?module:String);
    Sign(sign:String, nestingLevel:Int, ?module:String);
    StaticValue(value:String, type:String, nestingLevel:Int, ?module:String);
    Expression(parts:Array<ParserTokens>, type:String, nestingLevel:Int, ?module:String);
    Parameter(name:String, type:String, value:ParserTokens, nestingLevel:Int, ?module:String);
    ActionCallParameter(value:ParserTokens, type:String, nestingLevel:Int, ?module:String);
    ActionCall(name:String, params:Array<ParserTokens>, returnType:String, nestingLevel:Int, ?module:String);
    Return(value:ParserTokens, type:String, nestingLevel:Int, ?module:String);
    Error(title:String, reason:String, nestingLevel:Int, ?module:String);
    InvalidSyntax(string:String, nestingLevel:Int, ?module:String);
    Condition(type:String, condition:ParserTokens, body:Array<ParserTokens>, nestingLevel:Int, ?module:String);
}