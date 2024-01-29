package little.interpreter;

import little.interpreter.memory.MemoryPointer;

enum InterpTokens {
	
    SetLine(line:Int);
    SplitLine;

    /**
    	Usage:
		@param name `Identifier`, `PropertyAccess`
		@param type `Identifier`, `PropertyAccess`
		@param doc `String`, `null`
    **/
    VariableDeclaration(name:InterpTokens, type:InterpTokens, ?doc:String);

	/**
		Usage:
		@param name `Identifier`, `PropertyAccess`
		@param params `PartArray([*, SplitLine, *])`, `PartArray([*, SetLine, *])`, `PartArray([*, SetLine, *, SplitLine, *])`, `PartArray([*])`, `PartArray([])` 
		@param type `Identifier`, `PropertyAccess`
		@param doc `String`, `null`
	**/
    FunctionDeclaration(name:InterpTokens, params:InterpTokens, type:InterpTokens, ?doc:String);

	/**
		Usage:
		@param name `Identifier`, `PropertyAccess`
		@param conditionType `Identifier`, `PropertyAccess`
		@param doc `String`, `null`
	**/
	ConditionDeclaration(name:InterpTokens, conditionType:InterpTokens, ?doc:String);
	
	/**
		Usage:
		@param name `Identifier`, `PropertyAccess`
		@param doc `String`, `null`
	**/
	ClassDeclaration(name:InterpTokens, ?doc:String);

    /**
		Usage:
		@param name `Identifier`, `PropertyAccess`
		@param exp `PartArray`
		@param body `Block`
    **/
    ConditionCall(name:InterpTokens, exp:InterpTokens, body:InterpTokens);

	/**
	    Usage:
		@param requiredParams `Map<String, InterpTokens.Identifier>`
		@param body `Block`
	**/
	FunctionCode(requiredParams:Map<String, InterpTokens>, body:InterpTokens);

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
	Sign(sign:String);
	/**`null`**/
    NullValue;
	/**Void**/
	VoidValue;
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
	Object(toString:InterpTokens, props:Map<String, InterpTokens>, typeName:String);

	/**
	    - `name` must be a `String` representing the class' name
		- both field maps must have elements of types `Obj
	**/
	Class(name:String, instanceFields:Map<String, {documentation:String, type:String}>, staticFields:Map<String, {documentation:String, type:String}>);

    /**
    	Used for errors & warnings
    **/
    ErrorMessage(msg:String);

}