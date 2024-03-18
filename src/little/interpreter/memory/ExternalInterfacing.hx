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
	/** ExternalInterfacing.pointerToType getter **/ @:noCompletion function get_pointerToType() {
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

	/**
		Instantiates a new `ExternalInterfacing`.
	**/
	public function new(memory:Memory) {
		parent = memory;
		typeToPointer = new Map<String, MemoryPointer>();
	}

	/**
		Creates an object at the end of the path. If some of the path does not exist, it will be created.

		This function only creates paths at a specific tree - either `globalProperties` or `instanceProperties`.

		@param extType The tree to create the object in - either `globalProperties` or `instanceProperties`.
		@param path The path to the object. Provided as individual parameters. To use an array, use `...pathArray`
		@return The created object at the end of the path, of type `ExtTree` (External Tree)
	**/
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

	/**
		Helper function that uses `createPathFor` to create all possible paths for an object,
		on both `globalProperties` and `instanceProperties`.

		@param path The path to the object. Provided as individual parameters. To use an array, use `...pathArray`
	**/
	public function createAllPathsFor(...path:String) {
		for (tree in [globalProperties, instanceProperties]) {
			createPathFor(tree, ...path);
		}
	}

	/**
		Checks if a static object exists at the end of the path
		@param path The path to the object. Provided as individual parameters. To use an array, use `...pathArray`
		@return `true` if the object exists, `false` otherwise
	**/
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

	/**
		Checks if an instance field exists at the end of the path
		@param path The path to the object. Provided as individual parameters. To use an array, use `...pathArray`
		@return `true` if the object exists, `false` otherwise
	**/
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

	/**
		Gets a static object at the end of the path.

		@param path The path to the object. Provided as individual parameters. To use an array, use `...pathArray`
		@return The object at the end of the path, as a combination of `InterpTokens` and `MemoryPointer` 
	**/
	public function getGlobal(...path:String):{objectValue:InterpTokens, objectAddress:MemoryPointer} {
		var identifiers = path.toArray();
		
		var handle = globalProperties;
		for (ident in identifiers) {
			handle = handle.properties[ident];
		}

		return handle.getter(null, null); // Static externs are not tied to any runtime object, so this makes sense
	}
}

/**
	The External Object Tree. Used to store information about an external object.
**/
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

	/**
		This `ExtTree`'s children.
	**/
	public var properties:Map<String, ExtTree>;

	/**
		Instantiates a new `ExtTree`

		@param type The `Little` type this `ExtTree`'s getter should return. Used for runtime type information 
		@param getter The getter for the `ExtTree`, can be used in 2 ways - in the global tree, the two arguments are `null` and `null`. 
		In the instance tree, the arguments are the parent object's value and it's address in memory. In both cases, the returned value should be a value, 
		and it's address in memory.
		@param properties The properties of this tree. Used to quickly populate this `ExtTree` with child trees.
		@param doc The documentation of the field this `ExtTree` represents. 
	**/
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