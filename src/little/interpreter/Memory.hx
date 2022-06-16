package little. interpreter;

import haxe.extern.EitherType;
import haxe.ds.Either;
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
     * Pushes a Definition/Action to memory:
     * - For **Definitions**, will throw an exception if its "wrongly redefined".
     * - **Actions** are simply pushed to memory.
     * 
     * @param Definition The Definition to push to memory.
     */
    public static function safePush(v:EitherType<Action, Definition>) {
        if (v is Action) {
            var action:Action = cast v;
            actionMemory.set(action.name, action);
        } else {
            var def:Definition = cast v;
            if (definitionMemory.exists(def.name)) {
                if (definitionMemory[def.name].type != def.type) {
                    Runtime.safeThrow(new DefinitionTypeMismatch(def.name, definitionMemory[def.name].type, def.type));
                }
                definitionMemory[def.name] = v;
            } else {
                definitionMemory[def.name] = v;
            }
        }
    }

    /**
     * Push a Definition to memory, overwriting any existing Definition with the same name without checking for type.
     * @param v 
     */
    public static function unsafePush(v:EitherType<Action, Definition>) {
        if (v is Action) actionMemory.set(cast(v, Action).name, cast v);
        else definitionMemory[cast(v, Definition).name] = cast v;
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
    public static function hasLoadedVar(definitionName:String):Bool {
        return definitionMemory.exists(definitionName);
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