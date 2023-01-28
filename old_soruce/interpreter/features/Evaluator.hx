package little.interpreter.features;

import little.exceptions.Typo;
import little.exceptions.DefinitionTypeMismatch;
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
        else if (value.indexesOf("\"").length >= 2) {
            return value;
        } 
        else if (booleanDetector.match(value)) {
            return booleanDetector.matched(1);
        }
        else {
            if (Memory.hasLoadedVar(value)) {
                return Memory.getLoadedVar(value).basicValue;
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
        if (expression.contains('"')) return calculateStringMath(expression);
        if (expression.trim() == "false" || expression.trim() == "true") return expression.trim();
        if (Memory.hasLoadedVar(expression)) return Memory.getLoadedVar(expression).basicValue;
        expression = expression.replace("+", " + ").replace("-", " - ").replace("*", " * ").replace("/", " / ").replace("(", " ( ").replace(")", " ) ");
        // replace all Definitions with their values
        try {
            var tempExpression = expression;
            var DefinitionDetector:EReg = ~/([a-zA-Z_]+)/;
            var f = Formula.fromString(tempExpression);
            while (DefinitionDetector.match(tempExpression)) {
                var Definition = DefinitionDetector.matched(1);
                if (Memory.hasLoadedVar(Definition)) {
                    var value = Memory.getLoadedVar(Definition).basicValue;
                    if (~/[^0-9\.]+/.match(value)) {
                        Runtime.safeThrow(new DefinitionTypeMismatch(Definition, "Number", "e"));
                    }
                    f.bind(Formula.fromString(value), Definition);
                    var pos = DefinitionDetector.matchedPos();
                    tempExpression = tempExpression.substring(pos.pos + pos.len);
                } else {
                    Runtime.safeThrow(new UnknownDefinition(Definition));
                    return expression;
                }
            }
            var res = f.result;
            return res + "";
        } catch (e) {
            Runtime.safeThrow(new Typo(e.message));
            return "";
        }
    }

    public static function calculateStringAddition(expression:String, ?currentNode:Node):Node {
        if (currentNode == null) currentNode = {};

        if (expression.contains("+")) {
            var additionSplit = expression.split("+");
            var leftString = additionSplit[0].trim();
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
        return currentNode;
    }
    
    public static function calculateStringMath(expression:String):String {
        var result = "";
        var ast = calculateStringAddition(expression);
        if (ast.right == null) return expression;
        while (ast.left != null) {
            var left = ast.left;
            var right = ast.right;

            if ((ast.right == null && ast.sign == null) || ast.sign.replace(" ", "") == "+") {
                var addition = left.value.replacefirst("\"", "").replaceLast("\"", "");
                if (left.value == addition) {
                    try {
                        addition = Std.string(Memory.getLoadedVar(left.value).basicValue).replacefirst("\"", "").replaceLast("\"", "");
                    } catch (e) {
                        Runtime.safeThrow(new UnknownDefinition(left.value));
                        return result;
                    }
                    
                };
                result += addition;
            }
            ast = ast.right;
            if (ast == null) return '"$result"';
        }
        return '"$result"';
    }
}
typedef Node = {
    @:optional public var parent:Node;
    @:optional public var sign:String;
    @:optional public var value:String;
    @:optional public var left:Node;
    @:optional public var right:Node;
}