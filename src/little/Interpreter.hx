package little;

import little.interpreter.features.Assignment;
import little.exceptions.MissingTypeDeclaration;
import little.exceptions.Typo;
import little.interpreter.features.Evaluator;
import little.Runtime;
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
@:expose
@:native("LittleInterpreter")
class Interpreter {

    /**
     * The interpreter reads the code from top to bottom, starting at line 1.  
     * if equals to 0, it means the interpreter hasnt started yet.
    */
    public static var currentLine:Int = 1;

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
     * - `Any`
     * 
     * Also notice that the variable isnt present in `Memory` - this is to prevent the user from completely overwriting the variable.
     * 
     * @param name The variable's name. you might want to save it yourself too if you want to access the variable in memory
     * @param value The variable's value. should be a haxe, basic type, or Dynamic.
     */
    public static function registerVariable<T>(name:String, value:T) {
        final hType:String = Type.typeof(value).getName().substring(1);
        var v = new LittleVariable();
        v.name = name;
        v.basicValue = value;
        v.valueTree["%basicValue%"] = value;
        v.type = switch hType {
            case "String": "Characters";
            case "Int": "Number";
            case "Float": "Decimal";
            case "Bool": "Boolean";
            case "Dynamic" | "Any": "Everything";
            case _: "Unknown";
        };
        if (v.type == "Unknown") {
            safeThrow(new VariableRegistrationError(v.name, hType));
            return;
        }
        v.scope = {scope: GLOBAL, info: "Registered externally", initializationLine: 0};
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
     * 
     * As you notice, threres no return value. If you want to get the exit
     * value of the code, you can use the `exitCode` method.
     * 
     * For other runtime information, see the `Runtime` class.
     * @param code The code to run.
     */
    public static function run(code:String) {
        currentLine = 1;
        Memory.clear();
        code = code.replace("\r", "");
        code = code.replace(";", "\n");
        code = code.replace("    ", "\t");
        code = ~/\n{2,}/g.replace(code, "\n");
        var codeLines = code.split("\n");

        var currentIndent:Int = 0, lastIndent:Int = 0, blockNumber:Int = 0, currentlyClass:Bool = false;

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
            //new variables
            var lv = detectVariables(l);
            if (lv != null) {
                Memory.safePush(lv);
            }
            Assignment.assign(l);
            //print function
            detectPrint(l);

            currentLine++;
        }
    }

    public static var registeredVariables(default, null):Map<String, Variable> = [];

}

/**
 * Should detect variables inside:
 * 
 *     define x = 3
 *     define y:Number = x
 *     define z:Characters = "Hello"
 *     global define a:Boolean = true
 * 
 * @param line a line of code
 * @return the Variable insance, or null if it doesn't exist
 */
function detectVariables(line:String):LittleVariable {
    var v:LittleVariable = new LittleVariable();
    line = " " + line.trim();
    if (!line.contains(" define ") ) return null;
    //replace the starting "define" with ""
    var defParts = line.split(" define ");    

    // gets the variable name, type and value.
    var parts = defParts[1].split("=");
    v.scope.initializationLine = currentLine;
    if (parts[0].contains(":")) {
        final type = parts[0].split(":")[1].replace(" ", "");
        final name = parts[0].split(":")[0].replace(" ", "");

        if (type == "") {
            safeThrow(new MissingTypeDeclaration(name));
            return null;
        }

        v.name = name;
        v.type = type;
    }
    if (!parts[0].contains(":")) {
        v.name = parts[0].replace(" ", "");
        v.type = "Everything";
    }

    return v;

}

function processVariableValueTree(val:String):Dynamic {
    return {};
}

function detectPrint(line:String) {
    if (!line.contains("print(") && !line.endsWith(")")) return;
    //remove the print(
    line = line.substring(6);
    //remove the ending )
    if (!line.endsWith(")")) {
        Runtime.safeThrow(new Typo("When using the print function, you need to end it with a )"));
        return;
    }
    line = line.substring(0, line.length - 1);
    var value = Evaluator.getValueOf(line);
    Runtime.print(value);
}