package little.lexer;

import little.lexer.Tokens.TokenLevel1;
import little.lexer.Tokens.ComplexToken;
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

    

    public static final staticValueDetector:EReg = ~/[0-9\.]+|"[^"]+"|true|false|nothing/;
    public static final actionCallDetector:EReg = ~/.+\(.*\)/;
    public static final definitionAccessDetector:EReg = ~/^[^0-9].*$/;
    public static final calculationDetection:EReg = ~/^(?:[0-9\.]+|"[^"]+"|true|false|nothing|.+\(.*\))+(?:[\+\-\/\*\^%÷\(\) ]+(?:[0-9\.]+|"[^"]+"|true|false|nothing|.+\(.*\)))*$/;

    /**
    	Expects output from `lexIntoComplex()`, and returns a simplified version of that output:
         - function calls are differentiated
    **/
    public static function splitBlocks1(complexTokens:Array<ComplexToken>):Array<TokenLevel1> {
        var tokens:Array<TokenLevel1> = [];

        for (complex in complexTokens) {
            switch complex {
                case DefinitionDeclaration(line, name, complexValue, type): {
                    tokens.push(SetLine(line));
                    
                    var defName = name, defType = type, defValue:TokenLevel1;

                    // Now, figure out if defValue should be an ActionCall, StaticValue, DefinitionAccess or Calculation.
                    if (staticValueDetector.replace(complexValue, "").length == 0) {
                        defValue = StaticValue(complexValue);
                    }
                    else if (definitionAccessDetector.replace(complexValue, "").length == 0) {
                        defValue = DefinitionAccess(complexValue);
                    }
                    else if (actionCallDetector.replace(complexValue, "").length == 0) {
                        var _actionParamSplit = complexValue.split("(");
                        final actionName = _actionParamSplit[0];

                        final stringifiedParams = _actionParamSplit[1]; // remove the `actionName(` part
                        stringifiedParams.substring(0, _actionParamSplit[1].length - 1); // remove the closing )

                        var params = stringifiedParams.split(",");
                        params = params.map(item -> item.trim()); //removes whitespaces before/after each ,

                        defValue = ActionCall(actionName, [for (p in params) Specifics.extractParam(p)]);
                    } 
                    else if (calculationDetection.replace(complexValue, "").length == 0) {
                        // A bit more complicated, since any item in a calculation may be any of the above, even another calculation!
                        // We have a helper function to extract expressions, now we just need to separate everything into calculations
                        
                        var calcTokens:Array<TokenLevel1> = [];
                        
                    }
                    tokens.push(DefinitionDeclaration(defName, defValue, defType));
                }
                case Assignment(line, value, assignees): {

                }
            }
        }

        return tokens;
    }

}