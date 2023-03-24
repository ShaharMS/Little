package little.tools;

import little.interpreter.Interpreter;
import little.parser.Tokens.ParserTokens;
import little.interpreter.MemoryObject;
import little.Little.*;
import little.Keywords.*;

class Plugins {
	/**
		Registers an entire Haxe class's static fields & methods, to allow accessing them through Little. for example:

		doing:  

			Little.plugin.registerHaxeClass(Data.getClassInfo("Math"));

		Will let you access all of Math's static fields & methods through little:
		```py
		print(Math.sqrt(4) + Math.max(2, {define i = 3, i}))
		```

		@param cls Data about the class, obtained by using `Data.getClassInfo("YourClassName")`
			
	**/
	public static function registerHaxeClass(stats:Array<ItemInfo>) {

		if (stats.length == 0) {
			return;
		}

		var fieldValues = new Map<String, Dynamic>();
		var fieldFunctions = new Map<String, Dynamic>();
		var cls = Type.resolveClass(stats[0].className);
		//trace(cls);
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

		//// Test the maps by printing the values of Math.PI and Math.sqrt()
		//trace(fieldValues.get("PI")); // Output: 3.141592653589793
		//trace(fieldFunctions.get("sqrt")(9)); // Output: 3

		var motherObj = new MemoryObject(Module(stats[0].className), [], null, Identifier(TYPE_MODULE), true); 

		for (instance in stats) {
			//trace(instance.fieldType, instance.allowWrite, instance.name, instance.parameters, instance.returnType);
			switch (instance.fieldType) {
				case "var":
					{
						var value:ParserTokens = Conversion.toLittleValue(fieldValues[instance.name]);
						var type:ParserTokens = Identifier(Conversion.toLittleType(instance.returnType));
						motherObj.props[instance.name] = new MemoryObject(value, [] /*Should this be implemented?*/, null, type, true);
					}
				case "function": {
					var value:ParserTokens = External((args) -> {
						return Conversion.toLittleValue(Reflect.callMethod(null, fieldFunctions[instance.name], [for (arg in args) Conversion.toHaxeValue(arg)]));
					});
					var type:ParserTokens = Identifier(Conversion.toLittleType(instance.returnType));
					var params = [];
					for (param in instance.parameters) 
						params.push(Define(Identifier(param.name), Identifier(param.type)));

					motherObj.props[instance.name] = new MemoryObject(value, [] /*Should this be implemented?*/, params, type, true);
				}
			}
		}

		Interpreter.memory[stats[0].className] = motherObj;
	}
}

typedef ItemInfo = {
	className:String,
	name:String,
	parameters:Array<{name:String, type:String, optional:Bool}>,
	returnType:String,
	fieldType:String,
	allowWrite:Bool
} 
