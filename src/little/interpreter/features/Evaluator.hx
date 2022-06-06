package little.interpreter.features;

import little.exceptions.UnknownDefinition;
import haxe.ds.Either;
using TextTools;
using StringTools;

/**
 * Used to evaluate the value of an expression
 */
class Evaluator {
    

    public static function getValueOf(value:String) {
        value = simplifyEquation(value);
        final numberDetector:EReg = ~/([0-9\.]+)/;
        final booleanDetector:EReg = ~/(true|false)/;

        if (numberDetector.match(value)) {
            return numberDetector.matched(1);
        }
        else if (value.indexesOf("\"").length == 2) {
            return value;
        } 
        else if (booleanDetector.match(value)) {
            return booleanDetector.matched(1);
        }
        else {
            if (Memory.hasLoadedVar(value)) {
                return Memory.getLoadedVar(value).toString();
            }
        }
        return "Nothing";
    }

    /**
     * Evaluates the expression and returns its value. This also supports strings.
     * 
     * @param expression The expression to evaluate
     * @return The value of the expression, as a string
     */
    public static function simplifyEquation(expression:String):String {
        if (expression.contains("\"")) return expression;
        else if (Memory.hasLoadedVar(expression)) return Memory.getLoadedVar(expression).basicValue;
        expression = expression.replace("+", " + ").replace("-", " - ").replace("*", " * ").replace("/", " / ").replace("(", " ( ").replace(")", " ) ");
        //first, replace all variables with their values
        var tempExpression = expression;
        var variableDetector:EReg = ~/ ([a-zA-Z_]+[0-9]*) /;
        while (variableDetector.match(tempExpression)) {
            var variable = variableDetector.matched(1);
            if (!Memory.hasLoadedVar(variable)) {
                Runtime.safeThrow(new UnknownDefinition(variable));
                return expression;
            } else {
                tempExpression = tempExpression.replacefirst(variable, Memory.getLoadedVar(variable).basicValue);
            }
        }
        if (tempExpression == "") return expression;
        var res = Formula.fromString(tempExpression).simplify().result;
        return res + "";
    }

    public static function calculateStrings(expression:String):String {
        return expression;
    }
}



typedef Node = {
    @:optional public var term:Term;
    @:optional public var left:Node;
    @:optional public var right:Node;
}

typedef Term = {
    @:optional public var value:String;
}