package little;

import little.transpiler.syntax.WriteStyle;
import little.transpiler.syntax.FunctionRecognition;
import little.transpiler.syntax.VariableRecognition;
import little.interpreter.Memory;
import little.interpreter.constraints.Variable;

/**
 * The `Runtime` class is some sort of a bridge, 
 * connecting the interpreter of the language and you, the user.
 * 
 * It contains many functions and listeners, used 
 * to interact/listen to the interpreter's actions.
 */
class Runtime {
    
    /**
     * `onNextLine` is called **after** the interpreter successfully parses
     * and executes a line and moves on to the next line
     * 
     * @param firstParameter the line number that was just parsed
     * @param secondParameter the line that was just parsed
     */
    public static var onNextLine:(Int, Int) -> Void = (a, b) -> return;

    /**
     * `preNextLine` is called **after** the interpreter successfully parses and executes a line,
     * but **before** the interpreter moves on to the next line
     * 
     * @param firstParameter the line number that was just parsed
     * @param secondParameter the line that was just parsed
     */
    public static var preNextLine:(Int, Int) -> Void = (a, b) -> return;

    /**
     * called every time a variable is found and initialized (eg. `define x = 5`)
     * 
     * @param name the name of the variable
     * @param variable the `Variable` reference associated with the name
     * @param line the line where the number was found
     */
    public static var onVariableInitialized:(String, Variable, Int, Int) -> Void = (a, b, c, d) -> return;

    /**
     * The interpreter reads the code from top to bottom, starting at line 1.  
     * if equals to 0, it means the interpreter hasnt started yet.
     */
    public static var currentLine(default, null):Int = 0;

    /**
     * Returns a stringified version of the currently used values in memory.
     * 
     * @return A map-like string, containing the name of the variable, pointing to its `Variable` value in memory. 
     * That value will be stringified according to the provided `toString` function.
     */
    public static function getMemorySnapshot():String {
        return Memory.variableMemory.copy().toString(); //TODO: #1 Very incomplete, needs string formatting
    }

    public static function getMemoryStructure():Map<String, Variable> {
        return Memory.variableMemory.copy();
    }

    public static function transpile(code:String, ?options:TranspilerOptions):String {
        code = VariableRecognition.parse(code);
        code = FunctionRecognition.parse(code, options.functionWriteStyle);
        return code;
    }
}

@:structInit
class TranspilerOptions {
    /**Whether or not to ignore obvious errors at compile-time**/       public var ignoreErrors:Bool = false;
    /**Whether or not to ignore and delete classes**/                   public var ignoreWarnings:Bool = false;
    /**Whether or not to ignore visibility modifiers at runtime**/      public var ignoreVisibility:Bool = false;
    /**Whether or not to ignore external field definitions**/           public var ignoreExternals:Bool = false;
    /**Whether or not to keep comments in the generated source code**/  public var keepComments:Bool = false;
    /**Useful When `ignoreVisibility` is set to true, this will be set
     * as the prefix to every variable and function**/                  public var prefixFieldsWith:String = "";
    /**Removes condensable whitespaces**/                               public var condense:Bool = false;
    /**Removes all condensable characters, shortens variable names**/   public var minify:Bool = false;
    /**When defined, writes the resulting code to the defined path**/   public var codePath:String = "";
    /**Decides in what way a function is written**/                     public var functionWriteStyle:WriteStyle = SAME_LEVEL;

}