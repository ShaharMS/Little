package little.tools;

import little.Little.*;

class Plugins {
    
    public static function registerHaxeClass(cls:Class<Dynamic>) {
        var moduleName = Type.getClassName(cls);
        var functions = Type.getClassFields(cls);
        for (func in functions) {
            // if (Reflect.isFunction(Type.))
        }
    }

}