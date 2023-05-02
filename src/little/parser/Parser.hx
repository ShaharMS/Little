package little.parser;

import little.tools.Layer;
import little.tools.PrettyPrinter;
import little.parser.Tokens.ParserTokens;
import little.lexer.Tokens.LexerTokens;
import little.Keywords.*;
import little.interpreter.Runtime;

using StringTools;
using little.tools.TextTools;

@:access(little.interpreter.Runtime)
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
        // trace("before:", tokens);
        tokens = mergeBlocks(tokens);
        // trace("blocks:", tokens);
        tokens = mergeExpressions(tokens);
        // trace("expressions:", tokens);
        tokens = mergeTypeDecls(tokens);
        // trace("types:", tokens);
        tokens = mergeComplexStructures(tokens);
        // trace("structures:", tokens);
        tokens = mergeCalls(tokens);
        // trace("calls:", tokens);
        tokens = mergePropertyOperations(tokens);
        // trace("props:", tokens);
        tokens = mergeWrites(tokens);
        // trace("writes:", tokens);
        tokens = mergeValuesWithTypeDeclarations(tokens);

        return tokens;
    }



    public static function mergeBlocks(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Sign("{"): {
                    var blockStartLine = line;
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

                    // Throw error for unclosed blocks;
                    if (i + 1 == pre.length) {
                        Runtime.throwError(ErrorMessage('Unclosed code block, starting at line ' + blockStartLine));
                        return null;
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

        resetLines();
        return post;
    }

    public static function mergeExpressions(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Sign("("): {
                    var expressionStartLine = line;
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
                    // Throw error for unclosed expressions;
                    if (i + 1 == pre.length) {
                        Runtime.throwError(ErrorMessage('Unclosed expression, starting at line ' + expressionStartLine));
                        return null;
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

        resetLines();
        return post;
    }

    public static function mergeTypeDecls(pre:Array<ParserTokens>):Array<ParserTokens> {
        
        if (pre == null) return null;

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Identifier(word): {
                    if (word == TYPE_DECL_OR_CAST && i + 1 < pre.length) {
                        var lookahead = pre[i + 1];
                        post.push(TypeDeclaration(null, lookahead));
                        i++;
                    } else if (word == TYPE_DECL_OR_CAST) {
                        // Throw error for incomplete type declarations;
                    if (i + 1 == pre.length) {
                        Runtime.throwError(ErrorMessage('Incomplete type declaration, make sure to input a type after the $TYPE_DECL_OR_CAST.'));
                        return null;
                    }
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

        resetLines();
        return post;
    }

    public static function mergeComplexStructures(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];

            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Identifier(_ == VARIABLE_DECLARATION => true): {
                    i++;
                    if (i >= pre.length) {
                        Runtime.throwError(ErrorMessage("Missing variable name, variable is cut off by the end of the file, block or expression."), Layer.PARSER);
                        return null;
                    }

                    var name:Array<ParserTokens> = [];
                    var pushToName = true;
                    var type:ParserTokens = null;
                    while (i < pre.length) {
                        var lookahead = pre[i];
                        switch lookahead {
                            case TypeDeclaration(_, typeToken): {
                                if (name.length == 0) {
                                    Runtime.throwError(ErrorMessage("Missing variable name before type declaration."), Layer.PARSER);
                                    return null;
                                }
                                type = typeToken;
                                break;
                            }
                            case SetLine(_) | SplitLine | Sign("="): i--; break;
                            case Sign(_ == PROPERTY_ACCESS_SIGN => true): {
                                pushToName = true;
                                name.push(lookahead);
                            }
                            case Block(body, type): {
                                if (pushToName) {name.push(Block(mergeComplexStructures(body), type)); pushToName = false;}
                                else if (type == null) type = Block(mergeComplexStructures(body), type);
                                else {
                                    i--;
                                    break;
                                }
                            }
                            case Expression(body, type): {
                                if (pushToName) {name.push(Expression(mergeComplexStructures(body), type)); pushToName = false;}
                                else if (type == null) type = Expression(mergeComplexStructures(body), type);
                                else {
                                    i--;
                                    break;
                                }
                            }
                            case _: {
                                if (pushToName) {name.push(lookahead); pushToName = false;}
                                else if (type == null && lookahead.getName() == "TypeDeclaration") type = lookahead;
                                else {
                                    i--;
                                    break;
                                }
                            }
                        }
                        i++;
                    }
                    post.push(Variable(if (name.length == 1) name[0] else PartArray(name) /* Soon to be: PropertyAccess */, type));
                }
                case Identifier(_ == FUNCTION_DECLARATION => true): {
                    i++;
                    if (i >= pre.length) {
                        Runtime.throwError(ErrorMessage("Missing function name, function is cut off by the end of the file, block or expression."), Layer.PARSER);
                        return null;
                    }
                    if (i + 1 >= pre.length) {
                        Runtime.throwError(ErrorMessage("Missing function parameter body, function is cut off by the end of the file, block or expression."), Layer.PARSER);
                        return null;
                    }
                    
                    var name:Array<ParserTokens> = [];
                    var pushToName = true;
                    var params:ParserTokens = null;
                    var type:ParserTokens = null;
                    while (i < pre.length) {
                        var lookahead = pre[i];
                        switch lookahead {
                            case TypeDeclaration(_, typeToken): {
                                if (name.length == 0) {
                                    Runtime.throwError(ErrorMessage("Missing function name & parameters before type declaration."), Layer.PARSER);
                                    return null;
                                }
                                else if (params == null) {
                                    Runtime.throwError(ErrorMessage("Missing function parameters before type declaration."), Layer.PARSER);
                                    return null;
                                }
                                type = typeToken;
                                break;
                            }
                            case Sign("="): i--; break;
                            case Sign(_ == PROPERTY_ACCESS_SIGN => true): {
                                if (params != null) {i--; break;}
                                pushToName = true;
                                name.push(lookahead);
                            }
                            case Block(body, type): {
                                if (pushToName) {name.push(Block(mergeComplexStructures(body), type)); pushToName = false;}
                                else if (params == null) params = Block(mergeComplexStructures(body), type);
                                else if (type == null) type = Block(mergeComplexStructures(body), type);
                                else {
                                    break;
                                }
                            }
                            case Expression(body, type): {
                                if (pushToName) {name.push(Expression(mergeComplexStructures(body), type)); pushToName = false;}
                                else if (params == null) params = Expression(mergeComplexStructures(body), type);
                                else if (type == null) type = Expression(mergeComplexStructures(body), type);
                                else {
                                    break;
                                }
                            }
                            case _: {
                                if (pushToName) {name.push(lookahead); pushToName = false;}
                                else if (params == null) params = lookahead;
                                else if (type == null && lookahead.getName() == "TypeDeclaration") type = lookahead;
                                else {
                                    break;
                                }
                            }
                        }
                        i++;
                    }
                    post.push(Function(if (name.length == 1) name[0] else PartArray(name) /* Soon to be: PropertyAccess */, params, type));
                }
                case Identifier(CONDITION_TYPES.contains(_) => true): {
                    i++;
                    if (i >= pre.length) {
                        Runtime.throwError(ErrorMessage("Missing condition name, condition is cut off by the end of the file, block or expression."), Layer.PARSER);
                        return null;
                    }

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
                            case Block(_, _) | TypeDeclaration(_): type = pre[i + 1]; i++;
                            case _:
                        }
                    }
                    post.push(Condition(name, exp, body, type));
                }
                case Identifier(_ == FUNCTION_RETURN => true): {
                    i++;
                    if (i >= pre.length) {
                        Runtime.throwError(ErrorMessage("Missing return value, value is cut off by the end of the file, block or expression."), Layer.PARSER);
                        return null;
                    }

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

        resetLines();
        return post;
    }

    public static function mergeCalls(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {

            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Expression(parts, type): {
                    parts = mergeCalls(parts);
                    if (i == 0) {
                        post.push(Expression(parts, type));
                    } else {
                        var lookbehind = pre[i - 1];
                        switch lookbehind {
                            case Sign(_) | SplitLine | SetLine(_): post.push(Expression(parts, type));
                            case _: {
                                var previous = post.pop(); // When parsing a function that returns a function, this handles the "nested call" correctly
                                token = PartArray(parts);
                                post.push(FunctionCall(previous, token));
                            }
                        }
                    }
                }
                case Block(body, type): post.push(Block(mergeCalls(body), type));
                case Variable(name, type): post.push(Variable(mergeCalls([name])[0], type));
                case Function(name, params, type): post.push(Function(mergeCalls([name])[0], mergeCalls([params])[0], type));
                case Condition(name, exp, body, type): post.push(Condition(mergeCalls([name])[0], mergeCalls([exp])[0], mergeCalls([body])[0], type));
                case Return(value, type): post.push(Return(mergeCalls([value])[0], type));
                case PartArray(parts): post.push(PartArray(mergeCalls(parts)));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    public static function mergePropertyOperations(pre:Array<ParserTokens>) :Array<ParserTokens> {

        if (pre == null) return null;

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {

            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Sign(_ == PROPERTY_ACCESS_SIGN => true): {
                    if (post.length == 0) {
                        Runtime.throwError(ErrorMessage("Property access cut off by the start of file, block or expression."), Layer.PARSER);
                        return null;
                    }
                    var lookbehind = post.pop();
                    switch lookbehind {
                        case SplitLine | SetLine(_): {
                            Runtime.throwError(ErrorMessage("Property access cut off by the start of a line, or by a line split (; or ,)."), Layer.PARSER);
                            return null;
                        }
                        case Sign(s): {
                            Runtime.throwError(ErrorMessage('Cannot access the property of a sign ($s). Was the property access cut off by accident?'));
                            return null;
                        }
                        case _: {
                            var field = pre[++i];
                            post.push(PropertyAccess(lookbehind, field));
                        }
                    }
                }
                case Block(body, type): post.push(Block(mergePropertyOperations(body), type));
                case Expression(parts, type): post.push(Expression(mergePropertyOperations(parts), type));
                case Variable(name, type): post.push(Variable(mergePropertyOperations(if (name.getName() == "PartArray") name.getParameters()[0] else [name])[0], type));
                case Function(name, params, type): post.push(Function(mergePropertyOperations(if (name.getName() == "PartArray") name.getParameters()[0] else [name])[0], mergePropertyOperations([params])[0], type));
                case Condition(name, exp, body, type): post.push(Condition(mergePropertyOperations([name])[0], mergePropertyOperations([exp])[0], mergePropertyOperations([body])[0], type));
                case Return(value, type): post.push(Return(mergePropertyOperations([value])[0], type));
                case PartArray(parts): post.push(PartArray(mergePropertyOperations(parts)));
                case FunctionCall(name, params): post.push(FunctionCall(mergePropertyOperations([name])[0], mergePropertyOperations([params])[0]));
                case Write(assignees, value, type): post.push(Write(mergePropertyOperations(assignees), mergePropertyOperations([value])[0], type));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    public static function mergeWrites(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;

        var post:Array<ParserTokens> = [];

        var potentialAssignee:ParserTokens = NullValue;
        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case SetLine(line): {
                    setLine(line); 
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = token;
                }
                case SplitLine: {
                    nextPart(); 
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = token;
                }
                case Sign("="): {
                    if (i + 1 >= pre.length) {
                        Runtime.throwError(ErrorMessage("Missing value after the `=`"), Layer.PARSER);
                        return null;
                    }

                    var currentAssignee:Array<ParserTokens> = [potentialAssignee];
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
                    if (currentAssignee.length == 0) {
                        Runtime.throwError(ErrorMessage("Missing value after the last `=`"), Layer.PARSER);
                        return null;
                    }
                    // The last currentAssignee is the value;
                    value = if (currentAssignee.length == 1) currentAssignee[0] else Expression(currentAssignee, null);
                    var fValue = mergeWrites([value]);
                    var v = if (fValue.length == 1) fValue[0] else Expression(fValue, null);
                    post.push(Write(assignees, v, null));
                    potentialAssignee = null;
                }
                case Expression(parts, type): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = Expression(mergeWrites(parts), type);
                }
                case PartArray(parts): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = PartArray(mergeWrites(parts));
                }
                case Block(body, type): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = Block(mergeWrites(body), type);
                }
                case Variable(name, type): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = Variable(mergeWrites([name])[0], type);
                }
                case Function(name, params, type): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = Function(mergeWrites([name])[0], mergeWrites([params])[0], type);
                }
                case Condition(name, exp, body, type): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = Condition(mergeWrites([name])[0], mergeWrites([exp])[0], mergeWrites([body])[0], type);
                }
                case Return(value, type): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = Return(mergeWrites([value])[0], type);
                }
                case FunctionCall(name, params): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = FunctionCall(mergeWrites([name])[0], mergeWrites([params])[0]);
                }
                case PropertyAccess(name, property): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = PropertyAccess(mergeWrites([name])[0], mergeWrites([property])[0]);
                }
                case _: {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = token;
                }
                
            }

            i++;
        }
        // trace(potentialAssignee);
        if (potentialAssignee != null) post.push(potentialAssignee);
        post.shift();

        resetLines();
        return post;
    }

    public static function mergeValuesWithTypeDeclarations(pre:Array<ParserTokens>) :Array<ParserTokens> {

        if (pre == null) return null;

        var post:Array<ParserTokens> = [];

        var i = pre.length - 1;
        while (i >= 0) {
            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.unshift(token);}
                case SplitLine: {nextPart(); post.unshift(token);}
                case TypeDeclaration(null, type): {
                    if (i-- <= 0) {
                        Runtime.throwError(ErrorMessage("Value's type declaration cut off by the start of file, block or expression."), Layer.PARSER);
                        return null;
                    }
                    var lookbehind = pre[i];
                    switch lookbehind {
                        case SplitLine | SetLine(_): {
                            Runtime.throwError(ErrorMessage("Value's type declaration access cut off by the start of a line, or by a line split (; or ,)."), Layer.PARSER);
                            return null;
                        }
                        case _: {
                            post.unshift(TypeDeclaration(lookbehind, type));
                        }
                    }
                }
                case Block(body, type): post.unshift(Block(mergeValuesWithTypeDeclarations(body), type));
                case Expression(parts, type): post.unshift(Expression(mergeValuesWithTypeDeclarations(parts), type));
                case Variable(name, type): post.unshift(Variable(mergeValuesWithTypeDeclarations(if (name.getName() == "PartArray") name.getParameters()[0] else [name])[0], type));
                case Function(name, params, type): post.unshift(Function(mergeValuesWithTypeDeclarations(if (name.getName() == "PartArray") name.getParameters()[0] else [name])[0], mergeValuesWithTypeDeclarations([params])[0], type));
                case Condition(name, exp, body, type): post.unshift(Condition(mergeValuesWithTypeDeclarations([name])[0], mergeValuesWithTypeDeclarations([exp])[0], mergeValuesWithTypeDeclarations([body])[0], type));
                case Return(value, type): post.unshift(Return(mergeValuesWithTypeDeclarations([value])[0], type));
                case PartArray(parts): post.unshift(PartArray(mergeValuesWithTypeDeclarations(parts)));
                case FunctionCall(name, params): post.unshift(FunctionCall(mergeValuesWithTypeDeclarations([name])[0], mergeValuesWithTypeDeclarations([params])[0]));
                case Write(assignees, value, type): post.unshift(Write(mergeValuesWithTypeDeclarations(assignees), mergeValuesWithTypeDeclarations([value])[0], type));
                case _: post.unshift(token);
            }
            i--;
        }

        resetLines();
        return post;
    }

    







    static var line(get, set):Int;
    static function get_line() return Runtime.line;
    static function set_line(l:Int) return Runtime.line = l;
    static var linePart:Int = 0;
    static function setLine(l:Int) {
        line = l;
        linePart = 0;
    }
    static function nextPart() linePart++;
    static function resetLines() {
        line = 0;
        linePart = 0;
    }
}