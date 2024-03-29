package little.interpreter.memory;

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

		Use `TYPE_DYNAMIC` to have a property for every single type. PAY ATTENTION - it blocks this word from being used as a property name for an object.
	**/
	public var instanceProperties:ExtTree = new ExtTree(0, null, null, 0);

	/**
	    Global static variables, defined using a path to the property.
	**/
	public var globalProperties:ExtTree = new ExtTree(0, null, null, 0);

	public function new(memory:Memory) {
		parent = memory;
		typeToPointer = new Map<String, MemoryPointer>();
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

	public function hasInstance(...path:String):Bool {
		var identifiers = path.toArray();
		
		var handle = instanceProperties;
		while (identifiers.length > 0) {
			var identifier = identifiers.shift();
			if (handle.properties.exists(identifier))
				handle = handle.properties[identifier];
			else
				return false;
		}

		return true;
	}

	public function getGlobal(...path:String):{objectValue:InterpTokens, objectAddress:MemoryPointer} {
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
	public var getter:(objectValue:InterpTokens, objectAddress:MemoryPointer) -> {objectValue:InterpTokens, objectAddress:MemoryPointer};

	/**
	    A pointer to this prop's doc. Used instead of string to avoid re-allocations.
	**/
	public var doc:MemoryPointer;

	/**
	    A pointer to the type this prop's getter returns. Used for providing consistent behavior for runtime type info acquisition.
	**/
	public var type:MemoryPointer;

	public var properties:Map<String, ExtTree>;

	public function new(?type:MemoryPointer, ?getter:(objectValue:InterpTokens, objectAddress:MemoryPointer) -> {objectValue:InterpTokens, objectAddress:MemoryPointer}, ?properties:Map<String, ExtTree>, ?doc:MemoryPointer) {
		this.getter = getter ?? (objectValue, objectAddress) -> {
			return {
				objectValue: Characters('Externally registered, attached to $objectAddress'),
				objectAddress: objectAddress,
			}
		}
		this.properties = properties ?? new Map<String, ExtTree>();
		this.doc = doc ?? Little.memory.constants.EMPTY_STRING;
		this.type = type ?? Little.memory.constants.UNKNOWN;
	}
}