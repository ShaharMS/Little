package language.features;

/**
 * The memory class contains all in-memory references defined by the user.
 */
class MemoryTree {
    
    public static var tree:Map<String, Dynamic> = [

    ];

    public static function pushKey(name:String, value:Dynamic) {
        if (name == null) return;
        tree.set(name, value);
    }

    public static function removeKey(name:String) {
        tree.remove(name);
    }

    public static function toString():String {
        var str:String = "";
        for (key => value in tree) {
            str += key + ": " + value + "\n";
        }
        return str;
    }
}
