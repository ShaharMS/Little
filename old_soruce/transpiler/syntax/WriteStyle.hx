package little.transpiler.syntax;

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