package little.interpreter.constraints;

import little.interpreter.constraints.Types;

interface Definition {
    /**
     * Mostly used with primitive types, contains the core value of the Definition.
     */
    public var basicValue(get, set):Dynamic;

    /**
     * Mostly used with object types, contains the object's Definition and function tree.
     */
    public var valueTree:Map<String, Dynamic>;

    /**
     * The type of the Definition (primitive or object).
     */
    public var type:String;

    /**
     * The Definition's asscoiated name, should be used to get its value in memory.
     */
    public var name:String;

    /**
     * The Definition's scope and place of creation.
     */
    public var scope:{scope:Scope, info:String, initializationLine:Int};

    /**
     * A String representation of the Definition, to be used for printing.
     */
    public function toString():String;

    /**
     * Forcfully removes the Definition from memory.
     */
    public function dispose():Void;
}