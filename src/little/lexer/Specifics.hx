package little.lexer;

import texter.general.math.MathLexer;
import texter.general.math.MathAttribute;
import little.lexer.Tokens.TokenLevel1;
import little.lexer.Lexer.*;
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
     * Converts a `complexValue` into a level 1 token
     */
    public static function complexValueIntoTokenLevel1(complexValue:String) {
        var defValue:TokenLevel1 = InvalidSyntax(complexValue);

        // Now, figure out if defValue should be an ActionCall, StaticValue, DefinitionAccess or Calculation.
        if (staticValueDetector.replace(complexValue, "").length == 0) {
            defValue = StaticValue(complexValue);
        }
        else if (definitionAccessDetector.replace(complexValue, "").length == 0) {
            defValue = DefinitionAccess(complexValue);
        }
        else if (actionCallDetector.replace(complexValue, "").length == 0) {
            var _actionParamSplit = complexValue.split("(");
            final actionName = _actionParamSplit[0];

            final stringifiedParams = _actionParamSplit[1]; // remove the `actionName(` part
            stringifiedParams.substring(0, _actionParamSplit[1].length - 1); // remove the closing )

            var params = stringifiedParams.split(",");
            params = params.map(item -> item.trim()); //removes whitespaces before/after each ,

            defValue = ActionCall(actionName, [for (p in params) Specifics.extractParam(p)]);
        } 
        else /* if (calculationDetection.replace(complexValue, "").length == 0)*/  { // Todo: is this the solution?
            // A bit more complicated, since any item in a calculation may be any of the above, even another calculation!
            // Luckily, texter has the MathLexer class, which should help as extract the wanted info.
            
            defValue = Specifics.attributesIntoCalculation(MathLexer.resetAttributesOrder(MathLexer.splitBlocks(MathLexer.getMathAttributes(complexValue))));                                    
        }

        return defValue;
    }


    /**
     * Converts texter math tokens to little ones.
     */
    public static function attributesIntoCalculation(calcTokens:Array<MathAttribute>):TokenLevel1 {
        var finalTokens:Array<TokenLevel1> = [];

        calcTokens.push(Sign(-1, "+")); // Todo: not a great solution, i have a bug somewhere here.

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
                    var tokenPushed = false;
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
                                tokenPushed = true;
                                break;
                            }
                            case _: {
                                i++;
                                break;
                            }
                        }
                        i++;
                    }
                    if (!tokenPushed) {
                        finalTokens.push(DefinitionAccess(name));
                    }
                    continue;
                }
                case Number(index, letter): finalTokens.push(StaticValue(letter));
                case Sign(index, letter): finalTokens.push(Sign(letter));
                case Closure(index, letter, content): finalTokens.push(attributesIntoCalculation(content));
                case _:
            }
            i++;
        }
        finalTokens.pop();

        return Calculation(finalTokens);
    }


}