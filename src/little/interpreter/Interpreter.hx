package little.interpreter;

import little.parser.Tokens.ParserTokens;

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
        var nVal:Int = null, dVal:Float = null, sVal:String = null, bVal:Bool = null, mode:String = "";
        var returnVal:ParserTokens = null;

        if (exp.getName() == "ErrorMessage") Runtime.throwError(exp, INTERPRETER_TOKEN_STRINGIFIER);

        switch exp {
            case Expression(parts, type): {
                for (token in parts) {
                    var tokenVal = evaluate(token); // Handles nested Blocks/Expressions
                }
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

        

        return returnVal;
    }
}