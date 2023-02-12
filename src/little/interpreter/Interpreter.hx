package little.interpreter;

import little.parser.Tokens.ParserTokens;
import little.parser.Tokens.UnInfoedParserTokens;

class Interpreter {

    static var errorThrown:Bool = false;

    static var currentNesting(default, set):Int;

    static function set_currentNesting(indent:Int) {
        var n = currentNesting;
        currentNesting = indent;
        if (n != indent)
            collectGarbage();
        return indent;
    }

    public static function interpret(tokens:Array<ParserTokens>) {
        
    }

    /**
     * Goes over saved references in memory, and removes references for everything "unreferenceable"
     */
    public static function collectGarbage() {
        /*
            Currently, we have a simple check - we check the nesting level, and if the reference is inaccessible
            due to the reference being nested above the current nesting level, we clear it.
        */
        for (key => token in memory) {
            var nestingLevel:Int = token.getParameters()[token.getParameters().length - 2];
            if (nestingLevel > currentNesting)
                memory.remove(key);
        }
    }

    static var memory:Map<String, ParserTokens>;
}