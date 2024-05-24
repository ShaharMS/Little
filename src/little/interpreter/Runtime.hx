package little.interpreter;

import little.tools.PrettyPrinter;
import little.interpreter.Tokens.InterpTokens;
import little.tools.Layer;

using StringTools;
using little.tools.TextTools;
using little.tools.Extensions;

/**
	A class containing values and callbacks related to Little's runtime.
**/
@:access(little.interpreter.Interpreter)
class Runtime {
    
    public function new() {}

    /**
    	The line currently interpreted.
    **/
    public var line(default, null):Int = 0;

    /**
        The currently interpreted part of a line, split by `,` or `;`
    **/
    public var linePart(default, null):Int = 0;

    /**
        The next token to be interpreted
    **/
    public var currentToken(default, null):InterpTokens = null;

    /**
    	The module in which tokens are currently interpreted.
    **/
    public var module(default, null):String;

    /**
        The token that has just been interpreted
    **/
    public var previousToken(default, null):InterpTokens;

    /**
        | Code | Description |
        | :---:| ---         |
        | **0** | Everything went fine, aside from potential warnings. |
        | **1** | An error was thrown, and terminated the program. The error is printed to stdout, and its token is kept after the fact in `Little.runtime.errorToken`. |
    **/
    public var exitCode(default, null):Int = 0;

	/**
		This is set to `true` if an error was thrown. Execution should stop.
	**/
	public var errorThrown(default, null):Bool = false;
    
    /**
        The last error that was thrown. On normal settings, gets set at the same time the program terminates.
    **/
    public var errorToken(default, null):InterpTokens;

    /**
    	Dispatches right before the interpreter starts running a line of code.

        @param line The line the interpreter just finished running.
    **/
    public var onLineChanged:Array<Int -> Void> = [];

	/**
	    Dispatches right after the interpreter switches between running module.

        This can happen when code from another file is suddenly ran, for example, 
        from a function call.

        @param previous The module the interpreter just switched from.
	**/
    public var onModuleChanged:Array<String -> Void> = [];
	
	/**
		Dispatches every time the interpreter finds a line splitter (`,` or `;`)

		@param line The line the interpreter just finished running.
	**/
	public var onLineSplit:Array<Void -> Void> = [];

    /**
		Dispatches after finishing interpreting a token.

		#### - What is a token?

		In order for Little to run your code from a string, it has to 
				
		 - first, extract the useful content ot of the string
		 - then, extract more information from the useful content we've just extracted
		 - and only then, iterate over the tokens in order to run the code

		After each iteration, this method gets called, passing the token we've just parsed as an argument.

		@param token The token that was just interpreted. Note - expressions (`()`) are passed as is, and may contain multiple tokens.
    **/
    public var onTokenInterpreted:Array<InterpTokens -> Void> = [];

    /**
    	Dispatches right after an error is thrown, and printed to the standard output.

        @param module the module from which the error was thrown.
        @param line the line from which the error was thrown.
        @param reason The contents of the error.
    **/
    public var onErrorThrown:Array<(String, Int, String) -> Void> = [];

    /**
        Dispatches right after a warning is printed to the standard output

        @param module the module from which the warning was printed.
        @param line the line form which the warning was printed
        @param reason the contents of the warning

    **/
    public var onWarningPrinted:Array<(String, Int, String) -> Void> = [];

    /**
    	Dispatches right after the program has written something to a variable/multiple variables.
    
        @param variables The variables that were written to. Value can be retrieved using `memory.read()`.
    **/
    public var onWriteValue:Array<Array<String> -> Void> = [];

    /**
    	Dispatches right before a function is called, and before it is added to the callstack.

		Useful when used with the `line`, `linePart` and `module` properties.
			
		@param name The name of the function, may include module/object name.
		@param parameters The parameters the function was called with.
    **/
	public var onFunctionCalled:Array<(String, Array<InterpTokens>) -> Void> = [];

	/**
		Dispatches right before a condition is called.

		Useful when used with the `line`, `linePart` and `module` properties.

		@param name The name of the condition, may include module/object name.
		@param parameters The parameters the condition was called with. 
		@param body The body of the condition. Is either a `Block` containing code, or another single token.
	**/
	public var onConditionCalled:Array<(String, Array<InterpTokens>, InterpTokens) -> Void> = [];

	/**
		Dispatches right after a field is declared & written to memory.

		Listeners are not triggered on external variable/function declarations.

		@param name The name of the field. Includes full path (`object.a.c`, `b`)
		@param fieldType The type of the field (variable, function, etc.)
	**/
	public var onFieldDeclared:Array<(String, FieldDeclarationType) -> Void> = [];

    /**
        Dispatches right after a value has successfully casted to a type.
        
        @param value the pre-casted value, which is castable to the type
        @param type the type the value was casted to. Given as a string, containing the path to the type.
    **/
    public var onTypeCast:Array<(InterpTokens, String) -> Void> = [];

    /**
    	The program's standard output.
    **/
    public var stdout:StdOut = new StdOut();

    /**
    	Contains every function call interpreted during the program's runtime.
    **/
    public var callStack:Array<{module:String, line:Int, linePart:Int, token:InterpTokens}> = [];

    /**
    	Stops the execution of the program, and prints an error message to the console. Dispatches `onErrorThrown`.
        @param token some token which is the error, usually `ErrorMessage`
        @param layer the "stage" from which the error was called
        @return the token that caused the error (the first parameter of this function)
        **/
    public function throwError(token:InterpTokens, ?layer:Layer = INTERPRETER):InterpTokens {

        
        var mod:String = module, reason:String;
        var content = switch token {
            case _: {
                reason = Std.string(token).remove(token.getName()).substring(1).replaceLast(")", "");
                '${if (Little.debug) (layer : String).toUpperCase() + ": " else ""}ERROR: Module ${module}, Line $line:  ${reason}';
            }
        }
        stdout.output += '\n$content\n';
        stdout.output += callStack.map(obj -> '\tCalled from Module ${obj.module}, Line ${obj.line} (part ${obj.linePart}): ${PrettyPrinter.stringifyInterpreter(obj.token)}').join('\n');
		stdout.stdoutTokens.push(token);

        callStack.push({module: module, line: line, linePart: linePart, token: token});

        exitCode = Layer.getIndexOf(layer);
        errorToken = token;
        errorThrown = true;        
        for (func in onErrorThrown) func(mod, line, reason);

        throw token; // Currently, no flag exists that disables immediate quitting, so this is fine.

        return token;
    }

    /**
        Same as `throwError`, but doesn't stop execution, and has the "WARNING" prefix.
        @param token some token which is the error, usually `ErrorMessage`
        @param layer the "stage" from which the error was called
    **/
    public function warn(token:InterpTokens, ?layer:Layer = INTERPRETER) {
        callStack.push({module: module, line: line, linePart: linePart, token: token});
        
        var reason:String;
        var content = switch token {
            case _: {
                reason = Std.string(token).remove(token.getName()).substring(1).replaceLast(")", "");
                '${if (Little.debug) (layer : String).toUpperCase() + ": " else ""}WARNING: Module ${module}, Line $line:  ${reason}';
            }
        }
        stdout.output += '\n$content';
		stdout.stdoutTokens.push(token);
        for (func in onWarningPrinted) func(module, line, reason);
    }

    /**
    	Prints a Haxe string to `Little`'s standard output.
    	@param item 
    **/
    public function print(item:String) {
        stdout.output += '\n${if (Little.debug) (INTERPRETER : String).toUpperCase() + ": " else ""}Module $module, Line $line:  $item';
		stdout.stdoutTokens.push(Characters(item));
	}

    /**
    	Prints a Haxe string to `Little`'s standard output, without any positional information.
		On `Little.debug` mode, the string will be prefixed with `BROADCAST: `. 
    **/
    public dynamic function broadcast(item:String) {
        stdout.output += '\n${if (Little.debug) "BROADCAST: " else ""}${item}';
		stdout.stdoutTokens.push(Characters(item));
    }

	/**
		Quiet broadcast, without addition to stdoutTokens 
	**/
	dynamic function __broadcast(item:String) {
        stdout.output += '\n${if (Little.debug) "BROADCAST: " else ""}${item}';		
	}

	/**
		A special type of `print`, which allows addition of custom tokens to stdoutTokens.
	**/
	function __print(item:String, representativeToken:InterpTokens) {
		stdout.output += '\n${if (Little.debug) (INTERPRETER : String).toUpperCase() + ": " else ""}Module $module, Line $line:  $item';
		stdout.stdoutTokens.push(representativeToken);
	}
}

/**
	Types of field declarations.
**/
enum FieldDeclarationType {
	VARIABLE;
	FUNCTION;
	CONDITION;
	CLASS;
	OPERATOR;
}