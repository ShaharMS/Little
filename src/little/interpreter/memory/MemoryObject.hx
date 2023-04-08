package little.interpreter.memory;

import little.tools.PrettyPrinter;
import little.tools.Layer;
import little.parser.Tokens.ParserTokens;


@:structInit
/**
	Represents a function/variable in memory. contains usage fields.
**/
class MemoryObject {

    @:noCompletion public static var objects:Array<MemoryObject> = [];

    public static var defaultProperties:Map<String, MemoryObject> = [];

    public static function addDefaultProperty(name:String, value:MemoryObject) {
        defaultProperties[name] = value;
        for (obj in objects) obj.props.set(name, value);
    }

    public static function removeDefaultProperty(name:String) {
        defaultProperties.remove(name);
        for (obj in objects) obj.props.remove(name);
    }

    @:optional public var parent:MemoryObject;

    public var value(default, set):ParserTokens = NullValue;

    function set_value(val:ParserTokens) {
        var t = Interpreter.getValueType(val);
        if (type == null && t != null) type = t;
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

    @:optional public var props:MemoryTree;
    @:optional public var params(default, set):Array<ParserTokens> = null;
    @:optional public var type:ParserTokens = null;
    @:optional public var external:Bool = false;
    @:optional public var condition:Bool = false;
    /**
    	When under a memory object, suppose, `T`, of type `"Type"`, it acts as a property of every object of type `Type`.
    **/
    @:optional public var nonStatic:Bool = true;

    function set_params(parameters) {
        if (parameters == null) return params = null;
        return params = parameters.filter(p -> switch p {case SplitLine | SetLine(_): false; case _: true;});
    }

    public function new(?value:ParserTokens, ?props:MemoryTree, ?params:Array<ParserTokens>, ?type:ParserTokens, ?external:Bool, ?condition:Bool, ?nonStatic:Bool, ?parent:MemoryObject) {
        this.value = value == null ? NullValue : value;
        this.params = params;
        this.type = type == null ? Interpreter.getValueType(this.value) : type;
        this.external = external == null ? false : external;
        this.condition = condition == null ? false : condition;
        this.nonStatic = nonStatic == null ? true : nonStatic;
        this.props = new MemoryTree(this);
        this.parent = parent != null ? parent : this; //Interesting solution
        this.props.concat(defaultProperties);

        objects.push(this);
        if (value.getParameters()[0] == "hey") trace(this.props);
    }


    public function use(parameters:ParserTokens):ParserTokens {

        if (condition) {
            // trace("condition");
            if (value.getName() != "ExternalCondition") return ErrorMessage('Undefined external condition');
            if (parameters.getName() != "PartArray") return ErrorMessage('Incorrect parameter group format, given group format: ${parameters.getName()}, expected Format: `PartArray`');
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
        if (parameters.getName() != "PartArray") return ErrorMessage('Incorrect parameter group format, given group format: ${parameters.getName()}, expected Format: `PartArray`');


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

        //given = [for (element in given) Interpreter.evaluate(element)];

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