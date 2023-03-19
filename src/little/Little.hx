package little;

import haxe.extern.EitherType;
import little.interpreter.MemoryObject;
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
        Interpreter.memory = [];
        PrepareRun.addFunctions();
        PrepareRun.addConditions();
        Interpreter.interpret(Parser.parse(Lexer.lex(code)), {});
        if (debug != null) Little.debug = previous;
    }

    public static function registerVariable(variableName:String, ?variableModuleName:String, allowWriting:Bool = false, ?staticValue:ParserTokens, ?valueGetter:Void -> ParserTokens, ?valueSetter:ParserTokens -> ParserTokens) {
        Interpreter.memory[variableName] = new MemoryObject(
            External(params -> {
                var currentModuleName = runtime.currentModule;
                if (variableModuleName != null) runtime.currentModule = variableModuleName;
                return try {
                    var val = if (staticValue != null) staticValue;
                    else valueGetter();
                    runtime.currentModule = currentModuleName;
                    val;
                } catch (e) {
                    runtime.currentModule = currentModuleName;
                    ErrorMessage('External Variable Error: ' + e.details());
                }
            }), 
            [], 
            null,
            null, 
            true
        );

        if (valueSetter != null) {
            Interpreter.memory[variableName].valueSetter = function (v) {
                return Interpreter.memory[variableName].value = valueSetter(v);
            }
        }
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
    public static function registerFunction(actionName:String, ?actionModuleName:String, expectedParameters:EitherType<String, Array<ParserTokens>>, callback:Array<ParserTokens> -> ParserTokens) {
        var params = if (expectedParameters is String) {
            Parser.parse(Lexer.lex(expectedParameters));
        } else expectedParameters;

        var memObject = new MemoryObject(
            External(params -> {
                var currentModuleName = runtime.currentModule;
                if (actionModuleName != null) runtime.currentModule = actionModuleName;
                return try {
                    var val = callback(params);
                    runtime.currentModule = currentModuleName;
                    val;
                } catch (e) {
                    runtime.currentModule = currentModuleName;
                    ErrorMessage('External Function Error: ' + e.details());
                }
            }), 
            [], 
            expectedParameters, 
            null, 
            true
        );

        if (actionModuleName != null) {
            Interpreter.memory[actionModuleName] = new MemoryObject(Module(actionModuleName), [], null, Identifier(TYPE_MODULE), true);
            Interpreter.memory[actionModuleName].props[actionName] = memObject;
        } else Interpreter.memory[actionName] = memObject;
    }

    public static function registerCondition(conditionName:String, callback:(Array<ParserTokens>, Array<ParserTokens>) -> ParserTokens) {
        CONDITION_TYPES.push(conditionName);
        Interpreter.memory[conditionName] = new MemoryObject(
            External(params -> {
                return try {
                    callback(params[0].getParameters()[0], params[1].getParameters()[0]);
                } catch (e) {
                    ErrorMessage('External Function Error: ' + e.details());
                }
            }), 
            [], 
            null, 
            null, 
            true
        );
    }

    public static function registerHaxeClass() {
        
    }
}