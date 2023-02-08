package;

import little.expressions.Expressions;
import little.lexer.Specifics;
import texter.general.math.MathLexer;
import little.lexer.Lexer;
using StringTools;
class Main {

    static var code = /*'
    define ohYeah as Decimal = 5 + (2 / 22).toString(2, 2) + someNumber + (true || false)
    a = b = 5
    var.property = 5
    action x(a as Number = 5, b = 6, c as Decimal) as Decimal {
        c = 5
        define d = 3
        return x(c, d, e)
        return 0
    }
    if (a == b) {
        if (b * 2 == a * 2) {
            a = b = a - 1
            x(a, b, 0)
        }
    }
    a.c = 55 * 3'*/
    'if (x) 
    {
        a = b
        if (y) {
            d = 7
            define x as Decimal = 343.5 + 5 * 3

        }
        e = 2
    }
    
    action a() {
        if (x) {
            a = 3
        }
    }'
    ;

    static function main() {
        trace(Lexer.prettyPrintAst(Lexer.splitBlocks1(Lexer.lexIntoComplex(code)), 5));
        // trace(Specifics.extractActionBody(Specifics.cropCode("a = b = 5\nvar.property = 5\naction x(a, b) as Decimal {\n\n\n\nc = 5\ndefine d = 3\nx(c, d)\n}\na = 5\na = 5", 2)));
        // trace(Lexer.prettyPrintAst(Lexer.splitBlocks1(Lexer.lexIntoComplex("if (x == 5) {\na = 5\n}\nfor (i from 0 to 5 every 3)\nwhile(a <= 5)"))));
        // var exp = Lexer.splitBlocks1(Lexer.lexIntoComplex("3 - 5 + 5 -false - false * \"ggg\""));
        // exp.shift();
        // trace(exp);
        // trace(little.parser.Specifics.evaluateExpressionType(Expression(exp)));
        // Expressions.lex('555 + 3.toString(16) + (hey + "hey there!")');
    }
}