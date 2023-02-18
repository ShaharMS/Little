package refactored_little.parser;

enum ParserTokens {

    SetLine(line:Int);
    SplitLine;

    Define(name:ParserTokens, type:ParserTokens);
    Action(name:ParserTokens, params:Array<ParserTokens>, body:ParserTokens, type:ParserTokens);
    Condition(name:ParserTokens, exp:ParserTokens, body:ParserTokens, type:ParserTokens);

    Read(name:ParserTokens);
    Write(assignees:Array<ParserTokens>, value:ParserTokens, type:ParserTokens);

    Identifier(word:String);
    TypeDeclaration(type:ParserTokens);
    Return(value:ParserTokens);

    Expression(parts:Array<ParserTokens>, type:ParserTokens);
    Block(body:Array<ParserTokens>, type:ParserTokens);

    Parameter(name:ParserTokens, value:ParserTokens, type:ParserTokens);

    Sign(sign:String);
    Number(num:String);
    Decimal(num:String);
    Characters(string:String);

    NullValue;
    TrueValue;
    FalseValue;
}