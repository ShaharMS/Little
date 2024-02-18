package little.interpreter.memory;

import haxe.Unserializer;
import haxe.Serializer;
import little.interpreter.Tokens.InterpTokens;

class ByteCode {
    public static function compile(...tokens:InterpTokens):String {
        return Serializer.run(tokens); // Simple, for now.
    }

    public static function decompile(bytecode:String):Array<InterpTokens> {
        return Unserializer.run(bytecode);
    }
}