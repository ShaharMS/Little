package little.lexer;

enum ComplexToken {
    DefinitionDeclaration(name:String, complexValue:String, ?type:String);
}