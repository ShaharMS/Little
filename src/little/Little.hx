package little;

import little.tools.PrettyPrinter;
import little.interpreter.memory.Memory;
import little.interpreter.KeywordConfig;
import little.interpreter.Actions;
import little.interpreter.Operators;
import little.tools.Plugins;
import little.tools.PrepareRun;
import little.lexer.Lexer;
import little.parser.Parser;
import little.interpreter.Interpreter;
import little.interpreter.Runtime;
import little.Keywords.*;

@:access(little.interpreter.Interpreter)
@:access(little.interpreter.Runtime)
@:expose
class Little {
    
    public static var keywords(default, null):KeywordConfig = Keywords.defaultKeywordSet;

    public static var runtime(default, null) = Runtime;
    public static var operators(default, null) = Operators;
    public static var memory(default, null):Memory = new Memory();
    public static var plugin(default, null):Plugins = new Plugins(Little.memory);


    /**
    	When enabled:

		 - `print`, `error` and `warn` calls will contain the part of the lexer/parser/interpreter hat called them (see `little.tools.Layer`)
		 - All documentation will be stored in memory, and can be accessed via property `documentation` (for example `someObject.documentation`, `Class.documentation`).
    **/
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
        Runtime.errorThrown = false;
        Runtime.line = 0;
        Runtime.currentModule = name;
        if (runRightBeforeMain) {

        } else {
            final previous = Little.debug;
            if (debug != null) Little.debug = debug;
            if (!PrepareRun.prepared) {
                PrepareRun.addTypes();
				PrepareRun.addSigns();
                PrepareRun.addFunctions();
                PrepareRun.addConditions();
                PrepareRun.addProps();
            }
            Actions.run(Interpreter.convert(...Parser.parse(Lexer.lex(code))));
            if (debug != null) Little.debug = previous;
        }
    }

    /**
        Runs a new Little program.  
        If you want to preload some more code, use the `Little.loadModule()` method before calling this.
        
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
        final previous = Little.debug;
        if (debug != null) Little.debug = debug;
        if (!PrepareRun.prepared) {
            PrepareRun.addTypes();
			PrepareRun.addSigns();
            PrepareRun.addFunctions();
            PrepareRun.addConditions();
            PrepareRun.addProps();
        }
        Actions.run(Interpreter.convert(...Parser.parse(Lexer.lex(code))));
        if (debug != null) Little.debug = previous;
    }

	public static function reset() {
		Runtime.errorThrown = false;
        Runtime.line = 0;
        Runtime.callStack = [];
        Runtime.stdout.reset();
        Runtime.currentModule = Keywords.MAIN_MODULE_NAME;
		Operators.lhsOnly.clear();
		Operators.rhsOnly.clear();
		Operators.standard.clear();
		Operators.priority.clear();
		Little.memory.reset();
	}

}