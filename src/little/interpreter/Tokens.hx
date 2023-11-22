package little.interpreter;

enum InterpTokens {
	
    SetLine(line:Int);
    SplitLine;

    VariableDeclaration(name:InterpTokens, type:InterpTokens, ?doc:String);
    FunctionDeclaration(name:InterpTokens, params:InterpTokens, type:InterpTokens, ?doc:String);

    Condition(name:InterpTokens, exp:InterpTokens, body:InterpTokens);

    Read(name:InterpTokens);
	FunctionCall(name:InterpTokens, params:InterpTokens);    
	FunctionReturn(value:InterpTokens, type:InterpTokens);

    Write(assignees:Array<InterpTokens>, value:InterpTokens);


    TypeCast(value:InterpTokens, type:InterpTokens);

    Expression(parts:Array<InterpTokens>, type:InterpTokens);
    Block(body:Array<InterpTokens>, type:InterpTokens);
    PartArray(parts:Array<InterpTokens>);

    PropertyAccess(name:InterpTokens, property:InterpTokens);

    Number(num:Int);
    Decimal(num:Float);
    Characters(string:String);
	Sign(sign:String);
    NullValue;
    TrueValue;
    FalseValue;

	Identifier(word:String);

	/**
		If `value` is `Block`, this `Object` is a function.
		If `value` is `ClassFields`, this `Object` is a type.
		If `value` is `ConditionEvaluator`, this `Object` is a condition.
		in any other case, this `Object` is a normal value. 
	**/
	Object(value:InterpTokens, type:InterpTokens, props:Map<String, InterpTokens>, ?doc:InterpTokens);
	
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

		`superClass` has to be of type `Read`.
	**/
	ClassFields(staticFields:Map<String, InterpTokens>, instanceFields:Map<String, InterpTokens>, ?superClass:InterpTokens);

}