package little.lexer;

enum ComplexToken {
    DefinitionCreationDetails(line:Int, name:String, complexValue:String, ?type:String);
    ActionCreationDetails(line:Int, name:String, parameters:String, actionBody:Array<ComplexToken>, ?type:String);
    Assignment(line:Int, value:String, assignees:Array<String>);
    ConditionStatement(line:Int, type:String, conditionExpression:String, conditionBody:Array<ComplexToken>);
    GenericExpression(line:Int, exp:String);
}

enum TokenLevel1 {
    SetLine(line:Int);

    DefinitionCreation(name:String, value:TokenLevel1, ?type:String);   
    ActionCreation(name:String, params:Array<TokenLevel1>, body:Array<TokenLevel1>, ?type:String);
    DefinitionAccess(name:String);
    DefinitionWrite(assignee:String, value:TokenLevel1);
    Sign(sign:String);
    StaticValue(value:String);
    Expression(parts:Array<TokenLevel1>);
    Parameter(name:String, type:String, value:TokenLevel1);
    ActionCallParameter(value:TokenLevel1);
    ActionCall(name:String, params:Array<TokenLevel1>);
    Return(value:TokenLevel1);
    InvalidSyntax(string:String);
    Condition(type:String, condition:TokenLevel1, body:Array<TokenLevel1>);
}