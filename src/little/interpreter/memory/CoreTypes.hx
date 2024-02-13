package little.interpreter.memory;

import little.interpreter.memory.ExternalInterfacing.VarExtTree;
import little.interpreter.Tokens.InterpTokens;
using little.tools.Extensions;

class CoreTypes {
    public static function addFor(externs:ExternalInterfacing) {
        
        // STRING is defined first, depending only on INT
        externs.createPathFor(externs.instanceProperties, Little.keywords.TYPE_STRING);
        externs.createPathFor(externs.instanceMethods, Little.keywords.TYPE_STRING);
        // We need to provide a pointer, but the value is not used, so we take as 
        // little (he he) as we can, which is a byte
        trace(externs.parent.reserved.getBytes(0, 15).toArray());
        externs.typeToPointer[Little.keywords.TYPE_STRING] = externs.parent.heap.storeByte(1);
        trace(externs.typeToPointer[Little.keywords.TYPE_STRING]);
        // STRING properties:
        externs.instanceProperties.properties[Little.keywords.TYPE_STRING].properties = [
            "length" => new VarExtTree((value, _) -> {
                var length = value.parameter(0).length;
                return { objectValue: Number(length), objectAddress: externs.parent.heap.storeInt32(length), objectDoc: "the length of the string" }
            })
        ];
        externs.instanceProperties.properties[Little.keywords.TYPE_STRING].properties = [
            
        ];

        // Then, the FUNCTION type is defined, as it relies on STRING

        externs.createPathFor(externs.instanceProperties, Little.keywords.TYPE_FUNCTION);
        externs.createPathFor(externs.instanceMethods, Little.keywords.TYPE_FUNCTION);

        externs.typeToPointer[Little.keywords.TYPE_FUNCTION] = externs.parent.heap.storeByte(1);

        externs.instanceProperties.properties[Little.keywords.TYPE_FUNCTION].properties = [
            "token" => new VarExtTree((value, _) -> {
                return { objectValue: Characters(Std.string(value)), objectAddress: externs.parent.heap.storeString(Std.string(value)), objectDoc: "the token of the function, as a String" }
            })
        ];


		// With FUNCTION, we also need CONDITION

		externs.createPathFor(externs.instanceProperties, Little.keywords.TYPE_CONDITION);
		externs.createPathFor(externs.instanceMethods, Little.keywords.TYPE_CONDITION);

		externs.typeToPointer[Little.keywords.TYPE_CONDITION] = externs.parent.heap.storeByte(1);

		externs.instanceProperties.properties[Little.keywords.TYPE_CONDITION].properties = [
			"token" => new VarExtTree((value, _) -> {
				return { objectValue: Characters(Std.string(value)), objectAddress: externs.parent.heap.storeString(Std.string(value)), objectDoc: "the token of the condition, as a String" }
			})
		];
    }
}