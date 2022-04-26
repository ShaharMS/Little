package;

import haxe.Timer;
import sys.io.File;
import sys.FileSystem;
import transpiler.syntax.FunctionRecognition;
import transpiler.syntax.VariableRecognition;
import transpiler.syntax.SyntaxFixer;

class Main {

    static var path = "C:/Users/shahar/Documents/GitHub/Multilang-Coder/";

    static function main() {
        new Timer(500).run = transpile;
    }
    static function transpile() {
        var n = File.getContent(path + "code.txt");
        n = StringTools.replace(n, ";", "\n");
        n = VariableRecognition.parse(n);
        n = FunctionRecognition.parse(n);
        n = SyntaxFixer.removeSemicolonOverloads(n);
        var w = File.write(path + "codeHX.hx");
        w.writeString(n);
        w.close();
        var trace = 5;
    }
}