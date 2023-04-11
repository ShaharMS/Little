package little.tools;

import little.interpreter.Interpreter;
import little.parser.Tokens.ParserTokens;

class Extensions {
    
    public static function identifier(token:ParserTokens):String {
        return Interpreter.stringifyTokenIdentifier(token);
    }

    public static function value(token:ParserTokens):String {
        return Interpreter.stringifyTokenValue(token);
    }

}