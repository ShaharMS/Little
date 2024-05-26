package little.interpreter;

import little.interpreter.Tokens.InterpTokens;

class StdOut {
	
	/**
    	A string, containing everything that was printed to the console during the program's runtime.
    **/
	public var output:String = "";

	
    /**
    	An array of tokens consisting of all tokens that were printed-out.
    **/
	public var stdoutTokens:Array<InterpTokens> = new Array<InterpTokens>();


	/**
		Resets the `output` and `stdoutTokens` variables, thus resetting the console.
	**/
	public function reset() {
		output = "";
		stdoutTokens = new Array<InterpTokens>();
	}

	/**
		Instantiates a new `StdOut`.
	**/
	public function new() {}
}