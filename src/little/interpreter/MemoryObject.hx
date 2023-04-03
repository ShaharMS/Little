package little.interpreter;

import little.tools.PrettyPrinter;
import little.tools.Layer;
import little.parser.Tokens.ParserTokens;



@:structInit
/**
	Represents a function/variable in memory. contains usage fields.
**/
class MemoryObject {
    public var value(default, set):ParserTokens = NullValue;

    function set_value(val:ParserTokens) {
        value = valueSetter(val);
        for (setter in setterListeners) {
            setter(value);
        }
        return value;
    }

    @:optional public dynamic function valueSetter(val:ParserTokens) {
        return val;
    }

    /**
        Setter listeners can retrieve the new value right after its set, but theyre unable to directly edit it.  
        Each element of this array needs to be a function, that takes in a ParserToken (the new value), and return Void.
    **/
    @:optional public var setterListeners:Array<ParserTokens -> Void> = [];

    @:optional public var props:Map<String, MemoryObject> = [];
    @:optional public var params(default, set):Array<ParserTokens> = null;
    @:optional public var type:ParserTokens = null;
    @:optional public var external:Bool = false;
    @:optional public var condition:Bool = false;
    /**
    	When under a memory object, suppose, `T`, of type `"Type"`, it acts as a property of every object of type `T`.
    **/
    @:optional public var nonStatic:Bool = true;

    function set_params(parameters) {
        if (parameters == null) return params = null;
        return params = parameters.filter(p -> switch p {case SplitLine | SetLine(_): false; case _: true;});
    }

    public function new(?value:ParserTokens, ?props:Map<String, MemoryObject>, ?params:Array<ParserTokens>, ?type:ParserTokens, ?external:Bool, ?condition:Bool, ?nonStatic:Bool) {
        this.value = value == null ? NullValue : value;
        this.props = props == null ? [] : props;
        this.params = params;
        this.type = type;
        this.external = external == null ? false : external;
        this.condition = condition == null ? false : condition;
        this.nonStatic = nonStatic == null ? true : nonStatic;
    }


    public function use(parameters:ParserTokens):ParserTokens {

        if (condition) {
            // trace("condition");
            if (value.getName() != "ExternalCondition") return ErrorMessage('Undefined external condition');
            if (parameters.getName() != "PartArray") return ErrorMessage('Incorrect parameter group format, given group format: ${parameters.getName()}, expectedFormat: ${PartArray}');
            // trace("checks passed");
            // trace(parameters.getParameters()[0][0]);
            var con = (parameters.getParameters()[0][0] : ParserTokens).getParameters()[0];
            var body = (parameters.getParameters()[0][1] : ParserTokens).getParameters()[0];

            if (params != null) { // Used to "strongly type" the condition
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
            
                if (given.length != params.length) return ErrorMessage('Incorrect number of expressions in condition, expected: ${params.length} (${PrettyPrinter.parseParamsString(params)}), given: ${given.length} (${PrettyPrinter.parseParamsString(given, false)})');
                
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

        if (params == null) return ErrorMessage('Cannot call definition');
        if (parameters.getName() != "PartArray") return ErrorMessage('Incorrect parameter group format, given group format: ${parameters.getName()}, expectedFormat: ${PartArray}');


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

        if (given.length != params.length) return ErrorMessage('Incorrect number of parameters, expected: ${params.length} (${PrettyPrinter.parseParamsString(params)}), given: ${given.length} (${PrettyPrinter.parseParamsString(given, false)})');

        given = [for (element in given) Interpreter.evaluate(element)];

        if (external) {
            if (value.getName() != "External") return ErrorMessage('Undefined external function');
            return (value.getParameters()[0] : Array<ParserTokens> -> ParserTokens)(given);
        } else {
            var paramsDecl = [];
            for (i in 0...given.length) {
                paramsDecl.push(Write([params[i]], given[i], null));
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
            return Interpreter.runTokens(body, null, null, null);
        }
    }
}