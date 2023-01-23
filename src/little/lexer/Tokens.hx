package little.lexer;

enum ComplexToken {
    DefinitionDeclaration(line:Int, name:String, complexValue:String, ?type:String);
    Assignment(line:Int, value:String, assignees:Array<String>);
}

enum TokenLevel1 {
    SetLine(line:Int);

    DefinitionDeclaration(name:String, value:TokenLevel1, ?type:String);   
    DefinitionAccess(name:String);
    DefinitionWrite(assignee:String, value:TokenLevel1);
    Sign(sign:String);
    StaticValue(value:String);
    Calculation(parts:Array<TokenLevel1>);
    Parameter(name:String, type:String, value:TokenLevel1);
    ActionCall(name:String, params:Array<TokenLevel1>);
    InvalidSyntax(string:String);
}