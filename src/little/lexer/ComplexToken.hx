package little.lexer;

enum ComplexToken {
    DefinitionDeclaration(line:Int, name:String, complexValue:String, ?type:String);
    Assignment(line:Int, value:String, assignees:Array<String>);
}

enum TokenLevel1 {
    SetLine(line:Int);
    NextLine;

    DefinitionDeclaration(name:String, value:TokenLevel1, ?type:String);   
    DefinitionAccess(name:String);
    Assignment(value:TokenLevel1, assignee:TokenLevel1);
    Parameter(name:String, type:String, value:TokenLevel1);
    ActionCall(name:String, params:Array<TokenLevel1>);

}