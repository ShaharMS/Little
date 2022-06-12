package little.interpreter.constraints;

enum DefinitionScope {
    /**Used for externally registered Definitions**/ EXTERNAL;
    /**Used for global Definitions, which wont get cleared out by the gc*/GLOBAL;
    /**Initialized at the file level, outside classes**/MODULE;
    /**Initialized at class level**/CLASS;
    /**Initialized Inside a function**/Method(methodNumber:Int);
    /**Initialized inside a code block**/Block(blockNumber:Int);
    /**Initialized in a one-line expression/statement**/Inline(lineNumber:Int);
}