package little.tools;

import little.interpreter.Interpreter;
import little.interpreter.Runtime;

using Std;

import little.Keywords.*;
class PrepareRun {
    
    public static function addFunctions() {
        Little.registerFunction("print", null, [Define(Identifier("item"), null)], (params) -> {
            trace(params[0]);
            Runtime.print(Interpreter.stringifyTokenValue(Interpreter.evaluate(params[0])));
            return NullValue;
        });

        //------------------------------------------
        //                  Math
        //------------------------------------------

        Little.registerFunction("sqrt", "Math", [Define(Identifier("decimal"), Identifier(TYPE_FLOAT))], (params) -> {
            return Decimal('${Math.sqrt(Interpreter.stringifyTokenValue(Interpreter.evaluate(params[0])).parseFloat())}');
        });
    }

}