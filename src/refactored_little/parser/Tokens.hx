package refactored_little.parser;

enum ParserTokens {

    SetLine(line:Int);
    SplitLine;

    Define(name:String, value:ParserTokens, type:String);
    Action(name:String, params:Array<ParserTokens>, body:ParserTokens, type:String);
    Condition(name:String, exp:ParserTokens, body:ParserTokens, type:String);

    Read(name:String);
    Write(assignees:Array<ParserTokens>, value:ParserTokens, type:String);

    Identifier(word:String);
    TypeDeclaration(type:String);
    Cast(value:ParserTokens, type:String);
    Return(value:ParserTokens);

    Expression(parts:Array<ParserTokens>, type:String);
    Block(body:Array<ParserTokens>, type:String);

    Parameter(name:String, value:ParserTokens, type:String);

    Sign(sign:String);
    Number(num:String);
    Decimal(num:String);
    Characters(string:String);

    NullValue;
    TrueValue;
    FalseValue;
}