package little.interpreter;

import little.parser.Tokens.ParserTokens;
import little.parser.Tokens.UnInfoedParserTokens;

class Interpreter {

    static var errorThrown:Bool = false;

    public static function interpret(tokens:Array<ParserTokens>) {

    }

    /**
     * Goes over saved references in memory, and removes references for everything "unreferenceable"
     */
    public static function collectGarbage() {
        
    }

    static var memory:Map<String, ParserTokens>;
}