package little. interpreter;

import little.exceptions.DefinitionTypeMismatch;
import little.interpreter.constraints.Variable;

/**
 * This class contains methods used to get information about the application's memory status.
 * 
 * It can also be used to collect garbage and push variables to memory.
 * 
 * To get the memory status, check out the `Runtime` class.
 */
class Memory {
    
    public static var variableMemory:Map<String, Variable> = [];

    public static var functionMemory:Map<String, Actio>

    /**
     * Pushes a variable to memory, will throw an exception if a variable is "wrongly redefined".
     * 
     * @param variable The variable to push to memory.
     */
    public static function safePush(v:Variable) {
        if (variableMemory.exists(v.name)) {
            if (variableMemory[v.name].type != v.type) {
                Runtime.safeThrow(new DefinitionTypeMismatch(v.name, variableMemory[v.name].type, v.type));
            }
            variableMemory[v.name] = v;
        } else {
            variableMemory[v.name] = v;
        }
    }

    /**
     * Push a variable to memory, overwriting any existing variable with the same name without checking for type.
     * @param v 
     */
    public static function unsafePush(v:Variable) {
        variableMemory[v.name] = v;
    }

    //TODO: #4 garbage collector for the interpreter
    public static function collectGarbage() {
        
    }

    /**
     * Checks if a variable exists in the memory.
     * useful for checking if a variable is defined, and the accessing its value.
     * 
     * @param variableName the name of the variable to check
     * @return Whether the variable exists in the memory.
     */
    public static function hasLoadedVar(variableName:String):Bool {
        return variableMemory.exists(variableName);
    }

    /**
     * Gets the variable instance of a loaded, non garbage collected variable.
     * If the variable is not loaded, it will return null, as to allow you to safely throw
     * a custom error
     * 
     * @param variableName the name of the variable to get
     * @return The variable instance, or null if it is not loaded.
     */
    public static function getLoadedVar(variableName:String):Variable {
        return variableMemory[variableName] != null ? variableMemory[variableName] : null;
    }

    public static function clear() {
        return variableMemory = [];
    }
}