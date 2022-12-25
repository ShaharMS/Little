package littleRefactored.lexer;

import littleRefactored.lexer.Tokens;

enum Tokens {
    Nothing;
    Module(name:String, value:Dynamic);
    Define(name:String, info:Tokens);
    Action(name:String, params:Array<Tokens>, body:Array<Tokens>);
    NewLine;
}