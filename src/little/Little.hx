package little;

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
        Interpreter.interpret(Parser.signWithModule(Parser.assignNesting(Parser.typeTokens(Lexer.splitBlocks1(Lexer.lexIntoComplex(code)))), name));
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
    **/
    public static function run(code:String) {
        Interpreter.errorThrown = false;
        Runtime.line = 0;
        Runtime.callStack = [];
        Runtime.stdout = "";
        Interpreter.interpret(Parser.signWithModule(Parser.assignNesting(Parser.typeTokens(Lexer.splitBlocks1(Lexer.lexIntoComplex(code)))), MAIN_MODULE_NAME));
        Interpreter.memory = [];
    }

    public static function registerVariable() {
        
    }

    // public static function registerFunction(actionName:String, ?actionModuleName:String, expectedParameters:Array<RegisteredParameter>, callback:Array<RegisteredParameter> -> Void) {
    //     var moduleName = actionModuleName == null ? REGISTERED_MODULE_NAME : actionModuleName;
    //     var parameters = [for (param in expectedParameters) Parameter(param.name, param.type, StaticValue(param.defaultValue), 1, moduleName)];
    // }

    public static function registerClass() {
        
    }
}

typedef RegisteredParameter = {name:String, type:String, defaultValue:Dynamic}