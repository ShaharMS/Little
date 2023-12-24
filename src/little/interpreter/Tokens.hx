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
		@param exp `PartArray`
		@param body `Block`
    **/
    Condition(name:InterpTokens, exp:InterpTokens, body:InterpTokens);

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

		- `baseValue` must be of type `Value`
		- `props`' elements may either be a `Structure`, or a **statically storable** object.
			- `props`'s entries are unnamed, since they're retrieved using their type information only. Type is retrieved from `baseValue`
			- Order is **highly** relevant

		If `baseValue.value` is `FunctionCaller`, this `Object` is a function.
		If `baseValue.value` is `ClassFields`, this `Object` is a type.
		If `baseValue.value` is `ConditionEvaluator`, this `Object` is a condition.
		If `baseValue.value` is `NullValue`, this `Object` is a normal structure. 
	**/
	Structure(baseValue:InterpTokens, props:Array<InterpTokens>);

	/**
		Usage:
		@param value `FunctionCaller`, `ClassFields`, `ConditionEvaluator`, `*`
		@param type `Identifier`, `PropertyAccess`
		@param doc `String`, `null`
	**/
	Value(value:InterpTokens, type:InterpTokens, ?doc:InterpTokens);
	
	/**
		Usage:
		@param params `PartArray([*, SplitLine, *])`, `PartArray([*, SetLine, *])`, `PartArray([*, SetLine, *, SplitLine, *])`, `PartArray([*])`, `PartArray([])`
		@param body `Block(*, type)`
		@param type `Identifier`, `PropertyAccess`
	**/
	FunctionCaller(params:InterpTokens, body:InterpTokens);

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

	//------------------------------------------------------------------
	// Unimplemented
	//------------------------------------------------------------------

	ConditionDeclaration(name:InterpTokens, type:InterpTokens, ?doc:String);
	/**
		`caller` should be of type `Block`. When it is run, Two values should be pre-attached:

		 - A variable named `conditionFieldName`, for the original conditon expression
		 - A variable named `bodyFieldName`, for the body of the condition. Should be able to attach usable variables via Actions.runWith, or an externally registered runWith function
	**/
	ConditionEvaluator(conditionFieldName:String, bodyFieldName:String, caller:InterpTokens);
	/**
		This should only be used as the "value" of a class.

		`superClass` has to be of type ~`Read`~.
		both `staticFields` and `instanceFields` must be of type an array containing `InterpToken.VariableDeclaration`s
	**/
	ClassFields(staticFields:Array<InterpTokens>, instanceFields:Array<InterpTokens>, ?superClass:InterpTokens);

}