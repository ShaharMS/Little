package little.expressions;

import little.interpreter.Tokens.Token;
import texter.general.CharTools;
import texter.general.CharTools.*;
import little.Keywords.*;

class Expressions {
    
    public static function lex(exp:String):Array<ExpTokens> {
        var split = exp.split("");
        var tokens:Array<ExpTokens> = [];

        var i = 0;
        while (i < split.length) {
            var l = split[i];
            if (numericChars.match(l)) {
                tokens.push(Value(l));
            } else if (softChars.contains(l)) {
                tokens.push(Sign(l));
            } else {
                tokens.push(Variable(l));
            }
            i++;
        }

        var mergedValues:Array<ExpTokens> = [];
        i = 0;
        while (i < tokens.length) {
            var token = tokens[i];
            switch token {
                case Value(v): {
                    var val = v;
                    while (i < tokens.length) {
                        if (i + 1 >= tokens.length) break;
                        var nextToken = tokens[i + 1];
                        switch nextToken {
                            case Value(value): val += value;
                            case Sign("."): val += ".";
                            case _: break;
                        }
                        i++;
                    }

                    mergedValues.push(Value(val));
                }
                case Variable(value): mergedValues.push(Variable(value));
                case Sign(value): mergedValues.push(Sign(value));
                case Characters(value): mergedValues.push(Characters(value));
                case Call(value, content): mergedValues.push(Call(value, content));
                case Closure(content): mergedValues.push(Closure(content));
            }
            i++;
        }

        var mergedVariables:Array<ExpTokens> = [];
        i = 0;
        while (i < mergedValues.length) {
            var token = mergedValues[i];
            switch token {
                case Variable(v): {
                    var val = v;
                    while (i < mergedValues.length) {
                        if (i + 1 >= mergedValues.length) break;
                        var nextToken = mergedValues[i + 1];
                        switch nextToken {
                            case Variable(value): val += value;
                            case _: break;
                        }
                        i++;
                    }

                    mergedVariables.push(Variable(val));
                }
                case Value(value): mergedVariables.push(Value(value));
                case Sign(value): mergedVariables.push(Sign(value));
                case Characters(value): mergedVariables.push(Characters(value));
                case Call(value, content): mergedVariables.push(Call(value, content));
                case Closure(content): mergedVariables.push(Closure(content));
            }
            i++;
        }
        mergedVariables = mergedVariables.map(e -> {
            if (Type.enumEq(e, Variable(TRUE_VALUE))) return ExpTokens.Value(TRUE_VALUE);
            else if (Type.enumEq(e, Variable(FALSE_VALUE))) return ExpTokens.Value(FALSE_VALUE);
            else if (Type.enumEq(e, Variable(NULL_VALUE))) return ExpTokens.Value(NULL_VALUE);
            else return e;
        });

        var mergedChars:Array<ExpTokens> = [];
        i = 0;
        while (i < mergedVariables.length) {
            var token = mergedVariables[i];
            switch token {
                case Sign('"'): {
                    var val = "";
                    while (i < mergedVariables.length) {
                        if (i + 1 >= mergedVariables.length) break;
                        var nextToken = mergedVariables[i + 1];
                        switch nextToken {
                            case Sign('"'): i++; break;
                            case Variable(value) | Value(value) | Sign(value): val += value;
                            case _: break;
                        }
                        i++;
                    }

                    mergedChars.push(Characters(val));
                }
                case Variable(value): mergedChars.push(Variable(value));
                case Value(value): mergedChars.push(Value(value));
                case Sign(value): mergedChars.push(Sign(value));
                case Characters(value): mergedChars.push(Characters(value));
                case Call(value, content): mergedChars.push(Call(value, content));
                case Closure(content): mergedChars.push(Closure(content));
            }
            i++;
        }
        mergedChars = mergedChars.filter(e -> !Type.enumEq(e, Sign(" ")));
        
        var mergedClosures:Array<ExpTokens> = [];
        i = 0;
        while (i < mergedChars.length) {
            var token = mergedChars[i];
            switch token {
                case Sign('('): {
                    var val = [];
                    while (i < mergedChars.length) {
                        if (i + 1 >= mergedChars.length) break;
                        var nextToken = mergedChars[i + 1];
                        switch nextToken {
                            case Sign(')'): i++; break;
                            case Variable(_) | Value(_) | Sign(_) | Characters(_): val.push(nextToken);
                            case _: break;
                        }
                        i++;
                    }

                    mergedClosures.push(Closure(val));
                }
                case Variable(value): mergedClosures.push(Variable(value));
                case Value(value): mergedClosures.push(Value(value));
                case Sign(value): mergedClosures.push(Sign(value));
                case Characters(value): mergedClosures.push(Characters(value));
                case Call(value, content): mergedClosures.push(Call(value, content));
                case Closure(content): mergedClosures.push(Closure(content));
            }
            i++;
        }
        
        var mergedCalls:Array<ExpTokens> = [];
        i = 0;
        while (i < mergedClosures.length) {
            var token = mergedClosures[i];
            switch token {
                case Variable(value): {
                    while (i < mergedClosures.length) {
                        if (i + 1 >= mergedClosures.length) break;
                        var nextToken = mergedClosures[i + 1];
                        switch nextToken {
                            case Sign(' '): i++; continue;
                            case Closure(content): mergedCalls.push(Call(value, content)); i++; break;
                            case _: break;
                        }
                        i++;
                    }
                }
                case _: mergedCalls.push(token);
            }
            i++;
        }

        return mergedCalls;
    }
}