package little. transpiler.syntax;

using StringTools;
/**
 * This class is used to to compile `Haxe` functions from `Little` functions.
 * 
 * It also includes some features to generate nicer code, such as:
 * 
 *  - intuitive syntax (not using :Void)
 *  - inline styles (for now unsupported, but can alter the positioning of curly brackets/remove them)
 */
class FunctionRecognition {
    
    public static final clearFuncParse:EReg = ~/((?:external: |hide | |\t|^)+)action +([a-zA-Z0-9_]+) *\(([^)]*)\) *= *[ \n\r]*{((?:.|\n)*)}/m;

    public static function parse(code:String, ?style:WriteStyle = SAME_LEVEL):String {
        while (clearFuncParse.match(code)) {
            var modifier = clearFuncParse.matched(1).replace("hide", "private").replace("external", ""); if (modifier == "") modifier = "public";
            final name:String = clearFuncParse.matched(2);
            final args:String = clearFuncParse.matched(3);
            final body:String = clearFuncParse.matched(4).charAt(0) == "\n" ? clearFuncParse.matched(4).substring(1, clearFuncParse.matched(4).length) : clearFuncParse.matched(4);
            code = clearFuncParse.replace(code, '$modifier function $name($args)');

            function writeStyle() {
                switch style {
                    case Inline(defaultType): {
                        if (body.contains("\n")) {
                            style = defaultType;
                            writeStyle();
                        }
                        code += ' $body';
                    }
                    case SAME_LINE: code += ' {$body}';
                    case SAME_LEVEL: code += '\n{\n$body\n}';
                    case ARCH: code += ' {\n$body\n}';
                }
            }
            writeStyle();
        }
        return code;
    }

}

