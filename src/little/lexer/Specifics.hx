package little.lexer;

import texter.general.math.MathAttribute;
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
     * Converts texter math tokens to little ones.
     */
    public static function attributesIntoCalculation(calcTokens:Array<MathAttribute>):TokenLevel1 {
        var finalTokens:Array<TokenLevel1> = [];
        for (attribute in calcTokens) {
            switch attribute {
                case FunctionDefinition(index, letter):  // Won't appear
                case Division(index, upperHandSide, lowerHandSide): finalTokens.push(Calculation([attributesIntoCalculation([upperHandSide]), Sign("/"), attributesIntoCalculation([lowerHandSide])]));
                case Variable(index, letter): finalTokens.push(DefinitionAccess(letter));
                case Number(index, letter): finalTokens.push(StaticValue(letter));
                case Sign(index, letter): finalTokens.push(Sign(letter));
                case StartClosure(index, letter):  // Won't appear
                case EndClosure(index, letter):  // Won't appear
                case Closure(index, letter, content): finalTokens.push(Calculation([attributesIntoCalculation(content)]));
                case Null(index):  // Won't appear
            }
        }

        return Calculation(finalTokens);
    }


}