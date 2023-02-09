package little.lexer;

import haxe.extern.EitherType;

enum ComplexToken {
    DefinitionCreationDetails(line:Int, name:String, complexValue:String, ?type:String);
    ActionCreationDetails(line:Int, name:String, parameters:String, actionBody:EitherType<Array<ComplexToken>, String>, ?type:String);
    Assignment(line:Int, value:String, assignees:Array<String>);
    ConditionStatement(line:Int, type:String, conditionExpression:String, conditionBody:EitherType<Array<ComplexToken>, String>);
    GenericExpression(line:Int, exp:String);
}

enum LexerTokens {
    SetLine(line:Int);

    DefinitionCreation(name:String, value:LexerTokens, ?type:String);   
    ActionCreation(name:String, params:Array<LexerTokens>, body:Array<LexerTokens>, ?type:String);
    DefinitionAccess(name:String);
    DefinitionWrite(assignee:String, value:LexerTokens);
    Sign(sign:String);
    StaticValue(value:String);
    Expression(parts:Array<LexerTokens>);
    Parameter(name:String, ?type:String, value:LexerTokens);
    ActionCallParameter(value:LexerTokens);
    ActionCall(name:String, params:Array<LexerTokens>);
    Return(value:LexerTokens);
    InvalidSyntax(string:String);
    Condition(type:String, condition:LexerTokens, body:Array<LexerTokens>);
}