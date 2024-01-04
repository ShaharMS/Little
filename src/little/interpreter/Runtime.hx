package little.interpreter;

import little.lexer.Lexer;
import little.interpreter.memory.MemoryObject;
import little.interpreter.memory.MemoryTree;
import haxe.EnumTools;
import little.parser.Tokens.ParserTokens;
import little.parser.Parser;
import haxe.extern.EitherType;
import little.parser.Tokens.ParserTokens;
import little.tools.Layer;

using StringTools;
using little.tools.TextTools;

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
    	The program's memory tree
    **/
    public static var memory:MemoryTree = Interpreter.memory;

    /**
        The next token to be interpreted
    **/
    public static var currentToken(default, null):ParserTokens = /*Module(Identifier(Little.keywords.MAIN_MODULE_NAME))*/ null; //todo

    /**
    	The module in which tokens are currently interpreted.
    **/
    public static var currentModule(default, null):String;

    /**
        The token that has just been interpreted
    **/
    public static var previousToken(default, null):ParserTokens;

    /**
        | Code | Description |
        | :---:| ---         |
        | **0** | Everything went fine, aside from potential warnings. |
        | **1** | An error was thrown, and terminated the program. The error is printed to stdout, and its token is kept after the fact in `Runtime.errorToken`. |
    **/
    public static var exitCode(default, null):Int = 0;
    
    /**
        The last error that was thrown. On normal settings, gets set at the same time the program terminates.
    **/
    public static var errorToken(default, null):ParserTokens;

    /**
    	Dispatches every time the interpreter finishes running a line of code.

        @param line The line the interpreter just finished running.
    **/
    public static var onLineChanged:Array<Int -> Void> = [];

    /**
    	Dispatches after finishing interpreting a token.

        #### - What is a token?

        In order for Little to run your code from a string, it has to 
        
         - first, extract the useful content ot of the string
         - then, extract more information from the useful content we've just extracted
         - and only then, iterate over the tokens in order to run the code

        After each iteration, this method gets called, passing the token we've just parsed as an argument.
    **/
    public static var onTokenInterpreted:Array<ParserTokens -> Void> = [];

    /**
    	Dispatches right after an error is thrown, and printed to the console.

        @param module the module from which the error was thrown.
        @param line the line from which the error was thrown.
        @param title The error's title. When a non-`Error(title, reason)` token is thrown, this value is empty.
        @param reason The contents of the error.
    **/
    public static var onErrorThrown:Array<(String, Int, String, String) -> Void> = [];

    /**
    	The program's standard output.
    **/
    public static var stdout = StdOut;

    /**
    	Contains every function call interpreted during the program's runtime.
    **/
    public static var callStack:Array<ParserTokens> = [];

    /**
    	Stops the execution of the program, and prints an error message to the console. Dispatches `onErrorThrown`.
        @param token some token which is the error, usually `ErrorMessage`
        @param layer the "stage" from which the error was called
        @return the token that caused the error (the first parameter of this function)
        **/
    public static function throwError(token:ParserTokens, ?layer:Layer = INTERPRETER):ParserTokens {

        callStack.push(token);
        
        var module:String = currentModule, title:String = "", reason:String;
        var content = switch token {
            case _: {
                reason = Std.string(token).remove(token.getName()).substring(1).replaceLast(")", "");
                '${if (Little.debug) (layer : String).toUpperCase() + ": " else ""}ERROR: Module ${currentModule}, Line $line:  ${reason}';
            }
        }
        stdout.output += '\n$content';
		stdout.stdoutTokens.push(token);
        exitCode = Layer.getIndexOf(layer);
        errorToken = token;
        Interpreter.errorThrown = true;        
        for (func in onErrorThrown) func(module, line, title, reason);

        return token;
    }

    /**
        Same as `throwError`, but doesnt stop execution, and has the "WARNING" prefix.
        @param token some token which is the error, usually `ErrorMessage`
        @param layer the "stage" from which the error was called
    **/
    public static function warn(token:ParserTokens, ?layer:Layer = INTERPRETER) {
        callStack.push(token);
        
        var reason:String;
        var content = switch token {
            case _: {
                reason = Std.string(token).remove(token.getName()).substring(1).replaceLast(")", "");
                '${if (Little.debug) (layer : String).toUpperCase() + ": " else ""}WARNING: Module ${currentModule}, Line $line:  ${reason}';
            }
        }
        stdout.output += '\n$content';
		stdout.stdoutTokens.push(token);
    }

    public static function print(item:String) {
        stdout.output += '\n${if (Little.debug) (INTERPRETER : String).toUpperCase() + ": " else ""}Module $currentModule, Line $line:  $item';
		stdout.stdoutTokens.push(Characters(item));
	}

    public static function broadcast(item:String) {
        stdout.output += '\n${if (Little.debug) "BROADCAST: " else ""}${item}';
		stdout.stdoutTokens.push(Characters(item));
    }

	static function __broadcast(item:String) {
        stdout.output += '\n${if (Little.debug) "BROADCAST: " else ""}${item}';		
	}

	static function __print(item:String, representativeToken:ParserTokens) {
		stdout.output += '\n${if (Little.debug) (INTERPRETER : String).toUpperCase() + ": " else ""}Module $currentModule, Line $line:  $item';
		stdout.stdoutTokens.push(representativeToken);
	}

    /**
        Tries to access the value stored on an object denoted by `obj`.  
        usage of property access (`thing.other`, `SomeClass.property`) is allowed.
        When a multi-item expression is given (`"something" + 1`), only the first 
        item of the expression will get taken into account (in this case, `"something"`.)
        @param obj the name of the variable
        @return MemoryObject, or null if it wasn't found
    **/
    public static function access(obj:String):MemoryObject {
        return Interpreter.accessObject(Parser.parse(Lexer.lex(obj))[0]);
    }
}