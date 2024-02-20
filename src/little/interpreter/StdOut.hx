package little.interpreter;

import little.interpreter.Tokens.InterpTokens;

class StdOut {
	
	/**
    	A string, containing everything that was printed to the console during the program's runtime.
    **/
	public var output = "";

	
    /**
    	An array of tokens consisting of all tokens that were printed-out.
    **/
	public var stdoutTokens = new Array<InterpTokens>();


	/**
		Resets the `output` and `stdoutTokens` variables, thus resetting the console.
	**/
	public function reset() {
		output = "";
		stdoutTokens = new Array<InterpTokens>();
	}

	public function new() {}
}