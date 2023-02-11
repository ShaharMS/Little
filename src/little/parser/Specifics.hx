package little.parser;

import little.parser.Parser.*;
import little.parser.Tokens.UnInfoedParserTokens;
import little.lexer.Tokens.LexerTokens;
import little.Keywords.*;

using StringTools;
using TextTools;

class Specifics {
    
    /**
    	Notice: The difference between TYPE_VOID and TYPE_UNKNOWN is that VOID is not a typeable expression, and thus an invalid value, 
        while UNKNOWN is a typeable expresion, of which the type is not yet known, and will be "discovered" at runtime.
    **/
    public static function evaluateExpressionType(exp:LexerTokens):String {
        switch exp {
            case Sign(sign): return TYPE_VOID;
            case StaticValue(value): {
                if (stringDetector.replace(value, "").length == 0) return TYPE_STRING;
                else if (booleanDetector.replace(value, "").length == 0) return TYPE_BOOLEAN;
                else if (numberDetector.replace(value, "").length == 0) return TYPE_INT;
                else if (decimalDetector.replace(value, "").length == 0) return TYPE_FLOAT;
                return TYPE_UNKNOWN;
            }
            case Expression(parts): {

                var resultType:String = "";
                var currentType:String = "";
                var hierarchy = [TYPE_BOOLEAN, TYPE_INT, TYPE_FLOAT, TYPE_STRING, TYPE_UNKNOWN];
                // Some rules before we begin:
                /*
                 - Type hierarchy:
                       TYPE_UNKNOWN
                       TYPE_STRING
                       TYPE_FLOAT
                       TYPE_INT
                       TYPE_BOOLEAN
                 - any other actions beside -, + or * on TYPE_STRING throws a type mismatch
                 - any other actions beside -, + or * on TYPE_INT promotes to TYPE_FLOAT and above
                 - 
                */
                var promoteOnNextFromInt:Bool = false;
                for (part in parts) {
                    switch part {
                        case DefinitionAccess(name): resultType = TYPE_UNKNOWN;
                        case Sign(sign): {
                            if (!".+-*".contains(sign) && currentType == TYPE_INT) promoteOnNextFromInt = true;
                            else if (!".+-*".contains(sign) && currentType == TYPE_STRING) throw "Type Mismatch";
                        }
                        case StaticValue(value): {
                            var valType = evaluateExpressionType(StaticValue(value));
                            if (hierarchy.indexOf(valType) > hierarchy.indexOf(currentType)) currentType = valType;
                            if (hierarchy.indexOf(valType) > hierarchy.indexOf(resultType)) resultType = valType;

                        }
                        case Expression(parts): {
                            var valType = evaluateExpressionType(Expression(parts));
                            if (hierarchy.indexOf(valType) > hierarchy.indexOf(currentType)) currentType = valType;
                            if (hierarchy.indexOf(valType) > hierarchy.indexOf(resultType)) resultType = valType;
                        }
                        case a: throw "Type Mismatch" + ', $a';
                    }
                }

                return resultType;
            }
            case Parameter(name, type, value): {
                if (type != null && type != evaluateExpressionType(value)) throw "Type Mismatch";
                return type != null ? type : evaluateExpressionType(value);
            }
            case ActionCallParameter(value): return evaluateExpressionType(value);
            case ActionCall(name, params): return TYPE_UNKNOWN;
            case DefinitionAccess(name): return TYPE_UNKNOWN;
            case DefinitionWrite(assignee, value): return TYPE_UNKNOWN; // Assignee may be of a different type, in which case theres either a mismatch or a cast.
            case Return(value): return evaluateExpressionType(value);
            case Condition(type, _, body): { 
                // A bit more complex, since the last element in a condition block may be a lone value, in which case the condition returns an expression, and thus, has a type
                // The best solution here is to just return the evaluated expression of the last token in the body.
                return evaluateExpressionType(body[body.length - 1]);
            }
            case SetLine(line): return TYPE_VOID;
            case DefinitionCreation(name, value, type): return TYPE_VOID; // "Element" creation expressions are typeless
            case ActionCreation(name, params, body, type): return TYPE_VOID; // "Element" creation expressions are typeless
            case InvalidSyntax(string): return TYPE_VOID;

        }
    }

}