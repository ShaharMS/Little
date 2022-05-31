package little;

import little.Runtime.*;
using StringTools;

/**
 * This is the interface for the `little` language interpreter.
 * 
 * From here, you can run pieces of code, and get the results, without the need for compilation.
 * 
 * This interpreter is currently syntax-based, which means that very difficult to parse code might not work.
 * 
 * For information mid-interpretation, see the `Runtime` class.
 */
class Interpreter {
    
    /**
     * Runs a piece of code programmed in the `little` language.
     * 
     * lines of code may be separated by `\n`,`\r\n` or a semicolon.
     * @param code 
     */
    public static function run(code:String) {
        code = code.replace("\r", "");
        code = code.replace(";", "\n");
        code = ~/\n{2,}/g.replace(code, "\n");
    }


}