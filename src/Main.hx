package;

import little.Transpiler;
using StringTools;
import sys.FileSystem;
import sys.io.File;
class Main {
    static function main() {
        var s = File.getContent("C:\\Users\\shaha\\Documents\\GitHub\\Minilang\\testltl.md");
    var lines = s.split("\n"), lineWrite = 0;
    for (i in 0...lines.length) if (lines[i].contains("/////")) lineWrite = i + 1;
    final kept = lines.slice(0, lineWrite).join("\n");
    var writer = File.write("C:\\Users\\shaha\\Documents\\GitHub\\Minilang\\testltl.md");

    final regex = ~/```(.+)```/s;
    regex.match(s);
    final transpiled = "```haxe\n" + Transpiler.transpile(regex.matched(1)) + "\n```";
    writer.writeString(kept + transpiled);
    }
}