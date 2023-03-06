package little.interpreter;

import little.parser.Tokens.ParserTokens;
import little.Keywords.*;
using StringTools;
using Std;
using Math;
using little.tools.TextTools;
@:access(little.interpreter.Runtime)
class Interpreter {
    
    public static var errorThrown = false;

    
    public static var varMemory:Map<String, ParserTokens> = [];
    public static var funcMemory:Map<String, ParserTokens> = [];

    public static var currentConfig:RunConfig;

    public static function interpret(tokens:Array<ParserTokens>, runConfig:RunConfig) {
        currentConfig = runConfig;
        if (tokens[0].getName() != "Module") {
            tokens.unshift(Module(runConfig.defaultModuleName));
        }
        runTokens(tokens, runConfig.prioritizeVariableDeclarations, runConfig.prioritizeFunctionDeclarations, runConfig.strictTyping);
    }

    public static function runTokens(tokens:Array<ParserTokens>, preParseVars:Bool, preParseFuncs:Bool, strict:Bool):ParserTokens {
        // Todo: support preParseVars
        // Todo: support preParseFuncs

        var returnVal:ParserTokens = null;

        var i = 0;
        while (i < tokens.length) {
            var token = tokens[0];
            switch token {
                case SetLine(line): Runtime.line = line;
                case Module(name): Runtime.currentModule = name;
                case Number(num):
                case Decimal(num):
                case Characters(string):
                case NullValue:
                case TrueValue:
                case FalseValue:
                case SplitLine:
                case Define(name, type): 
                case Action(name, params, type):
                case Condition(name, exp, body, type):
                case Read(name):
                case Write(assignees, value, type):
                case Identifier(word):
                case TypeDeclaration(type):
                case ActionCall(name, params):
                case Return(value, type):
                case Expression(parts, type):
                case Block(body, type):
                case PartArray(parts):
                case Parameter(name, type):
                case Sign(sign):
                case External(haxeValue):
                case _:
            }
        }

        return returnVal;
    }

    public static function stringifySimpleToken(token:ParserTokens):String {

        if (token.getName() == "ErrorMessage") Runtime.throwError(token, INTERPRETER_TOKEN_STRINGIFIER);

        switch token {
            case Block(body, type): return stringifySimpleToken(runTokens(body, currentConfig.prioritizeVariableDeclarations, currentConfig.prioritizeFunctionDeclarations, currentConfig.strictTyping));
            case Expression(parts, type): return stringifySimpleToken(evaluate(token));
            case Characters(string): return string;
            case Number(num): return num;
            case Decimal(num): return num;
            case TrueValue: return Keywords.TRUE_VALUE;
            case FalseValue: return Keywords.FALSE_VALUE;
            case NullValue: return Keywords.NULL_VALUE;
            case Read(name): {
                var str = stringifySimpleToken(name);
                return stringifySimpleToken(if (varMemory[str] != null) varMemory[str] else if (funcMemory[str] != null) funcMemory[str] else ErrorMessage('No Such Definition/Action: $str'));
            }
            case Write(_, value, _): {
                return stringifySimpleToken(value);
            }
            case _:
        }

        return "Something went wrong";
    }

    public static function evaluate(exp:ParserTokens):ParserTokens {
        if (exp.getName() == "ErrorMessage") Runtime.throwError(exp, INTERPRETER_VALUE_EVALUATOR);

        switch exp {
            case Expression(parts, type): {
                return evaluateExpressionParts(parts);
            }
            case Block(body, type): {
                var returnVal = runTokens(body, currentConfig.prioritizeVariableDeclarations, currentConfig.prioritizeFunctionDeclarations, currentConfig.strictTyping);
                return evaluate(returnVal);
            }
            case Number(_) | Decimal(_) | Characters(_) | TrueValue | FalseValue | NullValue: return exp;
            case Write(_, value, _): return evaluate(value);
            case Read(name): {
                var str = stringifySimpleToken(name);
                return evaluate(if (varMemory[str] != null) varMemory[str] else if (funcMemory[str] != null) funcMemory[str] else ErrorMessage('No Such Definition/Action: $str'));
            }
            case _:
        }

        

        return null;
    }

    public static function evaluateExpressionParts(parts:Array<ParserTokens>):ParserTokens {

        var value = "", valueType = TYPE_UNKNOWN, mode = "+";

        for (token in parts) {
            var val:ParserTokens = null;
            switch token {
                case Block(body, type): {
                    val = runTokens(body, currentConfig.prioritizeVariableDeclarations, currentConfig.prioritizeFunctionDeclarations, currentConfig.strictTyping);
                }
                case Expression(parts, type): {
                    val = evaluateExpressionParts(parts);
                }
                case _: val = evaluate(token); // Safety net, for expressions containing things other then values/reads
            }

            switch val {
                case Sign(sign): mode = sign;
                case TrueValue | FalseValue: {
                    if (valueType == TYPE_BOOLEAN) {
                        var bool = (val == TrueValue);
                        switch mode {
                            case "&&": value = (value.parseBool() && bool).string();
                            case "||": value = (value.parseBool() || bool).string();
                            case "==": value = (value.parseBool() == bool).string();
                            case "^^" | "!=": value = (value.parseBool() != bool).string(); // xor
                            case _: return ErrorMessage('Cannot preform $valueType($value) $mode $TYPE_BOOLEAN($bool)');
                        }
                    } else if (valueType == TYPE_INT || valueType == TYPE_FLOAT) {
                        var num = (val == TrueValue) ? 1 : 0;
                        switch mode {
                            case "+": value = "" + (value.parseInt() + num);
                            case "-": value = "" + (value.parseInt() - num);
                            case "*": value = "" + (value.parseInt() * num);
                            case "/": {
                                valueType = TYPE_FLOAT;
                                value = "" + (value.parseInt() / num);
                            }
                            case _: return ErrorMessage('Cannot preform $valueType($value) $mode $TYPE_BOOLEAN(${(val == TrueValue)})');
                        }
                    } else if (valueType == TYPE_STRING) {
                        var bool = (val == TrueValue) ? "true" : "false";
                        switch mode {
                            case "+": value += bool;
                            case "-": value = value.replaceLast(bool, "");
                            case "*": value = value.multiply(bool.parseBool() ? 1 : 0);
                            case _: return ErrorMessage('Cannot preform $valueType($value) $mode $TYPE_BOOLEAN(${(val == TrueValue)})');
                        }
                    }
                }
                case Number(num): {
                    if (valueType == TYPE_BOOLEAN) {
                        valueType = TYPE_INT;
                        // Convert true/false to 1/0
                        value = value.replace(TRUE_VALUE, "1").replace(FALSE_VALUE, "0").replace(NULL_VALUE, "0");
                    } else if (valueType == TYPE_FLOAT || valueType == TYPE_INT) {
                        switch mode {
                            case "+": value = "" + (value.parseInt() + num.parseInt());
                            case "-": value = "" + (value.parseInt() - num.parseInt());
                            case "*": value = "" + (value.parseInt() * num.parseInt());
                            case "/": {
                                valueType = TYPE_FLOAT;
                                value = "" + (value.parseInt() / num.parseInt());
                            }
                            case _: return ErrorMessage('Cannot preform $valueType($value) $mode $TYPE_INT($num)');
                        }
                    } else if (valueType == TYPE_STRING) {
                        switch mode {
                            case "+": value += num;
                            case "-": value = value.replaceLast(num, "");
                            case "*": value = value.multiply(num.parseInt());
                            case _: return ErrorMessage('Cannot preform $valueType($value) $mode $TYPE_INT($num)');
                        }
                    }
                }
                case Decimal(num): {
                    if (valueType == TYPE_BOOLEAN) {
                        valueType = TYPE_FLOAT;
                        // Convert true/false to 1/0
                        value = value.replace(TRUE_VALUE, "1").replace(FALSE_VALUE, "0").replace(NULL_VALUE, "0");
                    } else if (valueType == TYPE_FLOAT || valueType == TYPE_INT) {
                        switch mode {
                            case "+": value = "" + (value.parseFloat() + num.parseFloat());
                            case "-": value = "" + (value.parseFloat() - num.parseFloat());
                            case "*": value = "" + (value.parseFloat() * num.parseFloat());
                            case "/": value = "" + (value.parseFloat() / num.parseFloat());
                            case _: return ErrorMessage('Cannot preform $valueType($value) $mode $TYPE_FLOAT($num)');
                        }
                    } else if (valueType == TYPE_STRING) {
                        switch mode {
                            case "+": value += num;
                            case "-": value = value.replaceLast(num, "");
                            case _: return ErrorMessage('Cannot preform $valueType($value) $mode $TYPE_FLOAT($num)');
                        }
                    }
                }
                case Characters(string): {
                    valueType = TYPE_STRING;
                    switch mode {
                        case "+": value += string;
                        case "-": value = value.replaceLast(string, "");
                        case _: return ErrorMessage('Cannot preform $valueType($value) $mode $TYPE_STRING($string)');
                    }
                }

                case _:
            }
        }

        switch valueType {
            case (_ == TYPE_INT => true): return Number(value);
            case (_ == TYPE_FLOAT => true): return Decimal(value);
            case (_ == TYPE_BOOLEAN => true): return value == "true" ? TrueValue : FalseValue;
            case (_ == TYPE_STRING => true): return Characters(value);
            case _:
        }

        return null;
    }
}