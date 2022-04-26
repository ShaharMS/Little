package transpiler.syntax;

/**
 * After Convertions, some unusual syntaxing artifects may occur.
 * 
 * `SyntaxFixer` does the cleanup job
 */
class SyntaxFixer {
    
    public static function removeDoubleSemicolons(code:String):String {
        return ~/;;$/gm.replace(code, ";");
    }

}