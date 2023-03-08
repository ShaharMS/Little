package little.tools;

import little.interpreter.Interpreter;
import little.interpreter.Runtime;

class PrepareRun {
    
    public static function addFunctions() {
        Little.registerFunction("print", null, PartArray([Define(Identifier("item"), null)]), (params) -> {
            Runtime.print(Interpreter.stringifySimpleToken(Interpreter.evaluate(params.getParameters()[0][0])));
            return NullValue;
        });
    }

}