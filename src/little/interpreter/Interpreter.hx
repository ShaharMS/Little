package little.interpreter;

import little.parser.Tokens.UnInfoedParserTokens;

class Interpreter {

    static var errorThrown:Bool = false;

    public static function interpret(tokens:Array<UnInfoedParserTokens>) {

    }

    static var memory:Map<String, {scopeLevel:Int, module:String, token:UnInfoedParserTokens}>;
}