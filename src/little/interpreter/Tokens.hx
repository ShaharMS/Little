package little.interpreter;

import little.interpreter.memory.MemoryPointer;

enum InterpTokens {
	
    SetLine(line:Int);
    SplitLine;

    /**
    	Usage:
		@param name `Identifier`, `PropertyAccess`
		@param type `Identifier`, `PropertyAccess`
		@param doc `Characters`
    **/
    VariableDeclaration(name:InterpTokens, type:InterpTokens, ?doc:InterpTokens);

	/**
		Usage:
		@param name `Identifier`, `PropertyAccess`
		@param params `PartArray([*, SplitLine, *])`, `PartArray([*, SetLine, *])`, `PartArray([*, SetLine, *, SplitLine, *])`, `PartArray([*])`, `PartArray([])` 
		@param type `Identifier`, `PropertyAccess`
		@param doc `Characters`
	**/
    FunctionDeclaration(name:InterpTokens, params:InterpTokens, type:InterpTokens, ?doc:InterpTokens);

	/**
		Usage:
		@param name `Identifier`, `PropertyAccess`
		@param conditionType `Identifier`, `PropertyAccess`
		@param doc `Characters`
	**/
	ConditionDeclaration(name:InterpTokens, conditionType:InterpTokens, ?doc:InterpTokens);
	
	/**
		Usage:
		@param name `Identifier`, `PropertyAccess`
		@param doc `Characters`
	**/
	ClassDeclaration(name:InterpTokens, ?doc:InterpTokens);

	/**
		`callers` is a map of `InterpTokens` configs representing the structure of the condition itself, in correlation to the conditions outcome. 
		Use haxe `null` to denote a wildcard - a free value decided by the user.  
		for example, Little's for loop would be:

			[
				[VariableDeclaration(null, null, null), Identifier("from"), null, Identifier("to"), null, Identifier("jump"), null] => ...,
				[VariableDeclaration(null, null, null), Identifier("from"), null, Identifier("to"), null] => ...
			]	

		Ideally, to validate the "`null`" tokens (the wildcard ones) one will use the macro-ish tools the language provide (extracting type, extracting identifiers...)

		**Important** - to define a "dynamic" condition (that accepts any number of parameters) you provide a `null` pattern key.

		The actual `Block` that decides how an if to run the code associated with the condition should expect two defined parameters of `InterpTokens.Characters`'s type,
		one named `Little.keywords.CONDITION_PATTERN_PARAMETER_NAME` and one named `Little.keywords.CONDITION_BODY_PARAMETER_NAME`.

		@param callers `Map<Array<InterpTokens.*>, InterpTokens.Block>`
	**/
	ConditionCode(callers:Map<Array<InterpTokens>, InterpTokens>);

    /**
		Usage:
		@param name `Identifier`, `PropertyAccess`
		@param exp `PartArray`
		@param body `Block`
    **/
    ConditionCall(name:InterpTokens, exp:InterpTokens, body:InterpTokens);

	/**
	    Usage:
		@param requiredParams `OrderedMap<String, InterpTokens.Identifier>`
		@param body `Block`
	**/
	FunctionCode(requiredParams:OrderedMap<String, InterpTokens>, body:InterpTokens);

	/**
		Usage:
		@param name `Identifier`, `PropertyAccess`
		@param params `PartArray([*, SplitLine, *])`, `PartArray([*, SetLine, *])`, `PartArray([*, SetLine, *, SplitLine, *])`, `PartArray([*])`, `PartArray([])`
	**/
	FunctionCall(name:InterpTokens, params:InterpTokens);    

	/**
		Usage:
		@param value `Identifier`, `PropertyAccess`
		@param type `Identifier`, `PropertyAccess`
	**/
	FunctionReturn(value:InterpTokens, type:InterpTokens);

	/**
		Usage:
		@param assignees `Array<InterpTokens.Identifier>`
		@param value `*`
	**/
    Write(assignees:Array<InterpTokens>, value:InterpTokens);

	/**
		Usage:
		@param value `*`
		@param type `Identifier`, `PropertyAccess`
	**/
    TypeCast(value:InterpTokens, type:InterpTokens);

	/**
		Usage:
		@param parts `Array<InterpTokens.*>`
		@param type `Identifier`, `PropertyAccess`
	**/
    Expression(parts:Array<InterpTokens>, type:InterpTokens);

    /**
		Usage:
		@param body `Array<InterpTokens.*>`
		@param type `Identifier`, `PropertyAccess`
    **/
    Block(body:Array<InterpTokens>, type:InterpTokens);

	/**
		Usage:
		@param parts `Array<InterpTokens.*>`
	**/
    PartArray(parts:Array<InterpTokens>);

	/**
		Usage:
		@param name `Identifier`, `PropertyAccess`
		@param property `Identifier`, `Number`, `Decimal`, `Characters`, `Sign`, `NullValue`, `TrueValue`, `FalseValue`
	**/
    PropertyAccess(name:InterpTokens, property:InterpTokens);

	/**Int32**/
    Number(num:Int);
	/**Float64**/
    Decimal(num:Float);
    /**String UTF8**/
    Characters(string:String);
	/**String UTF8**/
	Documentation(doc:String);
	/**32/64bit memory pointer**/
	ClassPointer(pointer:MemoryPointer);
	/**String UTF8**/
	Sign(sign:String);
	/**`null`**/
    NullValue;
	/**`true`**/
    TrueValue;
	/**`false`**/
    FalseValue;

	/**
		Usage:
		@param word `String`
	**/
	Identifier(word:String);

	/**

		- `toString` must be a `Block`, representing a function with 0 parameters returning a string.
		- `props`' elements may either be a `Object`, a `FunctionBody`, or a **statically storable** object.
		- `typeName` must be a `String`, containing a proper, accessible type.
			
	**/
	Object(toString:InterpTokens, props:Map<String, {documentation:String, value:InterpTokens}>, typeName:String);

	/**
	    - `name` must be a `String` representing the class' name
		- both field maps must have elements of types `Obj
	**/
	@:deprecated Class(name:String, instanceFields:Map<String, {documentation:String, type:String}>, staticFields:Map<String, {documentation:String, type:String}>);

    /**
    	Used for errors & warnings
    **/
    ErrorMessage(msg:String);

	/**
	    DO NOT USE. Necessary for very specific cases (extern function calls when params are required)
	**/
	HaxeExtern(func:Void -> InterpTokens);
}