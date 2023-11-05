package little.lexer;

import little.lexer.Tokens.LexerTokens;
import little.Keywords.*;

using StringTools;
using little.tools.TextTools;

class Lexer {
    
    static var signs = ["!", "#", "$", "%", "&", "'", "(", ")", "*", "+", "-", ".", "/", ":", "<", "=", ">", "?", "@", "[", "\\", "]", "^", "_", "`", "{", "|", "}", "~", "^", "√"];

    public static function lex(code:String):Array<LexerTokens> {
        var tokens:Array<LexerTokens> = [];

        var i = 0;
        while (i < code.length) {
            var char = code.charAt(i);
            if (i < code.length - 2 && code.substr(i, 3).replace('"', "").length == 0) {
                var string = "";
                var queuedNewlines = 0;
				i += 3;
                while (i < code.length - 2 && code.substr(i, 3).replace('"', "").length != 0) {
                    string += code.charAt(i);
                    if (code.charAt(i) == "\n") queuedNewlines++;
                    i++;
                }
				i += 2;
                for (j in 0...queuedNewlines) tokens.push(Newline);
                tokens.push(Documentation(string.replace("<br>", "\n").replace("</br>", "\n")));
            }
            else if (char == '"') {
                var string = "";
                i++;
                while (i < code.length && code.charAt(i) != '"') {
                    string += code.charAt(i);
                    i++;
                }
                tokens.push(Characters(string));
            } else if ("1234567890.".contains(char)) {
                var num = char;
                i++;
                while (i < code.length && "1234567890.".contains(code.charAt(i))) {
                    num += code.charAt(i);
                    i++;
                }
                i--;
                if (num == ".") tokens.push(Sign("."))
                else if (num.endsWith(".")) {
                    tokens.push(Number(num.replaceLast(".", "")));
                    tokens.push(Sign("."));
                }
                else tokens.push(Number(num));
                
            } else if (char == "\n") {
                tokens.push(Newline);
            } else if (char == ";" || char == ",") {
                tokens.push(SplitLine);
            } else if (signs.contains(char)) {
                var sign = char;
                i++;
                while (i < code.length && signs.contains(code.charAt(i))) {
                    sign += code.charAt(i);
                    i++;
                }
                i--;
                tokens.push(Sign(sign));
            } else if (~/[^+-.!@#$%%^&*0-9 \t\n\r;,\(\)\[\]\{\}]/.match(char)) {
                var name = char;
                i++;
                while (i < code.length && ~/[^+-.!@#$%%^&*0-9 \t\n\r;,\(\)\[\]\{\}]/.match(code.charAt(i))) {
                    name += code.charAt(i);
                    i++;
                }
                i--;
                tokens.push(Identifier(name));
            }
            i++;        
        }

        tokens = separateBooleanIdentifiers(tokens);
        tokens = mergeOrSplitKnownSigns(tokens);

        return tokens;
    }

    public static function separateBooleanIdentifiers(tokens:Array<LexerTokens>):Array<LexerTokens> {
        return tokens.map(token -> {
            if (Type.enumEq(token, Identifier(TRUE_VALUE)) || Type.enumEq(token, Identifier(FALSE_VALUE))) {
                Boolean(token.getParameters()[0]);
            } else if (Type.enumEq(token, Identifier(NULL_VALUE))) {
                NullValue;
            } else token;
        });
    }

    public static function mergeOrSplitKnownSigns(tokens:Array<LexerTokens>):Array<LexerTokens> {
        var post = [];

        var i = 0;
        while (i < tokens.length) {
            var token = tokens[i];

            switch token {
                case Sign(char): {
                    // First: reorder the keyword array by length
                    SPECIAL_OR_MULTICHAR_SIGNS = TextTools.sortByLength(SPECIAL_OR_MULTICHAR_SIGNS);
                    SPECIAL_OR_MULTICHAR_SIGNS.reverse();

                    var shouldContinue = false;
                    while (char.length > 0) {
                        shouldContinue = false;
                        for (sign in SPECIAL_OR_MULTICHAR_SIGNS) {
                            if (char.startsWith(sign)) {
                                char = char.substring(sign.length);
                                post.push(Sign(sign));
                                shouldContinue = true;
                                break;
                            }
                        }
                        if (shouldContinue) continue;
                        post.push(Sign(char.charAt(0)));
                        char = char.substring(1);
                    }
                }
                case _: post.push(token);
            }
            i++;
        }

        return post;
    }
}