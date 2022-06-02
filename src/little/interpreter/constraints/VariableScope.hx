package little.interpreter.constraints;

enum VariableScope {
    GLOBAL;
    MODULE;
    CLASS;
    METHOD;
    BLOCK;
    INLINE;
}