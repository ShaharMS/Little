package little.interpreter.features;

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
}