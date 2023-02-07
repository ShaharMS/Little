package little.lexer;

import texter.general.math.MathAttribute;
import little.lexer.Tokens.TokenLevel1;
import little.lexer.Lexer.*;
import little.Keywords.*;
using StringTools;
using TextTools;

/**
 * Contains unrelated, token-specific  helper methods
 */
class Specifics {
    

    public static function cropCode(code:String, line:Int):String {
        for (_ in 0...line) {

            code = code.substring(code.indexOf("\n") + 1);
        }        
        return code;
    }

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
        return ActionCallParameter(Specifics.attributesIntoExpression(MathLexer.resetAttributesOrder(MathLexer.splitBlocks(MathLexer.getMathAttributes(string)))));
    }

    public static function extractParamForActionCreation(string:String):TokenLevel1 {
        if (string.contains("=")) {
            var __nameValSplit = string.splitOnFirst("=");
            var param = extractParamForActionCreation(__nameValSplit[0]);
            var value = complexValueIntoTokenLevel1(__nameValSplit[1]);
            switch param {
                case Parameter(name, type, _): return Parameter(name, type, value);
                case _: throw "That Shouldn't Happen...";
            }
        } else {
            if (string.contains(TYPE_CHECK_OR_CAST)) {
                var extractor = new EReg('(\\w+) +$TYPE_CHECK_OR_CAST +(\\w+)', "");
                extractor.match(string.replace("\t", " ").trim());
                return Parameter(extractor.matched(1), extractor.matched(2), StaticValue(NULL_VALUE));
            } else {
                return Parameter(string.replace("\t", " ").trim(), null, StaticValue(NULL_VALUE));
            }
        }

        var valueNameSplit = string.split("="), name:String, type:String = TYPE_DYNAMIC, value:TokenLevel1 = StaticValue(NULL_VALUE);
        if (valueNameSplit[0].contains(TYPE_CHECK_OR_CAST)) {
            var extractor = new EReg('(\\w+) +$TYPE_CHECK_OR_CAST +(\\w+)', "");
            extractor.match(valueNameSplit[0].replace("\t", " ").trim());
            name = extractor.matched(1);
            type = extractor.matched(2);
        } else {
            name = valueNameSplit[0].replace("\t", " ").trim();
        }
        if (valueNameSplit.length == 1) 
            return Parameter(name, type, value);
        else
            value = complexValueIntoTokenLevel1(valueNameSplit[1].replace("\t", " ").trim());
        return Parameter(name, type, value);
    }

    public static function extractActionBody(code:String):{body:String, lineCount:Int} {
        var lastFunctionLineCount = 0;
        var lines = code.split("\n"); // split the code into lines
        var stack = new Array<Int>(); // stack to keep track of curly brackets
        var functionBody = ""; // variable to store the function body
        var inFunction = true; // flag to indicate if we are currently inside the function
        
        for (line in lines) {
            var lineTrimmed = line.trim(); // remove leading and trailing whitespaces
            
            // check for open curly bracket
            if (lineTrimmed.countOccurrencesOf("{") != 0) {
                for (_ in 0...lineTrimmed.countOccurrencesOf("{")) stack.push(1); // add 1 to the stack
                if (!inFunction) {
                    inFunction = true; // set flag to indicate we are now inside the function
                }
            }
            
            // check for closed curly bracket
            if (lineTrimmed.countOccurrencesOf("}") != 0) {
                for (_ in 0...lineTrimmed.countOccurrencesOf("}")) {
                    if (stack.length > 0) {
                        stack.pop(); // remove 1 from the stack
                    }
                } 
                                
                if (stack.length == 0 && inFunction) {
                    inFunction = false; // set flag to indicate we are now outside the function
                    break;
                }
            }
            
            if (inFunction) {
                functionBody += line + "\n"; // add the line to the function body
            }
            lastFunctionLineCount++;
        }
        lastFunctionLineCount++;
        return {body: functionBody.substring(functionBody.indexOf("{") + 1),lineCount: lastFunctionLineCount};
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
            trace('"$complexValue"');
            defValue = DefinitionAccess(complexValue);
        }
        else if (actionCallDetector.replace(complexValue, "").length == 0) {
            var _actionParamSplit = complexValue.splitOnFirst("(");
            final actionName = _actionParamSplit[0];

            final stringifiedParams = _actionParamSplit[1]; // remove the `actionName(` part
            stringifiedParams.substring(0, _actionParamSplit[1].lastIndexOf(")")); // remove the closing )

            var params = stringifiedParams.split(",");
            trace(params);
            params = params.map(item -> item.trim()); //removes whitespaces before/after each ,
            trace(params);
            defValue = ActionCall(actionName, [for (p in params) Specifics.extractParam(p)]);
        } 
        else {
            // A bit more complicated, since any item in a calculation may be any of the above, even another calculation!
            // Luckily, texter has the MathLexer class, which should help as extract the wanted info.
            // todo: #7 strings within expressions are parsed incorrectly
            defValue = Specifics.attributesIntoExpression(MathLexer.resetAttributesOrder(MathLexer.splitBlocks(MathLexer.getMathAttributes(complexValue))));                                    
        }

        return defValue;
    }


    /**
     * Converts texter math tokens to little ones.
     */
    public static function attributesIntoExpression(calcTokens:Array<MathAttribute>):TokenLevel1 {
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
                case Division(index, upperHandSide, lowerHandSide): finalTokens.push(Expression([attributesIntoExpression([upperHandSide]), Sign("/"), attributesIntoExpression([lowerHandSide])]));
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
                        // We have to fish for boolean values, since they get caught with variables using texter.
                        if (["true", "false", "nothing"].contains(name)) finalTokens.push(StaticValue(name));
                        else finalTokens.push(DefinitionAccess(name));
                    }
                    continue;
                }
                case Number(index, letter): finalTokens.push(StaticValue(letter));
                case Sign(index, letter): finalTokens.push(Sign(letter));
                case Closure(index, letter, content): finalTokens.push(attributesIntoExpression(content));
                case _:
            }
            i++;
        }
        finalTokens.pop();

        return Expression(finalTokens);
    }


}