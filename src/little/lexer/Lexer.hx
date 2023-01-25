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
                case DefinitionDeclaration(line, name, complexValue, type): {
                    tokens.push(SetLine(line));
                    
                    var defName = name, defType = type, defValue:TokenLevel1 = Specifics.complexValueIntoTokenLevel1(complexValue);
                    tokens.push(DefinitionDeclaration(defName, defValue, defType));
                }
                case Assignment(line, value, assignees): {

                }
            }
        }

        return tokens;
    }

















    public static function astToString(tokens:Array<TokenLevel1>) {
        string = "";
        return getTree(Calculation(tokens), "", tokens.length == 1);
    }

    static var string:String = "";
    static function getTree(root:TokenLevel1, prefix:String, last:Bool):String {
        var t = if (last) "└" else "├";
        var d = "───";
        if (root == null) return "";
        switch root {
            case SetLine(line): return string += '$prefix$t$d SetLine($line)\n';
            case DefinitionDeclaration(name, value, type): {
                return string += '$prefix$t$d Definition Declaration\n$prefix      $t$d $name\n$prefix      $t$d $type\n${getTree(value, prefix + "      ", true)}';
            }
            case DefinitionAccess(name): return string += '$prefix$t$d $name\n';
            case DefinitionWrite(assignee, value): {
                return string += '$prefix$t$d Definition Write\n$prefix      $t$d $assignee\n${getTree(value, prefix + "      ", true)}';
            }
            case StaticValue(value) | Sign(value): {
                return string += '$prefix$t$d $value\n';
            }
            case Calculation(parts): {
                if (parts.length == 0) return '$prefix$t$d Empty Calculation\n';
                string += '$prefix$t$d Calculation\n';
                var strParts = [for (i in 0...parts.length) getTree(parts[i], prefix + "      ", false)];
                strParts.push(getTree(parts[parts.length - 1], prefix + "      ", true));
                return string += strParts.join("");
            }
            case Parameter(name, type, value): {
                return string += '$prefix$t$d Parameter\n$prefix      $t$d $name\n$prefix      $t$d $type\n${getTree(value, prefix + "      ", true)}';
            }
            case ActionCall(name, params): {
                string += '$prefix$t$d Action Call\n$prefix      $t$d $name\n';
                var strParts = [for (i in 0...params.length) getTree(params[i], prefix + "      ", false)];
                if (params.length == 0) return string;
                strParts.push(getTree(params[params.length - 1], prefix + "      ", true));
                return string += strParts.join("");
            }
            case InvalidSyntax(string): return Lexer.string += '$prefix$t$d INVALID SYNTAX: $string\n';
        }
        return string;
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