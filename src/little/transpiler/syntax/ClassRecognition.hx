package little.transpiler.syntax;

using StringTools;

class ClassRecognition {
    
    public static final clearClassParse:EReg = ~/className: +([a-zA-Z_]+) *(?:[ \n\r]((?:.|\n)+)| *)/s;

    public static function parse(code:String, ?style:WriteStyle = SAME_LEVEL) {
        final parts = code.split("className: ");
        for (p in parts) {
            final i = parts.indexOf(p);
            p = "className: " + p;
            if (clearClassParse.match(p)) {
                final className = clearClassParse.matched(1);
                var body = clearClassParse.matched(2);
                final lines = body.split("\n");
                body = lines.join("\n");
                parts[i] = 'class $className';
                function writeStyle() {
                    switch style {
                        case Inline(defaultType): {
                            if (body.contains("\n")) {
                                style = defaultType;
                                writeStyle();
                            }
                            code += ' $body';
                        }
                        case SAME_LINE: parts[i] += ' {${StringTools.replace(body, "\n", "")}}';
                        case SAME_LEVEL: parts[i] += '\n{\n$body\n}';
                        case ARCH: parts[i] += ' {\n$body\n}';
                    }
                }
            }
        }
        return parts.join("");
    }
}