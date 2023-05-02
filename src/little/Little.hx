package little;

import little.tools.Plugins;
import haxe.extern.EitherType;
import little.interpreter.memory.MemoryObject;
import little.tools.PrepareRun;
import little.parser.Tokens.ParserTokens;
import little.lexer.Lexer;
import little.parser.Parser;
import little.interpreter.Interpreter;
import little.interpreter.Runtime;
import little.Keywords.*;

@:access(little.interpreter.Interpreter)
@:access(little.interpreter.Runtime)
@:expose
class Little {
    
    public static var runtime(default, null) = Runtime;
    public static var plugin(default, null) = Plugins;

    public static var debug:Bool = false;

    /**
        Loads little code, without clearing memory, stdout or the callstack. useful if you want to 
        use multiple files/want to preload code for the end user to use.

        Notice - after calling this method, event listeners will dispatch (i.e. they're not exclusive to the `run()` method).

        @param code a string containing code written in Little.
        @param name a name to call the module, so it would be easily identifiable
        @param runRightBeforeMain When set to true, instead of parsing and running the code right after this function is called, 
            we wait for `Little.run()` to get called, and then we parse and run this module right before the main module. Defaults to false.
    **/
    public static function loadModule(code:String, name:String, debug:Bool = false, runRightBeforeMain:Bool = false) {
        Interpreter.errorThrown = false;
        Runtime.line = 0;
        Runtime.currentModule = name;
        if (runRightBeforeMain) {

        } else {
            final previous = Little.debug;
            if (debug != null) Little.debug = debug;
            if (!PrepareRun.prepared) {
                PrepareRun.addTypes();
                PrepareRun.addFunctions();
                PrepareRun.addConditions();
                PrepareRun.addProps();
            }
            Interpreter.interpret(Parser.parse(Lexer.lex(code)), {});
            if (debug != null) Little.debug = previous;
        }
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
        Runtime.currentModule = Keywords.MAIN_MODULE_NAME;
        final previous = Little.debug;
        if (debug != null) Little.debug = debug;
        Interpreter.memory.underlying.map = [];
        if (!PrepareRun.prepared) {
            PrepareRun.addTypes();
            PrepareRun.addFunctions();
            PrepareRun.addConditions();
            PrepareRun.addProps();
        }
        Interpreter.interpret(Parser.parse(Lexer.lex(code)), {});
        if (debug != null) Little.debug = previous;
    }

}