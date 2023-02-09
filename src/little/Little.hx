package little;

import eval.luv.Loop.RunMode;
import little.interpreter.Interpreter;
import little.interpreter.Runtime;

@:access(little.interpreter.Interpreter)
@:access(little.interpreter.Runtime)
class Little {
    
    public static var runtime(default, null) = Runtime;

    /**
        Loads little code, without clearing memory. useful if you want to 
        use multiple files/want to preload code for the end user to use.

        @param code a string containing code written in Little.
        @param name a name to call the module, so it would be easily identifiable
    **/
    public static function loadModule(code:String, name:String) {
        
    }

    /**
        Runs a new Little program.  
        If you want to preload some more code, use the `Little.loadModule()` method before calling this.  
        to unload a loaded module , use `Little.unloadModule()` with the name of the module you wish to remove.  
        
         - **pay attention - all modules are unloaded after each run.**

        If you want to use another keyword set (for example, to allow programming everything in spanish),
        make sure to set `currentKeywordSet` before calling this. If you want to use the default keywords with some changes,
        you can make some changes to the properties in `little.Keywords` instead.

        To register different types of "elements", such as definitions (variables), actions (functions), or even entire classes, you can use the various methods inside `Little.runtime`
        
        @param code 
    **/
    public static function run(code:String) {
        Interpreter.errorThrown = false;
        Runtime.line = 0;
        Runtime.callStack = [];
        Runtime.stdout = "";
        
    }

}