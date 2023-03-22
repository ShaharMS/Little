package little.tools;

import little.Little.*;

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
	public static function registerHaxeClass(stats:Array<{name:String, parameters:Array<{name:String, type:String, optional:Bool}>, returnType:String}>) {
		for (instance in stats) {
			trace(instance.name, instance.parameters, instance.returnType);
		}
	}
}