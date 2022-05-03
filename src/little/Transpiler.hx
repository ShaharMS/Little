package little;

import haxe.Timer;
import little.transpiler.syntax.SyntaxFixer;
import little.transpiler.syntax.Classes;
import little.transpiler.syntax.WriteStyle;
import little.transpiler.syntax.Functions;
import little.transpiler.syntax.Variables;

/**
 * The `Transpiler` class is some sort of a bridge between the transpiler
 * and the user. it contains the main `transpile` method, as well as some more 
 * useful things.
 */
class Transpiler {
    
    //TODO #2 Handle overloaded functions
    //TODO #3 Handle classes and static functions

    /**
     * Takes some `Little` code and transpiles it over to haxe, to achive complete
     * cross-platforms capabilities.
     * @param code A string representatin of the code
     * @param options Some transpiler options to customize the output code
     * @return A string representation of the transpiled code
     */
    public static function transpile(code:String, ?options:TranspilerOptions):String {
        final st = Timer.stamp();
        code = Variables.parse(code);
        code = Classes.parse(code);
        code = SyntaxFixer.removeTrailingNewlines(code);
        code = SyntaxFixer.addSemicolons(code);
        wholeTranspileTime = Timer.stamp() - st;
        return code;
    }

    /**
     * The time it took to transpile everything from `Little` to `Haxe`
     */
    public static var wholeTranspileTime(default, null):Null<Float>;

    public static var transpileTimes:TranspileTimes;

}

@:structInit
class TranspilerOptions {
    /**Whether or not to ignore obvious errors at compile-time**/       public var ignoreErrors:Bool = false;
    /**Whether or not to ignore and delete classes**/                   public var ignoreWarnings:Bool = false;
    /**Whether or not to ignore visibility modifiers at runtime**/      public var ignoreVisibility:Bool = false;
    /**Whether or not to ignore external field definitions**/           public var ignoreExternals:Bool = false;
    /**Whether or not to keep comments in the generated source code**/  public var keepComments:Bool = false;
    /**Useful When `ignoreVisibility` is set to true, this will be set
     * as the prefix to every variable and function**/                  public var prefixFieldsWith:String = "";
    /**Removes condensable whitespaces**/                               public var condense:Bool = false;
    /**Removes all condensable characters, shortens variable names**/   public var minify:Bool = false;
    /**When defined, writes the resulting code to the defined path**/   public var codePath:String = "";
    /**Decides in what way a function is written**/                     public var functionWriteStyle:WriteStyle = SAME_LEVEL;
    /**Decides in what way a function is written**/                     public var classWriteStyle:WriteStyle = SAME_LEVEL;
    /**Whether or not to generate a Main class**/                       public var generateMainClass:Bool = true;
}

typedef TranspileTimes = {
    //desugering
    inlines:Float,
    loopUnrolls:Float,
    deadCodeElimination:Float,
    desugering:Float,
    //syntax
    classes:Float,
    functions:Float,
    variables:Float,
    syntax:Float,
}