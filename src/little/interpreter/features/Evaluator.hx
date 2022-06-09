package little.interpreter.features;

import haxe.io.Encoding;
import little.exceptions.UnknownDefinition;
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
        var variableDetector:EReg = ~/([a-zA-Z_]+)/;
        var f = Formula.fromString(tempExpression);
        while (variableDetector.match(tempExpression)) {
            var variable = variableDetector.matched(1);
            if (Memory.hasLoadedVar(variable)) {
                f.bind(Formula.fromString(Memory.getLoadedVar(variable).basicValue), variable);
                var pos = variableDetector.matchedPos();
                tempExpression = tempExpression.substring(pos.pos + pos.len);
            } else {
                Runtime.safeThrow(new UnknownDefinition(variable));
                return expression;
            }
        }
        var res = f.result;
        return res + "";
    }

    public static function calculateStringAddition(expression:String, ?currentNode:Node):String {
        if (currentNode == null) currentNode = {};

        if (expression.contains("+")) {
            var additionSplit = expression.split("+");
            var leftString = additionSplit[0];
            currentNode.left = {};
            currentNode.left.value =  leftString;
            currentNode.sign = "+";
            additionSplit.shift();
            currentNode.right = {};
            calculateStringAddition(additionSplit.join("+"), currentNode.right);
        } else if (expression.contains("\"")) {
            currentNode.left = {}
            currentNode.left.value = expression;
        }
        trace(currentNode);
        return expression;
    }
    
}
typedef Node = {
    @:optional public var parent:Node;
    @:optional public var sign:String;
    @:optional public var value:String;
    @:optional public var left:Node;
    @:optional public var right:Node;
}