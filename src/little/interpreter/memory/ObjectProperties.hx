package little.interpreter.memory;

import little.parser.Tokens.ParserTokens;
import little.Keywords.*;

class ObjectPropertiesBase {
    public var map:Map<String, MemoryObject>;
    public var objType:String;
    public var obj:MemoryObject;

    public function new(t:String, m:MemoryObject) {
        objType = t;
        obj = m;
    }
}

abstract ObjectProperties(ObjectPropertiesBase) {

    @:op([]) public function getProperty(name:String):MemoryObject {
        if (this.map.exists(name)) return this.map[name];
        else {
            if (!Interpreter.memory.exists(this.objType)) {
                Runtime.throwError(ErrorMessage('Type ${this.objType} does not exist.'));
                return null;
            }
            if (!Interpreter.memory[this.objType].props.exists(name)) return null; // Throws non existent prop on Interpreter.accessObject().
            
            var field = Interpreter.memory[this.objType].props[name];
            if (!field.nonStatic) {
                Runtime.throwError(ErrorMessage('Property $name belongs to the actual type ${this.objType}, not to an object of type (${this.objType}). Try using ${this.objType}$PROPERTY_ACCESS_SIGN$name instead.'));
                return null;
            }
            if (((field.params[1].getParameters()[0] : ParserTokens).getParameters()[0] : String).charAt(5) == " ") { // nonstatic variable
                var value = field.use(this.obj.value);
                return Interpreter.createObject(field.use(this.obj.value));
            } else { // nonstatic function, here we start maneuvering...
                var value = External(params -> {
                    return field.use(PartArray([this.obj.value].concat(params)));
                });
                return new MemoryObject(value, null, {var copy = field.params.copy(); copy.shift(); copy;}, null, true, false, false);
            }
        }

        return null;
    }
}