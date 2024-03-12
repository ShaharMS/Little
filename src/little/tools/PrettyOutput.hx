package little.tools;

import little.parser.Tokens.ParserTokens;
import little.lexer.Lexer;
import little.parser.Parser;

using StringTools;

class PrettyOutput {
    /**
        Uses the parser to generate the AST, and then returns an HTML table of each stage of the parsing process.
    **/
    public static function generateAstHtml(code:String):String {
        var htmlFile = "<table><tr><th>Stage</th><th>AST</th></tr>";
        
        var lexical = Parser.convert(Lexer.lex(code));

        var map:OrderedMap<String, Array<ParserTokens> -> Array<ParserTokens>> = new OrderedMap();
        for (k => v in [
            "Merge Blocks" => Parser.mergeBlocks, 
            "Merge Expressions" => Parser.mergeExpressions, 
            "Merge Property Operations" => Parser.mergePropertyOperations, 
            "Merge Type Declarations" => Parser.mergeTypeDecls, 
            "Merge Complex Structures" => Parser.mergeComplexStructures, 
            "Merge Calls" => Parser.mergeCalls,
            "Merge Writes" => Parser.mergeWrites,
            "Marge Values With Type Decl" => Parser.mergeValuesWithTypeDeclarations,
            "Merge Non-Block Bodies" => Parser.mergeNonBlockBodies,
            "Merge Elses" => Parser.mergeElses
        ]) map.set(k, v);

        for (key => func in map) {
            htmlFile += '<tr><th>$key</th>';
            var pretty = PrettyPrinter.printParserAst(func(lexical));
            pretty = pretty.replace("\n", "<br>").replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;");
            htmlFile += '<td>$pretty</td></tr>';
        }
        htmlFile += "</table>";

        return htmlFile;
    }
}