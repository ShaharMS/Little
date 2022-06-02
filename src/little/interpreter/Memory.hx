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

    public static function safePush(v:Variable) {
        if (variableMemory.exists(v.name)) {
            if (variableMemory[v.name].type != v.type) {
                Runtime.safeThrow(new DefinitionTypeMismatch(v.name, variableMemory[v.name].type, v.type));
            }
            variableMemory[v.name] = v;
        }
    }

    //TODO: #4 garbage collector for the interpreter
    public static function collectGarbage() {
        
    }
}