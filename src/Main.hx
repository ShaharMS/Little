package;

import language.features.BasicMath;
import language.types.basic.DecimalVar;
import language.features.MemoryTree;
import language.types.basic.NumberVar;

class Main {
    static function main() {
        var n = Sys.args()[0] != null ? Sys.args()[0] : "define name = 1000";
        var arr = n.split(";");
        for (i in arr) {
            i = BasicMath.condense(i);
            NumberVar.process(i);
            if (NumberVar.process(i) == null) DecimalVar.process(i);
        }
        trace(MemoryTree.toString());
    }
}