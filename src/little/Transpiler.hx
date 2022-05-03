package little;

import little.transpiler.syntax.SyntaxFixer;
import little.transpiler.syntax.ClassRecognition;
import little.transpiler.syntax.WriteStyle;
import little.transpiler.syntax.FunctionRecognition;
import little.transpiler.syntax.VariableRecognition;

/**
 * The `Transpiler` class is some sort of a bridge between the transpiler
 * and the user. it contains the main `transpile` method, as well as some more 
 * useful things.
 */
class Transpiler {
    
    //TODO #2 Handle overloaded functions
    //TODO #3 Handle classes and static functions
    public static function transpile(code:String, ?options:TranspilerOptions):String {
        code = VariableRecognition.parse(code);
        code = FunctionRecognition.parse(code);
        code = ClassRecognition.parse(code);
        code = SyntaxFixer.removeTrailingNewlines(code);
        code = SyntaxFixer.addSemicolons(code);
        return code;
    }

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

}