package little.interpreter;

import little.parser.Tokens.ParserTokens;

class Interpreter {
    
    public static var errorThrown = false;

    public static function interpret(tokens:Array<ParserTokens>, runConfig:RunConfig) {
        if (tokens[0].getName() != "Module") {
            tokens.unshift(Module(runConfig.defaultModuleName));
        }
        runTokens(tokens, runConfig.prioritizeVariableDeclarations, runConfig.prioritizeFunctionDeclarations, runConfig.strictTyping);
    }

    public static function runTokens(tokens:Array<ParserTokens>, preParseVars:Bool, preParseFuncs:Bool, strict:Bool) {
        // Todo: support preParseVars
        // Todo: support preParseFuncs

        var i = 0;
        while (i < tokens.length) {
            var token = tokens[0];
        }
    }

    public static var varMemory:Map<String, ParserTokens> = [];
    public static var funcMemory:Map<String, ParserTokens> = [];
}