package little.interpreter.memory;

import little.parser.Parser;
import little.tools.PrettyPrinter;
import little.tools.Layer;
import little.parser.Tokens.ParserTokens;

using little.tools.Extensions;

@:structInit
/**
	Represents a function/variable in memory. contains usage fields.
**/
class MemoryObject {

    @:optional public var parent:MemoryObject;

    @:optional public var value(default, set):ParserTokens = NullValue;

    function set_value(val:ParserTokens) {
        // Todo: fix body eval not working for function, possible solutions including:
            // Separate code checker for errors
            // Allow side-effect free code running
        if (parameters == null && val != NullValue) {
            var t = Interpreter.getValueType(val);
            val = Actions.type(val, valueType);
            if (typeOnNextAssign && !t.is(NULL_VALUE)) {
                switchType(t);
				typeOnNextAssign = false;
            }
        }

        value = valueSetter(val);
        for (setter in setterListeners.copy()) {
            setter(value);
        }
        return value;
    }

    @:optional public dynamic function valueSetter(val:ParserTokens) return val;

    /**
        Setter listeners can retrieve the new value right after its set, but they're unable to directly edit it.  
        Each element of this array needs to be a function, that takes in a ParserToken (the new value), and returns Void.
    **/
    @:optional public var setterListeners:Array<ParserTokens -> Void> = [];

    @:optional public var parameters(default, set):Array<ParserTokens> = null;
    @:optional public var valueType:ParserTokens = NullValue;
    @:optional public var isExternal:Bool = false;
    @:optional public var isCondition:Bool = false;

    /**
    	documentation for this variable/function/condition
    **/
	@:optional public var documentation:String;

    /**
    	When under a memory object, suppose, `T`, of type `"Type"`, it acts as a property of every object of type `Type`.
    **/
    @:optional public var isInstanceField:Bool = true;
	
	@:optional public var props:MemoryTree;

    function set_parameters(params:Array<ParserTokens>) {
        if (params == null) return parameters = null;
        return parameters = params.filter(p -> switch p {case SplitLine | SetLine(_): false; case _: true;});
    }

	/**
		When this object is started with no value, look for type in first assignation only.
	**/
	var typeOnNextAssign:Bool;

    public function new(?value:ParserTokens = NullValue, ?props:MemoryTree, ?params:Array<ParserTokens>, ?type:ParserTokens = NullValue, ?external:Bool, ?condition:Bool, ?nonStatic:Bool, ?parent:MemoryObject, ?doc:String) {
        if (this.value.equals(NullValue) && type.equals(NullValue)) typeOnNextAssign = true;
		
		this.value = value;
        this.parameters = params;
        this.valueType = (type.equals(NullValue) && !value.equals(NullValue)) ? Interpreter.getValueType(this.value) : type;
        this.isExternal = external == null ? false : external;
        this.isCondition = condition == null ? false : condition;
        this.isInstanceField = nonStatic == null ? true : nonStatic;
        this.props = new MemoryTree(this);
        this.parent = parent != null ? parent : this; //Interesting solution
		this.documentation = doc != null ? doc : "";
    }


    /**
        If `this` is a function, `use` calls it with the given parameters.  
        If its a condition, it executes the body 0 to n times, according to `parameters`.  
        if its a variable, it throws an error.  
        @param parameters an instance of `ParserTokens` of type `PartArray`. 
        @return The resulting value after usage of this `MemoryObject`.
    **/
    public function use(parameters:ParserTokens):ParserTokens {

        if (isCondition) {
            // trace("condition");
            if (value.is(EXTERNAL_CONDITION)) return ErrorMessage('Undefined external condition');
            if (!parameters.is(PART_ARRAY)) return ErrorMessage('Incorrect parameter group format, given group format: ${parameters.getName()}, expected Format: `PartArray`');
            // trace("checks passed");
            // trace(parameters.getParameters()[0][0]);
            var con = (parameters.getParameters()[0][0] : ParserTokens).getParameters()[0];
            var body = [(parameters.getParameters()[0][1] : ParserTokens)];

            if (parameters != null) { // Used to "strongly type" the condition
                var given:Array<ParserTokens> = [];
                if (con.length != 0) {
                    var currentParam:Array<ParserTokens> = [];
                    var _params:Array<ParserTokens> = con;
                    for (value in _params) {
                        switch value {
                            case SplitLine | SetLine(_): {
                                given.push(Expression(currentParam.copy(), null));
                                currentParam = [];
                            }
                            case _: currentParam.push(value);
                        }
                    }
                    if (currentParam.length != 0) given.push(Expression(currentParam.copy(), null));
                }
            
                if (given.length != this.parameters.length) return ErrorMessage('Incorrect number of expressions in condition, expected: ${this.parameters.length} (${PrettyPrinter.parseParamsString(this.parameters)}), given: ${given.length} (${PrettyPrinter.parseParamsString(given, false)})');
                
                con = given;
                // trace("now, eval");
                return switch value {
                    case ExternalCondition(use): return use(con, body);
                    case _: return ErrorMessage('Incorrect external condition value format, expected: ExternalCondition, given: ${value}');
                }

            } else {
                // trace("now, eval");
                return switch value {
                    case ExternalCondition(use): return use(con, body);
                    case _: return ErrorMessage('Incorrect external condition value format, expected: ExternalCondition, given: ${value}');
                }
            }
        }

        if (parameters == null) return ErrorMessage('Cannot call definition');
        if (!parameters.is(PART_ARRAY)) return ErrorMessage('Incorrect parameter group format, given group format: ${parameters.getName()}, expected Format: `PartArray`');


        var given:Array<ParserTokens> = [];
        if (parameters.getParameters()[0].length != 0) {
            var currentParam:Array<ParserTokens> = [];
            var _params:Array<ParserTokens> = parameters.getParameters()[0];
            for (value in _params) {
                switch value {
                    case SplitLine | SetLine(_): {
                        given.push(Expression(currentParam.copy(), null));
                        currentParam = [];
                    }
                    case _: currentParam.push(value);
                }
            }
            if (currentParam.length != 0) given.push(Expression(currentParam.copy(), null));
        }

        if (given.length != this.parameters.length) return ErrorMessage('Incorrect number of parameters, expected: ${this.parameters.length} (${PrettyPrinter.stringifyParserthis.parameters)}), given: ${given.length} (${PrettyPrinter.stringifyParsergiven)})');

        //given = [for (element in given) Interpreter.evaluate(element)];

        if (isExternal) {
            if (value.getName() != "External") return ErrorMessage('Undefined external function');
            return (value.getParameters()[0] : Array<ParserTokens> -> ParserTokens)(given);
        } else {
            var paramsDecl = [];
            for (i in 0...given.length) {
                paramsDecl.push(Write([this.parameters[i]], given[i]));
            }
            paramsDecl.push(SplitLine);

            var body = null;
            if (value.getName() == "Block") {
                body = value.getParameters()[0];
                body = paramsDecl.concat(body);

            } else {
                paramsDecl.push(value);
                body = paramsDecl;
            }
            return Actions.run(body);
        }
    }

	/**
		Copies this object
	**/
	public inline function copy() {
		var obj = new MemoryObject(
			this.value, 
			this.props, 
			this.parameters, 
			this.valueType, 
			this.isExternal, 
			this.isCondition, 
			this.isInstanceField, 
			this.parent, 
			this.documentation
		);
		obj.typeOnNextAssign = this.typeOnNextAssign;
		obj.setterListeners = this.setterListeners;
		obj.valueSetter = this.valueSetter;
		return obj;
	}
    
    /**
    	Get object property
    	@param propName property name as string
    **/
    public inline function get(propName:String) {
        return props.get(propName);       
    }

    /**
    	Set object property
    	@param propName property name as string
    	@param object a `MemoryObject`
    **/
    public inline function set(propName:String, object:MemoryObject) {
        return props.set(propName, object);       
    }

	/**
		Remove object property
		@param propName property name as string
	**/
	public inline function remove(propName:String) {
		return props.remove(propName);       
	}



    /**
        Returns the type of this object:
         - if `object.type` is `NullValue`, `Interpreter.getValueType()` is returned
         - if `object.type` is not `NullValue`, `object.type` is returned
    **/
    public inline function getType() {
        if (this.valueType != NullValue) return this.valueType;
        return Interpreter.getValueType(this.value);
    }
	

	/**
		Switches the type of this object, usually called at object creation/after the first value is assigned.

		If you wish, you can also call this function with a type of your own.
		
		@param type A new type for this object
		@param deleteOld Whether to delete old type-related properties
	**/
	public inline function switchType(type:ParserTokens, ?deleteOld:Bool = false) {
		var ot = type;
		if (!type.is(MODULE)) type = Actions.evaluate(type);
		if (!type.is(IDENTIFIER)) Runtime.throwError(ErrorMessage('Cannot use ${PrettyPrinter.stringifyParserot)} as type' + (type.is(CHARACTERS) ? '(For accessing a type using a ${Little.keywords.TYPE_STRING} instance, use ${Little.keywords.READ_FUNCTION_NAME}(${type}))' : '')));
	
		var typeObject = Interpreter.accessObject(type, @:privateAccess Actions.memory);

		if (deleteOld) {
			var oldTypeObject = Interpreter.accessObject(this.valueType, @:privateAccess Actions.memory);
			if (valueType.parameter(0) != Little.keywords.TYPE_DYNAMIC) {
				// Iterate instance fields, remove them from this object
				for (field => obj in oldTypeObject.props) {
					if (!obj.isInstanceField) continue;
					this.remove(field);
				}
			}
		}

		for (field => obj in typeObject.props) {
			if (!obj.isInstanceField) continue;
			var c = obj.copy();
			c.parent = this;
			this.set(field, c);
		}

		this.valueType = type;
	}

}