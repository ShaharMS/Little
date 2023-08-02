package little.lexer;

enum LexerTokens {
    Identifier(name:String);
    Sign(char:String);
    Number(num:String);
    Boolean(value:String);
    Characters(string:String);
    NullValue;
    Newline;
    SplitLine;
    Documentation(content:String);
}