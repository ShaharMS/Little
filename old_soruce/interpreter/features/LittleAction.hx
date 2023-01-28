package little.interpreter.features;

import little.interpreter.constraints.Scope;
import little.interpreter.constraints.Parameter;
import little.interpreter.constraints.Action;

class LittleAction implements Action {
    
	public var startLine:Int;

	public var parameters:Array<Parameter>;

    public function new() {}

	public var name:String;

	public var returnType:String;

	public var scope:{scope:Scope, info:String, initializationLine:Int}
}