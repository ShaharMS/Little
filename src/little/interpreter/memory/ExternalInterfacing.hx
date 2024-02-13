package little.interpreter.memory;

import haxe.extern.EitherType;
import haxe.Exception;
import little.tools.Conversion;
import little.tools.Tree;
import little.interpreter.Tokens.InterpTokens;

class ExternalInterfacing {
	
	public var parent:Memory;
	
	/**
	    For each type registered, a pointer to the type must be provided
	**/
	public var typeToPointer:Map<String, MemoryPointer>;

	/**
	    Inverse of `typeToPointer`, not performance efficient
	**/
	public var pointerToType(get ,null):Map<MemoryPointer, String>;
	@:noCompletion function get_pointerToType() {
		var pointerToType = new Map<MemoryPointer, String>();
		for (type => pointer in typeToPointer) {
			pointerToType[pointer] = type;
		}

		return pointerToType;
	}

	/**
	    Properties of instances of a certain type.
		for example, one may want to define a `length` property on an array
	**/
	public var instanceProperties:VarExtTree = new VarExtTree();

	/**
	    Methods of instances of a certain type.
		for example, one may want to define a `push` method on an array
	**/
	public var instanceMethods:FunExtTree = new FunExtTree();

	/**
	    Global static variables, defined using a path to the property.
	**/
	public var globalProperties:VarExtTree = new VarExtTree();

	/**
	    Global static functions, defined using a path to the property.
	**/
	public var globalMethods:FunExtTree = new FunExtTree();

	public function new(memory:Memory) {
		parent = memory;
		typeToPointer = new Map<String, MemoryPointer>();
		CoreTypes.addFor(this);
	}

	public function createPathFor(extType:EitherType<VarExtTree, FunExtTree>, ...path:String) {
		var identifiers = path.toArray();

		var handle = extType;
		while (identifiers.length > 0) { 
			var identifier = identifiers.shift();
			if (untyped handle.properties.exists(identifier)) {
				handle = untyped handle.properties[identifier];
			} else {
				untyped {
					handle.properties[identifier] = extType is VarExtTree ? new VarExtTree() : new FunExtTree();
					handle = handle.properties[identifier];
				}
			}
		}
	}

	public function hasGlobal(...path:String):Bool {
		var identifiers = path.toArray();

		var handle = globalProperties;
		while (identifiers.length > 0) {
			var identifier = identifiers.shift();
			if (handle.properties.exists(identifier))
				handle = handle.properties[identifier];
			else
				return false;
		}

		return true;
	}

	public function getGlobal(...path:String):{objectValue:InterpTokens, objectAddress:MemoryPointer, objectDoc:String} {
		var identifiers = path.toArray();
		
		var handle = globalProperties;
		for (ident in identifiers) {
			handle = handle.properties[ident];
		}

		return handle.getter(null, null); // Static externs are not tied to any runtime object, so this makes sense
	}
}

class VarExtTree {

	public var getter:(objectValue:InterpTokens, objectAddress:MemoryPointer) -> {objectValue:InterpTokens, objectAddress:MemoryPointer, objectDoc:String};

	public var properties:Map<String, VarExtTree>;

	public function new(?getter:(objectValue:InterpTokens, objectAddress:MemoryPointer) -> {objectValue:InterpTokens, objectAddress:MemoryPointer, objectDoc:String}, ?properties:Map<String, VarExtTree>) {
		this.getter = getter ?? (objectValue, objectAddress) -> {
			return {
				objectValue: Characters('Externally registered, attached to $objectAddress'),
				objectAddress: objectAddress,
				objectDoc: ""
			}
		}
		this.properties = properties ?? new Map<String, VarExtTree>();
	}
}

class FunExtTree {

	public var doc:String;
	public var caller:(objectValue:InterpTokens, objectAddress:MemoryPointer, params:Array<{objectValue:InterpTokens, objectAddress:MemoryPointer}>) -> {objectValue:InterpTokens, objectAddress:MemoryPointer};

	public var properties:Map<String, FunExtTree>;

	public function new(?caller:(objectValue:InterpTokens, objectAddress:MemoryPointer, params:Array<{objectValue:InterpTokens, objectAddress:MemoryPointer}>) -> {objectValue:InterpTokens, objectAddress:MemoryPointer}, ?properties:Map<String, FunExtTree>, ?doc:String) {
		this.caller = caller ?? (objectValue, objectAddress, params) -> {
			return {
				objectValue: Characters('Externally registered, attached to $objectAddress'),
				objectAddress: objectAddress,
			}
		}
		this.properties = properties ?? new Map<String, FunExtTree>();
		this.doc = doc ?? "";
	}
}