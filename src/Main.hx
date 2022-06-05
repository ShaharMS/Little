package;

import little.Runtime;
import little.interpreter.Memory;
import little.interpreter.features.LittleVariable;
import little.Interpreter;
import little.Transpiler;
using StringTools;
class Main {
    static function main() {
        var a = 18;
        Interpreter.registerVariable("a", a);
        Interpreter.run("define e = 19");
        trace(Memory.variableMemory);
        a = 19;
        trace(Runtime.getMemorySnapshot());
    }
}