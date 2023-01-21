package;

import little.lexer.Lexer;
import little.interpreter.features.Evaluator;
import little.Little;
import little.Runtime;
import little.interpreter.Memory;
import little.interpreter.features.LittleDefinition;
import little.Interpreter;
import little.Transpiler;
using StringTools;
class Main {

    static var code = 'define ohYeah of type = 5 + 55\nx = y = 5';

    static function main() {
        trace(Lexer.lexIntoComplex(code).toString());
    }
}