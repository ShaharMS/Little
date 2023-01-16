package little.lexer;

using StringTools;
using TextTools;

class Lexer {
    
    /**
    	Parses little source code into complex tokens. complex tokens dont handle logic, but they do handle flow.
    **/
    public static function lexIntoComplex(code:String):Array<ComplexToken> {
        var tokens:Array<ComplexToken> = [];

        var l = 1;
        for (line in code.split("\n")) {
            /* definitions:
                define x
                define x = 5
                define x of type Number
                define x of type Number = 5
            */
            if (line.trim().replace("\t", "").startsWith("define")) {
                var items = line.split(" ").filter(s -> s != "");
                if (items.length == 0) throw "Definition name and value are missing at line " + l + ".";
                if (items.length == 1) {
                    if (~/[0-9]/g.replace(items[0], "").length == 0) throw "Definition name must contain at least one non-numerical character"
                    else tokens.push(DefinitionDeclaration(items[0], "Nothing"));
                    continue;
                }
                var filtered = [];
                var potentialType = false;
                var expectType = false, expectValue = false;
                for (item in items) {
                    if (item == "of") potentialType = true;
                    else if (item == "type" && potentialType) {expectType = true; expectValue = false;
                    else if (item == )
                }
            }
            l++;
        }

        return tokens;
    }

}