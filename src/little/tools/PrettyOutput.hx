package little.tools;

import little.lexer.Lexer;
import little.parser.Parser;

using StringTools;

class PrettyOutput {
    

    public static function generateAstHtml(code:String):String {
        var htmlFile = "<table><tr><th>Stage</th><th>AST</th></tr>";
        
        var lexical = Parser.convert(Lexer.lex(code));

        var map = [
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
        ];

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