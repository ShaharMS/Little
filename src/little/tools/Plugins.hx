package little.tools;

import haxe.ds.StringMap;
import little.interpreter.memory.MemoryPointer;
import little.interpreter.memory.ExternalInterfacing.ExtTree;
import little.interpreter.memory.Memory;
import little.interpreter.memory.Operators.OperatorType;
import haxe.exceptions.ArgumentException;
import little.interpreter.Runtime;
import haxe.extern.EitherType;
import little.lexer.Lexer;
import little.parser.Parser;
import little.interpreter.Interpreter;
import little.interpreter.Tokens.InterpTokens;
import little.Little.*;

using little.tools.Plugins;
using little.tools.Extensions;
using little.tools.TextTools;
@:access(little.Little)
@:access(little.interpreter.Runtime)
class Plugins {

    private var memory:Memory;

    /**
    	Instantiates the `Plugins` class.
    **/
    public function new(memory:Memory) {
        this.memory = memory;
    }

    @:noCompletion static var __noTypeCreation:Bool;
    /**
        registers a class in little code, or extends the fields of an existing class. The class' fields are dictated by this function's `fields` attribute,
        which provides instance & static functions, variables, and nested objects. 
        The allowed key-value types in `fields`'s key-value pairs:

        |Key Syntax                                           | Type                                                                                                                          | Application       | Description |
        |-----------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|-------------------|-------------|
        |`public <Type> <name>`                               | `(address:MemoryPointer, value:InterpTokens) -> InterpTokens`                                                                 | Instance Variable | A function that returns a value, that can be based on its parent. The returned value is stored in memory upon retrieval. |
        |`public <Type> <name>`                               | `(address:MemoryPointer, value:InterpTokens) -> {address:MemoryPointer, value:InterpTokens}`                                  | Instance Variable | A function that returns a value, that can be based on its parent. The returned value is not stored in memory, and we rely upon the given pointer to be correct. |
        |`public <Type> <name> (define <param> as <Type>)`    | `(address:MemoryPointer, value:InterpTokens, givenParams:Array<InterpTokens>) -> InterpTokens`                                | Instance Function | A function, that returns a value based on its parent & other given parameters, provided by a Little function call. The returned value is stored in memory upon retrieval. |
        |`static <Type> <name>`                               | `() -> InterpTokens`                                                                                                          | Static Variable   | A function that returns a static value. The returned value is stored in memory upon retrieval. |
        |`static <Type> <name>`                               | `() -> {address:MemoryPointer, value:InterpTokens}`                                                                           | Static Variable   | A function that returns a static value. The returned value is not stored in memory, and we rely upon the given pointer to be correct. |
        |`static <Type> <name> ()`                            | `(givenParams:Array<InterpTokens>) -> InterpTokens`                                                                           | Static Function   | A function that returns a value based on some given parameters, provided by a Little function call. The returned value is stored in memory upon retrieval. |
        |`static <Type> <name>`                               | `TypeFields`                                                                                                                  | Static Variable   | Another option for a static variable, but this time it's for a nested object. The object itself isn't allocated in Little's memory, but its decedents may be. instance objects are not available this way, since they are tied to an object, thus needing to be allocated many times. |

        **Notice** - key syntax is very sensitive - must start with `public` or `static`, continue with a `little` type, then a name, and parameters if its a function. Each element separated by a single whitespace. Example:
        
            'public Number id'
            'static ${Conversion.toLittleType("String")} getProfile (define summed as ${Conversion.toLittleType("Bool")})'
        
        **Notice 2** - for function parameters, syntax follows Little function parameter syntax - multiple parameter declarations, with optional type and optional default values, separated by a comma.
        
        @param typeName The name of the class. May be nested inside other "packages" using a `.`, and not specifically the defined `PROPERTY_ACCESS_SIGN` (for example. my_pack.MyClass). Don't use other signs
						in the name, as they are not valid. 
        @param fields A string map that has key-value pairs of certain types. Refer to the table above for more information.
    **/
    public function registerType(typeName:String, fields:TypeFields) {
        var instances = memory.externs.createPathFor(memory.externs.instanceProperties, ...typeName.split("."));
        var statics = memory.externs.createPathFor(memory.externs.globalProperties, ...typeName.split("."));

        instances.type = statics.type = memory.getTypeInformation(Little.keywords.TYPE_MODULE).pointer;

        if (__noTypeCreation) __noTypeCreation = false;
        else if (!memory.externs.externToPointer.exists(typeName) && !memory.constants.hasType(typeName)) {
            memory.externs.externToPointer[typeName] = memory.storage.storeByte(1);
            statics.getter = (_, _) -> {
                objectValue: ClassPointer(memory.externs.externToPointer[typeName]),
                objectAddress: memory.externs.externToPointer[typeName]
            }
		} else if (memory.constants.hasType(typeName) && !memory.externs.externToPointer.exists(typeName)) {
			memory.externs.externToPointer[typeName] = memory.constants.getType(typeName);
			statics.getter = (_, _) -> {
				objectValue: ClassPointer(memory.externs.externToPointer[typeName]),
				objectAddress: memory.externs.externToPointer[typeName]
			}
		}

        for (key => field in fields) {
            switch key.split(" ") {
                case (_[0] == "public" && _.length == 3) => true: {
					var name = key.split(" ")[2].replace(Little.keywords.PROPERTY_ACCESS_SIGN, "_");
                    var type = memory.getTypeInformation(key.split(" ")[1]).pointer;
                    instances.properties[name] = new ExtTree(type, (value, address) -> {
                        // We can't optimize for the two cases outside of the callback, since haxe doesn't support
                        // type checking on function types.
                        try {
                            var result = untyped field(address, value);
                            if (result is InterpTokens) {
                                return {
                                    objectValue: result,
                                    objectAddress: memory.store(result)
                                };
                            } 
                            return {
                                objectValue: untyped result.value,
                                objectAddress: untyped result.address
                            }
                        } catch (e) {
                            return {
                                objectValue: ErrorMessage('External Variable Error: ' + e.details()),
                                objectAddress: memory.constants.ERROR
                            }
                        }
                        
                    });
                }
                case (_[0] == "public") => true: {
					var name = key.split(" ")[2].replace(Little.keywords.PROPERTY_ACCESS_SIGN, "_");
                    var type = memory.getTypeInformation(key.split(" ")[1]);
                    var params = Interpreter.convert(...Parser.parse(Lexer.lex(key.replaceFirst('public function $name ', "").replaceFirst("(", "").replaceLast(")", ""))));

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

                    instances.properties[name] = new ExtTree(memory.getTypeInformation(Little.keywords.TYPE_FUNCTION).pointer, (value, address) -> {
                        var returnType:InterpTokens = type.typeName.asTokenPath();
                        return {
                            objectValue: FunctionCode(paramMap, Block([
                                FunctionReturn(HaxeExtern(() -> {
                                    var result = (field : (MemoryPointer, InterpTokens, Array<InterpTokens>) -> InterpTokens)(address, value, paramMap.keys().toArray().map(key -> Interpreter.evaluate(memory.read(key).objectValue)));
                                    return result;
                                }), returnType)
                            ], returnType)),
                            objectAddress: memory.constants.EXTERN
                        }
                    });
                }

                case (_[0] == "static" && _.length == 3) => true: {
                    var name = key.split(" ")[2].replace(Little.keywords.PROPERTY_ACCESS_SIGN, "_");
                    var type = memory.getTypeInformation(key.split(" ")[1]).pointer;
                    if (field is StringMap) {
                        __noTypeCreation = true;
                        registerType(typeName + "." + name, field);
                        continue;
                    }
                    statics.properties[name] = new ExtTree(type, (_, _) -> {
                        // We can't optimize for the two cases outside of the callback, since haxe doesn't support
                        // type checking on function types.
                            try {
                                var result = untyped field();
                                if (result is InterpTokens) {
                                    return {
                                        objectValue: result,
                                        objectAddress: memory.store(result)
                                    };
                                } 
                                return {
                                    objectValue: untyped result.value,
                                    objectAddress: untyped result.address
                                }
                            } catch (e) {
                                return {
                                    objectValue: ErrorMessage('External Variable Error: ' + e.details()),
                                    objectAddress: memory.constants.ERROR
                                }
                            }
                    });
                }
                case (_[0] == "static") => true: {
					var name = key.split(" ")[2].replace(Little.keywords.PROPERTY_ACCESS_SIGN, "_");
                    var type = memory.getTypeInformation(key.split(" ")[1]);
                    var params = Interpreter.convert(...Parser.parse(Lexer.lex(key.replaceFirst('static function $name ', "").replaceFirst("(", "").replaceLast(")", ""))));
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
                    
                    statics.properties[name] = new ExtTree(memory.getTypeInformation(Little.keywords.TYPE_FUNCTION).pointer, (_, _) -> {
                        var returnType:InterpTokens = type.typeName.asTokenPath();
                        return {
                            objectValue: FunctionCode(paramMap, Block([
                                FunctionReturn(HaxeExtern(() -> {
                                    var result = untyped field(paramMap.keys().toArray().map(key -> Interpreter.evaluate(memory.read(key).objectValue)));
                                    return result;
                                }), returnType)
                            ], returnType)),
                            objectAddress: memory.constants.EXTERN
                        }
                    });
                }

                case _: throw 'Invalid key syntax for `$key`. Must start with either `public`/`static` `function`/`var`, and end with a variable name. (Example: `public var myVar`). Each item must be separated by a single whitespace.';
            }
        }
    }

    /**
        registers a haxe value/property inside Little code.

        @param variableName the name of the variable, for usage in Little code. If you want it nested in some kind of path, use `.`, and not specifically the defined `PROPERTY_ACCESS_SIGN` (e.g. `mother.varName`). 
        @param variableType the type of the variable, in little. Use `Conversion.toLittleType` for haxe basic types if needed.       
        @param documentation documentation for this variable.
        @param staticValue **Option 1** - a static value to assign to this variable
        @param valueGetter **Option 2** - a function that returns a value that this variable gives when accessed.
    **/
    public function registerVariable(variableName:String, variableType:String, ?documentation:String, ?staticValue:InterpTokens, ?valueGetter:Void -> InterpTokens) {
        var varPath = variableName.split(".");
        var object = memory.externs.createPathFor(memory.externs.globalProperties, ...varPath);

        object.type = memory.getTypeInformation(variableName).pointer;
        object.getter = (_, _) -> {
            return try {
                var value = staticValue == null ? valueGetter() : staticValue;
                {
                    objectValue: value,
                    objectAddress: memory.store(value),
                    // objectDoc: documentation ?? ""
                }
            } catch (e) {
                {
                    objectValue: ErrorMessage('External Variable Error: ' + e.details()),
                    objectAddress: memory.constants.ERROR,
                    // objectDoc: ""
                }
            }
        }
    }

    /**
    	Allows usage of a function written in haxe inside Little code.

    	@param actionName The name by which to identify the function. If you want this nested in some kind of path, use `.`, and not specifically the defined `PROPERTY_ACCESS_SIGN` (e.g. `mother.funcName`)
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
    public function registerFunction(functionName:String, ?documentation:String, expectedParameters:EitherType<String, Array<InterpTokens>>, callback:Array<{objectValue:InterpTokens, objectTypeName:String, objectAddress:MemoryPointer}> -> InterpTokens, returnType:String) {
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
            FunctionReturn(HaxeExtern(() -> callback(paramMap.keys().toArray().map(key -> memory.read(key)))), returnTypeToken)
        ], returnTypeToken));
        
        var object = memory.externs.createPathFor(memory.externs.globalProperties, ...functionPath);

        object.type = memory.getTypeInformation(Little.keywords.TYPE_FUNCTION).pointer;
        object.getter = (_, _) -> {
			objectValue: token,
			objectAddress: memory.constants.EXTERN,
			// objectDoc: documentation ?? ""
        }
    }

    /**
		Adds a condition to be used in Little.

		Conditions are can be described as a special function, that decides how many time another given function is run, and with which parameters.
		Their syntax:

			<condition_name> (<params>) {
				<body>
			}
		
		@param conditionName The name by which to identify the condition. If you want this nested in some kind of path, use `.`, and not specifically the defined `PROPERTY_ACCESS_SIGN` (e.g. `mother.conditionName`)
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
					HaxeExtern(() -> callback(
						Interpreter.convert(...Parser.parse(Lexer.lex(memory.read(Little.keywords.CONDITION_PATTERN_PARAMETER_NAME).objectValue.parameter(0)))).slice(1), 
						Interpreter.convert(...Parser.parse(Lexer.lex(memory.read(Little.keywords.CONDITION_BODY_PARAMETER_NAME).objectValue.parameter(0))))
						)
					) // No FunctionReturn here, since conditions propagate existing returns, and if we put one here, it will get propagated outside
					  // The scope of this condition, which results in unexpected behavior (program/function quits prematurely)
				], null)
			]),
			objectAddress: memory.constants.EXTERN,
			// objectDoc: documentation ?? ""
		}
    }

	/**
		Registers a haxe-property-like variable on a little class found at `onType`.


		@param propertyName The name of the property, must not include signs.
        @param propertyType The type of the property. Must be a little class. 
		@param onType The type of the object the property is on. Must be a little class, and if the class is nested within an object, a full path must be specified. 
		If the class is nested within other objects, provide a dot-based path, not one split specifically by little's `PROPERTY_ACCESS_SIGN`.
		@param documentation The documentation of the property
		@param staticValue **Option 1**. A static value this property always returns.
		@param valueGetter **Option 2**. A function that returns the value of the property. It takes in the value of the parent object, and it's address in memory.
	**/
	public function registerInstanceVariable(propertyName:String, propertyType:String, onType:String, ?documentation:String, ?staticValue:InterpTokens, ?valueGetter:(objectValue:InterpTokens, objectAddress:MemoryPointer) -> InterpTokens) {
		var classPath = onType.split(".");
        classPath.push(propertyName);
		var object = memory.externs.createPathFor(memory.externs.instanceProperties, ...classPath);

        object.type = memory.getTypeInformation(propertyType).pointer;
		object.getter = (v, a) -> {
			return try {
				var value = staticValue == null ? valueGetter(v, a) : staticValue;
				{
					objectValue: value,
					objectAddress: memory.store(value),
					// objectDoc: documentation ?? ""
				}
			} catch (e) {
				{
					objectValue: ErrorMessage('External Function Error: ' + e.details()),
					objectAddress: memory.constants.ERROR,
					// objectDoc: ""
				}
			}
		}
	}

	/**
		Registers a method on every object of the given type, that can be called from Little.

		@param propertyName The name of the property, must not include signs.
		@param onType The type of the object the property is on. Must be a little class, and if the class is nested within an object, a full path must be specified.
					  If the class is nested within other objects, provide a dot-based path, not one split specifically by little's `PROPERTY_ACCESS_SIGN`.
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
	public function registerInstanceFunction(propertyName:String, onType:String, ?documentation:String, expectedParameters:EitherType<String, Array<InterpTokens>>, callback:(objectValue:InterpTokens, objectAddress:MemoryPointer, params:Array<{objectValue:InterpTokens, objectTypeName:String, objectAddress:MemoryPointer}>) -> InterpTokens, returnType:String) {
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
        classPath.push(propertyName);
		var object = memory.externs.createPathFor(memory.externs.instanceProperties, ...classPath);
		var returnTypeToken = Interpreter.convert(...Parser.parse(Lexer.lex(returnType)))[0]; // May be a PropertyAccess or an Identifier
		
        object.type = memory.getTypeInformation(Little.keywords.TYPE_FUNCTION).pointer;
        object.getter = (v, a) -> {
			return try {
				{
					objectValue: FunctionCode(paramMap, Block([
						FunctionReturn(HaxeExtern(() -> callback(v, a, paramMap.keys().toArray().map(key -> memory.read(key)))), returnTypeToken)
					], returnTypeToken)),
					objectAddress: memory.constants.EXTERN,
					// objectDoc: documentation ?? ""
				}
			} catch (e) {
				{
					objectValue: ErrorMessage('External Function Error: ' + e.details()),
					objectAddress: memory.constants.ERROR,
					// objectDoc: ""
				}
			}
		}
	}

    /**
		Checks if the given `Array<{lhs:String, rhs:String}>` contains the given `lhs` and `rhs` combination.
    **/
    static function combosHas(combos:Array<{lhs:String, rhs:String}>, lhs:String, rhs:String) {
        for (c in combos) if (c.rhs == rhs && c.lhs == lhs) return true;
        return false;
    }

    /**
		Registers an operator, to be used in expressions in `Little`. An operator can be a single sided operator, or a double sided operator. 
		An operator can also accept specific types for each side, or specific types for both sides.

		@param symbol a `String` which is the symbol of the operator. Must not contain any letters or whitespaces.
		@param info Information about the operator, including callback for when the operator is used and other properties.
    **/
    public function registerOperator(symbol:String, info:OperatorInfo) {

        if (info.operatorType == null || info.operatorType == LHS_RHS) {
            if (info.callback == null && info.singleSidedOperatorCallback != null) 
                throw new ArgumentException("callback", 'Incorrect callback given for operator type ${info.operatorType ?? LHS_RHS} - `singleSidedOperatorCallback` was given, when `callback` was expected');
            else if (info.callback == null)
                throw new ArgumentException("callback", 'No callback given for operator type ${info.operatorType ?? LHS_RHS} (`callback` is null)');
            
            var callbackFunc:(InterpTokens, InterpTokens) -> InterpTokens;

			// A bunch of ifs in order to shorten the final callback function, improves performance a bit
            if (info.lhsAllowedTypes != null && info.rhsAllowedTypes == null && info.allowedTypeCombos == null) {
                callbackFunc = (lhs, rhs) -> {
                    final lType = Interpreter.evaluate(lhs).type(), rType = Interpreter.evaluate(rhs).type();
                    if (!info.lhsAllowedTypes.contains(lType)) {
                        return Little.runtime.throwError(ErrorMessage('Cannot preform $lType(${lhs.extractIdentifier()}) $symbol $rType(${rhs.extractIdentifier()}) - Left operand cannot be of type $lType (accepted types: ${info.lhsAllowedTypes})'));
                    }

                    return info.callback(lhs, rhs);
                }
            } else if (info.lhsAllowedTypes == null && info.rhsAllowedTypes != null && info.allowedTypeCombos == null) {
                callbackFunc = (lhs, rhs) -> {
                    final lType = Interpreter.evaluate(lhs).type(), rType = Interpreter.evaluate(rhs).type();
                    if (!info.rhsAllowedTypes.contains(rType)) {
                        return Little.runtime.throwError(ErrorMessage('Cannot preform $lType(${lhs.extractIdentifier()}) $symbol $rType(${rhs.extractIdentifier()}) - Right operand cannot be of type $rType (accepted types: ${info.rhsAllowedTypes})'));
                    }

                    return info.callback(lhs, rhs);
                }
            } else if (info.lhsAllowedTypes != null && info.rhsAllowedTypes != null && info.allowedTypeCombos == null) {
                callbackFunc = (lhs, rhs) -> {
                    final lType = Interpreter.evaluate(lhs).type(), rType = Interpreter.evaluate(rhs).type();
                    if (!info.rhsAllowedTypes.contains(rType)) {
                        return Little.runtime.throwError(ErrorMessage('Cannot preform $lType(${lhs.extractIdentifier()}) $symbol $rType(${rhs.extractIdentifier()}) - Right operand cannot be of type $rType (accepted types: ${info.rhsAllowedTypes})'));
                    }
					
                    if (!info.rhsAllowedTypes.contains(lType)) {
                        return Little.runtime.throwError(ErrorMessage('Cannot preform $lType(${lhs.extractIdentifier()}) $symbol $rType(${rhs.extractIdentifier()}) - Left operand cannot be of type $lType (accepted types: ${info.lhsAllowedTypes})'));
                    }

                    return info.callback(lhs, rhs);
                }
            } else if (info.lhsAllowedTypes != null && info.rhsAllowedTypes == null && info.allowedTypeCombos != null) {
                callbackFunc = (lhs, rhs) -> {
                    final lType = Interpreter.evaluate(lhs).type(), rType = Interpreter.evaluate(rhs).type();
                    if (!info.lhsAllowedTypes.contains(lType) && !info.allowedTypeCombos.containsCombo(lType, rType)) {
                        return Little.runtime.throwError(ErrorMessage('Cannot preform $lType(${lhs.extractIdentifier()}) $symbol $rType(${rhs.extractIdentifier()}) - Right operand cannot be of type $rType while left operand is of type $lType (accepted types for left operand: ${info.lhsAllowedTypes}, accepted type combinations: ${info.allowedTypeCombos.map(object -> '${object.rhs} $symbol ${object.lhs}')})'));
                    }

                    return info.callback(lhs, rhs);
                }
            } else if (info.lhsAllowedTypes == null && info.rhsAllowedTypes != null && info.allowedTypeCombos != null) {
                callbackFunc = (lhs, rhs) -> {
                    final lType = Interpreter.evaluate(lhs).type(), rType = Interpreter.evaluate(rhs).type();
                    if (!info.rhsAllowedTypes.contains(rType) && !info.allowedTypeCombos.containsCombo(lType, rType)) {
                        return Little.runtime.throwError(ErrorMessage('Cannot preform $lType(${lhs.extractIdentifier()}) $symbol $rType(${rhs.extractIdentifier()}) - Right operand cannot be of type $rType while left operand is of type $lType (accepted types for right operand: ${info.rhsAllowedTypes}, accepted type combinations: ${info.allowedTypeCombos.map(object -> '${object.rhs} $symbol ${object.lhs}')})'));
                    }

                    return info.callback(lhs, rhs);
                }
            } else if (info.lhsAllowedTypes != null && info.rhsAllowedTypes != null && info.allowedTypeCombos != null) {
                callbackFunc = (lhs, rhs) -> {
                    final lType = Interpreter.evaluate(lhs).type(), rType = Interpreter.evaluate(rhs).type();
                    if (!info.rhsAllowedTypes.contains(rType) && !info.allowedTypeCombos.containsCombo(lType, rType)) {
                        return Little.runtime.throwError(ErrorMessage('Cannot preform $lType(${lhs.extractIdentifier()}) $symbol ${rType}(${rhs.extractIdentifier()}) - Right operand cannot be of type $rType (accepted types: ${info.rhsAllowedTypes}, accepted type combinations: ${info.allowedTypeCombos.map(object -> '${object.rhs} $symbol ${object.lhs}')})'));
                    }
					
                    if (!info.rhsAllowedTypes.contains(lType) && !info.allowedTypeCombos.containsCombo(lType, rType)) {
                        return Little.runtime.throwError(ErrorMessage('Cannot preform $lType(${lhs.extractIdentifier()}) $symbol ${rType}(${rhs.extractIdentifier()}) - Left operand cannot be of type $lType (accepted types: ${info.lhsAllowedTypes}, accepted type combinations: ${info.allowedTypeCombos.map(object -> '${object.rhs} $symbol ${object.lhs}')})'));
                    }

                    return info.callback(lhs, rhs);
                }
            } else callbackFunc = info.callback;

			Little.memory.operators.add(symbol, LHS_RHS, info.priority, callbackFunc);
        } else { // One sided operator
			if (info.singleSidedOperatorCallback == null && info.callback != null) 
                throw new ArgumentException("singleSidedOperatorCallback", 'Incorrect callback given for operator type ${info.operatorType} - `callback` was given, when `singleSidedOperatorCallback` was expected');
            else if (info.singleSidedOperatorCallback == null)
                throw new ArgumentException("singleSidedOperatorCallback", 'No callback given for operator type ${info.operatorType ?? LHS_RHS} (`singleSidedOperatorCallback` is null)');
            
			var callbackFunc:InterpTokens -> InterpTokens;

			if (info.operatorType == LHS_ONLY) {
				callbackFunc = (lhs) -> {
					var lType = Interpreter.evaluate(lhs).type();
					if (!info.lhsAllowedTypes.contains(lType)) {
						return Little.runtime.throwError(ErrorMessage('Cannot perform $lType(${lhs.extractIdentifier()})$symbol - Operand cannot be of type $lType (accepted types: ${info.lhsAllowedTypes})'));
					}

					return info.singleSidedOperatorCallback(lhs);
				}
			} else {
				callbackFunc = (rhs) -> {
                    var rType = Interpreter.evaluate(rhs).type();
					if (!info.rhsAllowedTypes.contains(rType)) {
						return Little.runtime.throwError(ErrorMessage('Cannot perform $symbol$rType(${rhs.extractIdentifier()}) - Operand cannot be of type $rType (accepted types: ${info.rhsAllowedTypes})'));
					}

					return info.singleSidedOperatorCallback(rhs);
				}
			} 

			Little.memory.operators.add(symbol, info.operatorType, info.priority, callbackFunc);
        }
    }




















    /**
		Checks if the given array contains the given combo
    **/
    static function containsCombo(array:Array<{lhs:String, rhs:String}>, lhs:String, rhs:String):Bool {
        for (a in array) {
            if (a.lhs == lhs && a.rhs == rhs) return true;
        }
        return false;
    }
}

/**
	Info about an operator
**/
typedef OperatorInfo = {
    ?lhsAllowedTypes:Array<String>,
    ?rhsAllowedTypes:Array<String>,
    ?allowedTypeCombos:Array<{lhs:String, rhs:String}>,
    ?callback:(InterpTokens, InterpTokens) -> InterpTokens,
    ?singleSidedOperatorCallback:InterpTokens -> InterpTokens,
    ?operatorType:OperatorType,
	/**
		@see Little.memory.operators.setPriority
	**/
	?priority:String,
}

/**
	Used to represent the fields of a type
**/
typedef TypeFields = Map<String, OneOfSeven<
    // Instance fields:
    (address:MemoryPointer, value:InterpTokens) -> InterpTokens, // variable
    (address:MemoryPointer, value:InterpTokens) -> {address:MemoryPointer, value:InterpTokens}, // variable, with pointer
    (address:MemoryPointer, value:InterpTokens, givenParams:Array<InterpTokens>) -> InterpTokens, // function
        // Static fields:
    () -> InterpTokens, // variable
    () -> {address:MemoryPointer, value:InterpTokens}, // variable
    (givenParams:Array<InterpTokens>) -> InterpTokens, // function
    TypeFields // nested object
>>;

/**
	Can be used to represent the fields of a type
**/
abstract OneOfSeven<T1, T2, T3, T4, T5, T6, T7>(Dynamic) 
    from T1 from T2 from T3 from T4 from T5 from T6 from T7
    to T1 to T2 to T3 to T4 to T5 to T6 to T7 {}