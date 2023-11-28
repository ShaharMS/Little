package little.tools;

enum abstract Layer(String) from String to String {
    var LEXER = "Lexer";
    var PARSER = "Parser";
	var PARSER_MACRO = "Parser, Macro";
    var INTERPRETER = "Interpreter";
	var INTERPRETER_VALUE_EVALUATOR = "Interpreter, Value Evaluator";
	var INTERPRETER_EXPRESSION_EVALUATOR = "Interpreter, Expression Evaluator";
    var INTERPRETER_TOKEN_VALUE_STRINGIFIER = "Interpreter, Token Value Stringifier";
    var INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER = "Interpreter, Token Identifier Stringifier";
	var MEMORY = "Memory";
	var MEMORY_STACK = "Memory, Stack";
	var MEMORY_HEAP = "Memory, Heap";
	var MEMORY_GARBAGE_COLLECTOR = "Memory, Garbage Collector";

    public static function getIndexOf(layer:String) {
        return switch layer {
            case LEXER: 1;
            case PARSER: 2;
			case PARSER_MACRO: 3;
            case INTERPRETER: 4;
            case INTERPRETER_VALUE_EVALUATOR: 5;
            case INTERPRETER_EXPRESSION_EVALUATOR: 6;
            case INTERPRETER_TOKEN_VALUE_STRINGIFIER: 7;
            case INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER: 8;
			case MEMORY: 9;
			case MEMORY_STACK: 10;
			case MEMORY_HEAP: 11;
			case MEMORY_GARBAGE_COLLECTOR: 12;
            case _: 999999999;
        }
    }
}