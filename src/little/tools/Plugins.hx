package little.tools;

import little.Little.*;

class Plugins {
	public static function registerHaxeClass(cls:Class<Dynamic>) {
		var moduleName = Type.getClassName(cls);
		var fieldValues = new Map<String, Dynamic>();
		var fieldFunctions = new Map<String, Dynamic>();

		// Iterate over the fields of the Math class
		for (field in Reflect.fields(cls)) {
			// Check if the field is a static field
			// Get the field value and store it in the fieldValues map
			var value = Reflect.field(cls, field);
			// Check if the field is a function (i.e., a method)
			if (Reflect.isFunction(value)) {
				// Store the function in the fieldFunctions map
				fieldFunctions.set(field, value);
			} else {
				fieldValues.set(field, value);
			}
		}
	}
}