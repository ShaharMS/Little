package language.constraints;

enum Types {
    /**
     * Represents a haxe floating point number.
     */
    DECIMAL_NUMBER;

    /**
     * Represents a haxe integer number.
     */
    NUMBER;

    /**
     * Represent an array of immutable characters
     */
    STRING;

    /**
     * The regular true/false boolean type. will be represented as `yes`/`no` for simplicity
     */
    BOOLEAN;

    /**
     * The standart player type.
     */
    CHILD;

    /**
     * The standart level goal
     */
    STAR;
}