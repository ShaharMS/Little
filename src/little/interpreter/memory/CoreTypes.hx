package little.interpreter.memory;

import haxe.Json;
import little.interpreter.memory.ExternalInterfacing.ExtTree;
import little.interpreter.Tokens.InterpTokens;
using little.tools.Extensions;

class CoreTypes {
    public static function addFor(externs:ExternalInterfacing) {
        // STRING is defined first, depending only on INT
        externs.createPathFor(externs.instanceProperties, Little.keywords.TYPE_STRING);
        // We need to provide a pointer, but the value is not used, so we take as 
        // little (he he) as we can, which is a byte
        externs.typeToPointer[Little.keywords.TYPE_STRING] = externs.parent.storage.storeByte(1);
        // STRING properties:
        externs.instanceProperties.properties[Little.keywords.TYPE_STRING].properties = [
            "length" => new ExtTree((value, _) -> {
                var length = value.parameter(0).length;
                return { objectValue: Number(length), objectAddress: externs.parent.storage.storeInt32(length), objectDoc: "the length of the string" }
            })
        ];
        externs.instanceProperties.properties[Little.keywords.TYPE_STRING].properties = [
            
        ];

        // Then, the FUNCTION type is defined, as it relies on STRING

        externs.createPathFor(externs.instanceProperties, Little.keywords.TYPE_FUNCTION);

        externs.typeToPointer[Little.keywords.TYPE_FUNCTION] = externs.parent.storage.storeByte(1);

        externs.instanceProperties.properties[Little.keywords.TYPE_FUNCTION].properties = [
            "token" => new ExtTree((value, _) -> {
                return { objectValue: Characters(Std.string(value)), objectAddress: externs.parent.storage.storeString(Std.string(value)), objectDoc: "the token of the function, as a String" }
            })
        ];


		// With FUNCTION, we also need CONDITION

		externs.createPathFor(externs.instanceProperties, Little.keywords.TYPE_CONDITION);

		externs.typeToPointer[Little.keywords.TYPE_CONDITION] = externs.parent.storage.storeByte(1);

		externs.instanceProperties.properties[Little.keywords.TYPE_CONDITION].properties = [
			"token" => new ExtTree((value, _) -> {
				return { objectValue: Characters(Std.string(value)), objectAddress: externs.parent.storage.storeString(Std.string(value)), objectDoc: "the token of the condition, as a String" }
			})
		];
    }
}