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

    static var code = 'define ohYeah of type Decimal = 5 + 55 + sin(60)';

    static function main() {
        trace(Lexer.splitBlocks1(Lexer.lexIntoComplex(code)).toString());
    }
}