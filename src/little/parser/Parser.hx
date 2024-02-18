package little.parser;

import little.tools.Layer;
import little.tools.PrettyPrinter;
import little.parser.Tokens.ParserTokens;
import little.lexer.Tokens.LexerTokens;
import little.Keywords.*;
import little.interpreter.Runtime;

using StringTools;
using little.tools.TextTools;
using little.tools.Extensions;

using little.parser.Parser;

@:access(little.interpreter.Runtime)
class Parser {

    public static var additionalParsingLevels:Array<Array<ParserTokens> -> Array<ParserTokens>> = [/*Parser.mergeNonBlockBodies ,*/ Parser.mergeElses];

    public static function parse(lexerTokens:Array<LexerTokens>):Array<ParserTokens> {
        var tokens = convert(lexerTokens);

        #if parser_debug trace("before:", PrettyPrinter.printParserAst(tokens)); #end
        tokens = mergeBlocks(tokens);
        #if parser_debug trace("blocks:", PrettyPrinter.printParserAst(tokens)); #end
        tokens = mergeExpressions(tokens);
        #if parser_debug trace("expressions:", PrettyPrinter.printParserAst(tokens)); #end
        tokens = mergePropertyOperations(tokens);
        #if parser_debug trace("props:", PrettyPrinter.printParserAst(tokens)); #end
        tokens = mergeTypeDecls(tokens);
        #if parser_debug trace("types:", PrettyPrinter.printParserAst(tokens)); #end
        tokens = mergeComplexStructures(tokens);
        #if parser_debug trace("structures:", PrettyPrinter.printParserAst(tokens)); #end
        tokens = mergeCalls(tokens);
        #if parser_debug trace("calls:", PrettyPrinter.printParserAst(tokens)); #end
        tokens = mergeWrites(tokens);
        #if parser_debug trace("writes:", PrettyPrinter.printParserAst(tokens)); #end
        tokens = mergeValuesWithTypeDeclarations(tokens);
        #if parser_debug trace("casts:", PrettyPrinter.printParserAst(tokens)); #end
        for (level in Parser.additionalParsingLevels) {
            tokens = level(tokens);
            #if parser_debug trace('${level}:', tokens); #end
        }
        #if parser_debug trace("macros:", PrettyPrinter.printParserAst(tokens)); #end

        return tokens;
    }

    public static function convert(lexerTokens:Array<LexerTokens>):Array<ParserTokens> {
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
                    if (value == Little.keywords.FALSE_VALUE) tokens.push(FalseValue);
                    else if (value == Little.keywords.TRUE_VALUE) tokens.push(TrueValue);
                }
                case Characters(string): tokens.push(Characters(string));
                case NullValue: tokens.push(NullValue);
                case Newline: {
                    tokens.push(SetLine(line));
                    line++;
                }
                case SplitLine: tokens.push(SplitLine);
                case Documentation(content): tokens.push(Documentation(content));
            }

            i++;
        }

        return tokens;
    }


    public static function mergeBlocks(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

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
                case Expression(parts, type): post.push(Expression(mergeBlocks(parts), mergeBlocks([type])[0]));
                case Block(body, type): post.push(Block(mergeBlocks(body), mergeBlocks([type])[0]));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    public static function mergeExpressions(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

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

                case Expression(parts, type): post.push(Expression(mergeExpressions(parts), mergeExpressions([type])[0]));
                case Block(body, type): post.push(Block(mergeExpressions(body), mergeExpressions([type])[0]));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    public static function mergePropertyOperations(pre:Array<ParserTokens>) :Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

        var post:Array<ParserTokens> = [];
        var i = 0;
        while (i < pre.length) {

            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Sign(_ == PROPERTY_ACCESS_SIGN => true): {
                    if (i + 1 >= pre.length) {
                        Runtime.throwError(ErrorMessage("Property access cut off by the end of file, block or expression."), Layer.PARSER);
                        return null;
                    }
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
                case Block(body, type): post.push(Block(mergePropertyOperations(body), mergePropertyOperations([type])[0]));
                case Expression(parts, type): post.push(Expression(mergePropertyOperations(parts), mergePropertyOperations([type])[0]));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    public static function mergeTypeDecls(pre:Array<ParserTokens>):Array<ParserTokens> {
        
        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

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
                        post.push(TypeDeclaration(null, mergeTypeDecls([lookahead])[0]));
                        i++;
                    } else if (word == TYPE_DECL_OR_CAST) {
                        // Throw error for incomplete type declarations;
                    if (i + 1 == pre.length) {
                        Runtime.throwError(ErrorMessage('Incomplete type declaration, make sure to input a type after the `$TYPE_DECL_OR_CAST`.'));
                        return null;
                    }
                    } else {
                        post.push(token);
                    }
                }
                case Expression(parts, type): post.push(Expression(mergeTypeDecls(parts), mergeTypeDecls([type])[0]));
                case Block(body, type): post.push(Block(mergeTypeDecls(body), mergeTypeDecls([type])[0]));
                case PropertyAccess(name, property): post.push(PropertyAccess(mergeTypeDecls([name])[0], mergeTypeDecls([property])[0]));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    public static function mergeComplexStructures(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

        var post:Array<ParserTokens> = [];

		var currentDoc:ParserTokens = null;
        var i = 0;
        while (i < pre.length) {
            var token = pre[i];

            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
				case Documentation(doc): currentDoc = token;
                case Identifier(_ == Little.keywords.VARIABLE_DECLARATION => true): {
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
                                if (pushToName) {name.push(Block(mergeComplexStructures(body), mergeComplexStructures([type])[0])); pushToName = false;}
                                else if (type == null) type = Block(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else {
                                    i--;
                                    break;
                                }
                            }
                            case Expression(body, type): {
                                if (pushToName) {name.push(Expression(mergeComplexStructures(body), mergeComplexStructures([type])[0])); pushToName = false;}
                                else if (type == null) type = Expression(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
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
                    post.push(Variable(if (name.length == 1) name[0] else PartArray(name) /* Soon to be: PropertyAccess */, type, currentDoc));
					currentDoc = null;
                }
                case Identifier(_ == Little.keywords.FUNCTION_DECLARATION => true): {
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
                                type = mergeComplexStructures([typeToken])[0];
                                break;
                            }
                            case Sign("="): i--; break;
                            case Sign(_ == PROPERTY_ACCESS_SIGN => true): {
                                if (params != null) {i--; break;}
                                pushToName = true;
                                name.push(lookahead);
                            }
                            case Block(body, type): {
                                if (pushToName) {name.push(Block(mergeComplexStructures(body), mergeComplexStructures([type])[0])); pushToName = false;}
                                else if (params == null) params = Block(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else if (type == null) type = Block(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else {
                                    break;
                                }
                            }
                            case Expression(body, type): {
                                if (pushToName) {name.push(Expression(mergeComplexStructures(body), mergeComplexStructures([type])[0])); pushToName = false;}
                                else if (params == null) params = Expression(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else if (type == null) type = Expression(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else {
                                    break;
                                }
                            }
                            case _: {
                                if (pushToName) {name.push(lookahead); pushToName = false;}
                                else if (params == null) params = lookahead;
                                else if (type == null && lookahead.getName() == "TypeDeclaration") type = mergeComplexStructures([lookahead.getParameters()[1]])[0];
                                else {
                                    break;
                                }
                            }
                        }
                        i++;
                    }
                    post.push(Function(if (name.length == 1) name[0] else PartArray(name) /* Will be converted to PropertyAccess later on*/, params, type, currentDoc));
					currentDoc = null;
                }
                case Identifier(_ == Little.keywords.FUNCTION_RETURN => true): {
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
                                valueToReturn.push(Block(mergeComplexStructures(body), mergeComplexStructures([type])[0]));
                            }
                            case Expression(body, type): {
                                valueToReturn.push(Expression(mergeComplexStructures(body), mergeComplexStructures([type])[0]));
                            }
                            case _: valueToReturn.push(lookahead);
                        }
                        i++;
                    }
                    post.push(Return(if (valueToReturn.length == 1) valueToReturn[0] else Expression(valueToReturn.copy(), null), null));
                }
				case Identifier(_): { // Condition are definable, we need to look for the syntax: Identifier -> Expression -> Block. 
                    i++;
                    if (i + 1>= pre.length) {
                        post.push(token);
                        continue;
                    }

                    var name:ParserTokens = Identifier(token.getParameters()[0]);
                    var exp:ParserTokens = null;
                    var body:ParserTokens = null;

					var fallback = i - 1; // Reason for -1 here is because of the lookahead - if this isnt a condition, i-1 is pushed and i is the next token.

                    while (i < pre.length) {
                        var lookahead = pre[i];
                        switch lookahead {
                            case SetLine(_): {}
                            case SplitLine: { // Encountering a line split in any place breaks the sequence (if (), {}, if, () {})
							if (exp != null && body != null) break;
								i = fallback;
								break;
							}
                            case Block(b, type): {
                                if (exp == null) {
									i = fallback;
									break;
								}
                                else if (body == null) body = Block(mergeComplexStructures(b), mergeComplexStructures([type])[0])
                                else break;
                            }
                            case Expression(parts, type): {
                                if (exp == null) exp = Expression(mergeComplexStructures(parts), mergeComplexStructures([type])[0]);
                                else if (body == null) {
									i = fallback;
								}
                                else break;
                            }
                            case _: {
                                if (exp == null || body == null) {
									i = fallback;
									break;
								}
                                else break;
                            }
                        }
                        i++;
                    }
					if (i == fallback) {
						post.push(token);
					} else {
						i--;
						post.push(Condition(name, exp, body));
						currentDoc = null;
					}
                }                
                case Expression(parts, type): post.push(Expression(mergeComplexStructures(parts), mergeComplexStructures([type])[0]));
                case Block(body, type): post.push(Block(mergeComplexStructures(body), mergeComplexStructures([type])[0]));
                case PropertyAccess(name, property): post.push(PropertyAccess(mergeComplexStructures([name])[0], mergeComplexStructures([property])[0]));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    public static function mergeCalls(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

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
                case Block(body, type): post.push(Block(mergeCalls(body), mergeCalls([type])[0]));
                case Variable(name, type, doc): post.push(Variable(mergeCalls([name])[0], mergeCalls([type])[0], mergeCalls([doc])[0]));
                case Function(name, params, type, doc): post.push(Function(mergeCalls([name])[0], mergeCalls([params])[0], mergeCalls([type])[0], mergeCalls([doc])[0]));
                case Condition(name, exp, body): post.push(Condition(mergeCalls([name])[0], mergeCalls([exp])[0], mergeCalls([body])[0]));
                case Return(value, type): post.push(Return(mergeCalls([value])[0], mergeCalls([type])[0]));
                case PropertyAccess(name, property): post.push(PropertyAccess(mergeCalls([name])[0], mergeCalls([property])[0]));
                case PartArray(parts): post.push(PartArray(mergeCalls(parts)));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    public static function mergeWrites(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

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
                    post.push(Write(assignees, v));
                    potentialAssignee = null;
                }
                case Expression(parts, type): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = Expression(mergeWrites(parts), mergeWrites([type])[0]);
                }
                case PartArray(parts): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = PartArray(mergeWrites(parts));
                }
                case Block(body, type): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = Block(mergeWrites(body), mergeWrites([type])[0]);
                }
                case Variable(name, type, doc): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = Variable(mergeWrites([name])[0], mergeWrites([type])[0], mergeWrites([doc])[0]);
                }
                case Function(name, params, type, doc): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = Function(mergeWrites([name])[0], mergeWrites([params])[0], mergeWrites([type])[0], mergeWrites([doc])[0]);
                }
                case Condition(name, exp, body): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = Condition(mergeWrites([name])[0], mergeWrites([exp])[0], mergeWrites([body])[0]);
                }
                case Return(value, type): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = Return(mergeWrites([value])[0], mergeWrites([type])[0]);
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
        if (potentialAssignee != null) post.push(potentialAssignee);
        post.shift();

        resetLines();
        return post;
    }

    public static function mergeValuesWithTypeDeclarations(pre:Array<ParserTokens>) :Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

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
                case Block(body, type): post.unshift(Block(mergeValuesWithTypeDeclarations(body), mergeValuesWithTypeDeclarations([type])[0]));
                case Expression(parts, type): post.unshift(Expression(mergeValuesWithTypeDeclarations(parts), mergeValuesWithTypeDeclarations([type])[0]));
                case Variable(name, type, doc): post.unshift(Variable(mergeValuesWithTypeDeclarations([name])[0], mergeValuesWithTypeDeclarations([type])[0], mergeValuesWithTypeDeclarations([doc])[0]));
                case Function(name, params, type, doc): post.unshift(Function(mergeValuesWithTypeDeclarations([name])[0], mergeValuesWithTypeDeclarations([params])[0], mergeValuesWithTypeDeclarations([type])[0], mergeValuesWithTypeDeclarations([doc])[0]));
                case Condition(name, exp, body): post.unshift(Condition(mergeValuesWithTypeDeclarations([name])[0], mergeValuesWithTypeDeclarations([exp])[0], mergeValuesWithTypeDeclarations([body])[0]));
                case Return(value, type): post.unshift(Return(mergeValuesWithTypeDeclarations([value])[0], mergeValuesWithTypeDeclarations([type])[0]));
                case PartArray(parts): post.unshift(PartArray(mergeValuesWithTypeDeclarations(parts)));
                case FunctionCall(name, params): post.unshift(FunctionCall(mergeValuesWithTypeDeclarations([name])[0], mergeValuesWithTypeDeclarations([params])[0]));
                case Write(assignees, value): post.unshift(Write(mergeValuesWithTypeDeclarations(assignees), mergeValuesWithTypeDeclarations([value])[0]));
                case PropertyAccess(name, property): post.unshift(PropertyAccess(mergeValuesWithTypeDeclarations([name])[0], mergeValuesWithTypeDeclarations([property])[0]));
                case _: post.unshift(token);
            }
            i--;
        }

        resetLines();
        return post;
    }

    /**
    	NEEDS REWORKING
    **/
    public static function mergeNonBlockBodies(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Condition(name, exp, NoBody): {
                    if (i + 1 >= pre.length) {
                        Runtime.throwError(ErrorMessage('Condition has no body, body may be cut off by the end of file, block or expression.'), PARSER);
                        return null;
                    }
                    var skip = 2;
                    function look(i:Int):ParserTokens {
                        i++;
                        var lookahead = pre[i];
                        switch lookahead {
                            case SplitLine: {
                                Runtime.throwError(ErrorMessage('Condition has no body, body cut off by a line split, or does not exist'), PARSER);
                                return null;
                            }
                            case SetLine(_): {
                                Runtime.throwError(ErrorMessage('Condition has no body, body cut off by a new line, or does not exist'), PARSER);
                                return null;
                            }
                            case Condition(name1, exp1, NoBody): { //allow chaining 
                                skip++;
                                return Condition(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([exp])[0], mergeNonBlockBodies([{name = name1; exp = exp1; look(i);}])[0]);
                            }
                            case _: return Condition(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([exp])[0], mergeNonBlockBodies([lookahead])[0]);
                        }
                    }
                    post.push(mergeNonBlockBodies([look(i)])[0]);
                    i += skip;
                    continue;
                }
                case Block(body, type): post.push(Block(mergeNonBlockBodies(body), mergeNonBlockBodies([type])[0]));
                case Expression(parts, type): post.push(Expression(mergeNonBlockBodies(parts), mergeNonBlockBodies([type])[0]));
                case Variable(name, type, doc): post.push(Variable(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([type])[0], mergeNonBlockBodies([doc])[0]));
                case Function(name, params, type, doc): post.push(Function(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([params])[0], mergeNonBlockBodies([type])[0], mergeNonBlockBodies([doc])[0]));
                case Condition(name, exp, body): post.push(Condition(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([exp])[0], mergeNonBlockBodies([body])[0]));
                case Return(value, type): post.push(Return(mergeNonBlockBodies([value])[0], mergeNonBlockBodies([type])[0]));
                case PartArray(parts): post.push(PartArray(mergeNonBlockBodies(parts)));
                case FunctionCall(name, params): post.push(FunctionCall(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([params])[0]));
                case Write(assignees, value): post.push(Write(mergeNonBlockBodies(assignees), mergeNonBlockBodies([value])[0]));
                case PropertyAccess(name, property): post.push(PropertyAccess(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([property])[0]));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    public static function mergeElses(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Identifier(_ == ELSE => true): {
                    if (post.length == 0 || post[post.length - 1].getName() != 'Condition') {
                        post.push(token);
                        i++;
                        continue;
                    }
                    if (i + 1 >= pre.length) {
                        Runtime.throwError(ErrorMessage('Condition has no body, body may be cut off by the end of file, block or expression.'), PARSER);
                        return null;
                    }
                    var exp:ParserTokens = post[post.length - 1].getParameters()[1]; //Condition(name:ParserTokens, ->exp:ParserTokens<-, body:ParserTokens, type:ParserTokens)
                    exp = Expression([exp, Sign("!="), TrueValue], null);
                    i++;
                    var body:ParserTokens = pre[i];
                    switch body {
                        case SplitLine: {
                            Runtime.throwError(ErrorMessage('`$ELSE` condition has no body, body cut off by a line split, or does not exist'), PARSER);
                            return null;
                        }
                        case SetLine(_): {
                            Runtime.throwError(ErrorMessage('`$ELSE` condition has no body, body cut off by a new line, or does not exist'), PARSER);
                            return null;
                        }
                        case _: post.push(Condition(Identifier("if"), exp, body));
                    }
                }
                case Block(body, type): post.push(Block(mergeElses(body), mergeElses([type])[0]));
                case Expression(parts, type): post.push(Expression(mergeElses(parts), mergeElses([type])[0]));
                case Variable(name, type, doc): post.push(Variable(mergeElses([name])[0], mergeElses([type])[0], mergeElses([doc])[0]));
                case Function(name, params, type, doc): post.push(Function(mergeElses([name])[0], mergeElses([params])[0], mergeElses([type])[0], mergeElses([doc])[0]));
                case Condition(name, exp, body): post.push(Condition(mergeElses([name])[0], mergeElses([exp])[0], mergeElses([body])[0]));
                case Return(value, type): post.push(Return(mergeElses([value])[0], mergeElses([type])[0]));
                case PartArray(parts): post.push(PartArray(mergeElses(parts)));
                case FunctionCall(name, params): post.push(FunctionCall(mergeElses([name])[0], mergeElses([params])[0]));
                case Write(assignees, value): post.push(Write(mergeElses(assignees), mergeElses([value])[0]));
                case PropertyAccess(name, property): post.push(PropertyAccess(mergeElses([name])[0], mergeElses([property])[0]));
                case _: post.push(token);
            }
            i++;
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

    static function get<T>(a:Array<T>, i:Int):T {
        return a[i];
    }
}