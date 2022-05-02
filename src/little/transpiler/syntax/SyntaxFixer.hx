package little. transpiler.syntax;

import texter.general.TextTools;
using StringTools;
/**
 * After Convertions, some unusual syntaxing artifects may occur.
 * 
 * `SyntaxFixer` does the cleanup job
 */
class SyntaxFixer {
    
    public static function removeSemicolonOverloads(code:String):String {
        code = ~/{;[1,]/g.replace(code, "");
        code = StringTools.replace(code, "\r", "");
        return ~/;[2,]$/gm.replace(code, ";");
    }

    public static function removeTrailingNewlines(code:String):String {
        return ~/\n[2,]/.replace(code, "\n");
    }

    public static function addSemicolons(code:String) {
        code = StringTools.replace(code, "\r", "");
        var lines = code.split("\n");
        for (i in 0...lines.length) {
            var ic = lines[i].trim().replace("\t", "").replace(" ", "");
            if (ic.length != 0 && ic.charAt(ic.length - 1) != "{" && ic.charAt(ic.length - 1) != "}" && lines[i + 1].charAt(0) != "{") {
                lines[i] += ";";
            }
        }
        return lines.join("\n");
    }

}