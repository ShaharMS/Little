package;

#if js
import js.Browser;
#end
import little.parser.Parser;
import little.expressions.Expressions;
import little.lexer.Specifics;
import texter.general.math.MathLexer;
import little.lexer.Lexer;
using StringTools;
class Main {

    static var code = 
    'if (x) 
    {
        a = b
        if (y) {
            d = 7
            define x as Decimal = 343.5 + 5 * 3 - true

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
        #if js
        var text = Browser.document.getElementById("input");
        var output = Browser.document.getElementById("output");
        trace(text, output);
        text.addEventListener("keyup", (e) -> {
            try {
                output.innerHTML = Parser.prettyPrintAst(Parser.typeTokens(Lexer.splitBlocks1(Lexer.lexIntoComplex(untyped text.value))), 5);
            } catch (e) {}
        });
        #else
        trace(Parser.prettyPrintAst(Parser.typeTokens(Lexer.splitBlocks1(Lexer.lexIntoComplex(code))), 5));
        
        #end
    }
}