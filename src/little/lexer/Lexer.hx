package little.lexer;

using StringTools;
using TextTools;

class Lexer {
    
    public static final instanceDetector:EReg = ~/new +([a-zA-z0-9_]+)/;
    public static final numberDetector:EReg = ~/([0-9\.])/;
    public static final booleanDetector:EReg = ~/true|false/;
    public static final definitionDetector:EReg = ~/([a-zA-Z0-9]+)/;
    public static final typeDetector:EReg = ~/([A-Z][a-zA-Z0-9]+)/;
    public static final assignmentDetector:EReg = ~/[a-zA-Z0-9\.]+ *(?:=[^=]+)+/;

    /**
    	Parses little source code into complex tokens. complex tokens don't handle logic, but they do handle flow.
    **/
    public static function lexIntoComplex(code:String):Array<ComplexToken> {
        var tokens:Array<ComplexToken> = [];

        var l = 1;
        for (line in code.split("\n")) {
            /* definitions:
                define x
                define x = 5
                define x of type Number
                define x of type Number = 5 + welcome
                define x of type Number = nothing
            */
            if (line.trim().replace("\t", "").startsWith("define")) {
                var items = line.split(" ").filter(s -> s != "" && s != "define");
                if (items.length == 0) throw "Definition name and value are missing at line " + l + ".";
                if (items.length == 1) {
                    if (~/[0-9\.]/g.replace(items[0], "").length == 0) throw "Definition name must contain at least one non-numerical character"
                    else tokens.push(DefinitionDeclaration(l, items[0], "nothing", "Everything"));
                    continue;
                }
                var _defAndVal = line.split("=");
                var defValSplit = [_defAndVal[0].split(" ").filter(s -> s != "" && s != "define")];
                var defName = "", val = "", type = "Everything";
                var nameSet = false,  typeSet = false;
                for (i in 0...defValSplit[0].length) {
                    //name, type?
                    if (defValSplit[0][i] == "of" && defValSplit[0][i + 1] == "type" && defValSplit[0][i + 2] != null && typeDetector.replace(defValSplit[0][i + 2], "").length == 0) {
                        if (!typeSet) type = defValSplit[0][i + 2];
                        typeSet = true;
                    }
                    else if (definitionDetector.replace(defValSplit[0][i], "").length == 0) {
                        if (!nameSet) defName = defValSplit[0][i];
                        nameSet = true;
                    }
                }
                if (_defAndVal.length == 1) {
                    val = "nothing";
                    tokens.push(DefinitionDeclaration(l, defName, val, type));
                } else {
                    val = _defAndVal[1].trim();
                    tokens.push(DefinitionDeclaration(l, defName, val, type));
                }
            }

            /* assignments:
                x = something
                x = y = something
            */
            if (assignmentDetector.replace(line, "").length == 0) {
                var items = line.split("=");
                var value = items[items.length - 1].trim();
                var assignees = {items.pop(); items = items.map(item -> item.trim()); items;};
                tokens.push(Assignment(l, value, assignees));
            }
            l++;
        }

        return tokens;
    }

    /**
    	Expects output from `lexIntoComplex()`, and returns a simplified version of that output - function calls are differentiated
    **/
    public static function splitBlocks1() {
        
    }

}