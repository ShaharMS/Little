package little.tools;

enum abstract Layer(String) from String to String {
    var LEXER = "Lexer";
    var PARSER = "Parser";
    var INTERPRETER = "Interpreter";
    var INTERPRETER_TOKEN_VALUE_STRINGIFIER = "Interpreter, Token Value Stringifier";
    var INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER = "Interpreter, Token Identifier Stringifier";
    var INTERPRETER_VALUE_EVALUATOR = "Interpreter, Value Evaluator";
    var INTERPRETER_EXPRESSION_EVALUATOR = "Interpreter, Expression Evaluator";

    public static function getIndexOf(layer:String) {
        return switch layer {
            case LEXER: 1;
            case PARSER: 2;
            case INTERPRETER: 3;
            case INTERPRETER_VALUE_EVALUATOR: 4;
            case INTERPRETER_EXPRESSION_EVALUATOR: 5;
            case INTERPRETER_TOKEN_VALUE_STRINGIFIER: 6;
            case INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER: 6;
            case _: 999999999;
        }
    }
}