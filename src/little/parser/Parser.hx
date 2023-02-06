package little.parser;

import little.lexer.Tokens.TokenLevel1;
import little.parser.Tokens.ParserTokens;
import little.Keywords.*;

using StringTools;
using TextTools;

/**
	Converts lexer tokens into interpretable ones
**/
class Parser {
    
    public static final numberDetector:EReg = ~/([0-9])/;
    public static final decimalDetector:EReg = ~/([0-9\.])/;
	public static final booleanDetector:EReg = ~/true|false/;
    public static final stringDetector:EReg = ~/"(.*)"/;

    /**
    	evauate expressions' types, and assign them.
    **/
    public static function typeTokens(tokens:Array<TokenLevel1>):Array<ParserTokens> {
        var parserTokens = [];

        for (token in tokens) {
            var parserToken = InvalidSyntax("<unparsable>");
            switch token {
                case TokenLevel1.StaticValue(value): {
                    
                }
                case TokenLevel1.SetLine(line): {
                    parserToken = SetLine(line);
                }
                case TokenLevel1.DefinitionCreation(name, value, type):
                case TokenLevel1.ActionCreation(name, params, body, type):
                case TokenLevel1.DefinitionAccess(name):
                case TokenLevel1.DefinitionWrite(assignee, value):
                case TokenLevel1.Sign(sign):
                case TokenLevel1.Expression(parts):
                case TokenLevel1.Parameter(name, type, value):
                case TokenLevel1.ActionCallParameter(value):
                case TokenLevel1.ActionCall(name, params):
                case TokenLevel1.Return(value):
                case TokenLevel1.InvalidSyntax(string):
                case TokenLevel1.Condition(type, c, body):
            }
            parserTokens.push(parserToken);
        }

        return parserTokens;
    }

}