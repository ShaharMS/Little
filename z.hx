Little.plugin.registerVariable(
	"currentTime", "Characters", () -> {
		return Conversion.toLittleValue(
			Date.now().toString()
	  	); 	// Or alternatively, the token:
			// Characters(Date.now().toString())
	} 
);
  


Little.loadModule("
	define attachedToProgram = true
	define parentProgram = “My Program”
	action mySemiExtern() = {
	  print(“Hello World”)
	}
	", "Externs"
);
  

UnitTests.run(true);