package little.transpiler.desugering;
using StringTools;
class DLevel1 {

    /**
     * Desugering level 1: **Indentation**
     * 
     * - Replaces `    ` with `\t`
     * - Replaces `\r` with ` `
     */
    public static inline function desuger1(code:String):String {
        return code.replace("    ", "\t").replace("\r", "");
    }
}