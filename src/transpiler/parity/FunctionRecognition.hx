package transpiler.parity;

/**
 * This class is used to to compile Haxe functions from Minilang functions.
 * 
 * It also includes some features to generate nicer code, such as:
 * 
 *  - intuitive syntax (not useing :Void)
 *  - inline styles (for now unsupported, but can alter the positioning of curly brackets/remove them)
 */
class FunctionRecognition {
    
    public static final clearFuncRecongnition:EReg = ~/action +([a-zA-A0-9_]+) *\(([^)]+)\) *= *[ \n\r]{(.+)}/s;

    public static function parse(code:String):String {
        while (clearFuncRecongnition.match(code)) {
            var name:String = clearFuncRecongnition.matched(1);
            var args:String = clearFuncRecongnition.matched(2);
            var body:String = clearFuncRecongnition.matched(3);
            trace(body);
            var lines = body.split("\n");
            for (i in 1...lines.length) if (lines[i] == "" && lines[i].indexOf(';') != lines[i].length) lines[i] += ";";
            body = lines.join("\n");
            code = clearFuncRecongnition.replace(code, "function " + name + "(" + args + ") { " + body + " }");
        }
        return code;
    }

}

enum WriteStyle {
    /**
     * For one-line functions, will generate:
     * 
     * ```haxe
     * function inlineBody() do something;
     * ```
     * Otherwise, it will use the style inserted in `defaultStyle`
     */
    Inline(defaultType:WriteStyle);

    /**
     * Generates function with a one-lined but full function body:
     * 
     * ```haxe
     * function sameLineBody():Int {var hello = 10; hello += 1; return hello}
     * ```
     */
    SAME_LINE;

    /**
     * Generates function with a multi-lined function body, where all curly brackets are on the same indent level:
     * 
     * ```haxe
     * function sameLevelBody()
     * {
     *     var hello = 10;
     *     hello += 1;
     *     //uniform indent level
     * }
     * ```
     */
    SAME_LEVEL;

    /**
     * Generates function with a multi-lined function body, where the starting bracket is after the function:
     * 
     * ```haxe
     * function sameLevelBody() {
     *     var hello = 10;
     *     hello += 1;
     * }
     * ```
     */
    ARCH;
}