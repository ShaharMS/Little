package little.tools;

import little.lexer.Lexer;
import little.parser.Parser;
import little.interpreter.Interpreter;
import little.interpreter.Runtime;

import little.parser.Tokens;
import little.interpreter.memory.MemoryObject;

using Std;

import little.Keywords.*;
class PrepareRun {
    
    public static var prepared:Bool = false;

    public static function addTypes() {
        Little.plugin.registerHaxeClass(Data.getClassInfo("Math"));
        Little.plugin.registerHaxeClass(Data.getClassInfo("String"), TYPE_STRING);
        Little.plugin.registerHaxeClass(Data.getClassInfo("Array"), "Array"); // Experimental
        Interpreter.memory.set(TYPE_DYNAMIC, new MemoryObject(Module(TYPE_DYNAMIC), [], null, Identifier(TYPE_MODULE), true));
        Interpreter.memory.set(TYPE_INT, new MemoryObject(Module(TYPE_INT), [], null, Identifier(TYPE_MODULE), true));
        Interpreter.memory.set(TYPE_FLOAT, new MemoryObject(Module(TYPE_FLOAT), [], null, Identifier(TYPE_MODULE), true));
        Interpreter.memory.set(TYPE_BOOLEAN, new MemoryObject(Module(TYPE_INT), [], null, Identifier(TYPE_BOOLEAN), true));

    }

    public static function addProps() {
        Little.plugin.registerProperty("type", TYPE_DYNAMIC, true, null, {
            valueGetter: parent -> {
                trace(parent.value);
                trace(Interpreter.getValueType(parent.value));
                trace(Interpreter.stringifyTokenIdentifier(Interpreter.getValueType(parent.value)));
                return Characters(Interpreter.stringifyTokenIdentifier(Interpreter.getValueType(parent.value)));
            },
            allowWriting: false
        });
    }

    public static function addFunctions() {

        Little.plugin.registerFunction(PRINT_FUNCTION_NAME, null, [Define(Identifier("item"), null)], (params) -> {
            Runtime.print(Interpreter.stringifyTokenValue(Interpreter.evaluate(params[0])));
            return NullValue;
        });
        Little.plugin.registerFunction(RAISE_ERROR_FUNCTION_NAME, null, [Define(Identifier("message"), null)], (params) -> {
            Runtime.throwError(Interpreter.evaluate(params[0]));
            return NullValue;
        });
        Little.plugin.registerFunction(READ_FUNCTION_NAME, null, [Define(Identifier("string"), Identifier(TYPE_STRING))], (params) -> {
            return Read(Identifier(Interpreter.stringifyTokenValue(params[0])));
        });
        Little.plugin.registerFunction(RUN_CODE_FUNCTION_NAME, null, [Define(Identifier("code"), Identifier(TYPE_STRING))], (params) -> {
            return Interpreter.interpret(Parser.parse(Lexer.lex(params[0].getParameters()[0])), Interpreter.currentConfig);
        });
    }

    public static function addConditions() {
        Little.plugin.registerCondition("while", [Define(Identifier("rule"), Identifier(Keywords.TYPE_BOOLEAN))] , (params, body) -> {
            var val = NullValue;
            var safetyNet = 0;
            while (Conversion.toHaxeValue(Interpreter.evaluateExpressionParts(params))) {
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

        Little.plugin.registerCondition("for", (params:Array<ParserTokens>, body) -> {
            var val = NullValue;

            var fp = [];

            // Incase one does `from (4 + 2)` and it accidentally parses a function
            for (p in params) {
                switch p {
                    case ActionCall(_.getParameters()[0] == FOR_LOOP_IDENTIFIERS.FROM => true, params): {
                        fp.push(Identifier(FOR_LOOP_IDENTIFIERS.FROM));
                        fp.push(Expression(params.getParameters()[0], null));
                    }
                    case ActionCall(_.getParameters()[0] == FOR_LOOP_IDENTIFIERS.TO => true, params): {
                        fp.push(Identifier(FOR_LOOP_IDENTIFIERS.TO));
                        fp.push(Expression(params.getParameters()[0], null));
                    }
                    case ActionCall(_.getParameters()[0] == FOR_LOOP_IDENTIFIERS.JUMP => true, params): {
                        fp.push(Identifier(FOR_LOOP_IDENTIFIERS.JUMP));
                        fp.push(Expression(params.getParameters()[0], null));
                    }
                    case _: fp.push(p);
                }
            }

            params = fp;

            var handle = Interpreter.accessObject(params[0]);
            if (handle == null) {
                Runtime.throwError(ErrorMessage('`for` loop must start with a variable to count on (expected definition/block, found: `${params[0]}`)'));
                return val;
            }
            
            var from:Null<Float> = null, to:Null<Float> = null, jump:Float = 1;

            function parserForLoop(token:ParserTokens, next:ParserTokens) {
                switch token {
                    case Identifier(_ == FOR_LOOP_IDENTIFIERS.FROM => true): {
                        var val = Conversion.toHaxeValue(Interpreter.evaluate(next));
                        if (val is Float || val is Int) {
                            from = val;
                        } else {
                            Runtime.throwError(ErrorMessage('`for` loop\'s `${FOR_LOOP_IDENTIFIERS.FROM}` argument must be of type $TYPE_INT/$TYPE_FLOAT (given: ${Interpreter.stringifyTokenValue(next)} as ${Interpreter.evaluate(next).getName()})'));
                        }
                    }
                    case Identifier(_ == FOR_LOOP_IDENTIFIERS.TO => true): {
                        var val = Conversion.toHaxeValue(Interpreter.evaluate(next));
                        if (val is Float || val is Int) {
                            to = val;
                        } else {
                            Runtime.throwError(ErrorMessage('`for` loop\'s `${FOR_LOOP_IDENTIFIERS.TO}` argument must be of type $TYPE_INT/$TYPE_FLOAT (given: ${Interpreter.stringifyTokenValue(next)} as ${Interpreter.evaluate(next).getName()})'));
                        }
                    }
                    case Identifier(_ == FOR_LOOP_IDENTIFIERS.JUMP => true): {
                        var val = Conversion.toHaxeValue(Interpreter.evaluate(next));
                        if (val is Float || val is Int) {
                            if (val < 0) {
                                Runtime.throwError(ErrorMessage('`for` loop\'s `${FOR_LOOP_IDENTIFIERS.JUMP}` argument must be positive (given: ${Interpreter.stringifyTokenValue(next)}). Notice - the usage of the `${FOR_LOOP_IDENTIFIERS.JUMP}` argument switches from increasing to decreasing the value of `${params[0].getParameters()[0]}` if `${FOR_LOOP_IDENTIFIERS.FROM}` is larger than `${FOR_LOOP_IDENTIFIERS.TO}`. Defaulting to 1'));
                            } else jump = val;
                        } else {
                            Runtime.throwError(ErrorMessage('`for` loop\'s `${FOR_LOOP_IDENTIFIERS.JUMP}` argument must be of type $TYPE_INT/$TYPE_FLOAT (given: ${Interpreter.stringifyTokenValue(next)} as ${Interpreter.evaluate(next).getName()}). Defaulting to `1`'));
                        }
                    }
                    case Block(_): {
                        var ident = Interpreter.evaluate(token);
                        parserForLoop(ident.getName() == "Characters" ? Identifier(ident.getParameters()[0]) : ident , next);
                    }
                    case _:
                }
            }

            var i = 1;

            while (i < fp.length) {
                var token = fp[i];
                var next = [];

                var lookahead = fp[i + 1];
                while (!Type.enumEq(lookahead, Identifier(FOR_LOOP_IDENTIFIERS.TO)) && !Type.enumEq(lookahead, Identifier(FOR_LOOP_IDENTIFIERS.JUMP))) {
                    next.push(lookahead);
                    lookahead = fp[++i + 1];
                    if (lookahead == null) break;
                }
                i--;

                //trace(token, next);
                parserForLoop(token, Expression(next, null));
                i += 2;
            }

            if (from == null) {
                Runtime.throwError(ErrorMessage('`for` loop must contain a `${FOR_LOOP_IDENTIFIERS.FROM}` argument.'));
                return val;
            }
            if (from == null) {
                Runtime.throwError(ErrorMessage('`for` loop must contain a `${FOR_LOOP_IDENTIFIERS.TO}` argument.'));
                return val;
            }

            if (from < to) {
                while (from < to) {
                    val = Interpreter.interpret([Write([params[0]], if (from == from.int()) Number("" + from) else Decimal("" + from), null)].concat(body), Interpreter.currentConfig);
                    from += jump;
                }
            } else {
                while (from > to) {
                    val = Interpreter.interpret([Write([params[0]], if (from == from.int()) Number("" + from) else Decimal("" + from), null)].concat(body), Interpreter.currentConfig);
                    from -= jump;
                }
            }

            return val;
        });

        Little.plugin.registerCondition("after", [Define(Identifier("rule"), Identifier(TYPE_BOOLEAN))], (params, body) -> {
            var val = NullValue;

            var handle = Interpreter.accessObject(params[0].getParameters()[0][0]);
            if (handle == null) {
                Runtime.throwError(ErrorMessage('`after` condition must start with a variable to watch (expected definition, found: `${params[0].getParameters()[0][0]}`)'));
                return val;
            }

            function dispatchAndRemove(set:ParserTokens) {
                if (Conversion.toHaxeValue(Interpreter.evaluateExpressionParts(params))) {
                    Interpreter.interpret(body, Interpreter.currentConfig);
                    handle.setterListeners.remove(dispatchAndRemove);
                }
            }
            handle.setterListeners.push(dispatchAndRemove);

            return val;
        });

        Little.plugin.registerCondition("whenever", [Define(Identifier("rule"), Identifier(TYPE_BOOLEAN))], (params, body) -> {
            var val = NullValue;

            var handle = Interpreter.accessObject(params[0].getParameters()[0][0]);
            if (handle == null) {
                Runtime.throwError(ErrorMessage('`whenever` condition must start with a variable to watch (expected definition, found: `${params[0].getParameters()[0][0]}`)'));
                return val;
            }

            function dispatchAndRemove(set:ParserTokens) {
                if (Conversion.toHaxeValue(Interpreter.evaluateExpressionParts(params))) {
                    Interpreter.interpret(body, Interpreter.currentConfig);
                }
            }
            handle.setterListeners.push(dispatchAndRemove);

            return val;
        });
    }
}