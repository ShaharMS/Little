package little;

import little.interpreter.Tokens.InterpTokens;
import vision.ds.Queue;
import vision.helpers.VisionThread;
import little.tools.PrettyPrinter;
import little.interpreter.memory.Memory;
import little.tools.Plugins;
import little.tools.PrepareRun;
import little.lexer.Lexer;
import little.parser.Parser;
import little.interpreter.Interpreter;
import little.interpreter.Runtime;
import little.interpreter.memory.Operators;

@:access(little.interpreter.Interpreter)
@:access(little.interpreter.Runtime)
@:expose("Little")
class Little {
    
    /**
        A feature of the `Little` programming language is that it is possible to change keywords & other
        usually hardcoded properties.

        You can change the values here if you want to, or just 
    **/
    public static var keywords:KeywordConfig = {};

    /**
        Used to access runtime details of the current "running instance" of `Little`.

        Contains callbacks for operations, access to the callstack, and more.
    **/
    public static var runtime(default, null):Runtime = new Runtime();

    /**
        The independent memory manager. Allocates and deallocates variables, using
        gradually allocated byte arrays.
    **/
    public static var memory(default, null):Memory = new Memory();

    /**
        A portal that allows external interfacing with little code, both during and before runtime.

        You can add classes, variables, functions, and even operators.
    **/
    public static var plugin(default, null):Plugins = new Plugins(Little.memory);

    /**
		Another form of external interfacing, focused on operators.
    **/
    public static var operators(default, null):Operators = new Operators();

    /**
        Used to store code that is currently being ran/queued for running right before the main module using
        `runRightBeforeMain` in `Little.loadModule()`.
    **/
    public static var queue(default, null):Queue<String> = new Queue();


    /**
    	When enabled:

		 - `print`, `error` and `warn` calls will contain the part of the lexer/parser/interpreter hat called them (see `little.tools.Layer`)
    **/
    public static var debug:Bool = false;

    /**
        Indicates the version of the Little compiler & Interpreter.
        First number is the major version, second is the minor version, third is the patch.
    **/
    public static var version:String = "1.0.0-f";

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
        runtime.errorThrown = false;
        runtime.line = 0;
        runtime.module = name;
        if (runRightBeforeMain) {
			Little.queue.enqueue(code);
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
            Interpreter.run(Interpreter.convert(...Parser.parse(Lexer.lex(code))));
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
        try {
            final previous = Little.debug;
            if (debug != null) Little.debug = debug;
            if (!PrepareRun.prepared) {
                PrepareRun.addTypes();
		    	PrepareRun.addSigns();
                PrepareRun.addFunctions();
                PrepareRun.addConditions();
                PrepareRun.addProps();
            }
            runtime.module = keywords.MAIN_MODULE_NAME;
            runtime.errorThrown = false;
            runtime.line = 0;
			Little.queue.enqueue(code);
			for (item in Little.queue) {
				Interpreter.run(Interpreter.convert(...Parser.parse(Lexer.lex(item))));
			}
            if (debug != null) Little.debug = previous;
        } catch (e) {
            
            e.message == "Quitting..." ? trace(e.message) : trace(e.details());
        }
    }

    /**
        Converts a string of code written in Little into an array of tokens, representing an AST.

        This array can be compiled into bytecode using `ByteCode.compile`, or run
        on the spot using `Interpreter.run`.

        This function, `ByteCode.compile` and `Interpreter.run` do no error handling on their own.
        When using this function, either verify that the coe your'e running is 100% correct, or encase
        the calls in a try-catch block.

        Aside from the difference mentioned above, code running "on the spot" behaves no 
        different than code running using `Little.run`.

        @param code 
    **/
    public static function compile(code:String):Array<InterpTokens> {
        return Interpreter.convert(...Parser.parse(Lexer.lex(code)));
    }

    public static function format(code:String):String {
        return PrettyPrinter.stringifyParser(Parser.parse(Lexer.lex(code)));
    }
	/**
	    Resets all runtime details.
	**/
	public static function reset() {
        runtime = new Runtime();
		Little.operators.lhsOnly.clear();
		Little.operators.rhsOnly.clear();
		Little.operators.standard.clear();
		Little.operators.priority.clear();
		Little.memory.reset();
		Little.queue = new Queue();
	}

}