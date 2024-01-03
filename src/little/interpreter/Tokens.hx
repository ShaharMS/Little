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
		@param name `Identifier`, `PropertyAccess`
		@param params `PartArray([*, SplitLine, *])`, `PartArray([*, SetLine, *])`, `PartArray([*, SetLine, *, SplitLine, *])`, `PartArray([*])`, `PartArray([])`
	**/
	FunctionCall(name:InterpTokens, params:InterpTokens);    

	/**
		Usage:
		@param name `Identifier`, `PropertyAccess`
		@param type `Identifier`, `PropertyAccess`
	**/
	FunctionReturn(value:InterpTokens, type:InterpTokens);

	/**
		Usage:
		@param name `Array<InterpTokens.Identifier>`
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

		- `baseValue` must be a `Block`, representing a function with 0 parameters returning a string.
		- `props`' elements may either be a `Object`, or a **statically storable** object.
			- `props`'s entries are unnamed, since they're retrieved using their type information only. Type is retrieved from `baseValue`
			- Order is **highly** relevant
	**/
	Object(toString:InterpTokens, props:Array<InterpTokens>);

    /**
    	Used for denoting an external var/func in the interpreter.
    **/
    External(get:Array<InterpTokens> -> InterpTokens);
    /**
    	Used for denoting external conditions in the interpreter
    **/
    ExternalCondition(use:(con:Array<InterpTokens>, body:Array<InterpTokens>) -> InterpTokens);

    /**
    	Used for errors & warnings
    **/
    ErrorMessage(msg:String);

}