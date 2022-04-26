package interpreter.features;

using texter.general.TextTools;
import interpreter.types.basic.DecimalVar;
import interpreter.types.basic.NumberVar;

/**
 * Responsible for all basic math operations - addition, subtraction, multiplication and division.
 */
class BasicMath {
    /**
     * Combines two numbers, while retaining the memory of the first number.
     * @param a The first number.
     * @param b The second number.
     * @return the sum of the two numbers, with `a`'s name
     */
    public overload extern inline static function add(a:NumberVar, b:NumberVar) return new NumberVar(a.intValue + b.intValue, a.name);
    public overload extern inline static function add(a:NumberVar, b:DecimalVar) return new DecimalVar(a.intValue + b.floatValue, a.name);
    public overload extern inline static function add(a:DecimalVar, b:NumberVar) return new DecimalVar(a.floatValue + b.intValue, a.name);
    public overload extern inline static function add(a:DecimalVar, b:DecimalVar) return new DecimalVar(a.floatValue + b.floatValue, a.name);

    /**
     * Subtracts two numbers, while retaining the memory of the first number.
     * @param a The first number.
     * @param b The second number.
     * @return the difference of the two numbers, with `a`'s name
     */
    public overload extern inline static function subtract(a:NumberVar, b:NumberVar) return new NumberVar(a.intValue - b.intValue, a.name);
    public overload extern inline static function subtract(a:NumberVar, b:DecimalVar) return new DecimalVar(a.intValue - b.floatValue, a.name);
    public overload extern inline static function subtract(a:DecimalVar, b:NumberVar) return new DecimalVar(a.floatValue - b.intValue, a.name);
    public overload extern inline static function subtract(a:DecimalVar, b:DecimalVar) return new DecimalVar(a.floatValue - b.floatValue, a.name);

    /**
     * Multiplies two numbers, while retaining the memory of the first number.
     * @param a The first number.
     * @param b The second number.
     * @return the product of the two numbers, with `a`'s name
     */
    public overload extern inline static function multiply(a:NumberVar, b:NumberVar) return new NumberVar(a.intValue * b.intValue, a.name);
    public overload extern inline static function multiply(a:NumberVar, b:DecimalVar) return new DecimalVar(a.intValue * b.floatValue, a.name);
    public overload extern inline static function multiply(a:DecimalVar, b:NumberVar) return new DecimalVar(a.floatValue * b.intValue, a.name);
    public overload extern inline static function multiply(a:DecimalVar, b:DecimalVar) return new DecimalVar(a.floatValue * b.floatValue, a.name);

    /**
     * Divides two numbers, while retaining the memory of the first number.
     * @param a The first number.
     * @param b The second number.
     * @return the quotient of the two numbers, with `a`'s name
     */
    public overload extern inline static function divide(a:NumberVar, b:NumberVar) return new DecimalVar(a.intValue / b.intValue, a.name);
    public overload extern inline static function divide(a:NumberVar, b:DecimalVar) return new DecimalVar(a.intValue / b.floatValue, a.name);
    public overload extern inline static function divide(a:DecimalVar, b:NumberVar) return new DecimalVar(a.floatValue / b.intValue, a.name);
    public overload extern inline static function divide(a:DecimalVar, b:DecimalVar) return new DecimalVar(a.floatValue / b.floatValue, a.name);

    public static function condense(equLine:String):String {
        return equLine;
    }
}
