package little.lexer;

import haxe.extern.EitherType;
import texter.general.math.MathAttribute;
import texter.general.math.MathLexer;
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

        // Replace each == with ⩵ to not confuse the assignment ereg
        code = code.replace("==", "⩵");
        // To allow writing multiple lines of code in the same line:
        code = code.replace(";", "\n");

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
                    else tokens.push(DefinitionCreation(l, items[0], "nothing", "Everything"));
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
                    tokens.push(DefinitionCreation(l, defName, val, type));
                } else {
                    val = _defAndVal[1].trim();
                    tokens.push(DefinitionCreation(l, defName, val, type));
                }
            }

            /* assignments:
                x = something
                x = y = something
            */
            if (assignmentDetector.replace(line.trim().replace("\t", ""), "").length == 0) {
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
    public static final actionCallDetector:EReg = ~/[^ ]+\(.*\)/;
    public static final definitionAccessDetector:EReg = ~/^[^0-9].*$/;
    public static final calculationDetection:EReg = ~/^(?:[0-9\.]+|"[^"]+"|true|false|nothing|[^ ]+\(.*\))+(?:[\+\-\/\*\^%÷\(\) ]+(?:[0-9\.]+|"[^"]+"|true|false|nothing|[^ ]+\(.*\)))*$/;

    /**
    	Expects output from `lexIntoComplex()`, and returns a simplified version of that output:
         - function calls are differentiated
    **/
    public static function splitBlocks1(complexTokens:Array<ComplexToken>):Array<TokenLevel1> {
        var tokens:Array<TokenLevel1> = [];
        for (complex in complexTokens) {
            switch complex {
                case DefinitionCreation(line, name, complexValue, type): {
                    tokens.push(SetLine(line));
                    
                    var defName = name, defType = type, defValue:TokenLevel1 = Specifics.complexValueIntoTokenLevel1(complexValue);
                    tokens.push(DefinitionCreation(defName, defValue, defType));
                }
                case Assignment(line, value, assignees): {
                    tokens.push(SetLine(line));
                    final parsedValue = Specifics.complexValueIntoTokenLevel1(value);
                    assignees.reverse(); // The first assignee needs to be the rightmost one
                    for (assignee in assignees) {
                        tokens.push(DefinitionWrite(assignee, parsedValue));
                    }
                }
            }
        }

        return tokens;
    }

















    public static function prettyPrintAst(ast:Array<TokenLevel1>, ?spacingBetweenNodes:Int = 6) {
        s = " ".multiply(spacingBetweenNodes);
        var unfilteredResult = getTree(Calculation(ast), [], 0, true);
        var filtered = "";
        for (line in unfilteredResult.split("\n")) {
            if (line == "└─── Calculation") continue;
            filtered += line.substring(spacingBetweenNodes - 1) + "\n";
        }
        return "\nAst\n" + filtered;
    }

    static function prefixFA(pArray:Array<Int>) {
        var prefix = "";
        for (i in 0...l) {
            if (pArray[i] == 1) {
                prefix += "│" + s.substring(1);
            } else {
                prefix += s;
            }
        }
        return prefix;
    }
    static function pushIndex(pArray:Array<Int>, i:Int) {
        var arr = pArray.copy();
        arr[i + 1] = 1;
        return arr;
    }

    static var s = "";
    static var l = 0;
    static function getTree(root:TokenLevel1, prefix:Array<Int>, level:Int, last:Bool):String {
        l = level;
        var t = if (last) "└" else "├";
        var c = "├";
        var d = "───";
        if (root == null) return "";
        switch root {
            case SetLine(line): return '${prefixFA(prefix)}$t$d SetLine($line)\n';
            case DefinitionCreation(name, value, type): {
                return '${prefixFA(prefix)}$t$d Definition Creation\n${prefixFA(prefix)}$s$c$d $name\n${prefixFA(prefix)}$s$c$d $type\n${getTree(value, prefix.copy(), level + 1, true)}';
            }
            case DefinitionAccess(name): return '${prefixFA(prefix)}$t$d $name\n';
            case DefinitionWrite(assignee, value): {
                return '${prefixFA(prefix)}$t$d Definition Write\n${prefixFA(prefix)}$s$c$d $assignee\n${getTree(value, prefix.copy(), level + 1, true)}';
            }
            case StaticValue(value) | Sign(value): {
                return '${prefixFA(prefix)}$t$d $value\n';
            }
            case Calculation(parts): {
                if (parts.length == 0) return '${prefixFA(prefix)}$t$d <empty calculation>\n';
                var strParts = ['${prefixFA(prefix)}$t$d Calculation\n'].concat([for (i in 0...parts.length - 1) getTree(parts[i], pushIndex(prefix, level), level + 1, false)]);
                strParts.push(getTree(parts[parts.length - 1], prefix.copy(), level + 1, true));
                return strParts.join("");
            }
            case Parameter(name, type, value): {
                if (name == "") name = "<unnamed>";
                if (type == "") type = "<untyped>";
                return '${prefixFA(prefix)}$t$d Parameter\n${prefixFA(prefix)}$s$c$d $name\n${prefixFA(prefix)}$s$c$d $type\n${getTree(value, prefix.copy(), level + 1, true)}';
            }
            case ActionCall(name, params): {
                var strParts = ['${prefixFA(prefix)}$t$d Action Call\n${prefixFA(prefix)}$s$c$d $name\n'].concat([for (i in 0...params.length - 1) getTree(params[i], pushIndex(prefix, level), level + 1, false)]);
                if (params.length == 0) return strParts.join("");
                strParts.push(getTree(params[params.length - 1], prefix.copy(), level + 1, true));
                return strParts.join("");
            }
            case InvalidSyntax(s): return '${prefixFA(prefix)}$t$d INVALID SYNTAX: $s\n';
        }
        return "";
    }

    // private static function tree(content, level:Int, isLastBranch:Bool, skipVerticalLinesOnLevels:Array<Int>):String
    //     {
    //         var s = "";

    //         if (content == null ) return "";

    //         for (i in 0...level - 1)
    //         {
    //             if (skipVerticalLinesOnLevels[i] == i) s += "    ";
    //             else s += "│   ";
    //         }

    //         if (level > 0)
    //         {
    //             if (isLastBranch)
    //             {
    //                 s += "└───";
    //                 skipVerticalLinesOnLevels[level - 1] = level - 1;
    //             }
    //             else s += "├───";
    //         }
    //         s += content.split("(")[0];
    //         s += "\n";

    //         if (content.contains(")")) isLastBranch = false;
    //         else isLastBranch = true;

    //         s += tree(root.left, level + 1, isLastBranch, skipVerticalLinesOnLevels.copy());
    //         s += tree(root.right, level + 1, true, skipVerticalLinesOnLevels.copy());
    //         return s;
    //     }
    // }
}