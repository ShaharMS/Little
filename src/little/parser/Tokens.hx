package little.parser;

import little.parser.Parser;

enum ParserTokens {

    SetLine(line:Int);
    SplitLine;

    Variable(name:ParserTokens, type:ParserTokens, ?doc:ParserTokens);
    Function(name:ParserTokens, params:ParserTokens, type:ParserTokens, ?doc:ParserTokens);
    Condition(name:ParserTokens, exp:ParserTokens, body:ParserTokens);

    Read(name:ParserTokens);
    Write(assignees:Array<ParserTokens>, value:ParserTokens, type:ParserTokens);

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
    	Used for multi-module coding & better error reporting.
    **/
    Module(name:String);

    /**
    	Used for denoting an external var/func in the interpreter.
    **/
    External(get:Array<ParserTokens> -> ParserTokens);
    /**
    	Used for denoting external conditions in the interpreter
    **/
    ExternalCondition(use:(con:Array<ParserTokens>, body:Array<ParserTokens>) -> ParserTokens);

    /**
    	Used for errors & warnings
    **/
    ErrorMessage(msg:String);

    NullValue;
    TrueValue;
    FalseValue;

    /**
        Used for no-body conditions
    **/
    NoBody;
}