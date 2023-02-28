package refactored_little.parser;

import refactored_little.parser.Parser;

enum ParserTokens {

    SetLine(line:Int);
    SplitLine;

    Define(name:ParserTokens, type:ParserTokens);
    Action(name:ParserTokens, params:ParserTokens, type:ParserTokens);
    Condition(name:ParserTokens, exp:ParserTokens, body:ParserTokens, type:ParserTokens);

    Read(name:ParserTokens);
    Write(assignees:Array<ParserTokens>, value:ParserTokens, type:ParserTokens);

    Identifier(word:String);
    TypeDeclaration(type:ParserTokens);
    ActionCall(name:ParserTokens, params:ParserTokens);
    Return(value:ParserTokens, type:ParserTokens);

    Expression(parts:Array<ParserTokens>, type:ParserTokens);
    Block(body:Array<ParserTokens>, type:ParserTokens);
    PartArray(parts:Array<ParserTokens>);

    Parameter(name:ParserTokens, type:ParserTokens);

    Sign(sign:String);
    Number(num:String);
    Decimal(num:String);
    Characters(string:String);

    NullValue;
    TrueValue;
    FalseValue;
}