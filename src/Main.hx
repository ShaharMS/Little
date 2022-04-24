package;

import language.types.basic.DecimalVar;
import language.features.MemoryTree;
import language.types.basic.NumberVar;

class Main {
    static function main() {
        var n = Sys.args()[0] != null ? Sys.args()[0] : "variable name = 1000";
        var arr = n.split(";");
        for (i in arr) {
            NumberVar.readIsolate(i);
            if (NumberVar.readIsolate(i) == null) DecimalVar.readIsolate(i);
        }

        trace(MemoryTree.toString());
    }
}