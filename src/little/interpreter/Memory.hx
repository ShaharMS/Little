package little. interpreter;

import little.interpreter.constraints.Action;
import little.exceptions.DefinitionTypeMismatch;
import little.interpreter.constraints.Definition;

/**
 * This class contains methods used to get information about the application's memory status.
 * 
 * It can also be used to collect garbage and push Definitions to memory.
 * 
 * To get the memory status, check out the `Runtime` class.
 */
class Memory {
    
    public static var definitionMemory:Map<String, Definition> = [];

    public static var actionMemory:Map<String, Action> = [];

    /**
     * Pushes a Definition to memory, will throw an exception if a Definition is "wrongly redefined".
     * 
     * @param Definition The Definition to push to memory.
     */
    public static function safePush(v:Definition) {
        if (definitionMemory.exists(v.name)) {
            if (definitionMemory[v.name].type != v.type) {
                Runtime.safeThrow(new DefinitionTypeMismatch(v.name, definitionMemory[v.name].type, v.type));
            }
            definitionMemory[v.name] = v;
        } else {
            definitionMemory[v.name] = v;
        }
    }

    /**
     * Push a Definition to memory, overwriting any existing Definition with the same name without checking for type.
     * @param v 
     */
    public static function unsafePush(v:Definition) {
        definitionMemory[v.name] = v;
    }

    //TODO: #4 garbage collector for the interpreter
    public static function collectGarbage() {
        
    }

    /**
     * Checks if a Definition exists in the memory.
     * useful for checking if a Definition is defined, and the accessing its value.
     * 
     * @param DefinitionName the name of the Definition to check
     * @return Whether the Definition exists in the memory.
     */
    public static function hasLoadedVar(DefinitionName:String):Bool {
        return definitionMemory.exists(DefinitionName);
    }

    /**
     * Gets the Definition instance of a loaded, non garbage collected Definition.
     * If the Definition is not loaded, it will return null, as to allow you to safely throw
     * a custom error
     * 
     * @param DefinitionName the name of the Definition to get
     * @return The Definition instance, or null if it is not loaded.
     */
    public static function getLoadedVar(definitionName:String):Definition {
        return definitionMemory[definitionName] != null ? definitionMemory[definitionName] : null;
    }

    public static function clearMemory() {
        definitionMemory = [];
        actionMemory = [];
    }
}