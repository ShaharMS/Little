package little.interpreter;

import little.parser.Tokens.ParserTokens;

class Interpreter {

    static var errorThrown:Bool = false;

    public static function interpret(tokens:Array<ParserTokens>) {

    }

    static var memory:Map<String, {scopeLevel:Int, module:String, token:ParserTokens}>;
}