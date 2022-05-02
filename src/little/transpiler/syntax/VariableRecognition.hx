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
    
    public static final clearVarParse:EReg = ~/((?:external: |hide | |\t|^)+)define +([a-zA-Z0-9_]+)(:[a-zA-Z0-9]+|) += +(.+)/m;

    public static  function parse(code:String) {
        while (clearVarParse.match(code)) {
            var modifier = clearVarParse.matched(1).replace("hide", "private").replace("external: ", "");
            if (modifier == "") modifier = "public";
            final name = clearVarParse.matched(2);
            final value = clearVarParse.matched(4);
            final type = clearVarParse.matched(3).contains(":") ? Typer.basicTypeToHaxe[clearVarParse.matched(3).replace(":", "")] : Typer.getValueType(value);
            code = clearVarParse.replace(code, '$modifier var $name${if (type != "") ':$type' else ''} = $value');
        }
        return code;
    }
}