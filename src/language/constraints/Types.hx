package language.constraints;

enum Types {

    /** Represents a haxe floating point number. */ DECIMAL_NUMBER;
    /** Represents a haxe integer number. */ NUMBER;
    /** Represent an "array" of immutable characters */ STRING;
    /** The regular true/false boolean type. will be represented as `yes`/`no` too for simplicity */BOOLEAN;
    /** Every other, non-primitive type */ Other(reference:Bool, typeName:String);
}