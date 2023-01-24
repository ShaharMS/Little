package little.lexer;

import texter.general.math.MathLexer;
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
        return Parameter("", "", Specifics.attributesIntoCalculation(MathLexer.resetAttributesOrder(MathLexer.splitBlocks(MathLexer.getMathAttributes(string)))));
    }

    /**
     * Converts texter math tokens to little ones.
     */
    public static function attributesIntoCalculation(calcTokens:Array<MathAttribute>):TokenLevel1 {
        var finalTokens:Array<TokenLevel1> = [];

        // Before conversion, merge separate, following vars into a single variable
        var merged:Array<MathAttribute> = [];
        var i = 0;
        while (i < calcTokens.length) {
            var attribute = calcTokens[i];
            switch attribute {
                
                case Variable(index, letter): {
                    var finalName = letter;
                    i++;
                    while (i < calcTokens.length) {
                        var nextAttribute = calcTokens[i];
                        switch nextAttribute {
                            default: {
                                merged.push(Variable(index, finalName));
                                break;
                            }
                            case Variable(_, letter): {
                                finalName += letter;
                                i++;
                            }
                        }
                    }
                }
                case _: {
                    merged.push(attribute);
                    i++;
                }
            }
        }

        calcTokens = merged;

        var i = 0;
        while (i < calcTokens.length) {
            var attribute = calcTokens[i];
            switch attribute {
                case Division(index, upperHandSide, lowerHandSide): finalTokens.push(Calculation([attributesIntoCalculation([upperHandSide]), Sign("/"), attributesIntoCalculation([lowerHandSide])]));
                case Variable(index, letter): { // More details, separate actions and definitions & merge numbers into them if needed
                    var iSave = i; //save the i value if needed
                    var name = letter;
                    i++;
                    var nextAttribute = calcTokens[i];
                    while (i < calcTokens.length) {
                        nextAttribute = calcTokens[i];
                        switch nextAttribute {
                            case Variable(index, letter) | Number(index, letter): name += letter;
                            case Sign(index, letter): break;
                            case Closure(index, letter, content): {
                                // its a function

                                var actParams = MathLexer.extractTextFromAttributes(content).split(",");
                                finalTokens.push(ActionCall(name, [for (param in actParams) Specifics.extractParam(param)]));
                                i++;
                                break;
                            }
                            case _: {
                                i++;
                                break;
                            }
                        }
                        i++;
                    }
                    continue;
                }
                case Number(index, letter): finalTokens.push(StaticValue(letter));
                case Sign(index, letter): finalTokens.push(Sign(letter));
                case Closure(index, letter, content): finalTokens.push(Calculation([attributesIntoCalculation(content)]));
                case _:
            }
            i++;
        }


        return Calculation(finalTokens);
    }


}