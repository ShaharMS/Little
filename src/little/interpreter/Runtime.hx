package little.interpreter;

import haxe.EnumTools;
import little.parser.Tokens.ParserTokens;
import little.parser.Parser;
import haxe.extern.EitherType;
import little.parser.Tokens.UnInfoedParserTokens;

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
        The next token to be interpreted
    **/
    public static var currentToken(default, null):ParserTokens;

    /**
        The token that has just been interpreted
    **/
    public static var previousToken(default, null):ParserTokens;

    public static var exitCode(default, null):Int = 0;
    

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

        @param module the module from which the error was thrown.
        @param line the line from which the error was thrown.
        @param title The error's title. When a non-`Error(title, reason)` token is thrown, this value is empty.
        @param reason The contents of the error.
    **/
    public static var onErrorThrown:(String, Int, String, String) -> Void;

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
    public static function throwError(token:ParserTokens, ?layer:Layer = INTERPRETER) {

        callStack.push(token);
        
        stdout += '\nLine $line: ';
        var module:String, title:String = "", reason:String;
        var content = switch token {
            case StaticValue(value, "", _, moduleName): {
                module = moduleName;
                reason = value;
                '${if (Little.debug) (layer : String).toUpperCase() + " " else ""}Module $moduleName, Line $line: ' +  value;
            }
            case Error(t, value, _, moduleName): {
                module = moduleName;
                title = t;
                reason = value;
                '${if (Little.debug) (layer : String).toUpperCase() + " " else ""}Module $moduleName, Line $line: $t:\n\t$value';
            }
            case _: {
                module = token.getParameters()[token.getParameters().length - 1];
                reason = Std.string(token);
                '${if (Little.debug) (layer : String).toUpperCase() + " " else ""}Module ${token.getParameters()[token.getParameters().length - 1]}, Line $line:  ${token}';
            }
        }
        stdout += '\nLine $line: ' + content;
        exitCode = EnumValueTools.getIndex(cast layer);
        onErrorThrown(module, line, title, reason);
    }
}