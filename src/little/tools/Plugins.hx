package little.tools;

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
		var fieldValues = new Map<String, Dynamic>();

		if (stats.length == 0) {
			return;
		}

		// Iterate over the fields of the Math class
		for (field in Reflect.fields(stats[0].className)) {
			try {
				// Attempt to get the field value without an instance object
				var value = Reflect.field(stats[0].className, field);

				// If the value is not null, the field is a static field
				if (value != null) {
					// Store the field value in the fieldValues map
					fieldValues.set(field, value);
				}
			} catch (error:Dynamic) {
				// Ignore errors caused by attempting to get instance fields
			}
		}

		var motherObj = new MemoryObject(Module(stats[0].className), [], null, Identifier(TYPE_MODULE), true); 

		for (instance in stats) {
			trace(instance.fieldType, instance.allowWrite, instance.name, instance.parameters, instance.returnType);
			switch (instance.fieldType) {
				case "var":
					{
						var value:ParserTokens = Conversion.toLittleValue(fieldValues[instance.name]);
						var type:ParserTokens = Identifier(Conversion.toLittleType(instance.returnType));
						motherObj.props[instance.name] = new MemoryObject(value, [] /*Should this be implemented?*/, null, type, true);
					}
				case "function": {
					var value:ParserTokens = Conversion.toLittleValue(fieldValues[instance.name]);
					var type:ParserTokens = Identifier(Conversion.toLittleType(instance.returnType));
					motherObj.props[instance.name] = new MemoryObject(value, [] /*Should this be implemented?*/, null, type, true);
				}
			}
		}
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
