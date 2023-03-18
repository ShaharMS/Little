package little.tools;

import little.lexer.Lexer;
import little.parser.Parser;
import little.interpreter.Interpreter;
import little.interpreter.Runtime;

import little.parser.Tokens;

using Std;

import little.Keywords.*;
class PrepareRun {
    
    public static function addFunctions() {

        Little.registerFunction("print", null, [Define(Identifier("item"), null)], (params) -> {
            Runtime.print(Interpreter.stringifyTokenValue(Interpreter.evaluate(params[0])));
            return NullValue;
        });
        Little.registerFunction("error", null, [Define(Identifier("message"), null)], (params) -> {
            Runtime.throwError(Interpreter.evaluate(params[0]));
            return NullValue;
        });
        Little.registerFunction("read", null, [Define(Identifier("string"), Identifier(TYPE_STRING))], (params) -> {
            return Read(Identifier(Interpreter.stringifyTokenValue(params[0])));
        });
        Little.registerFunction("run", null, [Define(Identifier("code"), Identifier(TYPE_STRING))], (params) -> {
            return Interpreter.interpret(Parser.parse(Lexer.lex(Interpreter.stringifyTokenValue(params[0]))), Interpreter.currentConfig);
        });

        //------------------------------------------
        //                  Math
        //------------------------------------------

        Little.registerFunction("sqrt", "Math", [Define(Identifier("decimal"), Identifier(TYPE_FLOAT))], (params) -> {
            return Decimal('${Math.sqrt(Interpreter.stringifyTokenValue(Interpreter.evaluate(params[0])).parseFloat())}');
        });
    }

    public static function addConditions() {
        Little.registerCondition("while", (params, body) -> {
            var val = NullValue;
            var safetyNet = 0;
            while (Interpreter.evaluateExpressionParts(params) == TrueValue) {
                if (safetyNet > 10000) return ErrorMessage("Too many iterations");
                trace(params);
                val = Interpreter.interpret(body, Interpreter.currentConfig);
                safetyNet++;
            }

            return val;
        });
    }
}