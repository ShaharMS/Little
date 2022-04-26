package transpiler.syntax;

using StringTools;
/**
 * Contains methods for parsing and converting Minilang defenitions into haxe variables.
 * 
 * It also does some extra things for optimization:
 * 
 *  - strongly types the variables on static platforms to improve performance
 */
class VariableRecognition {
    
    public static final clearVarParse:EReg = ~/define +([a-zA-Z0-9_]+) += +(.+)/;

    public static function parseLine(line:String):String {
        var condensed = line.trim() + ";";
        clearVarParse.match(condensed);
        var name = clearVarParse.matched(1);
        var value = clearVarParse.matched(2);
        var type = Typer.getValueType(value);
        return 'var ${name}${if (type != "") ':$type' else ''} = $value;';
    }

    public static  function parse(code:String) {
        while (clearVarParse.match(code)) {
            final name = clearVarParse.matched(1);
            final value = clearVarParse.matched(2);
            final type = Typer.getValueType(value);
            code = clearVarParse.replace(code, 'var $name:$type = $value;');
        }
        return code;
    }
}