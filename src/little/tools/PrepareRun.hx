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

        Little.plugin.registerFunction("print", null, [Define(Identifier("item"), null)], (params) -> {
            Runtime.print(Interpreter.stringifyTokenValue(Interpreter.evaluate(params[0])));
            return NullValue;
        });
        Little.plugin.registerFunction("error", null, [Define(Identifier("message"), null)], (params) -> {
            Runtime.throwError(Interpreter.evaluate(params[0]));
            return NullValue;
        });
        Little.plugin.registerFunction("read", null, [Define(Identifier("string"), Identifier(TYPE_STRING))], (params) -> {
            return Read(Identifier(Interpreter.stringifyTokenValue(params[0])));
        });
        Little.plugin.registerFunction("run", null, [Define(Identifier("code"), Identifier(TYPE_STRING))], (params) -> {
            return Interpreter.interpret(Parser.parse(Lexer.lex(params[0].getParameters()[0])), Interpreter.currentConfig);
        });

        //------------------------------------------
        //                  Math
        //------------------------------------------

        Little.plugin.registerHaxeClass(Data.getClassInfo("Math"));
    }

    public static function addConditions() {
        Little.plugin.registerCondition("while", [Define(Identifier("rule"), Identifier(Keywords.TYPE_BOOLEAN))] , (params, body) -> {
            var val = NullValue;
            var safetyNet = 0;
            while (Conversion.toHaxeValue(Interpreter.evaluateExpressionParts(params))) {
                if (safetyNet > 10000) return ErrorMessage("Too many iterations");
                val = Interpreter.interpret(body, Interpreter.currentConfig);
                safetyNet++;
            }

            return val;
        });

        Little.plugin.registerCondition("if", [Define(Identifier("rule"), Identifier(Keywords.TYPE_BOOLEAN))] , (params, body) -> {
            var val = NullValue;
            if (Conversion.toHaxeValue(Interpreter.evaluateExpressionParts(params))) {
                val = Interpreter.interpret(body, Interpreter.currentConfig);
            }

            return val;
        });
    }
}