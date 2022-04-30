package interpreter.constraints;

import interpreter.constraints.Types;

interface Variable {
    /**
     * Mostly used with primitive types, contains the core value of the variable.
     */
    public var basicValue(get, set):Dynamic;

    /**
     * Mostly used with object types, contains the object's variable and function tree.
     */
    public var valueTree(get, set):Dynamic;

    /**
     * The type of the variable (primitive or object).
     */
    public var type(default, never):Types;

    /**
     * The variable's asscoiated name, should be used to get its value in memory.
     */
    public var name:String;

    /**
     * The variable's scope and place of creation.
     */
    public var scope:{scope:VariableScope, info:String};

    /**
     * A String representation of the variable, to be used for printing.
     */
    public function toString():String;

    /**
     * Forcfully removes the variable from memory.
     */
    public function dispose():Void;
}