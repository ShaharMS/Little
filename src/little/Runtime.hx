package little;

import haxe.Log;
import little.interpreter.Memory;
import little.interpreter.ExceptionStack;
import little.interpreter.constraints.Exception;
import little.interpreter.constraints.Definition;

/**
 * The `Runtime` class is some sort of a bridge, 
 * connecting the interpreter of the language and you, the user.
 * 
 * It contains many functions and listeners, used 
 * to interact/listen to the interpreter's actions.
 */
class Runtime {
    
    public static var exceptionStack:ExceptionStack = new ExceptionStack();
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
     * @param thisLine the line number that was just parsed
     * @param nextLine the line that was just parsed
     */
    public static var preNextLine:(Int, Int) -> Void = (a, b) -> return;

    /**
     * called every time a Definition is found and initialized (eg. `define x = 5`)
     * 
     * @param name the name of the Definition
     * @param Definition the `Definition` reference associated with the name
     * @param line the line where the Definition was initialized
     */
    public static var onDefinitionInitialized:(String, Definition, Int) -> Void = (a, b, c) -> return;

    /**
     * The interpreter reads the code from top to bottom, starting at line 1.  
     * if equals to 0, it means the interpreter hasnt started yet.
     */
    public static var currentLine(get, null):Int = 0;

    

    /**
     * Returns a stringified version of the currently used values in memory.
     * 
     * @return A map-like string, containing the name of the Definition, pointing to its `Definition` value in memory. 
     * That value will be stringified according to the provided `toString` function.
     */
    public static function getMemorySnapshot():String {
        return Memory.DefinitionMemory.toString(); //TODO: #1 Very incomplete, needs string formatting
    }

    public static function getMemoryStructure():Map<String, Definition> {
        return Memory.DefinitionMemory.copy();
    }

    public static function safeThrow(exception:Exception) {
        exceptionStack.push(exception);
        print('Error! (from line $currentLine):\n\t---\n\t' + exception.content + "\n\t---");
    }
    public static function print(expression:String) {
        Log.trace('Line $currentLine: ' + expression, null);
    }

	static function get_currentLine():Int {
		return Interpreter.currentLine;
	}
}