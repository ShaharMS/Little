package refactored_little.parser;

import refactored_little.parser.Tokens.ParserTokens;
import refactored_little.lexer.Tokens.LexerTokens;
import refactored_little.Keywords.*;

using StringTools;
using TextTools;

class Parser {
    public static function parse(lexerTokens:Array<LexerTokens>):Array<ParserTokens> {
        var tokens:Array<ParserTokens> = [];

        var line = 1;

        var i = 0;
        while (i < lexerTokens.length) {
            var token = lexerTokens[i];

            switch token {
                case Identifier(name): tokens.push(Identifier(name));
                case Sign(char): tokens.push(Sign(char));
                case Number(num): {
                    if (num.countOccurrencesOf(".") == 0) tokens.push(Number(num));
                    else if (num.countOccurrencesOf(".") == 1) tokens.push(Decimal(num));
                }
                case Boolean(value): {
                    if (value == FALSE_VALUE) tokens.push(FalseValue);
                    else if (value == TRUE_VALUE) tokens.push(TrueValue);
                }
                case Characters(string): tokens.push(Characters(string));
                case NullValue: tokens.push(NullValue);
                case Newline: {
                    tokens.push(SetLine(line));
                    line++;
                }
                case SplitLine: tokens.push(SplitLine);
            }

            i++;
        }

        tokens = mergeBlocks(tokens);
        tokens = mergeExpressions(tokens);
        tokens = mergeTypeDecls(tokens);
        tokens = mergeComplexStructures(tokens);
        tokens = mergeWrites(tokens);



        return tokens;
    }

    public static function mergeTypeDecls(pre:Array<ParserTokens>):Array<ParserTokens> {
        
        if (pre == null) return null;

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case Identifier(word): {
                    if (word == TYPE_DECL_OR_CAST && i + 1 < pre.length) {
                        var lookahead = pre[i + 1];
                        post.push(TypeDeclaration(lookahead));
                        i++;
                    } else {
                        post.push(token);
                    }
                }
                case Expression(parts, type): post.push(Expression(mergeTypeDecls(parts), null));
                case Block(body, type): post.push(Block(mergeTypeDecls(body), null));
                case _: post.push(token);
            }
            i++;
        }

        return post;
    }

    public static function mergeBlocks(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;

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
                    i++;
                }
                case Expression(parts, type): post.push(Expression(mergeBlocks(parts), null));
                case Block(body, type): post.push(Block(mergeBlocks(body), null));
                case _: post.push(token);
            }
            i++;
        }

        return post;
    }

    public static function mergeExpressions(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case Sign("("): {
                    var expressionBody:Array<ParserTokens> = [];
                    var expressionStack = 1; // Open and close the block on the correct curly bracket
                    while (i + 1 < pre.length) {
                        var lookahead = pre[i + 1];
                        if (Type.enumEq(lookahead, Sign("("))) {
                            expressionStack++;
                            expressionBody.push(lookahead);
                        } else if (Type.enumEq(lookahead, Sign(")"))) {
                            expressionStack--;
                            if (expressionStack == 0) break;
                            expressionBody.push(lookahead);
                        } else expressionBody.push(lookahead);
                        i++;
                    }
                    post.push(Expression(mergeExpressions(expressionBody), null)); // The check performed above includes unmerged blocks inside the outer block. These unmerged blocks should be merged
                    i++;
                }

                case Expression(parts, type): post.push(Expression(mergeExpressions(parts), null));
                case Block(body, type): post.push(Block(mergeExpressions(body), null));
                case _: post.push(token);
            }
            i++;
        }

        return post;
    }

    public static function mergeComplexStructures(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];

            switch token {
                case Identifier(_ == VARIABLE_DECLARATION => true): {
                    i++;
                    if (i >= pre.length) return null;

                    var name:ParserTokens = null;
                    var type:ParserTokens = null;
                    while (i < pre.length) {
                        var lookahead = pre[i];
                        switch lookahead {
                            case TypeDeclaration(typeToken): {
                                if (name == null) return null;
                                type = typeToken;
                                break;
                            }
                            case SetLine(_) | SplitLine | Sign("="): i--; break;
                            case Block(body, type): {
                                if (name == null) name = Block(mergeComplexStructures(body), type);
                                else if (type == null) type = Block(mergeComplexStructures(body), type);
                                else {
                                    i--;
                                    break;
                                }
                            }
                            case Expression(body, type): {
                                if (name == null) name = Expression(mergeComplexStructures(body), type);
                                else if (type == null) type = Expression(mergeComplexStructures(body), type);
                                else {
                                    i--;
                                    break;
                                }
                            }
                            case _: {
                                if (name == null) name = lookahead;
                                else if (type == null) type = lookahead;
                                else {
                                    i--;
                                    break;
                                }
                            }
                        }
                        i++;
                    }
                    post.push(Define(name, type));
                }
                case Identifier(_ == FUNCTION_DECLARATION => true): {
                    i++;
                    if (i >= pre.length) return null;
                    
                    var name:ParserTokens = null;
                    var params:ParserTokens = null;
                    var type:ParserTokens = null;
                    while (i < pre.length) {
                        var lookahead = pre[i];
                        switch lookahead {
                            case TypeDeclaration(typeToken): {
                                if (name == null) return null;
                                else if (type == null) return null;
                                type = typeToken;
                                break;
                            }
                            case SetLine(_) | SplitLine | Sign("="): i--; break;
                            case Block(body, type): {
                                if (name == null) name = Block(mergeComplexStructures(body), type);
                                else if (params == null) params = Block(mergeComplexStructures(body), type);
                                else if (type == null) type = Block(mergeComplexStructures(body), type);
                                else {
                                    i--;
                                    break;
                                }
                            }
                            case Expression(body, type): {
                                if (name == null) name = Expression(mergeComplexStructures(body), type);
                                else if (params == null) params = Expression(mergeComplexStructures(body), type);
                                else if (type == null) type = Expression(mergeComplexStructures(body), type);
                                else {
                                    i--;
                                    break;
                                }
                            }
                            case _: {
                                if (name == null) name = lookahead;
                                else if (params == null) params = lookahead;
                                else if (type == null) type = lookahead;
                                else {
                                    i--;
                                    break;
                                }
                            }
                        }
                        i++;
                    }
                    i--;
                    post.push(Action(name, params, type));
                }
                case Identifier(CONDITION_TYPES.contains(_) => true): {
                    i++;
                    if (i >= pre.length) return null;

                    var name:ParserTokens = Identifier(token.getParameters()[0]);
                    var exp:ParserTokens = null;
                    var body:ParserTokens = null;
                    var type:ParserTokens = null;

                    while (i < pre.length) {
                        var lookahead = pre[i];
                        switch lookahead {
                            case SetLine(_) | SplitLine:
                            case Block(b, type): {
                                if (exp == null) exp = Block(mergeComplexStructures(b), type);
                                else if (body == null) body = Block(mergeComplexStructures(b), type)
                                else break;
                            }
                            case Expression(parts, type): {
                                if (exp == null) exp = Expression(mergeComplexStructures(parts), type);
                                else if (body == null) body = Expression(mergeComplexStructures(parts), type)
                                else break;
                            }
                            case _: {
                                if (exp == null) exp = lookahead;
                                else if (body == null) body = lookahead;
                                else break;
                            }
                        }
                        i++;
                    }
                    i--;
                    if (i + 1 < pre.length) {
                        switch pre[i + 1] {
                            case Block(_, _) | TypeDeclaration(_): type = pre[i + 1];
                            case _:
                        }
                    }
                    post.push(Condition(name, exp, body, type));
                }
                case Identifier(_ == FUNCTION_RETURN => true): {
                    i++;
                    if (i >= pre.length) return null;

                    var valueToReturn:Array<ParserTokens> = [];
                    while (i < pre.length) {
                        var lookahead = pre[i];
                        switch lookahead {
                            case SetLine(_) | SplitLine: i--; break;
                            case Block(body, type): {
                                valueToReturn.push(Block(mergeComplexStructures(body), type));
                            }
                            case Expression(body, type): {
                                valueToReturn.push(Expression(mergeComplexStructures(body), type));
                            }
                            case _: valueToReturn.push(lookahead);
                        }
                        i++;
                    }
                    post.push(Return(if (valueToReturn.length == 1) valueToReturn[0] else Expression(valueToReturn.copy(), null), null));
                }
                case Expression(parts, type): post.push(Expression(mergeComplexStructures(parts), null));
                case Block(body, type): post.push(Block(mergeComplexStructures(body), null));
                case _: post.push(token);
            }
            i++;
        }

        return post;
    }

    public static function mergeWrites(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;

        var post:Array<ParserTokens> = [];

        // First, merge two consecutive "=" into a single "=="

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            if (token == null) {
                i++;
                continue;
            }
            switch token {
                case Sign("="): {
                    if (i + 1 >= pre.length) {
                        post.push(Sign("="));
                        break;
                    }
                    var lookahead = pre[i + 1];
                    if (Type.enumEq(lookahead, Sign("="))) {
                        post.push(Sign("=="));
                        i++;
                    } else {
                        post.push(Sign("="));
                    }
                }
                case Block(body, type): post.push(Block(mergeWrites(body), type));
                case Expression(body, type): post.push(Expression(mergeWrites(body), type));
                case Define(name, type): post.push(Define(mergeWrites([name])[0], type));
                case Action(name, params, type): post.push(Action(mergeWrites([name])[0], mergeWrites([params])[0], type));
                case Condition(name, exp, body, type): post.push(Condition(mergeWrites([name])[0], mergeWrites([exp])[0], mergeWrites([body])[0], type));
                case Return(value, type): post.push(Return(mergeWrites([value])[0], type));
                case _: post.push(token);
            }

            i++;
        }

        pre = post.copy();
        post = [];

        // Now, deal with writes

        var potentialAssignee:ParserTokens = NullValue;
        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case Sign("="): {
                    if (i + 1 >= pre.length) break;

                    var currentAssignee:Array<ParserTokens> = [potentialAssignee];
                    // potentialAssignee might be a function call
                    // In that case, we should lookbehind for expressions, and stop when we find anything that isn't an expression
                    switch potentialAssignee {
                        case Expression(_, _): {
                            while (true) {
                                switch post[post.length - 1] {
                                    case Sign(_) | SetLine(_) | SplitLine: break;
                                    case Expression(_, _): {
                                        currentAssignee.unshift(post.pop());

                                    }
                                    case _: {
                                        currentAssignee.unshift(post.pop());
                                        break;
                                    }
                                }
                            }
                        }
                        case _:
                    }

                    var assignees = [currentAssignee.length == 1 ? currentAssignee[0] : Expression(currentAssignee.copy(), null)];
                    currentAssignee = [];
                    var value:ParserTokens;
                    while (i + 1 < pre.length) {
                        var lookahead = pre[i + 1];
                        switch lookahead {

                            case Sign("="): {
                                var assignee = currentAssignee.length == 1 ? currentAssignee[0] : Expression(currentAssignee.copy(), null);
                                assignees.push(assignee);
                                currentAssignee = [];
                            }
                            case SplitLine | SetLine(_): break;
                            case _: currentAssignee.push(lookahead);
                        }
                        i++;
                    }

                    // The last currentAssignee is the value;
                    value = Expression(currentAssignee, null);
                    post.push(Write(assignees, value, null));
                    potentialAssignee = null;
                }
                case Expression(parts, type): {
                    post.push(potentialAssignee);
                    potentialAssignee = Expression(mergeWrites(parts), type);
                }
                case Block(body, type): {
                    post.push(potentialAssignee);
                    potentialAssignee = Block(mergeWrites(body), type);
                }
                case Define(name, type): {
                    post.push(potentialAssignee);
                    potentialAssignee = Define(mergeWrites([name])[0], type);
                }
                case Action(name, params, type): {
                    post.push(potentialAssignee);
                    potentialAssignee = Action(mergeWrites([name])[0], mergeWrites([params])[0], type);
                }
                case Condition(name, exp, body, type): {
                    post.push(potentialAssignee);
                    potentialAssignee = Condition(mergeWrites([name])[0], mergeWrites([exp])[0], mergeWrites([body])[0], type);
                }
                case Return(value, type): {
                    post.push(potentialAssignee);
                    potentialAssignee = Return(mergeWrites([value])[0], type);
                }
                case _: {
                    post.push(potentialAssignee);
                    potentialAssignee = token;
                }
            }

            i++;
        }
        if (potentialAssignee != null) post.push(potentialAssignee);
        post.shift();
        return post;
    }
}