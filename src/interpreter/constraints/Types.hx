package interpreter.constraints;

enum Types {

    PRIMITIVE;
    /** Every other, non-primitive type */ Other(reference:Bool, typeName:String);
}