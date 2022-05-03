package little. transpiler.syntax;

import haxe.zip.Reader;
using StringTools;
using texter.general.TextTools;
/**
 * This class is used to to compile `Haxe` functions from `Little` functions.
 * 
 * It also includes some features to generate nicer code, such as:
 * 
 *  - intuitive syntax (not using :Void)
 *  - inline styles (for now unsupported, but can alter the positioning of curly brackets/remove them)
 */
class Functions {
    
    public static final clearFuncParse:EReg = ~/((?:external: |hide | |\t|^)+)action +([a-zA-Z0-9_]+) *\(([^)]*)\) *=/m;

    public static function parse(code:String, ?style:WriteStyle = SAME_LEVEL):String {
        while (clearFuncParse.match(code)) {
            var modifier = clearFuncParse.matched(1).replace("hide", "private").replace("external", ""); if (modifier == "") modifier = "public";
            final name:String = clearFuncParse.matched(2);
            final args:String = clearFuncParse.matched(3);
            final positions = clearFuncParse.matchedPos();
            final li = getLineIndexOfChar(code, positions.pos);
            var line = code.split("\n")[li].replace("    ", "\t");
            var indentLevel = line.length - line.replace("\t", "").length + 1;
            var potentCode = code.split("\n").slice(li);
            for (i in 0...potentCode.length) {
                if (potentCode[i].length == 0) continue;
                if (potentCode[i].length - potentCode[i].replace("\t", "").length < indentLevel) {
                    potentCode = potentCode.slice(0, i);
                    break;
                }
            }            
            var body = potentCode.join("\n");
            
            
        }
        return code;
    }

    /**
     * Base 0
     * @param string 
     * @param index 
     * @return Int
     */
    static function getLineIndexOfChar(string:String, index:Int):Int {
        var stringToCalc = string.substring(0, index + 1), sum = 0;
        for (i in 0... stringToCalc.length) {
            if (stringToCalc.charAt(i) == "\n") sum++;
        }

        return sum;
    }

}

