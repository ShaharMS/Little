package little.lexer;

import little.lexer.Tokens.TokenLevel1;
using StringTools;

/**
 * Contains unrelated, token-specific  helper methods
 */
class Specifics {
    
    /**
     * extracts
     * 
     *      Parameter(...)
     * 
     * from a string
     * 
     * @param string param string
     * @return Parameter()
     */
    public static function extractParam(string:String):TokenLevel1 {
        return null;
    }

    /**
     * extracts
     * 
     *      Sign(...)
     *      StaticValue(...)
     *      DefinitionAccess(...)
     *      ActionCall(...)
     * 
     * from a string
     */
    public static function extractMathExpr(string:String):TokenLevel1 {
        if (string.startsWith("(")) return Calculation(null);
        return null;
    }
}