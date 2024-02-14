package little.tools;

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
        @param allowWriting Whether writing to this variable is allowed or not.
        @param staticValue **Option 1** - a static value to assign to this variable
        @param valueGetter **Option 2** - a function that returns a value that this variable gives when accessed.
        @param valueSetter a function that dispatches whenever this value is assigned to. Takes effect when `allowWriting == true`.
    **/
    public function registerVariable(variableName:String, ?documentation:String, allowWriting:Bool = false, ?staticValue:InterpTokens, ?valueGetter:Void -> InterpTokens, ?setterCallback:Void -> Void) {
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
        object.settable = allowWriting;
        if (allowWriting && setterCallback != null) {
            object.onSet = setterCallback;
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
    	@param callback The actual function, which gets an array of the given parameters as little tokens (specifically of type `Expression`, 0 or more of them), and returns a value based on them
    **/
    public function registerFunction(functionName:String, ?documentation:String, expectedParameters:EitherType<String, Array<InterpTokens>>, callback:Array<InterpTokens> -> InterpTokens) {
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

        var token:InterpTokens = FunctionCode(paramMap, Block([
            
        ]));
        
        var object = memory.externs.createPathFor(memory.externs.globalProperties, ...functionPath);

        object.getter = (_, _) -> {

        }


        var memObject = new MemoryObject(
            External(params -> {
                var currentModuleName = Little.runtime.currentModule;
                if (actionModuleName != null) Little.runtime.currentModule = actionModuleName;
                return try {
                    var val = callback(params);
                    Little.runtime.currentModule = currentModuleName;
                    val;
                } catch (e) {
                    Little.runtime.currentModule = currentModuleName;
                    ErrorMessage('External Function Error: ' + e.details());
                }
            }), 
            [], 
            params, 
            null, 
            true
        );

        if (actionModuleName != null) {
            Interpreter.memory.set(actionModuleName, new MemoryObject(Module(Identifier(actionModuleName)), [], null, Module(Identifier(TYPE_MODULE)), true, Interpreter.memory.object));
            memObject.parent = Interpreter.memory.get(actionModuleName);
            Interpreter.memory.get(actionModuleName).props.set(actionName, memObject);
        } else Interpreter.memory.set(actionName, memObject);
    }

    public function registerCondition(conditionName:String, ?expectedConditionPattern:EitherType<String, Array<InterpTokens>> ,callback:(Array<InterpTokens>, Array<InterpTokens>) -> InterpTokens) {
        CONDITION_TYPES.push(conditionName);

		var params = if (expectedConditionPattern is String) {
            Parser.parse(Lexer.lex(expectedConditionPattern));
        } else expectedConditionPattern;

        Interpreter.memory.set(conditionName, new MemoryObject(
            ExternalCondition((con, body) -> {
                return try {
                    callback(con, body);
                } catch (e) {
                    ErrorMessage('External Condition Error: ' + e.details());
                }
            }), 
            [], 
            params, 
            null, 
            true,
			true,
            Interpreter.memory.object
        ));
    }

    public function registerProperty(propertyName:String, onObject:String, isType:Bool, ?valueOption1:FunctionInfo, ?valueOption2:VariableInfo) {
        if (isType) {
            if (!Interpreter.memory.exists(onObject) || Interpreter.memory.silentGet(onObject).value.getName() != "Module") {
                Interpreter.memory.set(onObject, new MemoryObject(Module(Identifier(onObject)), [], null, Module(Identifier(TYPE_MODULE)), true));
            }
        } else {
            if (!Interpreter.memory.exists(onObject)) {
                Interpreter.memory.set(onObject, new MemoryObject(NullValue, [], null, Module(Identifier(TYPE_DYNAMIC)), true));
            }
        }

        var memObject:MemoryObject = new MemoryObject();
        var parent = Interpreter.memory.silentGet(onObject);
        if (valueOption2 != null) {
            // Variable
            var info:VariableInfo = valueOption2;
            memObject = new MemoryObject(
                External(params -> {
                    return try {
                        var val = if (info.staticValue != null) info.staticValue;
                        else info.valueGetter(memObject.parent);
                        val;
                    } catch (e) {
                        ErrorMessage('External Variable Error: ' + e.details());
                    }
                }), 
                [], 
                if (!isType) null else [
                    Variable(Identifier("value " /* That extra space is used to differentiate between non-static fields and functions. Todo: Pretty bad solution */), Identifier(onObject))
                ],
                Identifier(info.type), 
                true,
                false,
                isType,
                parent
            );

            if (info.valueSetter != null) {
                memObject.valueSetter = function (v) {
                    return memObject.value = info.valueSetter(memObject.parent, v);
                }
            }

            if (info.allowWriting == false) {// null defaults to true here, so cant use !info.allowWriting
                memObject.valueSetter = function (v) {
                    Runtime.warn(ErrorMessage('Directly editing the property $onObject$PROPERTY_ACCESS_SIGN$propertyName is disallowed. New value is ignored, returning original value.'));
                    return try {
                        var val = if (info.staticValue != null) info.staticValue;
                        else info.valueGetter(memObject.parent);
                        val;
                    } catch (e) {
                        ErrorMessage('External Variable Error: ' + e.details());
                    }
                }
            }
        } else {
            // Function
            var info:FunctionInfo = valueOption1;

            var params = if (info.expectedParameters is String) {
                Parser.parse(Lexer.lex(info.expectedParameters));
            } else info.expectedParameters;
            if (isType) params.unshift(Variable(Identifier("value"), Identifier(onObject)));

            memObject = new MemoryObject(
                External(params -> {
                    return try {
                        var val = info.callback(memObject.parent, params);
                        val;
                    } catch (e) {
                        ErrorMessage('External Function Error: ' + e.details());
                    }
                }), 
                [], 
                params, 
                Identifier(info.type), 
                true,
                false,
                isType,
                parent
            );

            if (info.allowWriting == false) {// null defaults to true here, so cant use !info.allowWriting
                memObject.valueSetter = function (v) {
                    Runtime.throwError(ErrorMessage('Directly editing the property $onObject$PROPERTY_ACCESS_SIGN$propertyName is disallowed. New value is ignored, returning original value.'));
                    return try {
                        var val = info.callback(memObject.parent, params);
                        val;
                    } catch (e) {
                        ErrorMessage('External Function Error: ' + e.details());
                    }
                }
            }
        }
       
        // trace('Adding $propertyName to $onObject');
        parent.props.set(propertyName, memObject);
        
    }

	
	public function registerStaticField(fieldName:String, type:String, ?valueOption1:StaticFunctionInfo, ?valueOption2:StaticVariableInfo) {
		var typeObject = Interpreter.memory.get(type);

		if (valueOption1 != null) {
			var value = External(params -> {
				var prevModule = Runtime.currentModule;
				Actions.setModule(type);
				return try {
					var val = valueOption1.callback(params);
					Actions.setModule(prevModule);
					val;
				} catch (e) {
					ErrorMessage('External Function Error: ' + e.details());
				}
			});
			var params = if (valueOption1.expectedParameters is String) {
                Parser.parse(Lexer.lex(valueOption1.expectedParameters));
            } else valueOption1.expectedParameters;
			
			var obj = new MemoryObject(
				value, 
				[], 
				params, 
				Module(Identifier(valueOption1.valueType)) ?? Interpreter.getValueType(value), 
				true, false, false, 
				typeObject, 
				valueOption1.doc
			);
			if (!valueOption1.allowWriting) {
				obj.valueSetter = function (v) {
					Runtime.warn(ErrorMessage('Directly editing the property $type$PROPERTY_ACCESS_SIGN$fieldName is disallowed. New value is ignored, returning original value.'));
					return v;
				}
			}

			typeObject.set(fieldName, obj);
		} else {
			var value:InterpTokens, obj:MemoryObject = null;
			if (valueOption2.staticValue != null) value = valueOption2.staticValue;
			else {
				value = External(params -> {
					var prevModule = Runtime.currentModule;
					return try {
						Actions.setModule(type);
						var val = valueOption2.valueGetter(obj);
						Actions.setModule(prevModule);
						val;
					} catch (e) {
						ErrorMessage('External Variable Error: ' + e.details());
					}
				});
				
				obj = new MemoryObject(
					value,
					[],
					[],
					Module(Identifier(valueOption2.valueType)) ?? Interpreter.getValueType(value),
					true,
					false,
					false,
					typeObject,
					valueOption2.doc
				);

				
				if (!valueOption1.allowWriting) {
					obj.valueSetter = function (v) {
						Runtime.warn(ErrorMessage('Directly editing the property $type$PROPERTY_ACCESS_SIGN$fieldName is disallowed. New value is ignored, returning original value.'));
						return v;
					}
				}

				typeObject.set(fieldName, obj);
			}
		}
	}

	public function registerInstanceField(fieldName:String, type:String, ?valueOption1:InstanceFunctionInfo, ?valueOption2:InstanceVariableInfo) {
		var typeObject = Interpreter.memory.get(type);

		var obj:MemoryObject = null;
		if (valueOption1 != null) {
			var value = External(params -> {
				var prevModule = Runtime.currentModule;
				Actions.setModule(type);
				return try {
					var val = valueOption1.callback(obj, params);
					Actions.setModule(prevModule);
					val;
				} catch (e) {
					ErrorMessage('External Function Error: ' + e.details());
				}
			});
			var params = if (valueOption1.expectedParameters is String) {
				Parser.parse(Lexer.lex(valueOption1.expectedParameters));
			} else valueOption1.expectedParameters;

			obj = new MemoryObject(
				value,
				[],
				params,
				Module(Identifier(valueOption1.valueType)) ?? Interpreter.getValueType(value),
				true,
				false,
				true,
				typeObject,
				valueOption1.doc
			);

			if (!valueOption1.allowWriting) {
				obj.valueSetter = function (v) {
					Runtime.warn(ErrorMessage('Directly editing the property $type$PROPERTY_ACCESS_SIGN$fieldName is disallowed. New value is ignored, returning original value.'));
					return v;
				}
			}

			typeObject.set(fieldName, obj);
		} else {
			var value:InterpTokens;
			if (valueOption2.staticValue != null) value = valueOption2.staticValue;
			else {
				value = External(params -> {
					var prevModule = Runtime.currentModule;
					Actions.setModule(type);
					return try {
						var val = valueOption2.valueGetter(obj);
						Actions.setModule(prevModule);
						val;
					} catch (e) {
						ErrorMessage('External Variable Error: ' + e.details());
					}
				});
				
				obj = new MemoryObject(
					value,
					[],
					[],
					Module(Identifier(valueOption2.valueType)) ?? Interpreter.getValueType(value),
					true,
					false,
					true,
					typeObject,
					valueOption2.doc
				);

				if (!valueOption1.allowWriting) {
					obj.valueSetter = function (v) {
						Runtime.warn(ErrorMessage('Directly editing the property $type$PROPERTY_ACCESS_SIGN$fieldName is disallowed. New value is ignored, returning original value.'));
						return v;
					}
				}

				typeObject.set(fieldName, obj);
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