package interpreter.features;

import interpreter.constraints.Variable;


/**
 * Takes care of variable assignments (x = y)
 */
class Assignment {
    
    public static function assign(parent:Variable, value:Dynamic) {
        if (parent.type.getName() != "Other") {
            parent.basicValue = value;
        } else {
            parent.valueTree = value;
        }
    }

}