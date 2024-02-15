package little.interpreter;

import little.interpreter.Tokens.InterpTokens;
import little.interpreter.memory.Memory;
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
    	The program's memory manager.
    **/
    public static var memory:Memory = Little.memory;
    /**
        The next token to be interpreted
    **/
    public static var currentToken(default, null):InterpTokens = null;

    /**
    	The module in which tokens are currently interpreted.
    **/
    public static var currentModule(default, null):String;

    /**
        The token that has just been interpreted
    **/
    public static var previousToken(default, null):InterpTokens;

    /**
        | Code | Description |
        | :---:| ---         |
        | **0** | Everything went fine, aside from potential warnings. |
        | **1** | An error was thrown, and terminated the program. The error is printed to stdout, and its token is kept after the fact in `Runtime.errorToken`. |
    **/
    public static var exitCode(default, null):Int = 0;

	/**
		This is set to `true` if an error was thrown. Execution should stop.
	**/
	public static var errorThrown(default, null):Bool = false;
    
    /**
        The last error that was thrown. On normal settings, gets set at the same time the program terminates.
    **/
    public static var errorToken(default, null):InterpTokens;

    /**
    	Dispatches right before the interpreter starts running a line of code.

        @param line The line the interpreter just finished running.
    **/
    public static var onLineChanged:Array<Int -> Void> = [];
	
	/**
		Dispatches every time the interpreter finds a line splitter (`,` or `;`)

		@param line The line the interpreter just finished running.
	**/
	public static var onLineSplit:Array<Void -> Void> = [];

    /**
    	Dispatches after finishing interpreting a token.

        #### - What is a token?

        In order for Little to run your code from a string, it has to 
        
         - first, extract the useful content ot of the string
         - then, extract more information from the useful content we've just extracted
         - and only then, iterate over the tokens in order to run the code

        After each iteration, this method gets called, passing the token we've just parsed as an argument.
    **/
    public static var onTokenInterpreted:Array<InterpTokens -> Void> = [];

    /**
    	Dispatches right after an error is thrown, and printed to the console.

        @param module the module from which the error was thrown.
        @param line the line from which the error was thrown.
        @param title The error's title. When a non-`Error(title, reason)` token is thrown, this value is empty.
        @param reason The contents of the error.
    **/
    public static var onErrorThrown:Array<(String, Int, String, String) -> Void> = [];

    /**
    	Dispatches right after the program has written something to a variable/multiple variables.
    
        @param variables The variables that were written to. Value can be retrieved using `memory.read()`.
    **/
    public static var onWriteValue:Array<Array<String> -> Void> = [];
    /**
    	The program's standard output.
    **/
    public static var stdout = StdOut;

    /**
    	Contains every function call interpreted during the program's runtime.
    **/
    public static var callStack:Array<InterpTokens> = [];

    /**
    	Stops the execution of the program, and prints an error message to the console. Dispatches `onErrorThrown`.
        @param token some token which is the error, usually `ErrorMessage`
        @param layer the "stage" from which the error was called
        @return the token that caused the error (the first parameter of this function)
        **/
    public static function throwError(token:InterpTokens, ?layer:Layer = INTERPRETER):InterpTokens {

        trace('Thrown: $token');
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
        errorThrown = true;        
        for (func in onErrorThrown) func(module, line, title, reason);

        return token;
    }

    /**
        Same as `throwError`, but doesnt stop execution, and has the "WARNING" prefix.
        @param token some token which is the error, usually `ErrorMessage`
        @param layer the "stage" from which the error was called
    **/
    public static function warn(token:InterpTokens, ?layer:Layer = INTERPRETER) {
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

	static function __print(item:String, representativeToken:InterpTokens) {
		stdout.output += '\n${if (Little.debug) (INTERPRETER : String).toUpperCase() + ": " else ""}Module $currentModule, Line $line:  $item';
		stdout.stdoutTokens.push(representativeToken);
	}
}