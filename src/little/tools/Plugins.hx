package little.tools;

import little.interpreter.memory.MemoryPointer;
import little.interpreter.memory.ExternalInterfacing.ExtTree;
import little.interpreter.memory.Memory;
import little.interpreter.Actions;
import little.interpreter.Operators;
import haxe.exceptions.ArgumentException;
import little.interpreter.Operators.OperatorType;
import little.interpreter.Runtime;
import haxe.extern.EitherType;
import little.lexer.Lexer;
import little.parser.Parser;
import little.interpreter.Interpreter;
import little.interpreter.Tokens.InterpTokens;
import little.Little.*;
import little.Keywords.*;

using little.tools.Plugins;
using little.tools.Extensions;
@:access(little.Little)
@:access(little.interpreter.Runtime)
class Plugins {

    private var memory:Memory;

    public function new(memory:Memory) {
        this.memory = memory;
    }

    /**
        registers a haxe value/property inside Little code.

        @param variableName the name of the variable, for usage in Little code. If you want it nested in some kind of path, use `.` (e.g. `mother.varName`)
        @param documentation documentation for this variable.
        @param staticValue **Option 1** - a static value to assign to this variable
        @param valueGetter **Option 2** - a function that returns a value that this variable gives when accessed.
    **/
    public function registerVariable(variableName:String, ?documentation:String, ?staticValue:InterpTokens, ?valueGetter:Void -> InterpTokens) {
        var varPath = variableName.split(".");
        var object = memory.externs.createPathFor(memory.externs.globalProperties, ...varPath);
        object.getter = (_, _) -> {
            return try {
                var value = staticValue == null ? valueGetter() : staticValue;
                {
                    objectValue: value,
                    objectAddress: memory.store(value),
                    objectDoc: documentation ?? ""
                }
            } catch (e) {
                {
                    objectValue: ErrorMessage('External Variable Error: ' + e.details()),
                    objectAddress: memory.constants.ERROR,
                    objectDoc: ""
                }
            }
        }
    }

    /**
    	Allows usage of a function written in haxe inside Little code.

    	@param actionName The name by which to identify the function. If you want this nested in some kind of path, use `.` (e.g. `mother.funcName`)
    	@param documentation documentation for this function.
    	@param expectedParameters an `Array<InterpTokens>` consisting of `InterpTokens.Variable`s which contain the names & types of the parameters that should be passed on to the function. For example:
            ```
            [VariableDeclaration(Identifier(x), Identifier("Characters"))]
            ```
            **alternatively** - can be normal parameter "list" written in little: 
            ``` 
            define x as Characters, define index = 3, define y
            ```
            **Important** - if variables appear in the end and have assigned values, they are optional.
    	@param callback The actual function, which gets an array of the given parameters as reduced little tokens (basic types and `Object`), and returns a value based on them
		@param returnType The type of the returned value. This exists due to implementation limitations. You can use the `Conversion` class to know which types to put here.
    **/
    public function registerFunction(functionName:String, ?documentation:String, expectedParameters:EitherType<String, Array<InterpTokens>>, callback:Array<InterpTokens> -> InterpTokens, returnType:String) {
        var params = if (expectedParameters is String) {
            Interpreter.convert(...Parser.parse(Lexer.lex(expectedParameters)));
        } else (expectedParameters : Array<InterpTokens>);

        var functionPath = functionName.split(".");
        
        var paramMap = new OrderedMap<String, InterpTokens>();
		for (entry in params) {
			if (entry.is(SPLIT_LINE, SET_LINE)) continue;
			switch entry {
				case VariableDeclaration(name, null, _): paramMap[name.extractIdentifier()] = TypeCast(NullValue, Identifier(Little.keywords.TYPE_DYNAMIC));
				case VariableDeclaration(name, type, _): paramMap[name.extractIdentifier()] = TypeCast(NullValue, type);
				case Write(assignees, value): {
					switch assignees[0] {
						case VariableDeclaration(name, null, _): paramMap[name.extractIdentifier()] = TypeCast(value, Identifier(Little.keywords.TYPE_DYNAMIC));
						case VariableDeclaration(name, type, _): paramMap[name.extractIdentifier()] = TypeCast(value, type);
						default:
					}
				}
				default:
			}
		}

		var returnTypeToken = Interpreter.convert(...Parser.parse(Lexer.lex(returnType)))[0]; // May be a PropertyAccess or an Identifier
        var token:InterpTokens = FunctionCode(paramMap, Block([
            FunctionReturn(HaxeExtern(() -> callback(paramMap.keys().toArray().map(key -> Actions.evaluate(memory.read(key).objectValue)))), returnTypeToken)
        ], returnTypeToken));
        
        var object = memory.externs.createPathFor(memory.externs.globalProperties, ...functionPath);

        object.getter = (_, _) -> {
			objectValue: token,
			objectAddress: memory.constants.EXTERN,
			objectDoc: documentation ?? ""
        }
    }

    /**
		Adds a condition to be used in Little.

		Conditions are can be described as a special function, that decides how many time another given function is run, and with which parameters.
		Their syntax:

			<condition_name> (<params>) {
				<body>
			}
		
		@param conditionName The name by which to identify the condition. If you want this nested in some kind of path, use `.` (e.g. `mother.conditionName`)
		@param documentation documentation for this condition.
		@param callback The actual function, which gets an array of the given parameters, exactly as given (which means they might require further evaluation), 
			and another array representing the block of code right after the condition, and return an outcome token of the condition. 
			The outcome is usually expected to be the last value in the last iteration of the condition (for example, the same as haxe `if` statements)
    **/
    public function registerCondition(conditionName:String, ?documentation:String ,callback:(params:Array<InterpTokens>, body:Array<InterpTokens>) -> InterpTokens) {
		var conditionPath = conditionName.split(".");
		var object = memory.externs.createPathFor(memory.externs.globalProperties, ...conditionPath);

		object.getter = (_, _) -> {
			objectValue: ConditionCode([
				null => Block([
					FunctionReturn(HaxeExtern(() -> callback(
						Interpreter.convert(...Parser.parse(Lexer.lex(memory.read(Little.keywords.CONDITION_PATTERN_PARAMETER_NAME).objectValue.parameter(0)))), 
						Interpreter.convert(...Parser.parse(Lexer.lex(memory.read(Little.keywords.CONDITION_BODY_PARAMETER_NAME).objectValue.parameter(0))))))
					, null /**forces type inference**/)
				], null)
			]),
			objectAddress: memory.constants.EXTERN,
			objectDoc: documentation ?? ""
		}
    }

	/**
		Registers a haxe-property-like variable on a little class found at `onType`.


		@param propertyName The name of the property, must not include property access sign.
		@param onType The type of the object the property is on. Must be a little class, and if the class is nested within an object, a full path must be specified.
		@param documentation The documentation of the property
		@param staticValue **Option 1**. A static value this property always returns.
		@param valueGetter **Option 2**. A function that returns the value of the property. It takes in the value of the parent object, and it's address in memory.
	**/
	public function registerInstanceVariable(propertyName:String, onType:String, ?documentation:String, ?staticValue:InterpTokens, ?valueGetter:(objectValue:InterpTokens, objectAddress:MemoryPointer) -> InterpTokens) {
		var classPath = onType.split(".");
		var object = memory.externs.createPathFor(memory.externs.instanceProperties, ...classPath);

		object.getter = (v, a) -> {
			return try {
				var value = staticValue == null ? valueGetter(v, a) : staticValue;
				{
					objectValue: value,
					objectAddress: memory.store(value),
					objectDoc: documentation ?? ""
				}
			} catch (e) {
				{
					objectValue: ErrorMessage('External Function Error: ' + e.details()),
					objectAddress: memory.constants.ERROR,
					objectDoc: ""
				}
			}
		}
	}

	/**
		Registers a method on every object of the given type, that can be called from Little.

		@param propertyName The name of the property, must not include property access sign.
		@param onType The type of the object the property is on. Must be a little class, and if the class is nested within an object, a full path must be specified.
		@param documentation The documentation of the property
		@param expectedParameters an `Array<InterpTokens>` consisting of `InterpTokens.Variable`s which contain the names & types of the parameters that should be passed on to the function. For example:
            ```
            [VariableDeclaration(Identifier(x), Identifier("Characters"))]
            ```
            **alternatively** - can be normal parameter "list" written in little: 
            ``` 
            define x as Characters, define index = 3, define y
            ```
            **Important** - if variables appear in the end and have assigned values, they are optional.
		@param callback The actual function, which gets 3 parameters: the value of the object, the address of the object in memory, and an array of the given parameters, exactly as the user gave them (which means they might require further evaluation). The function should return something at the end, or a `VoidValue`.
		@param returnType The type of the returned value. This exists due to implementation limitations. You can use the `Conversion` class to know which types to put here.
	**/
	public function registerInstanceFunction(propertyName:String, onType:String, ?documentation:String, expectedParameters:EitherType<String, Array<InterpTokens>>, callback:(objectValue:InterpTokens, objectAddress:MemoryPointer, params:Array<InterpTokens>) -> InterpTokens, returnType:String) {
		var params = if (expectedParameters is String) {
            Interpreter.convert(...Parser.parse(Lexer.lex(expectedParameters)));
        } else (expectedParameters : Array<InterpTokens>);
        
        var paramMap = new OrderedMap<String, InterpTokens>();
		for (entry in params) {
			if (entry.is(SPLIT_LINE, SET_LINE)) continue;
			switch entry {
				case VariableDeclaration(name, null, _): paramMap[name.extractIdentifier()] = TypeCast(NullValue, Identifier(Little.keywords.TYPE_DYNAMIC));
				case VariableDeclaration(name, type, _): paramMap[name.extractIdentifier()] = TypeCast(NullValue, type);
				case Write(assignees, value): {
					switch assignees[0] {
						case VariableDeclaration(name, null, _): paramMap[name.extractIdentifier()] = TypeCast(value, Identifier(Little.keywords.TYPE_DYNAMIC));
						case VariableDeclaration(name, type, _): paramMap[name.extractIdentifier()] = TypeCast(value, type);
						default:
					}
				}
				default:
			}
		}

		var classPath = onType.split(".");
		var object = memory.externs.createPathFor(memory.externs.instanceProperties, ...classPath);
		var returnTypeToken = Interpreter.convert(...Parser.parse(Lexer.lex(returnType)))[0]; // May be a PropertyAccess or an Identifier
		object.getter = (v, a) -> {
			return try {
				{
					objectValue: FunctionCode(paramMap, Block([
						FunctionReturn(HaxeExtern(() -> callback(v, a, paramMap.keys().toArray().map(key -> Actions.evaluate(memory.read(key).objectValue)))), returnTypeToken)
					], returnTypeToken)),
					objectAddress: memory.constants.EXTERN,
					objectDoc: documentation ?? ""
				}
			} catch (e) {
				{
					objectValue: ErrorMessage('External Function Error: ' + e.details()),
					objectAddress: memory.constants.ERROR,
					objectDoc: ""
				}
			}
		}
	}


    static function combosHas(combos:Array<{lhs:String, rhs:String}>, lhs:String, rhs:String) {
        for (c in combos) if (c.rhs == rhs && c.lhs == lhs) return true;
        return false;
    }

    public function registerSign(symbol:String, info:SignInfo) {

        if (info.operatorType == null || info.operatorType == LHS_RHS) {
            if (info.callback == null && info.singleSidedOperatorCallback != null) 
                throw new ArgumentException("callback", 'Incorrect callback given for operator type ${info.operatorType ?? LHS_RHS} - `singleSidedOperatorCallback` was given, when `callback` was expected');
            else if (info.callback == null)
                throw new ArgumentException("callback", 'No callback given for operator type ${info.operatorType ?? LHS_RHS} (`callback` is null)');
            
            var callbackFunc:(InterpTokens, InterpTokens) -> InterpTokens;

			// A bunch of ifs in order to shorten the final callback function, improves performance a bit
            if (info.lhsAllowedTypes != null && info.rhsAllowedTypes == null && info.allowedTypeCombos == null) {
                callbackFunc = (lhs, rhs) -> {
                    if (!info.lhsAllowedTypes.contains(Interpreter.getValueType(lhs).getParameters()[0])) {
                        var t = Interpreter.getValueType(lhs).getParameters()[0];
                        return Little.runtime.throwError(ErrorMessage('Cannot preform ${t}(${Interpreter.stringifyTokenIdentifier(lhs)}) $symbol ${Interpreter.getValueType(rhs).getParameters()[0]}(${Interpreter.stringifyTokenIdentifier(rhs)}) - Left operand cannot be of type $t (accepted types: ${info.lhsAllowedTypes})'));
                    }

                    return info.callback(lhs, rhs);
                }
            } else if (info.lhsAllowedTypes == null && info.rhsAllowedTypes != null && info.allowedTypeCombos == null) {
                callbackFunc = (lhs, rhs) -> {
                    if (!info.rhsAllowedTypes.contains(Interpreter.getValueType(rhs).getParameters()[0])) {
                        var t = Interpreter.getValueType(rhs).getParameters()[0];
                        return Little.runtime.throwError(ErrorMessage('Cannot preform ${Interpreter.getValueType(lhs).getParameters()[0]}(${Interpreter.stringifyTokenIdentifier(lhs)}) $symbol ${t}(${Interpreter.stringifyTokenIdentifier(rhs)}) - Right operand cannot be of type $t (accepted types: ${info.rhsAllowedTypes})'));
                    }

                    return info.callback(lhs, rhs);
                }
            } else if (info.lhsAllowedTypes != null && info.rhsAllowedTypes != null && info.allowedTypeCombos == null) {
                callbackFunc = (lhs, rhs) -> {
                    var rhsType = Interpreter.getValueType(rhs).getParameters()[0],
                        lhsType = Interpreter.getValueType(lhs).getParameters()[0];
                    if (!info.rhsAllowedTypes.contains(Interpreter.getValueType(rhs).getParameters()[0])) {
                        var t = Interpreter.getValueType(rhs).getParameters()[0];
                        return Little.runtime.throwError(ErrorMessage('Cannot preform ${Interpreter.getValueType(lhs).getParameters()[0]}(${Interpreter.stringifyTokenIdentifier(lhs)}) $symbol ${t}(${Interpreter.stringifyTokenIdentifier(rhs)}) - Right operand cannot be of type $t (accepted types: ${info.rhsAllowedTypes})'));
                    }
					
                    if (!info.rhsAllowedTypes.contains(Interpreter.getValueType(lhs).getParameters()[0])) {
                        var t = Interpreter.getValueType(lhs).getParameters()[0];
                        return Little.runtime.throwError(ErrorMessage('Cannot preform ${Interpreter.getValueType(lhs).getParameters()[0]}(${Interpreter.stringifyTokenIdentifier(lhs)}) $symbol ${t}(${Interpreter.stringifyTokenIdentifier(rhs)}) - Left operand cannot be of type $t (accepted types: ${info.lhsAllowedTypes})'));
                    }

                    return info.callback(lhs, rhs);
                }
            } else if (info.lhsAllowedTypes != null && info.rhsAllowedTypes == null && info.allowedTypeCombos != null) {
                callbackFunc = (lhs, rhs) -> {
                    var r = Interpreter.getValueType(rhs).getParameters()[0];
                    var l = Interpreter.getValueType(lhs).getParameters()[0];
                    if (!info.lhsAllowedTypes.contains(l) && !info.allowedTypeCombos.containsCombo(l, r)) {
                        return Little.runtime.throwError(ErrorMessage('Cannot preform ${l}(${Interpreter.stringifyTokenIdentifier(lhs)}) $symbol ${r}(${Interpreter.stringifyTokenIdentifier(rhs)}) - Right operand cannot be of type $r while left operand is of type $l (accepted types for left operand: ${info.lhsAllowedTypes}, accepted type combinations: ${info.allowedTypeCombos.map(object -> '${object.rhs} $symbol ${object.lhs}')})'));
                    }

                    return info.callback(lhs, rhs);
                }
            } else if (info.lhsAllowedTypes == null && info.rhsAllowedTypes != null && info.allowedTypeCombos != null) {
                callbackFunc = (lhs, rhs) -> {
                    var r = Interpreter.getValueType(rhs).getParameters()[0];
                    var l = Interpreter.getValueType(lhs).getParameters()[0];
                    if (!info.rhsAllowedTypes.contains(r) && !info.allowedTypeCombos.containsCombo(l, r)) {
                        return Little.runtime.throwError(ErrorMessage('Cannot preform ${l}(${Interpreter.stringifyTokenIdentifier(lhs)}) $symbol ${r}(${Interpreter.stringifyTokenIdentifier(rhs)}) - Right operand cannot be of type $r while left operand is of type $l (accepted types for right operand: ${info.rhsAllowedTypes}, accepted type combinations: ${info.allowedTypeCombos.map(object -> '${object.rhs} $symbol ${object.lhs}')})'));
                    }

                    return info.callback(lhs, rhs);
                }
            } else if (info.lhsAllowedTypes != null && info.rhsAllowedTypes != null && info.allowedTypeCombos != null) {
                callbackFunc = (lhs, rhs) -> {
                    var rhsType = Interpreter.getValueType(rhs).getParameters()[0],
                        lhsType = Interpreter.getValueType(lhs).getParameters()[0];
                    if (!info.rhsAllowedTypes.contains(rhsType) && !info.allowedTypeCombos.containsCombo(lhsType, rhsType)) {
                        return Little.runtime.throwError(ErrorMessage('Cannot preform ${lhsType}(${Interpreter.stringifyTokenIdentifier(lhs)}) $symbol ${rhsType}(${Interpreter.stringifyTokenIdentifier(rhs)}) - Right operand cannot be of type $rhsType (accepted types: ${info.rhsAllowedTypes}, accepted type combinations: ${info.allowedTypeCombos.map(object -> '${object.rhs} $symbol ${object.lhs}')})'));
                    }
					
                    if (!info.rhsAllowedTypes.contains(lhsType) && !info.allowedTypeCombos.containsCombo(lhsType, rhsType)) {
                        return Little.runtime.throwError(ErrorMessage('Cannot preform ${lhsType}(${Interpreter.stringifyTokenIdentifier(lhs)}) $symbol ${rhsType}(${Interpreter.stringifyTokenIdentifier(rhs)}) - Left operand cannot be of type $lhsType (accepted types: ${info.lhsAllowedTypes}, accepted type combinations: ${info.allowedTypeCombos.map(object -> '${object.rhs} $symbol ${object.lhs}')})'));
                    }

                    return info.callback(lhs, rhs);
                }
            } else callbackFunc = info.callback;

			Little.operators.add(symbol, LHS_RHS, info.priority, callbackFunc);
        } else { // One sided operator
			if (info.singleSidedOperatorCallback == null && info.callback != null) 
                throw new ArgumentException("singleSidedOperatorCallback", 'Incorrect callback given for operator type ${info.operatorType} - `callback` was given, when `singleSidedOperatorCallback` was expected');
            else if (info.singleSidedOperatorCallback == null)
                throw new ArgumentException("singleSidedOperatorCallback", 'No callback given for operator type ${info.operatorType ?? LHS_RHS} (`singleSidedOperatorCallback` is null)');
            
			var callbackFunc:InterpTokens -> InterpTokens;

			if (info.operatorType == LHS_ONLY) {
				callbackFunc = (lhs) -> {
					var l = Interpreter.getValueType(lhs).getParameters()[0];
					if (!info.lhsAllowedTypes.contains(l)) {
						return Little.runtime.throwError(ErrorMessage('Cannot perform $l(${Interpreter.stringifyTokenIdentifier(lhs)})$symbol - Operand cannot be of type $l (accepted types: ${info.lhsAllowedTypes})'));
					}

					return info.singleSidedOperatorCallback(lhs);
				}
			} else {
				callbackFunc = (rhs) -> {
					var r = Interpreter.getValueType(rhs).getParameters()[0];
					if (!info.rhsAllowedTypes.contains(r)) {
						return Little.runtime.throwError(ErrorMessage('Cannot perform $symbol$r(${Interpreter.stringifyTokenIdentifier(rhs)}) - Operand cannot be of type $r (accepted types: ${info.rhsAllowedTypes})'));
					}

					return info.singleSidedOperatorCallback(rhs);
				}
			} 

			Little.operators.add(symbol, info.operatorType, info.priority, callbackFunc);
        }
    }




















    static function containsCombo(array:Array<{lhs:String, rhs:String}>, lhs:String, rhs:String):Bool {
        for (a in array) {
            if (a.lhs == lhs && a.rhs == rhs) return true;
        }
        return false;
    }
}

typedef ItemInfo = {
	className:String,
	name:String,
    doc:String,
	parameters:Array<{name:String, type:String, optional:Bool}>,
	returnType:String,
	fieldType:String,
	allowWrite:Bool,
    isStatic:Bool
}

typedef FunctionInfo = {
    expectedParameters:EitherType<String, Array<InterpTokens>>,
    callback:(MemoryObject, Array<InterpTokens>) -> InterpTokens, //parent, params to value
    ?allowWriting:Bool,
    ?type:String
}
typedef StaticFunctionInfo = {
    expectedParameters:EitherType<String, Array<InterpTokens>>,
    callback:(Array<InterpTokens>) -> InterpTokens, //parent, params to value
    ?allowWriting:Bool,
	?valueType:String,
	?doc:String
}

typedef StaticVariableInfo = {
	?staticValue:InterpTokens,
	?valueType:String,
	?valueGetter:MemoryObject -> InterpTokens, // this to value
	?valueSetter:(MemoryObject, InterpTokens) -> InterpTokens, // parent, provided value to value
	?allowWriting:Bool,
	?doc:String
}

typedef InstanceFunctionInfo = {
    expectedParameters:EitherType<String, Array<InterpTokens>>,
    callback:(thisObject:MemoryObject, Array<InterpTokens>) -> InterpTokens, //parent, params to value
	?valueType:String,
    ?allowWriting:Bool,
    ?type:String,
	?doc:String
}

typedef InstanceVariableInfo = {
	?staticValue:InterpTokens,
	?valueType:String,
	?valueGetter:MemoryObject -> InterpTokens, // this to value
	?valueSetter:(MemoryObject, InterpTokens) -> InterpTokens, // parent, provided value to value
	?allowWriting:Bool,
	?doc:String
}


typedef VariableInfo = {
    ?staticValue:InterpTokens, 
    ?valueGetter:MemoryObject -> InterpTokens, //parent to value
    ?valueSetter:(MemoryObject, InterpTokens) -> InterpTokens, //parent, provided value to value
    ?allowWriting:Bool,
    ?type:String
}

typedef SignInfo = {
    ?lhsAllowedTypes:Array<String>,
    ?rhsAllowedTypes:Array<String>,
    ?allowedTypeCombos:Array<{lhs:String, rhs:String}>,
    ?callback:(InterpTokens, InterpTokens) -> InterpTokens,
    ?singleSidedOperatorCallback:InterpTokens -> InterpTokens,
    ?operatorType:OperatorType,
	/**
		@see Operators.setPriority
	**/
	?priority:String,
}