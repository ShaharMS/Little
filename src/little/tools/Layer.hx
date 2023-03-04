package little.tools;

enum abstract Layer(String) from String to String {
    var LEXER = "Lexer";
    var PARSER = "Parser";
    var INTERPRETER = "Interpreter";
    var INTERPRETER_TOKEN_STRINGIFIER = "Interpreter, Token Stringifier";
}