package little.interpreter.constraints;

enum VariableScope {
    /**Used for externally registered variables**/ GLOBAL;
    /**Initialized at the file level, outside classes**/MODULE;
    /**Initialized at class level**/CLASS;
    /**Initialized Inside a function**/Method(methodNumber:Int);
    /**Initialized inside a code block**/Block(blockNumber:Int);
    /**Initialized in a one-line expression/statement**/Inline(lineNumber:Int);
}