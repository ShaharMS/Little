package little;

import little.interpreter.Lexer;
import little.interpreter.features.Assignment;
import little.exceptions.MissingTypeDeclaration;
import little.exceptions.Typo;
import little.interpreter.features.Evaluator;
import little.Runtime;
import little.exceptions.DefinitionTypeMismatch;
import little.interpreter.constraints.Definition;
import little.exceptions.VariableRegistrationError;
import little.interpreter.features.Typer;
import little.interpreter.features.LittleDefinition;
import little.interpreter.Memory;
import little.Runtime.*;
using StringTools;

/**
 * This is the interface for the `little` language interpreter.
 * 
 * From here, you can run pieces of code, and get the results, without the need for compilation.
 * 
 * This class supplies methods for registering certain objects/Definitions/functions,
 * Running code pieces, and getting the results of course.
 * 
 * For information mid-interpretation, see the `Runtime` class.
 */
@:expose
@:native("LittleInterpreter")
@:allow(little.interpreter.Lexer)
@:allow(little.Runtime)
class Interpreter {

    /**
     * The interpreter reads the code from top to bottom, starting at line 1.  
     * if equals to 0, it means the interpreter hasnt started yet.
    */
    public static var currentLine:Int = 1;

    /**
     * Registers a haxe, basic type variable, to be used in the language by the user.
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
     * Also notice that the Definition isnt present in `Memory` - this is to prevent the user from completely overwriting the Definition.
     * 
     * @param name The Definition's name. you might want to save it yourself too if you want to access the Definition in memory
     * @param value The Definition's value. should be a haxe, basic type, or Dynamic.
     */
    public static function registerVariable<T>(name:String, value:T) {
        final hType:String = Type.typeof(value).getName().substring(1);
        var v = new LittleDefinition();
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
        v.scope = {scope: EXTERNAL, info: "Registered externally", initializationLine: currentLine};
        Memory.unsafePush(v);
        registeredDefinitions.set(name, v);
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
        Memory.clearMemory();
        code = code.replace("\r", "");
        code = code.replace(";", "\n");
        code = code.replace("    ", "\t");
        code = ~/\n{2,}/g.replace(code, "\n");
        var codeLines = code.split("\n");
        
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
            //new Definitions
            var lv = Lexer.detectDefinitions(l);
            if (lv != null) {
                Memory.safePush(lv);
            }
            Assignment.assign(l);
            //print function
            Lexer.detectPrint(l);

            currentLine++;
        }
    }

    public static var registeredDefinitions(default, null):Map<String, Definition> = [];

    static var currentIndent:Int = 0;
    static var lastIndent:Int = 0;
    static var blockNumber:Int = 0;
    static var currentlyClass:Bool = false;
    static var currentlyFunction:Bool = false;
}