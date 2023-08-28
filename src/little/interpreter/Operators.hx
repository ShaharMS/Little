package little.interpreter;

import haxe.extern.EitherType;
import little.parser.Tokens.ParserTokens;


class Operators {
    
    /**
        Operators that require two sides to work, for example:
        | Operator | Code |
        | :---: | :---: |
        | Add | `5 + 5` |
        | Subtract | `5 - 5` |
        | Exponentiation | `5^2` |
        | "Non-Standard" Square Root  | `3√5` |
    **/
    public static var standard:Map<String, (lhs:ParserTokens, rhs:ParserTokens) -> ParserTokens> = new Map();

    /**
        Operators that require just the right side of the equations, for example:
        | Operator | Code |
        | :---: | :---: |
        | Negate | `-5` |
        | Increment | `++5` |
        | Decrement | `--5` |
        | "Standard" Square Root  | `√5` |
    **/
    public static var rhsOnly:Map<String, (ParserTokens) -> ParserTokens> = new Map();

    /**
        Operators that require just the left side of the equations, for example:
        | Operator | Code |
        | :---: | :---: |
        | Post Increment | `5++` |
        | Post Decrement | `5--` |
        | Factorial | `5!` |
    **/
    public static var lhsOnly:Map<String, (ParserTokens) -> ParserTokens> = new Map();

    public static function add(op:String, operatorType:OperatorType, callback:EitherType<(ParserTokens) -> ParserTokens, (ParserTokens, ParserTokens) -> ParserTokens>) {
        // TODO
    }
}

enum OperatorType {
    LHS_RHS;
    LHS_ONLY;
    RHS_ONLY;
}