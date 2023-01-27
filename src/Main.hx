package;

import texter.general.math.MathLexer;
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

    static var code = 'define ohYeah of type Decimal = 5 + (2 / 22).toString() + someNumber\na = b = 5';

    static function main() {
        trace(Lexer.astToString(Lexer.splitBlocks1(Lexer.lexIntoComplex(code))));
    }
}