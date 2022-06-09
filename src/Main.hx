package;

import little.interpreter.features.Evaluator;
import little.Little;
import little.Runtime;
import little.interpreter.Memory;
import little.interpreter.features.LittleVariable;
import little.Interpreter;
import little.Transpiler;
using StringTools;
class Main {
    static function main() {
        Evaluator.calculateStringAddition('"hey" + "heythere" + "hello"');
    }
}