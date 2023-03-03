package refactored_little.interpreter;

import refactored_little.parser.Tokens.ParserTokens;

class Interpreter {
    
    public static function interpret(tokens:Array<ParserTokens>, runConfig:RunConfig) {
        if (tokens[0].getName() != "Module") {
            tokens.unshift(Module(runConfig.defaultModuleName));
        }
    }

    public static function runTokens(tokens:Array<ParserTokens>, preParseVars:Bool, preParseFuncs:Bool, strict:Bool) {
        
    }

    public static var memory:Map<String, ParserTokens> = [];
}