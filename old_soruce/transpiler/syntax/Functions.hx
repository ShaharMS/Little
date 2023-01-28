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
    
    //detect a python function body and report its name, arguments and function body
    public static final clearFuncParse:EReg = ~/(.+?)* +action +([a-zA-Z0-9_]+) *\(([^)]*)\):/m;
    //now, create a public static function named parse using that regex that detects the function name, arguments and body - that function is in as3
    //that function should be written in Haxe
    public static function parse(code:String):String {
        while (clearFuncParse.match(code)) {
            //get the function name, arguments and visibility modifiers
            var name:String = clearFuncParse.matched(2);
            var args:String = clearFuncParse.matched(3);
            var mods:String = clearFuncParse.matched(1);
        }
        return code;
    }
    



    public static function getLineIndexOfChar(code:String, charIndex:Int):Int {
        var lines = code.split("\n");
        var lineIndex = 0;
        var charCount = 0;
        for (i in 0...lines.length) {
            var line = lines[i];
            charCount += line.length + 1;
            if (charCount > charIndex) {
                return lineIndex;
            }
            lineIndex++;
        }
        return -1;
    }

}

