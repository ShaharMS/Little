package little.tools;

import little.interpreter.Runtime;
import haxe.extern.EitherType;
import little.lexer.Lexer;
import little.parser.Parser;
import little.interpreter.Interpreter;
import little.parser.Tokens.ParserTokens;
import little.interpreter.memory.MemoryObject;
import little.Little.*;
import little.Keywords.*;


@:access(little.Little)
@:access(little.interpreter.Runtime)
class Plugins {
	/**
		Registers an entire Haxe class's static fields & methods, to allow accessing them through Little. for example:

		doing:  

			Little.plugin.registerHaxeClass(Data.getClassInfo("Math"));

		Will let you access all of Math's static fields & methods through little:
		```cpp
		print(Math.sqrt(4) + Math.max(2, {define i = 3, i}))
		```

		@param stats Data about the class, obtained by using `Data.getClassInfo("YourClassName")`
		@param littleClassName When provided, remaps the class in little, placing the properties inside the value of `littleClassName` instead of the class name given previously.
	**/
	public static function registerHaxeClass(stats:Array<ItemInfo>, ?littleClassName:String) {

		if (stats.length == 0) {
			return;
		}
        littleClassName = littleClassName != null ? littleClassName : stats[0].className;
		var fieldValues = new Map<String, Dynamic>();
		var fieldFunctions = new Map<String, Dynamic>();
		var cls = Type.resolveClass(stats[0].className);
		// trace(cls, Type.getClassFields(cls));
		// Iterate over the fields of the Math class
		for (s in stats) {
            if (s.isStatic) {
                var field = s.name;
			    // Check if the field is a static field
			    // Get the field value and store it in the fieldValues map
			    var value = Reflect.field(cls, field);
			    // Check if the field is a function (i.e., a method)
			    if (Reflect.isFunction(value)) {
			    	// Store the function in the fieldFunctions map
                    
			    	fieldFunctions.set(field, value);
			    } else {
                    fieldValues.set(field, value);
                } 
            } else {
                var field = s.name;
                var value = Reflect.field(Type.createEmptyInstance(cls), field);
                if (Reflect.isFunction(value)) {
                    fieldFunctions.set(field, (obj:ParserTokens, paramsArray) -> {
                        
                        return Reflect.callMethod(Conversion.toHaxeValue(obj), Reflect.field(Conversion.toHaxeValue(obj), field), paramsArray);
                    });
                } else {
                    fieldValues.set(field, (obj:ParserTokens) -> {
                        return Reflect.field(Conversion.toHaxeValue(obj), field);
                    });
                }
            }
           

		}

		//// Test the maps by printing the values of Math.PI and Math.sqrt()
		// trace(fieldValues);
		// trace(fieldFunctions);

		var motherObj = new MemoryObject(Module(littleClassName), [], null, Identifier(TYPE_MODULE), true); 

		for (instance in stats) {
			//trace(instance.fieldType, instance.allowWrite, instance.name, instance.parameters, instance.returnType);
			switch (instance.fieldType) {
				case "var":
					{
                        if (instance.isStatic) {
                            var value:ParserTokens = Conversion.toLittleValue(fieldValues[instance.name]);
						    var type:ParserTokens = Identifier(Conversion.toLittleType(instance.returnType));
						    motherObj.props.set(instance.name, new MemoryObject(value, [] /*Should this be implemented?*/, null, type, true, motherObj));
                        } else {
                            var value:ParserTokens = External(params -> {
                                return Conversion.toLittleValue(fieldValues[instance.name](params[0])); // params[0] should be the current var's value when using the function
                            });
                            var type:ParserTokens = Identifier(Conversion.toLittleType(instance.returnType));
                            motherObj.props.set(instance.name, new MemoryObject(value, [] /*Should this be implemented?*/, [
                                Variable(Identifier("value " /* That extra space is used to differentiate between non-static fields and functions. Todo: Pretty bad solution */), Identifier(littleClassName))
                            ], type, true, false, true, motherObj));
                        }
						
					}
				case "function": {
                    if (instance.isStatic) {
                        var value:ParserTokens = External((args) -> {
					    	return Conversion.toLittleValue(Reflect.callMethod(null, fieldFunctions[instance.name], [for (arg in args) Conversion.toHaxeValue(arg)]));
					    });

					    var type:ParserTokens = Identifier(Conversion.toLittleType(instance.returnType));
					    var params = [];
					    for (param in instance.parameters) 
					    	params.push(Variable(Identifier(param.name), Identifier(param.type)));

					    motherObj.props.set(instance.name, new MemoryObject(value, [] /*Should this be implemented?*/, params, type, true, motherObj));
                    } else {
                        var value:ParserTokens = External((args) -> {
                            var obj = args.shift();
                            var params = [for (a in args) Conversion.toHaxeValue(a)];
                            return Conversion.toLittleValue(fieldFunctions[instance.name](obj, params));
					    });

					    var type:ParserTokens = Identifier(Conversion.toLittleType(instance.returnType));
					    var params = [];
					    for (param in instance.parameters) 
					    	params.push(Variable(Identifier(param.name), Identifier(param.type)));
                        params.unshift(Variable(Identifier("value"), Identifier(littleClassName)));
					    motherObj.props.set(instance.name, new MemoryObject(value, [] /*Should this be implemented?*/, params, type, true, false, true, motherObj));
                    }

                    
				}
			}
		}

		Interpreter.memory.set(littleClassName, motherObj);
	}







































	
    public static function registerVariable(variableName:String, ?variableModuleName:String, allowWriting:Bool = false, ?staticValue:ParserTokens, ?valueGetter:Void -> ParserTokens, ?valueSetter:ParserTokens -> ParserTokens) {
        Interpreter.memory.set(variableName, new MemoryObject(
            External(params -> {
                var currentModuleName = Little.runtime.currentModule;
                if (variableModuleName != null) Little.runtime.currentModule = variableModuleName;
                return try {
                    var val = if (staticValue != null) staticValue;
                    else valueGetter();
                    Little.runtime.currentModule = currentModuleName;
                    val;
                } catch (e) {
                    Little.runtime.currentModule = currentModuleName;
                    ErrorMessage('External Variable Error: ' + e.details());
                }
            }), 
            [], 
            null,
            null, 
            true, 
            Interpreter.memory.object
        ));

        if (valueSetter != null) {
            Interpreter.memory.get(variableName).valueSetter = function (v) {
                return Interpreter.memory.get(variableName).value = valueSetter(v);
            }
        }
    }

    /**
    	Allows usage of a function written in haxe inside Little code.

    	@param actionName The name by which to identify the function
    	@param actionModuleName The module from which access to this function is granted. Also, when & if this function ever throws an error/prints to standard output, the name provided here will be present in the error message as the responsible module.
    	@param expectedParameters an `Array<ParserTokens>` consisting of `ParserTokens.Variable`s which contain the names & types of the parameters that should be passed on to the function. For example:
            ```
            [Variable(Identifier(x), Identifier("String"))]
            ```
    	@param callback 
    **/
    public static function registerFunction(actionName:String, ?actionModuleName:String, expectedParameters:EitherType<String, Array<ParserTokens>>, callback:Array<ParserTokens> -> ParserTokens) {
        var params = if (expectedParameters is String) {
            Parser.parse(Lexer.lex(expectedParameters));
        } else expectedParameters;

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
            Interpreter.memory.set(actionModuleName, new MemoryObject(Module(actionModuleName), [], null, Identifier(TYPE_MODULE), true, Interpreter.memory.object));
            memObject.parent = Interpreter.memory.get(actionModuleName);
            Interpreter.memory.get(actionModuleName).props.set(actionName, memObject);
        } else Interpreter.memory.set(actionName, memObject);
    }

    public static function registerCondition(conditionName:String, ?expectedConditionPattern:EitherType<String, Array<ParserTokens>> ,callback:(Array<ParserTokens>, Array<ParserTokens>) -> ParserTokens) {
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

    public static function registerProperty(propertyName:String, onObject:String, isType:Bool, ?valueOption1:FunctionInfo, ?valueOption2:VariableInfo) {
        if (isType) {
            if (!Interpreter.memory.exists(onObject) || Interpreter.memory.silentGet(onObject).value.getName() != "Module") {
                Interpreter.memory.set(onObject, new MemoryObject(Module(onObject), [], null, Identifier(TYPE_MODULE), true));
            }
        } else {
            if (!Interpreter.memory.exists(onObject)) {
                Interpreter.memory.set(onObject, new MemoryObject(NullValue, [], null, Identifier(TYPE_DYNAMIC), true));
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
                    Runtime.throwError(ErrorMessage('Directly editing the property $onObject$PROPERTY_ACCESS_SIGN$propertyName is disallowed. New value is ignored, returning original value.'));
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
}

typedef ItemInfo = {
	className:String,
	name:String,
	parameters:Array<{name:String, type:String, optional:Bool}>,
	returnType:String,
	fieldType:String,
	allowWrite:Bool,
    isStatic:Bool
}

typedef FunctionInfo = {
    expectedParameters:EitherType<String, Array<ParserTokens>>,
    callback:(MemoryObject, Array<ParserTokens>) -> ParserTokens, //parent, params to value
    ?allowWriting:Bool,
    ?type:String
}
typedef VariableInfo = {
    ?staticValue:ParserTokens, 
    ?valueGetter:MemoryObject -> ParserTokens, //parent to value
    ?valueSetter:(MemoryObject, ParserTokens) -> ParserTokens, //parent, provided value to value
    ?allowWriting:Bool,
    ?type:String
}
