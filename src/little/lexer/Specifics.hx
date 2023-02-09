package little.lexer;

import little.expressions.ExpTokens;
import little.expressions.Expressions;
import little.lexer.Tokens.LexerTokens;
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
    public static function extractParam(string:String):LexerTokens {
        return ActionCallParameter(Specifics.attributesIntoExpression(Expressions.lex(string)));
    }

    public static function extractParamForActionCreation(string:String):LexerTokens {
        if (string.contains("=")) {
            var __nameValSplit = string.splitOnFirst("=");
            var param = extractParamForActionCreation(__nameValSplit[0]);
            var value = complexValueIntoLexerTokens(__nameValSplit[1]);
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

        var valueNameSplit = string.split("="), name:String, type:String = TYPE_DYNAMIC, value:LexerTokens = StaticValue(NULL_VALUE);
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
            value = complexValueIntoLexerTokens(valueNameSplit[1].replace("\t", " ").trim());
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
    public static function complexValueIntoLexerTokens(complexValue:String) {
        var defValue:LexerTokens = InvalidSyntax(complexValue);

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
            defValue = Specifics.attributesIntoExpression(Expressions.lex(complexValue));                                    
        }

        return defValue;
    }


    /**
     * Converts texter math tokens to little ones.
     */
    public static function attributesIntoExpression(calcTokens:Array<ExpTokens>):LexerTokens {
        var finalTokens:Array<LexerTokens> = [];

        for (token in calcTokens) {
            switch token {
                case Variable(value): finalTokens.push(DefinitionAccess(value));
                case Value(value): finalTokens.push(StaticValue(value));
                case Characters(value): finalTokens.push(StaticValue('"$value"'));
                case Sign(value): finalTokens.push(Sign(value));
                case Call(value, content): finalTokens.push(ActionCall(value, [attributesIntoExpression(content)]));
                case Closure(content): finalTokens.push(attributesIntoExpression(content));
            }
        }

        return Expression(finalTokens);
    }


}