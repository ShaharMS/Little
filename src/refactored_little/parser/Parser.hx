package refactored_little.parser;

import refactored_little.parser.Tokens.ParserTokens;
import refactored_little.lexer.Tokens.LexerTokens;

class Parser {
    public static function parse(lexerTokens:Array<LexerTokens>):Array<ParserTokens> {
        var tokens:Array<ParserTokens> = [];

        var i = 0;
        while (i < lexerTokens.length) {
            
            i++;
        }


        return tokens;
    }

    public static function mergeBlocks(pre:Array<ParserTokens>):Array<ParserTokens> {
        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case Sign("{"): {
                    var blockBody:Array<ParserTokens> = [];
                    var blockStack = 1; // Open and close the block on the correct curly bracket
                    while (i + 1 < pre.length) {
                        var lookahead = pre[i + 1];
                        if (Type.enumEq(lookahead, Sign("{"))) {
                            blockStack++;
                            blockBody.push(lookahead);
                        } else if (Type.enumEq(lookahead, Sign("}"))) {
                            blockStack--;
                            if (blockStack == 0) break;
                            blockBody.push(lookahead);
                        } else blockBody.push(lookahead);
                        i++;
                    }
                    post.push(Block(mergeBlocks(blockBody), null)); // The check performed above includes unmerged blocks inside the outer block. These unmerged blocks should be merged
                }
                case _: post.push(token);
            }
            i++;
        }

        return post;
    }
}