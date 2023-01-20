package little.lexer;

enum ComplexToken {
    DefinitionDeclaration(line:Int, name:String, complexValue:String, ?type:String);
}