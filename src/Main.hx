package;

import transpiler.parity.FunctionRecognition;
import transpiler.parity.VariableRecognition;
import interpreter.features.BasicMath;
import interpreter.types.basic.DecimalVar;
import interpreter.features.MemoryTree;
import interpreter.types.basic.NumberVar;

class Main {

    static var n = Sys.args()[0] != null ? Sys.args()[0] : "define name = 1000";

    static function main() {
        transpile();
    }
    static function transpile() {
        n = StringTools.replace(n, ";", "\n");
        n = VariableRecognition.parse(n);
        n = FunctionRecognition.parse(n);
        trace(n);
    }
}