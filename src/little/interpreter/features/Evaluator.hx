package little.interpreter.features;

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
        if (expression.contains("\"")) return calculateStrings(expression);
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
        var res = f.simplify().result;
        return res + "";
    }

    public static function calculateStrings(expression:String):String {
        //first, make the ast and referencing stuff for easier node access
        var ast:AST = new AST(), nodeArray:Array<Node> = [];
        //second, we need to detect multiplication, and construct the AST
        var multiplicationSplit = expression.split("*");

        for (i in 0...multiplicationSplit.length) {
            //multiplication left side
            final leftString = multiplicationSplit[i];
            //used to calculate the equation in the ast later
            if (ast.currentNode == null) ast.currentNode = {};
            ast.currentNode.sign = "*";
            //assign to the left node
            if (ast.currentNode.left == null) ast.currentNode.left = {};
            ast.currentNode.left.value = leftString;
            //push the reference to the node array for easy access later
            nodeArray.push(ast.currentNode.left);
            nodeArray.push(ast.currentNode);
            ast.moveLeft();
            //continue calculations by going to the right side
            trace("Passed: " + leftString);
        }
        trace(nodeArray[-1]);
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

@:structInit class AST {

    public var currentNode:Node = {};

    public function new() {

        currentNode = {
            parent: null,
            left: {},
            right: {},
            value: "",
            sign: ""
        };
    }

    public function moveLeft():Node {
        return currentNode.left;
    }

    public function moveRight() {
        return currentNode.right;
    }

    public function initializeNode(n:Node) {
        n = {parent: currentNode, sign: "", value: ""};
    }

}