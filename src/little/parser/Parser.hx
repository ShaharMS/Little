package little.parser;

import little.tools.Layer;
import little.tools.PrettyPrinter;
import little.parser.Tokens.ParserTokens;
import little.lexer.Tokens.LexerTokens;
import little.interpreter.Runtime;

using StringTools;
using little.tools.TextTools;
using little.tools.Extensions;

using little.parser.Parser;

@:access(little.interpreter.Runtime)
class Parser {

    /**
        An array of functions, which take in the current state of the abstract syntax tree as an array of `ParserTokens`,
        and returns a manipulated version of that abstract syntax tree as another array of `ParserTokens`.

        @see `Parser.mergeElses`
    **/
    public static var additionalParsingLevels:Array<Array<ParserTokens> -> Array<ParserTokens>> = [Parser.mergeElses];

    /**
        Parses the given array of `LexerTokens` into an abstract syntax tree, using tokens of type `ParserTokens`.

        To allow "macro" insertion, this function is assignable, which allows you to add parsing functions between existing ones.
        If your macros aren't parse-level sensitive, it is recommended that you use the `additionalParsingLevels` 
        field instead of reassigning this function.

        @param lexerTokens The given tokens 
        @return An array of tokens, representing an abstract syntax tree
    **/
    public static dynamic function parse(lexerTokens:Array<LexerTokens>):Array<ParserTokens> {
        var tokens = convert(lexerTokens);

        tokens.unshift(SetModule(module));

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
		tokens = mergeNonBlockBodies(tokens);
		#if parser_debug trace("non-block bodies:", PrettyPrinter.printParserAst(tokens)); #end
        for (level in Parser.additionalParsingLevels) {
            tokens = level(tokens);
            #if parser_debug trace('${level}:', tokens); #end
        }
        #if parser_debug trace("macros:", PrettyPrinter.printParserAst(tokens)); #end

        return tokens;
    }

    /**
        Simply converts lexer to parser tokens.
    **/
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


    /**
        Merges This structure:
        ```
        { ... }
        ```
        Into a `Block()` token
    **/
    public static function mergeBlocks(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
				case SetModule(module): {Parser.module = module; post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Sign("{"): {
                    var blockStartLine = line;
                    var blockBody:Array<ParserTokens> = [SetModule(module), SetLine(blockStartLine)];
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
                        Little.runtime.throwError(ErrorMessage('Unclosed code block, starting at line ' + blockStartLine));
                        return null;
                    }

                    post.push(Block(mergeBlocks(blockBody), null)); // The check performed above includes unmerged blocks inside the outer block. These unmerged blocks should be merged
                    i++;
                }
                case Expression(parts, type): post.push(Expression(mergeBlocks(parts), mergeBlocks([type])[0]));
                case Block(body, type): post.push(Block(mergeBlocks(body), mergeBlocks([type])[0]));
				case Custom(name, params): post.push(Custom(name, params.map(x -> mergeBlocks([x])[0])));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    /**
        Merges This structure:
        ```
        (...)
        ```
        Into an `Expression()` token
    **/
    public static function mergeExpressions(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
				case SetModule(module): {Parser.module = module; post.push(token);}
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
                        Little.runtime.throwError(ErrorMessage('Unclosed expression, starting at line ' + expressionStartLine));
                        return null;
                    }
                    post.push(Expression(mergeExpressions(expressionBody), null)); // The check performed above includes unmerged blocks inside the outer block. These unmerged blocks should be merged
                    i++;
                }

                case Expression(parts, type): post.push(Expression(mergeExpressions(parts), mergeExpressions([type])[0]));
                case Block(body, type): post.push(Block(mergeExpressions(body), mergeExpressions([type])[0]));
				case Custom(name, params): post.push(Custom(name, params.map(x -> mergeExpressions([x])[0])));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    /**
       Merges a chain of single tokens seperated by `.`s into a

       `PropertyAccess(first, second)`

       Or a nested version when there are multiple `.`s

       `PropertyAccess(PropertyAccess(first, second), third)` 
    **/
    public static function mergePropertyOperations(pre:Array<ParserTokens>) :Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

        var post:Array<ParserTokens> = [];
        var i = 0;
        while (i < pre.length) {

            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
				case SetModule(module): {Parser.module = module; post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Sign(_ == Little.keywords.PROPERTY_ACCESS_SIGN => true): {
                    if (i + 1 >= pre.length) {
                        Little.runtime.throwError(ErrorMessage("Property access cut off by the end of file, block or expression."), Layer.PARSER);
                        return null;
                    }
                    if (post.length == 0) {
                        Little.runtime.throwError(ErrorMessage("Property access cut off by the start of file, block or expression."), Layer.PARSER);
                        return null;
                    }
                    var lookbehind = post.pop();
                    switch lookbehind {
                        case SplitLine | SetLine(_) | SetModule(_): {
                            Little.runtime.throwError(ErrorMessage("Property access cut off by the start of a line, or by a line split (; or ,)."), Layer.PARSER);
                            return null;
                        }
                        case Expression(_, _): {
                            var field = mergePropertyOperations([pre[++i]])[0];
                            // There are multiple cases, either:
                            // - ().something, in which outright parsing is valid
                            // - p().something, in which we need to generate a function call
                            // - read()().something, the latter gets a little compilcated.
                            // Also, need to handle a.b().c()().d type stuff.
                            var beforePropertyCalls:Array<ParserTokens> = [lookbehind];
                            while (post.length > 0) {
                                var last = post.pop();
                                switch last {
                                    case Identifier(_) | PropertyAccess(_, _): {
                                        beforePropertyCalls.push(last);
                                        break;
                                    }
                                    case Block(body, type): {
										beforePropertyCalls.push(Block(mergePropertyOperations(body), mergePropertyOperations([type])[0]));
										break;
									}
                                    case Expression(parts, type): beforePropertyCalls.push(Expression(mergePropertyOperations(parts), mergePropertyOperations([type])[0]));
                                    case _: {
                                        post.push(last);
                                        break;
                                    }
                                }
                            }

                            var parent:ParserTokens = lookbehind;

                            if (beforePropertyCalls.length > 0) {
                                parent = beforePropertyCalls.pop();
                                while (beforePropertyCalls.length > 0) {
                                    parent = FunctionCall(parent, beforePropertyCalls.pop());
                                }
                            }
                            post.push(PropertyAccess(parent, field));
                        }
						case _: {
							var field = mergePropertyOperations([pre[++i]])[0];
							post.push(PropertyAccess(lookbehind, field));
						}
					}
                }
                case Block(body, type): post.push(Block(mergePropertyOperations(body), mergePropertyOperations([type])[0]));
                case Expression(parts, type): post.push(Expression(mergePropertyOperations(parts), mergePropertyOperations([type])[0]));
				case Custom(name, params): post.push(Custom(name, params.map(x -> mergePropertyOperations([x])[0])));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    /**
        Merges `as <Type>` sequences into `TypeDeclaration(null, <Type>)`
    **/
    public static function mergeTypeDecls(pre:Array<ParserTokens>):Array<ParserTokens> {
        
        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
				case SetModule(module): {Parser.module = module; post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Identifier(word): {
                    if (word == Little.keywords.TYPE_DECL_OR_CAST && i + 1 < pre.length) {
                        var lookahead = pre[i + 1];
                        post.push(TypeDeclaration(null, mergeTypeDecls([lookahead])[0]));
                        i++;
                    } else if (word == Little.keywords.TYPE_DECL_OR_CAST) {
                        // Throw error for incomplete type declarations;
                    if (i + 1 == pre.length) {
                        Little.runtime.throwError(ErrorMessage('Incomplete type declaration, make sure to input a type after the `${Little.keywords.TYPE_DECL_OR_CAST}`.'));
                        return null;
                    }
                    } else {
                        post.push(token);
                    }
                }
                case Expression(parts, type): post.push(Expression(mergeTypeDecls(parts), mergeTypeDecls([type])[0]));
                case Block(body, type): post.push(Block(mergeTypeDecls(body), mergeTypeDecls([type])[0]));
                case PropertyAccess(name, property): post.push(PropertyAccess(mergeTypeDecls([name])[0], mergeTypeDecls([property])[0]));
				case Custom(name, params): post.push(Custom(name, params.map(x -> mergeTypeDecls([x])[0])));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    /**
        Merges many complex seqences into single tokens:

         - `define <name> [as <Type>]` -> `VariableCreation()`
         - `action <name>(<params>) [as <Type>]` -> `FunctionCreation()`
         - and more...
    **/
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
				case SetModule(module): {Parser.module = module; post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
				case Documentation(doc): currentDoc = token;
                case Identifier(_ == Little.keywords.VARIABLE_DECLARATION => true): {
                    i++;
                    if (i >= pre.length) {
                        Little.runtime.throwError(ErrorMessage("Missing variable name, variable is cut off by the end of the file, block or expression."), Layer.PARSER);
                        return null;
                    }

                    var name:ParserTokens = null;
                    var type:ParserTokens = null;

                    while (i < pre.length) {
                        var lookahead = pre[i];
                        switch lookahead {
                            case TypeDeclaration(_, typeToken): {
                                if (name == null) {
                                    Little.runtime.throwError(ErrorMessage("Missing variable name before type declaration."), Layer.PARSER);
                                    return null;
                                }
                                type = typeToken;
                                break;
                            }
                            case SetLine(_) | SetModule(_) | SplitLine | Sign("="): i--; break;
                            case Block(body, type): {
                                if (name == null) name = Block(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else if (type == null) type = Block(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else {
                                    i--;
                                    break;
                                }
                            }
                            case Expression(body, type): {
                                if (name == null) name = Expression(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else if (type == null) type = Expression(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else {
                                    i--;
                                    break;
                                }
                            }
                            case _: {
                                if (name == null) name = lookahead;
                                else if (type == null && lookahead.is(TYPE_DECLARATION)) type = lookahead;
                                else {
                                    i--;
                                    break;
                                }
                            }
                        }
                        i++;
                    }
                    if (name == null) 
                        Little.runtime.throwError(ErrorMessage("Missing variable name, variable is cut off by the end of the file, block or expression."), Layer.PARSER);
                    
                    post.push(Variable(name, type, currentDoc));
					currentDoc = null;
                }
                case Identifier(_ == Little.keywords.FUNCTION_DECLARATION => true): {
                    i++;
                    if (i >= pre.length) {
                        Little.runtime.throwError(ErrorMessage("Missing function name, function is cut off by the end of the file, block or expression."), Layer.PARSER);
                        return null;
                    }
                    if (i + 1 >= pre.length) {
                        Little.runtime.throwError(ErrorMessage("Missing function parameter body, function is cut off by the end of the file, block or expression."), Layer.PARSER);
                        return null;
                    }
                    
                    var name:ParserTokens = null;
                    var params:ParserTokens = null;
                    var type:ParserTokens = null;
                    while (i < pre.length) {
                        var lookahead = pre[i];
                        switch lookahead {
                            case TypeDeclaration(_, typeToken): {
                                if (name == null) {
                                    Little.runtime.throwError(ErrorMessage("Missing function name and parameters before type declaration."), Layer.PARSER);
                                    return null;
                                }
                                else if (params == null) {
                                    Little.runtime.throwError(ErrorMessage("Missing function parameters before type declaration."), Layer.PARSER);
                                    return null;
                                }
                                type = mergeComplexStructures([typeToken])[0];
                                break;
                            }
                            case Sign("="): i--; break;
                            case Block(body, type): {
                                if (name == null) name = Block(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else if (params == null) params = Block(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else if (type == null) type = Block(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else {
                                    break;
                                }
                            }
                            case Expression(body, type): {
                                if (name == null) name = Expression(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else if (params == null) params = Expression(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else if (type == null) type = Expression(mergeComplexStructures(body), mergeComplexStructures([type])[0]);
                                else {
                                    break;
                                }
                            }
                            case _: {
                                if (name == null) name = lookahead;
                                else if (params == null) params = lookahead;
                                else if (type == null && lookahead.getName() == "TypeDeclaration") type = mergeComplexStructures([lookahead.parameter(1)])[0];
                                else {
                                    break;
                                }
                            }
                        }
                        i++;
                    }
                    if (name == null) 
                        Little.runtime.throwError(ErrorMessage("Missing function name and parameters, function is cut off by the end of the file, block or expression."), Layer.PARSER);
                    else if (params == null)
                        Little.runtime.throwError(ErrorMessage("Missing function parameters, function is cut off by the end of the file, block or expression."), Layer.PARSER);

                    post.push(Function(name, params, type, currentDoc));
					currentDoc = null;
                }
                case Identifier(_ == Little.keywords.FUNCTION_RETURN => true): {
                    i++;
                    if (i >= pre.length) {
                        Little.runtime.throwError(ErrorMessage("Missing return value, value is cut off by the end of the file, block or expression."), Layer.PARSER);
                        return null;
                    }

                    var valueToReturn:Array<ParserTokens> = [];
                    while (i < pre.length) {
                        var lookahead = pre[i];
                        switch lookahead {
                            case SetLine(_) | SetModule(_) | SplitLine: i--; break;
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
				case Identifier(_): { // Conditions are definable, or at least, developers can register them dynamically, we need to look for the syntax: Identifier -> Expression -> Block. 
                    i++;
                    if (i + 1>= pre.length) {
                        post.push(token);
                        continue;
                    }

                    var name:ParserTokens = Identifier(token.parameter(0));
                    var exp:ParserTokens = null;
                    var body:ParserTokens = null;

					var fallback = i - 1; // Reason for -1 here is because of the lookahead - if this isn't a condition, i-1 is pushed and i is the next token.

                    while (true) {
                        if (i >= pre.length) {
                            i = fallback;
                            break;
                        }
                        var lookahead = pre[i];
                        switch lookahead {
                            case SetLine(_): {}
                            case SplitLine | SetModule(_): { // Encountering a hard split in any place breaks the sequence (if (), {}, if, () {})
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
                                    break;
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
						post.push(ConditionCall(name, exp, body));
						currentDoc = null;
					}
                }                
                case Expression(parts, type): post.push(Expression(mergeComplexStructures(parts), mergeComplexStructures([type])[0]));
                case Block(body, type): post.push(Block(mergeComplexStructures(body), mergeComplexStructures([type])[0]));
                case PropertyAccess(name, property): post.push(PropertyAccess(mergeComplexStructures([name])[0], mergeComplexStructures([property])[0]));
				case Custom(name, params): post.push(Custom(name, params.map(x -> mergeComplexStructures([x])[0])));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    /**
        Merges a token followed by an expression immediately into a `FunctionCall()`
    **/
    public static function mergeCalls(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {

            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
				case SetModule(module): {Parser.module = module; post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Expression(parts, type): {
                    parts = mergeCalls(parts);
                    if (i == 0) {
                        post.push(Expression(parts, type));
                    } else {
                        var lookbehind = pre[i - 1];
                        switch lookbehind {
                            case Sign(_) | SplitLine | SetLine(_) | SetModule(_): post.push(Expression(parts, type));
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
                case ConditionCall(name, exp, body): post.push(ConditionCall(mergeCalls([name])[0], mergeCalls([exp])[0], mergeCalls([body])[0]));
                case Return(value, type): post.push(Return(mergeCalls([value])[0], mergeCalls([type])[0]));
                case PropertyAccess(name, property): post.push(PropertyAccess(mergeCalls([name])[0], mergeCalls([property])[0]));
                case PartArray(parts): post.push(PartArray(mergeCalls(parts)));
				case Custom(name, params): post.push(Custom(name, params.map(x -> mergeCalls([x])[0])));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    /**
        Merges a chain of single tokens separated by a `=` into a `Write([<sequence>], <end of sequence>)`
    **/
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
				case SetModule(module): {
					Parser.module = module;
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
                        Little.runtime.throwError(ErrorMessage("Missing value after the `=`"), Layer.PARSER);
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
                            case SplitLine | SetLine(_) | SetModule(_): break;
                            case _: currentAssignee.push(lookahead);
                        }
                        i++;
                    }
                    if (currentAssignee.length == 0) {
                        Little.runtime.throwError(ErrorMessage("Missing value after the last `=`"), Layer.PARSER);
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
                case ConditionCall(name, exp, body): {
                    if (potentialAssignee != null) post.push(potentialAssignee);
                    potentialAssignee = ConditionCall(mergeWrites([name])[0], mergeWrites([exp])[0], mergeWrites([body])[0]);
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
				case Custom(name, params): {
					if (potentialAssignee != null) post.push(potentialAssignee);
					potentialAssignee = Custom(name, params.map(x -> mergeWrites([x])[0]));
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

    /**
        Merges `<token>, TypeDeclaration(null, <type>)` into `TypeDeclaration(<token>, <type>)`
    **/
    public static function mergeValuesWithTypeDeclarations(pre:Array<ParserTokens>) :Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

		var post:Array<ParserTokens> = [];

        var i = pre.length - 1;
        while (i >= 0) {
            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.unshift(token);}
				case SetModule(module): {Parser.module = module; post.unshift(token);}
                case SplitLine: {nextPart(); post.unshift(token);}
                case TypeDeclaration(null, type): {
                    if (i-- <= 0) {
                        Little.runtime.throwError(ErrorMessage("Value's type declaration cut off by the start of file, block or expression."), Layer.PARSER);
                        return null;
                    }
                    var lookbehind = pre[i];
                    switch lookbehind {
                        case SplitLine | SetLine(_) | SetModule(_): {
                            Little.runtime.throwError(ErrorMessage("Value's type declaration access cut off by the start of a line, or by a line split (; or ,)."), Layer.PARSER);
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
                case ConditionCall(name, exp, body): post.unshift(ConditionCall(mergeValuesWithTypeDeclarations([name])[0], mergeValuesWithTypeDeclarations([exp])[0], mergeValuesWithTypeDeclarations([body])[0]));
                case Return(value, type): post.unshift(Return(mergeValuesWithTypeDeclarations([value])[0], mergeValuesWithTypeDeclarations([type])[0]));
                case PartArray(parts): post.unshift(PartArray(mergeValuesWithTypeDeclarations(parts)));
                case FunctionCall(name, params): post.unshift(FunctionCall(mergeValuesWithTypeDeclarations([name])[0], mergeValuesWithTypeDeclarations([params])[0]));
                case Write(assignees, value): post.unshift(Write(mergeValuesWithTypeDeclarations(assignees), mergeValuesWithTypeDeclarations([value])[0]));
                case PropertyAccess(name, property): post.unshift(PropertyAccess(mergeValuesWithTypeDeclarations([name])[0], mergeValuesWithTypeDeclarations([property])[0]));
				case Custom(name, params): post.unshift(Custom(name, params.map(x -> mergeValuesWithTypeDeclarations([x])[0])));
				case _: post.unshift(token);
            }
            i--;
        }

        resetLines();
        return post;
    }

    /**
        Merges tokens that expect a `Block` as it's last parameter with the next token, if that last parameter is `null`.  
        Comes into play with condition calls:
        ```
        if (<exp>) <exp>
        ```
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
				case SetModule(module): {Parser.module = module; post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
				case FunctionCall(name, params): {
					if (i + 1 >= pre.length) {
						post.push(FunctionCall(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([params])[0]));
						i++;
						continue;
					}
					var lookahead = pre[i + 1];
					switch lookahead {
						case SetLine(_) | SplitLine | SetModule(_): {
							post.push(FunctionCall(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([params])[0]));
						}
						case _: {
							post.push(ConditionCall(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([params])[0], Block(mergeNonBlockBodies([lookahead]), null)));
							i++; // We consumed the lookahead, so we need to increment to its position, so that the final i++ gets to the next, correct, token.
						}
					}
				}
                case Block(body, type): post.push(Block(mergeNonBlockBodies(body), mergeNonBlockBodies([type])[0]));
                case Expression(parts, type): post.push(Expression(mergeNonBlockBodies(parts), mergeNonBlockBodies([type])[0]));
                case Variable(name, type, doc): post.push(Variable(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([type])[0], mergeNonBlockBodies([doc])[0]));
                case Function(name, params, type, doc): post.push(Function(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([params])[0], mergeNonBlockBodies([type])[0], mergeNonBlockBodies([doc])[0]));
                case ConditionCall(name, exp, body): post.push(ConditionCall(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([exp])[0], mergeNonBlockBodies([body])[0]));
                case Return(value, type): post.push(Return(mergeNonBlockBodies([value])[0], mergeNonBlockBodies([type])[0]));
                case PartArray(parts): post.push(PartArray(mergeNonBlockBodies(parts)));
                case Write(assignees, value): post.push(Write(mergeNonBlockBodies(assignees), mergeNonBlockBodies([value])[0]));
                case PropertyAccess(name, property): post.push(PropertyAccess(mergeNonBlockBodies([name])[0], mergeNonBlockBodies([property])[0]));
				case Custom(name, params): post.push(Custom(name, params.map(x -> mergeNonBlockBodies([x])[0])));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    /**
        Macro that adds support for `if`-`else` patterns.
    **/
    public static function mergeElses(pre:Array<ParserTokens>):Array<ParserTokens> {

        if (pre == null) return null;
        if (pre.length == 1 && pre[0] == null) return [null];

        var post:Array<ParserTokens> = [];

        var i = 0;
        while (i < pre.length) {
            var token = pre[i];
            switch token {
                case SetLine(line): {setLine(line); post.push(token);}
				case SetModule(module): {Parser.module = module; post.push(token);}
                case SplitLine: {nextPart(); post.push(token);}
                case Identifier(_ == Little.keywords.CONDITION__ELSE => true): {
                    if (post.length == 0 || !post[post.length - 1].is(CONDITION_CALL)) {
                        post.push(token);
                        i++;
                        continue;
                    }
                    if (i + 1 >= pre.length) {
                        Little.runtime.throwError(ErrorMessage('Condition has no body, body may be cut off by the end of file, block or expression.'), PARSER);
                        return null;
                    }
                    var exp:ParserTokens = post[post.length - 1].parameter(1); //Condition(name:ParserTokens, ->exp:ParserTokens<-, body:ParserTokens, type:ParserTokens)
                    exp = Expression([exp, Sign("!="), TrueValue], null);
                    i++;
                    var body:ParserTokens = pre[i];
                    switch body {
                        case SplitLine: {
                            Little.runtime.throwError(ErrorMessage('`${Little.keywords.CONDITION__ELSE}` condition has no body, body cut off by a line split, or does not exist'), PARSER);
                            return null;
                        }
                        case SetLine(_) | SetModule(_): {
                            Little.runtime.throwError(ErrorMessage('`${Little.keywords.CONDITION__ELSE}` condition has no body, body cut off by a new line, or does not exist'), PARSER);
                            return null;
                        }
						case ConditionCall(Identifier("if"), exp2, body): post.push(ConditionCall(Identifier("if"), Expression([exp, Sign("&&"), exp2], null) , !body.is(BLOCK) ? Block([body], null) : body));
                        case _: post.push(ConditionCall(Identifier("if"), exp, !body.is(BLOCK) ? Block([body], null) : body));
                    }
                }
                case Block(body, type): post.push(Block(mergeElses(body), mergeElses([type])[0]));
                case Expression(parts, type): post.push(Expression(mergeElses(parts), mergeElses([type])[0]));
                case Variable(name, type, doc): post.push(Variable(mergeElses([name])[0], mergeElses([type])[0], mergeElses([doc])[0]));
                case Function(name, params, type, doc): post.push(Function(mergeElses([name])[0], mergeElses([params])[0], mergeElses([type])[0], mergeElses([doc])[0]));
                case ConditionCall(name, exp, body): post.push(ConditionCall(mergeElses([name])[0], mergeElses([exp])[0], mergeElses([body])[0]));
                case Return(value, type): post.push(Return(mergeElses([value])[0], mergeElses([type])[0]));
                case PartArray(parts): post.push(PartArray(mergeElses(parts)));
                case FunctionCall(name, params): post.push(FunctionCall(mergeElses([name])[0], mergeElses([params])[0]));
                case Write(assignees, value): post.push(Write(mergeElses(assignees), mergeElses([value])[0]));
                case PropertyAccess(name, property): post.push(PropertyAccess(mergeElses([name])[0], mergeElses([property])[0]));
				case Custom(name, params): post.push(Custom(name, params.map(x -> mergeElses([x])[0])));
                case _: post.push(token);
            }
            i++;
        }

        resetLines();
        return post;
    }

    







    static var line(get, set):Int;
    /** Parser.line getter **/ static function get_line() return Little.runtime.line;
    /** Parser.line setter **/ static function set_line(l:Int) return Little.runtime.line = l;
    static var module(get, set):String;
    /** Parser.module getter **/ static function get_module() return Little.runtime.module;
    /** Parser.module setter **/ static function set_module(l:String) return Little.runtime.module = l;
    static var linePart:Int = 0;
    
	/**
		Changes the current line. Used only for error reporting.
	**/
	static function setLine(l:Int) {
        line = l;
        linePart = 0;
    }
    /**
    	Changes the current line part. Used only for error reporting.
    **/
    static function nextPart() linePart++;

    /**
    	Resets the line counters, used between parse stages.
    **/
    static function resetLines() {
        line = 0;
        linePart = 0;
    }
}