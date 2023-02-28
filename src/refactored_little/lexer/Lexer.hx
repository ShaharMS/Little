package refactored_little.lexer;

import refactored_little.lexer.Tokens.LexerTokens;
import refactored_little.Keywords.*;

using StringTools;
using TextTools;

class Lexer {
    
    static var signs = ["!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "@", "[", "\\", "]", "^", "_", "`", "{", "|", "}", "~", "^"];

    public static function lex(code:String):Array<LexerTokens> {
        var tokens:Array<LexerTokens> = [];

        var i = 0;
        while (i < code.length) {
            var char = code.charAt(i);

            if (char == '"') {
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
                tokens.push(Number(num));
                
            } else if (char == "\n") {
                tokens.push(Newline);
            } else if (char == ";") {
                tokens.push(SplitLine);
            } else if (signs.contains(char)) {
                tokens.push(Sign(char));
            } else if (~/\w/.match(char)) {
                var name = char;
                i++;
                while (i < code.length && ~/\w/.match(code.charAt(i))) {
                    name += code.charAt(i);
                    i++;
                }
                i--;
                tokens.push(Identifier(name));
            }
            i++;        
        }

        tokens = separateBooleanIdentifiers(tokens);


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

    public static function mergeKnownSigns(tokens:Array<LexerTokens>):Array<LexerTokens> {
    
        var post = [];
    
        return post;
    }
}