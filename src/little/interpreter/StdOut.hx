package little.interpreter;

import little.parser.Tokens.ParserTokens;

class StdOut {
	
	/**
    	A string, containing everything that was printed to the console during the program's runtime.
    **/
	public static var output = "";

	
    /**
    	An array of tokens consisting of all tokens that were printed-out.
    **/
	public static var stdoutTokens = new Array<ParserTokens>();


	/**
		Resets the `output` and `stdoutTokens` variables, thus resetting the console.
	**/
	public static function reset() {
		output = "";
		stdoutTokens = new Array<ParserTokens>();
	}
}