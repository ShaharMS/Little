package little. transpiler.syntax;

/**
 * After Convertions, some unusual syntaxing artifects may occur.
 * 
 * `SyntaxFixer` does the cleanup job
 */
class SyntaxFixer {
    
    public static function removeSemicolonOverloads(code:String):String {
        code = ~/{ *;[1,]/gm.replace(code, "");
        return ~/;[2,]$/gm.replace(code, ";");
    }

}