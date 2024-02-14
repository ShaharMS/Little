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
	public var instanceProperties:ExtTree = new ExtTree();

	/**
	    Global static variables, defined using a path to the property.
	**/
	public var globalProperties:ExtTree = new ExtTree();

	public function new(memory:Memory) {
		parent = memory;
		typeToPointer = new Map<String, MemoryPointer>();
		CoreTypes.addFor(this);
	}

	public function createPathFor(extType:ExtTree, ...path:String):ExtTree {
		var identifiers = path.toArray();

		var handle = extType;
		while (identifiers.length > 0) { 
			var identifier = identifiers.shift();
			if (handle.properties.exists(identifier)) {
				handle = handle.properties[identifier];
			} else {
				handle.properties[identifier] = new ExtTree();
				handle = handle.properties[identifier];
			}
		}

		return handle;
	}

	public function createAllPathsFor(...path:String) {
		for (tree in [globalProperties, instanceProperties]) {
			createPathFor(tree, ...path);
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

class ExtTree {

	/**
	    A getter for the extern value.
		The returned token has its parent's address in memory and value, if you want to modify it.
	**/
	public var getter:(objectValue:InterpTokens, objectAddress:MemoryPointer) -> {objectValue:InterpTokens, objectAddress:MemoryPointer, objectDoc:String};

	public var properties:Map<String, ExtTree>;

	public function new(?getter:(objectValue:InterpTokens, objectAddress:MemoryPointer) -> {objectValue:InterpTokens, objectAddress:MemoryPointer, objectDoc:String}, ?properties:Map<String, ExtTree>) {
		this.getter = getter ?? (objectValue, objectAddress) -> {
			return {
				objectValue: Characters('Externally registered, attached to $objectAddress'),
				objectAddress: objectAddress,
				objectDoc: ""
			}
		}
		this.properties = properties ?? new Map<String, ExtTree>();
	}
}