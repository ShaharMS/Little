package little;

import little.exceptions.DefinitionTypeMismatch;
import little.interpreter.constraints.Variable;
import little.exceptions.VariableRegistrationError;
import little.interpreter.features.Typer;
import little.interpreter.features.LittleVariable;
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
     * Registers a haxe, basic type variable, to be used in the language.
     * 
     * This is useful for games that want to give certine constants that the user needs
     * to be able to program things, or for general applications that have a code/macro interface,
     * that want to give their users control over certain variables used for design.
     * 
     * **Notice** - Not all variable types are supported here, the only ones that are supported:
     * 
     * - `String`
     * - `Int`
     * - `Float`
     * - `Bool`
     * - `Dynamic`
     * 
     * @param name The variable's name. you might want to save it yourself too if you want to access the variable in memory
     * @param value The variable's value. should be a haxe, basic type, or Dynamic.
     */
    public static function registerVariable<T>(name:String, value:T) {
        final hType = Type.getClassName(Type.getClass(value));
        var v = new LittleVariable();
        v.name = name;
        v.basicValue = value;
        v.valueTree = value;
        v.type = switch hType {
            case "String": "Letters";
            case "Int": "Number";
            case "Float": "Decimal";
            case "Bool": "Boolean";
            case "Dynamic": "Everything";
            case _: "Unknown";
        };
        if (v.type == "Unknown") {
            safeThrow(new VariableRegistrationError(v.name, hType));
            return;
        }
        v.scope = {scope: GLOBAL, info: "Registered externally"};
        Memory.safePush(v);
        registeredVariables.set(name, v);
    }
        
    public static function registerFunction(name:String, func:Dynamic) {
        
    }

    public static function registerObject(name:String, obj:Dynamic) {
        
    }

    public static function registerClass(name:String, cls:Dynamic) {
        
    }

    /**
     * Runs a piece of code programmed in the `little` language.
     * 
     * lines of code may be separated by `\n`,`\r\n` or a semicolon.
     * @param code 
     */
    public static function run(code:String) {
        code = code.replace("\r", "");
        code = code.replace(";", "\n");
        code = code.replace("    ", "\t");
        code = ~/\n{2,}/g.replace(code, "\n");
        var codeLines = code.split("\n");

        var currentIndent:Int = 0, lastIndent:Int = 0, blockNumber:Int = 0;

        for (l in codeLines) {
            lastIndent = currentIndent;
            currentIndent = 0;
            while (l.startsWith("\t")) {
                l = l.substring(1);
                currentIndent++;
            }
            if (lastIndent != currentIndent) {
                blockNumber++;
            }

        }
    }

    public static var registeredVariables(default, null):Map<String, Variable> = [];

}

@:noCompletion function detectVariables(line:String):Variable {
    var v:LittleVariable = new LittleVariable();
    line = line.trim();
    if (!line.startsWith("define ")) return null;
    //replace the starting "define" with ""
    line = line.substring(7);    
    var parts = line.split("=");
    if (parts[0].contains(":")) {
        var type = parts[0].split(":")[1];
        var name = parts[0].split(":")[0];
        v.name = name;
        v.type = type;
    }
    var valueType:String = Typer.getValueType(parts[1].trim());
    if (valueType != v.type) safeThrow(new DefinitionTypeMismatch(v.name, v.type, valueType));

    return v;

}