package little.interpreter.features;

import haxe.ds.Either;

/**
 * Used to evaluate the value of an expression
 */
class Evaluator {
    

    public static function getValueOf(value:String) {
        final numberDetector:EReg = ~/([0-9.])/;
        final stringDetector:EReg = ~/"[^"]*"/;
        final booleanDetector:EReg = ~/true|false/;

        if (numberDetector.match(value)) return numberDetector.matched(1);
        else if (stringDetector.match(value)) return stringDetector.matched(1);
        else if (booleanDetector.match(value)) return booleanDetector.matched(1);
        else {
            if (Memory.hasLoadedVar(value)) return Memory.getLoadedVar(value).toString();
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
        var value = "";

        //first, build the abstract syntax tree
        var ast:Node = {};
        
        
        return value;
    }

    
}



typedef Node = {
    public var term:Term;
    public var left:Node;
    public var right:Node;
}

typedef Term = {
    public var value:String;
}