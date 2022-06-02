package little;

import little.exceptions.VariableRegistrationError;
import little.transpiler.Typer;
import little.interpreter.features.ExternalVariable;
import little.interpreter.Memory;
import little.Runtime.*;
using StringTools;

/**
 * This is the interface for the `little` language interpreter.
 * 
 * From here, you can run pieces of code, and get the results, without the need for compilation.
 * 
 * This class supplies methods for registering certain objects/variables/functions,
 * Running code pieces, and getting the results of course.
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

    public static function registerVariable<T>(name:String, value:T) {
        final hType = Type.getClassName(Type.getClass(value));
        var v = new ExternalVariable();
        v.name = name;
        v.basicValue = value;
        v.valueTree = value;
        v.type = switch hType {
            case "String": "Letters";
            case "Number": "number";
            case "Boolean": "Boolean";
            case "Array": "Lineup";
            case "Dynamic": "Everything";
            case _: "Unknown";
        };
        if (v.type == "Unknown") {
            safeThrow(new VariableRegistrationError(hType));
            return;
        }
        v.scope = {scope: GLOBAL, info: "Registered externally"};
        Memory.safePush(v);
    }
        
    public static function registerFunction(name:String, func:Dynamic) {
        
    }

    public static function registerObject(name:String, obj:Dynamic) {
        
    }

}