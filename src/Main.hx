package;

import texter.general.math.MathLexer;
import little.lexer.Lexer;
using StringTools;
class Main {

    static var code = 'define ohYeah as Decimal = 5 + (2 / 22).toString() + someNumber; a = b = 5';

    static function main() {
        trace(Lexer.prettyPrintAst(Lexer.splitBlocks1(Lexer.lexIntoComplex(code))));
    }
}