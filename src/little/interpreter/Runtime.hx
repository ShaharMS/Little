package little.interpreter;

import haxe.extern.EitherType;
import little.parser.Tokens.ParserTokens;

/**
	A class containing values and callbacks related to Little's runtime.
**/
class Runtime {
    
    /**
    	The line currently interpreted.
    **/
    public static var line(default, null):Int = 0;

    /**
    	Dispatches every time the interpreter finishes running a line of code.

        @param line The line the interpreter just finished running.
    **/
    public static var onLineChanged:Int -> Void = (i) -> return;

    /**
    	Dispatches after finishing interpreting a token.

        #### - What is a token?

        In order for Little to run your code from a string, it has to 
        
         - first, extract the useful content ot of the string
         - then, extract more information from the useful content we've just extracted
         - and only then, iterate over the tokens in order to run the code

        After each iteration, this method gets called, passing the token we've just parsed as an argument.
    **/
    public static var onTokenInterpreted:ParserTokens -> Void = (t) -> return;

    public static var stdout:String;

    public static function throwError(error:EitherType<ParserTokens, String>) {
        var token = if (error is String) StaticValue(error, "") else error;
    }
}