package;

import little.lexer.Specifics;
import texter.general.math.MathLexer;
import little.lexer.Lexer;
using StringTools;
class Main {

    static var code = '
    define ohYeah as Decimal = 5 + (2 / 22).toString(2, 2) + someNumber + (true || false)
    a = b = 5
    var.property = 5
    action x(a as Number = 5, b = 6, c as Decimal) as Decimal {
        c = 5
        define d = 3
        if (d < 3) {
            return x(c, d, e)
        }
        return 0
    }
    a.c = 55 * 3';

    static function main() {
        trace(Lexer.prettyPrintAst(Lexer.splitBlocks1(Lexer.lexIntoComplex(code)), 5));
        // trace(Specifics.extractActionBody(Specifics.cropCode("a = b = 5\nvar.property = 5\naction x(a, b) as Decimal {\n\n\n\nc = 5\ndefine d = 3\nx(c, d)\n}\na = 5\na = 5", 2)));
        // trace(Lexer.prettyPrintAst(Lexer.splitBlocks1(Lexer.lexIntoComplex("if (x == 5) {\na = 5\n}\nfor (i from 0 to 5 every 3)\nwhile(a <= 5)"))));
    }
}