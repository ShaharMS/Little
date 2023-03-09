package little;

import little.tools.PrepareRun;
import little.parser.Tokens.ParserTokens;
import little.lexer.Lexer;
import little.parser.Parser;
import little.interpreter.Interpreter;
import little.interpreter.Runtime;
import little.Keywords.*;

@:access(little.interpreter.Interpreter)
@:access(little.interpreter.Runtime)
class Little {
    
    public static var runtime(default, null) = Runtime;

    public static var debug:Bool = false;

    /**
        Loads little code, without clearing memory, stdout & the callstack. useful if you want to 
        use multiple files/want to preload code for the end user to use.

        Notice - after calling this method, event listeners will dispatch (i.e. they're not exclusive to the `run()` method).

        @param code a string containing code written in Little.
        @param name a name to call the module, so it would be easily identifiable
    **/
    public static function loadModule(code:String, name:String) {
        Interpreter.errorThrown = false;
        Runtime.line = 0;
    }

    /**
        Runs a new Little program.  
        If you want to preload some more code, use the `Little.loadModule()` method before calling this.  
        to unload a loaded module , use `Little.unloadModule()` with the name of the module you wish to remove.  
        
         - **pay attention - all modules & registered elements are unloaded after each run.**

        If you want to use another keyword set (for example, to allow programming everything in spanish),
        make sure to set `currentKeywordSet` before calling this. If you want to use the default keywords with some changes,
        you can make some changes to the properties in `little.Keywords` instead.

        To register different types of "elements", such as definitions (variables), actions (functions), or even entire classes, you can use the various registration methods inside this class.
        
        If you want to add event listeners, to certain code interpretation events, check out the stats and listeners inside `Little.runtime`.
        
        @param code 
        @param debug specifically specify whether or not to print more debugging information. Overrides default `Little.debug`.
    **/
    public static function run(code:String, ?debug:Bool) {
        Interpreter.errorThrown = false;
        Runtime.line = 0;
        Runtime.callStack = [];
        Runtime.stdout = "";
        final previous = Little.debug;
        if (debug != null) Little.debug = debug;
        Interpreter.varMemory = [];
        Interpreter.funcMemory = [];
        PrepareRun.addFunctions();
        Interpreter.interpret(Parser.parse(Lexer.lex(code)), {});
        if (debug != null) Little.debug = previous;
    }

    public static function registerVariable() {
        
    }

    /**
    	Allows usage of a function written in haxe inside Little code.

    	@param actionName The name by which to identify the function
    	@param actionModuleName The module from which access to this function is granted. Also, when & if this function ever throws an error/prints to standard output, the name provided here will be present in the error message as the responsible module.
    	@param expectedParameters a `ParserTokens.PartArray` consisting of `ParserTokens.Define`s which contain the names & types of the parameters that should be passed on to the function. For example: 
            ```
            PartArray([Define])
            ```
    	@param callback 
    **/
    public static function registerFunction(actionName:String, ?actionModuleName:String, expectedParameters:ParserTokens, callback:ParserTokens -> ParserTokens) {
        Interpreter.externalFuncMemory[actionName] = (params) -> {
            if (actionModuleName != null) runtime.currentModule = actionModuleName;
            return callback(params);
        }
        Interpreter.funcMemory[actionName] = External(actionName);
        if (actionModuleName != null) {
            if (Interpreter.varMemory[actionModuleName] == null) {
                Interpreter.varMemory[actionModuleName] = PartArray([Action(Identifier(actionName), expectedParameters, null)]);
            } else if (Interpreter.varMemory[actionModuleName].getName() == "PartArray") {
                var props = Interpreter.varMemory[actionModuleName].getParameters()[0];
                props.push(Action(Identifier(actionName), expectedParameters, null));
                Interpreter.varMemory[actionModuleName] = PartArray(props);
            } else {
                // Todo: throw a "notice" instead of an error, telling the user the previous value of $actionModuleName has been overridden
                Interpreter.varMemory[actionModuleName] = PartArray([Action(Identifier(actionName), expectedParameters, null)]);
            }
        }
    }

    public static function registerClass() {
        
    }
}

typedef RegisteredParameter = {name:String, type:String, defaultValue:Dynamic}