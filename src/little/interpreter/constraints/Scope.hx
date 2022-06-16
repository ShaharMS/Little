package little.interpreter.constraints;

enum Scope {
    /**Used for externally registered Definitions**/ EXTERNAL;
    /**Used for global Definitions, which wont get cleared out by the gc*/GLOBAL;
    /**Initialized at the file level, outside classes**/MODULE;
    /**Initialized at class level**/CLASS;
    /**Initialized inside a code block**/Block(blockNumber:Int);
}