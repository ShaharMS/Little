package little.interpreter;

enum abstract Layer(String) from String to String {
    var LEXER = "lexer";
    var PARSER = "parser";
    var INTERPRETER = "interpreter";
}