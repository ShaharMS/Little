package little.tools;

import little.interpreter.Interpreter;
import little.interpreter.Runtime;

using Std;

import little.Keywords.*;
class PrepareRun {
    
    public static function addFunctions() {
        Little.registerFunction("print", null, PartArray([Define(Identifier("item"), null)]), (params) -> {
            Runtime.print(Interpreter.stringifyTokenValue(Interpreter.evaluate(params)));
            return NullValue;
        });

        //------------------------------------------
        //                  Math
        //------------------------------------------

        Little.registerFunction("sqrt", "Math", PartArray([Define(Identifier("decimal"), Identifier(TYPE_FLOAT))]), (params) -> {
            return Decimal('${Math.sqrt(Interpreter.stringifyTokenValue(Interpreter.evaluate(params)).parseFloat())}');
        });
    }

}