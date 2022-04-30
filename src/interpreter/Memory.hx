package interpreter;

import interpreter.constraints.Variable;

/**
 * This class contains methods used to get information about the application's memory status.
 */
class Memory {
    
    public static var variableMemory:Map<String, Variable> = [];

    public static function safePush(v:Variable) {
        if (variableMemory.exists(v.name)) {
            if (variableMemory[v.name].type != v.type) {
                throw "Defenition Type Missmatch: " + v.name + " has been defined with the type " + v.type + " but is being redefined with the type " + variableMemory[v.name].type;
            }
            variableMemory[v.name] = v;
        }
    }

}