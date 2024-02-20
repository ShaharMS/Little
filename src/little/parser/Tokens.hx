package little.parser;

import little.interpreter.Tokens.InterpTokens;
import little.parser.Parser;

enum ParserTokens {

    SetLine(line:Int);
    SplitLine;

    Variable(name:ParserTokens, type:ParserTokens, ?doc:ParserTokens);
    Function(name:ParserTokens, params:ParserTokens, type:ParserTokens, ?doc:ParserTokens);
    ConditionCall(name:ParserTokens, exp:ParserTokens, body:ParserTokens);

    Read(name:ParserTokens);
    Write(assignees:Array<ParserTokens>, value:ParserTokens);

    Identifier(word:String);
    TypeDeclaration(value:ParserTokens, type:ParserTokens);
    FunctionCall(name:ParserTokens, params:ParserTokens);
    Return(value:ParserTokens, type:ParserTokens);

    Expression(parts:Array<ParserTokens>, type:ParserTokens);
    Block(body:Array<ParserTokens>, type:ParserTokens);
    PartArray(parts:Array<ParserTokens>);

    PropertyAccess(name:ParserTokens, property:ParserTokens);

    Sign(sign:String);
    Number(num:String);
    Decimal(num:String);
    Characters(string:String);

	/**
		Documentation strings
	**/
	Documentation(doc:String);

    /**
    	Used for errors & warnings
    **/
    ErrorMessage(msg:String);

    NullValue;
    TrueValue;
    FalseValue;

	/**
		A custom token, if you want to implement macros with special syntax.
		You can match against your custom token using this syntax:

			switch token {
				case Custom("TokenName", [param1, param2]): {
					// do something
				}
				case Custom("IntHaver", [num]) if (num.match(Number(_))):
				case Custom("SimpleToken", []):
				case Custom("AnotherToken", enumParameters):
			}
	**/
	Custom(name:String, params:Array<ParserTokens>);
}