package little. transpiler.syntax;

using StringTools;
/**
 * Contains methods for parsing and converting `Little` definitions into `Haxe` variables.
 * 
 * It also does some extra things for optimization:
 * 
 *  - strongly types the variables on static platforms to improve performance
 */
class VariableRecognition {
    
    public static final clearVarParse:EReg = ~/([^\n]*) define +([a-zA-Z0-9_]+) += +(.+)/;

    public static function parseLine(line:String):String {
        var condensed = line.trim() + ";";
        clearVarParse.match(condensed);
        var modifier = clearVarParse.matched(1).replace("hide", "private").replace("external", "");
        if (modifier == "") modifier = "public";
        var name = clearVarParse.matched(2);
        var value = clearVarParse.matched(3);
        var type = Typer.getValueType(value);
        return '${modifier} var ${name}${if (type != "") ':$type' else ''} = $value;';
    }

    public static  function parse(code:String) {
        while (clearVarParse.match(code)) {
            var modifier = clearVarParse.matched(1).replace("hide", "private").replace("external", "");
            if (modifier == "") modifier = "public";
            final name = clearVarParse.matched(2);
            final value = clearVarParse.matched(3);
            final type = Typer.getValueType(value);
            code = clearVarParse.replace(code, '$modifier var $name${if (type != "") ':$type' else ''} = $value;');
        }
        return code;
    }
}