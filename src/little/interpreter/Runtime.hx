package little.interpreter;

import little.parser.Parser;
import haxe.extern.EitherType;
import little.parser.Tokens.ParserTokens;

using StringTools;
using TextTools;

/**
	A class containing values and callbacks related to Little's runtime.
**/
@:access(little.interpreter.Interpreter)
class Runtime {
    
    /**
    	The line currently interpreted.
    **/
    public static var line(default, null):Int = 0;

    /**
    	Dispatches every time the interpreter finishes running a line of code.

        @param line The line the interpreter just finished running.
    **/
    public static var onLineChanged:Int -> Void;

    /**
    	Dispatches after finishing interpreting a token.

        #### - What is a token?

        In order for Little to run your code from a string, it has to 
        
         - first, extract the useful content ot of the string
         - then, extract more information from the useful content we've just extracted
         - and only then, iterate over the tokens in order to run the code

        After each iteration, this method gets called, passing the token we've just parsed as an argument.
    **/
    public static var onTokenInterpreted:ParserTokens -> Void;

    /**
    	Dispatches right after an error is thrown, and printed to the console.

        @param title The error's title. When a non-`Error(title, reason)` token is thrown, this value is empty.
        @param reason The contents of the error.
    **/
    public static var onErrorThrown:(String, String) -> Void;

    /**
    	A string, containing everything that was printed to the console during the program's runtime.
    **/
    public static var stdout:String;

    /**
    	Contains every function call interpreted during the program's runtime.
    **/
    public static var callStack:Array<ParserTokens> = [];

    /**
    	Stops the execution of the program, and prints an error message to the console. Dispatches `onErrorThrown`.
    	@param error 
    **/
    public static function throwError(error:EitherType<ParserTokens, String>) {
        var token = if (error is String) StaticValue(error, "") else error;

        callStack.push(token);
        
        stdout += '\nLine $line: ';
        var content = switch token {
            case StaticValue(value, ""): value;
            case Error(title, value): 'Uncaught Error - $title:\n\t$value';
            case _: Parser.prettyPrintAst([token]).replaceFirst("Ast", "Error");
        }
        stdout += '\nLine $line: ' + content;
        Interpreter.errorThrown = true;
        onErrorThrown(
            switch token {
                case Error(title, reason): title;
                case _: "";
            },
            switch token {
                case StaticValue(value, ""): value;
                case Error(title, value): value;
                case _: Parser.prettyPrintAst([token]).replaceFirst("Ast", "Error").replaceFirst("\n\n", "");
            }
        );
    }
}