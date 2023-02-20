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
    '
    a = define {define i = 5; i = i + 1; ("num" + i)} = 6'
    ;

    static function main() {
        // #if js
        // var text = Browser.document.getElementById("input");
        // var output = Browser.document.getElementById("output");
        // trace(text, output);
        // text.addEventListener("keyup", (e) -> {
        //     try {
        //         output.innerHTML = Parser.prettyPrintAst(Parser.typeTokens(Lexer.splitBlocks1(Lexer.lexIntoComplex(untyped text.value))), 5);
        //     } catch (e) {}
        // });
        // #else
        // trace(Parser.prettyPrintAst(Parser.typeTokens(Lexer.splitBlocks1(Lexer.lexIntoComplex(code))), 5));
        
        // #end

        trace(
            refactored_little.tools.PrettyPrinter.printParserAst(
                refactored_little.parser.Parser.parse(
                    refactored_little.lexer.Lexer.separateBooleanIdentifiers(
                        refactored_little.lexer.Lexer.lex(code)
                    )
                )
            )
        );
    }
}