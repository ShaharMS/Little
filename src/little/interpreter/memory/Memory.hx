package little.interpreter.memory;

import little.tools.PrettyPrinter;
import little.interpreter.memory.MemoryPointer.POINTER_SIZE;
import little.tools.TextTools;
import little.interpreter.Tokens.InterpTokens;
import vision.ds.ByteArray;

using little.tools.Extensions;
using vision.tools.MathTools;

class Memory {

    public var storage:Storage;
	public var referrer:Referrer;
	public var externs:ExternalInterfacing;
    public var constants:ConstantPool;

	@:noCompletion public var memoryChunkSize:Int = 512; // 512 bytes

	/**
		The maximum amount of memory that can be allocated, by bytes.
		By default, this is 2GB.
	**/
	public var maxMemorySize:Int = 1024 * 1024 * 2;

	/**
		The current amount of memory allocated, in bytes.
	**/
	public var currentMemorySize(get, never):Int;
	/** Memory.currentMemorySize getter **/ @:noCompletion function get_currentMemorySize() {
		return storage.reserved.length + referrer.bytes.length;
	}

	/**
		Instantiates a new `Memory`.
	**/
	public function new() {
		storage = new Storage(this);
		referrer = new Referrer(this);
		constants = new ConstantPool(this);
		externs = new ExternalInterfacing(this);
	}

	/**
		Resets all stored values, and releases all extra allocated memory.
	**/
	public function reset() {
		storage = new Storage(this);
		referrer = new Referrer(this);
		externs = new ExternalInterfacing(this);
		// Constants don't need to be reset
	}

	/**
		General-purpose memory allocation for objects:

		- if `token` is `true`, `false`, `0`, or `null`, it pulls a pointer from the constant pool
		- if `token` is a string, a number, a sign or a decimal, it stores & pulls a pointer from the storage.
		- if `token` is a structure, it stores it on the storage, and returns a pointer to it.
		- if `token` is a `ClassPointer`, it returns it's address.
	**/
	public function store(token:InterpTokens):MemoryPointer {
		if (token.is(TRUE_VALUE, FALSE_VALUE, NULL_VALUE)) {
			return constants.get(token);
		} else if (token.staticallyStorable()) {
			return storage.storeStatic(token);
		} else if (token.is(OBJECT)) {
			return storage.storeObject(token);
		} else if (token.is(FUNCTION_CODE, BLOCK)) {
			return storage.storeCodeBlock(token);
		} else if (token.is(CONDITION_CODE)) {
			return storage.storeCondition(token);
		} else if (token.is(CLASS_POINTER)) {
			return token.parameter(0);
		}

		Little.runtime.throwError(ErrorMessage('Unable to allocate memory for token `$token`.'), MEMORY_STORAGE);
		throw 'Unable to allocate memory for token `$token`.';
	}

	/**
	    Similar to the `store` function, but respects pass by value/reference rules.

		Whether an object of type `T` is passed by reference or not is dictated by the value of a field
		named `passedByReference`. This field cannot be changed at runtime for existing types.

		@param token A simple token (for which the returned value will be the same as a `store` call), or an identifiable
		token (evaluable by `Extensions.extractIdentifier`), specifically ones that return some sort of a "path" to that value. 
		@return A pointer to that location/value.
	**/
	public function retrieve(token:InterpTokens):MemoryPointer {
		switch token {
			case _ if (token.is(TRUE_VALUE, FALSE_VALUE, NULL_VALUE, OBJECT, FUNCTION_CODE, BLOCK, CONDITION_CODE, CLASS_POINTER) || token.passedByValue()): {
				return store(token);
			}
			case Identifier(_) | PropertyAccess(_, _): {
				var path = token.asStringPath();
				var cell = read(...path);
				if (cell.objectValue.passedByValue()) return store(cell.objectValue);
				return cell.objectAddress;
			}
			case Block(_, _) | Expression(_, _): {
				var result = Interpreter.evaluate(token);
				switch result {
					case Identifier(_) | PropertyAccess(_, _): retrieve(result);
					case _: {
						Little.runtime.throwError(ErrorMessage('Code block returned a value that cannot be read from (for value: ${PrettyPrinter.stringifyInterpreter(result)})'));
						throw 'Unable to retrieve a pointer to token $result';
					}
				}
			}
			case _:
		}

		Little.runtime.throwError(ErrorMessage('Unable to retrieve a pointer to token $token'));
		throw 'Unable to retrieve a pointer to token $token';
	}

	/**
		Reads the value at the end of the path.

		@param path The path to read. Provided as individual parameters. To use an array, use `...pathArray`.
		@return an anonymous structure: `{objectValue:InterpTokens, objectTypeName:String, objectAddress:MemoryPointer}`.
	**/
	public function read(...path:String):{objectValue:InterpTokens, objectTypeName:String, objectAddress:MemoryPointer} {
		// If the path is empty, we just return null
		if (path.length == 0) {
			return {
				objectValue: null,
				objectTypeName: null,
				objectAddress: null,
			}
		}

		var current:InterpTokens = null;
		var currentAddress:MemoryPointer = null;
		var currentType:String = null;

		var processed = path.toArray();
		var wentThroughPath = [];

		// Before anything, global external values are prioritized

		if (externs.hasGlobal(processed[0])) {
			if (externs.hasGlobal(...path)) {
				var object = externs.getGlobal(...path);
				var typeName = getTypeName(externs.createPathFor(externs.globalProperties, ...path).type);
				return {
					objectValue: object.objectValue,
					objectTypeName: typeName,
					objectAddress: object.objectAddress,
				}
			} else {
				var external = [processed.shift()];
				wentThroughPath.push(external[0]);
				while (externs.hasGlobal(...external.concat([processed[0]]))) {
					external.push(processed.shift());
					wentThroughPath.push(external[external.length - 1]);
				}
				var object = externs.getGlobal(...external);
				current = object.objectValue;
				currentAddress = object.objectAddress;
				currentType = getTypeName(externs.createPathFor(externs.globalProperties, ...external).type);
			}
		} else {

			// If we didn't find anything on the externs, we look in the current scope.
			if (!referrer.exists(path[0])) {
				Little.runtime.throwError(ErrorMessage('Variable `${path[0]}` does not exist'), MEMORY_REFERRER);
			}
			var data = referrer.get(path[0]);
			current = switch data.type {
				case (_ == Little.keywords.TYPE_STRING => true): Characters(storage.readString(data.address));
				case (_ == Little.keywords.TYPE_INT => true): Number(storage.readInt32(data.address));
				case (_ == Little.keywords.TYPE_FLOAT => true): Decimal(storage.readDouble(data.address));
				case (_ == Little.keywords.TYPE_BOOLEAN => true): constants.getFromPointer(data.address);
				case (_ == Little.keywords.TYPE_FUNCTION => true): storage.readCodeBlock(data.address);
				case (_ == Little.keywords.TYPE_CONDITION => true): storage.readCondition(data.address);
				case (_ == Little.keywords.TYPE_MODULE => true): ClassPointer(data.address);
	            // Because of the way we store lone nulls (as type dynamic), 
	            // they might get confused with objects of type dynamic, so we need to do this:
	            case (_ == Little.keywords.TYPE_DYNAMIC && constants.hasPointer(data.address) && constants.getFromPointer(data.address).equals(NullValue) => true): NullValue;
	            case (_ == Little.keywords.TYPE_SIGN => true): storage.readSign(data.address);
				case _: storage.readObject(data.address);
			}
			currentAddress = data.address;
			currentType = data.type;
			wentThroughPath.push(processed.shift()); // We already went through with it in the code above
		}
		
		while (processed.length > 0) {
			// Get the current field, and the type of that field as well
			var identifier = processed.shift();
			wentThroughPath.push(identifier);
			var typeName = current.type();
			// By design, the only other way properties are accessible on non-object
			// values is through externs. So, after the object checks, we only need to look there.
			// We should notice that, like before, externs are prioritized, so externs are evaluated first.
		
			// Property check:
			if (externs.hasInstance(...typeName.split(Little.keywords.PROPERTY_ACCESS_SIGN))) {
				var classProperties = externs.instanceProperties.properties.get(typeName);
				if (classProperties.properties.exists(identifier)) {
					var newCurrent = classProperties.properties.get(identifier).getter(current, currentAddress);
					current = newCurrent.objectValue;
					currentAddress = newCurrent.objectAddress;
					continue;
				}
			}
			// If it doesn't exist on that specific type, it may exist on TYPE_DYNAMIC:
			if (externs.hasInstance(...Little.keywords.TYPE_DYNAMIC.split(Little.keywords.PROPERTY_ACCESS_SIGN))) {
				var classProperties = externs.instanceProperties.properties.get(Little.keywords.TYPE_DYNAMIC);
				if (classProperties.properties.exists(identifier)) {
					var newCurrent = classProperties.properties.get(identifier).getter(current, currentAddress);
					current = newCurrent.objectValue;
					currentAddress = newCurrent.objectAddress;
					continue;
				}
			}

			// Then, we check the object's hash table for that field
			if (current.is(OBJECT)) {
				var objectHashTableBytes = HashTables.getHashTableOf(currentAddress, storage);
				
				if (HashTables.hashTableHasKey(objectHashTableBytes, identifier, storage)) {
					var keyData = HashTables.hashTableGetKey(objectHashTableBytes, identifier, storage);
					switch getTypeName(keyData.type) {
						case (_ == Little.keywords.TYPE_STRING => true): current = Characters(storage.readString(keyData.value));
						case (_ == Little.keywords.TYPE_INT => true): current = Number(storage.readInt32(keyData.value));
						case (_ == Little.keywords.TYPE_FLOAT => true): current = Decimal(storage.readDouble(keyData.value));
						case (_ == Little.keywords.TYPE_BOOLEAN => true): current = constants.getFromPointer(keyData.value);
						case (_ == Little.keywords.TYPE_FUNCTION => true): current = storage.readCodeBlock(keyData.value);
						case (_ == Little.keywords.TYPE_CONDITION => true): current = storage.readCondition(keyData.value);
						case (_ == Little.keywords.TYPE_MODULE => true): current = ClassPointer(keyData.value);
						case (keyData.value == constants.NULL => true): current = NullValue;
						case (_ == Little.keywords.TYPE_SIGN => true): current = storage.readSign(keyData.value);
						case _: current = storage.readObject(keyData.value);
					}

					currentAddress = keyData.value;
				}
			}

			// If we still don't have a value, we throw an error, cause that means that field doesn't exist.
			else {
				wentThroughPath.pop();
				var p = wentThroughPath.join(Little.keywords.PROPERTY_ACCESS_SIGN);
				Little.runtime.throwError(ErrorMessage('Field `$identifier` does not exist on `$p` ${current.is(NULL_VALUE) ? '(`$p` is `${Little.keywords.NULL_VALUE}`)' : ''}'));
				return {
					objectValue: NullValue,
					objectAddress: constants.NULL,
					objectTypeName: Little.keywords.TYPE_DYNAMIC,
				}
			}
		}


		return {
			objectValue: current,
			objectAddress: currentAddress,
			objectTypeName: current.type()
		}
	}

	/**
		Starts reading from a specified value instead of preforming a lookup, and returns the value at the end of the path, when
		originating from the given value.
		@param value a value-address pair
		@param path the path to the value. Provided as individual parameters. To use an array, use `...pathArray`
	**/
	public function readFrom(value:{objectValue:InterpTokens, objectAddress:MemoryPointer}, ...path:String) {
		var current = value.objectValue;
		var currentAddress = value.objectAddress;

		var processed = path.toArray();
		var wentThroughPath = [];
		while (processed.length > 0) {
			// Get the current field, and the type of that field as well
			var identifier = processed.shift();
			wentThroughPath.push(identifier);
			var typeName = current.type();
			// By design, the only other way properties are accessible on non-object
			// values is through externs. So, after the object checks, we only need to look there.
			// We should notice that, like before, externs are prioritized, so externs are evaluated first.
		
			// Property check:
			if (externs.hasInstance(...typeName.split(Little.keywords.PROPERTY_ACCESS_SIGN))) {
				var classProperties = externs.instanceProperties.properties.get(typeName);
				if (classProperties.properties.exists(identifier)) {
					var newCurrent = classProperties.properties.get(identifier).getter(current, currentAddress);
					current = newCurrent.objectValue;
					currentAddress = newCurrent.objectAddress;
					continue;
				}
			}
			// If it doesn't exist on that specific type, it may exist on TYPE_DYNAMIC:
			if (externs.hasInstance(...Little.keywords.TYPE_DYNAMIC.split(Little.keywords.PROPERTY_ACCESS_SIGN))) {
				var classProperties = externs.instanceProperties.properties.get(Little.keywords.TYPE_DYNAMIC);
				if (classProperties.properties.exists(identifier)) {
					var newCurrent = classProperties.properties.get(identifier).getter(current, currentAddress);
					current = newCurrent.objectValue;
					currentAddress = newCurrent.objectAddress;
					continue;
				}
			}

			// Then, we check the object's hash table for that field
			if (current.is(OBJECT)) {
				var objectHashTableBytesLength = storage.readInt32(currentAddress);
				var objectHashTableBytes = storage.readBytes(currentAddress.rawLocation + 4, objectHashTableBytesLength);
				
				if (HashTables.hashTableHasKey(objectHashTableBytes, identifier, storage)) {
					var keyData = HashTables.hashTableGetKey(objectHashTableBytes, identifier, storage);
					
					switch getTypeName(keyData.type) {
						case (_ == Little.keywords.TYPE_STRING => true): current = Characters(storage.readString(keyData.value));
						case (_ == Little.keywords.TYPE_INT => true): current = Number(storage.readInt32(keyData.value));
						case (_ == Little.keywords.TYPE_FLOAT => true): current = Decimal(storage.readDouble(keyData.value));
						case (_ == Little.keywords.TYPE_BOOLEAN => true): current = constants.getFromPointer(keyData.value);
						case (_ == Little.keywords.TYPE_FUNCTION => true): current = storage.readCodeBlock(keyData.value);
						case (_ == Little.keywords.TYPE_CONDITION => true): current = storage.readCondition(keyData.value);
						case (_ == Little.keywords.TYPE_MODULE => true): current = ClassPointer(keyData.value);
						case (keyData.value == constants.NULL => true): current = NullValue;
						case (_ == Little.keywords.TYPE_SIGN => true): current = storage.readSign(keyData.value);
						case _: current = storage.readObject(keyData.value);
					}

					currentAddress = keyData.value;
				}
			}

			// If we still don't have a value, we throw an error, cause that means that field doesn't exist.
			else {
				wentThroughPath.pop();
				var p = wentThroughPath.join(Little.keywords.PROPERTY_ACCESS_SIGN);
				Little.runtime.throwError(ErrorMessage('Field `$identifier` does not exist on `$p` ${current.is(NULL_VALUE) ? '(`$p` is `${Little.keywords.NULL_VALUE}`)' : ''}'));
				return {
					objectValue: NullValue,
					objectAddress: constants.NULL,
					objectTypeName: Little.keywords.TYPE_DYNAMIC,
				}
			}
		}


		return {
			objectValue: current,
			objectAddress: currentAddress,
			objectTypeName: current.type()
		}
	}

	/**
		Writes a new value to a **new** path specified by `path`.

		If a part of the path doesn't exist which is not it's end, an error will be thrown in `Little`'s runtime.

		If the path fully exists, it's value will be overwritten
		If `value` is given as an identifier/property access/block, there will be an attempt
		to retrieve the original object's address there, if it's type has `passedByReference` set to `true`. See `Memory.retrieve`


		@param path An array of strings representing the path to the value
		@param value The value to write. If `null`, the value will be set to `NullValue`
		@param type The type of the value. If `null`, the type will be set to `TYPE_DYNAMIC`
		@param doc The documentation of the value. If `null`, the documentation will be set to `""`
	**/
	public function write(path:Array<String>, ?value:InterpTokens, ?type:String, ?doc:String) {
		// A couple notices:
		/*
			- The first n-1 elements of the path must exist beforehand, and must be objects
			- The last element will be a field of the last object
		*/

		if (path.length == 0) {
			Little.runtime.throwError(ErrorMessage('Cannot write to an empty path'));
			// Does not make sense to have a path of length 0, but still more useful than a quiet return/crash.
		}

		if (path.length == 1) {
			referrer.reference(path[0], retrieve(value), type);

		} else {
			var pathCopy = path.slice(0, path.length - 1);
			var wentThroughPath = [path[0]];
			var current = referrer.get(pathCopy.shift());
			while (pathCopy.length > 0) {
				if (!getTypeInformation(current.type).passedByReference) {
					Little.runtime.throwError(ErrorMessage('Cannot write to a static type. Only objects can have dynamic properties (${wentThroughPath.join(Little.keywords.PROPERTY_ACCESS_SIGN)} is `${current.type}`)'));
				}
				if (!HashTables.hashTableHasKey(HashTables.getHashTableOf(current.address, storage), pathCopy[0], storage)) {
					var a = wentThroughPath.concat([pathCopy[0]]).join(Little.keywords.PROPERTY_ACCESS_SIGN);
					Little.runtime.throwError(ErrorMessage('Cannot write a property to ${a}, since ${pathCopy[0]} does not exist (did you forget to define ${a}?)'));
				}
				var hashTableKey = HashTables.hashTableGetKey(HashTables.getHashTableOf(current.address, storage), pathCopy[0], storage);
				current = {
					address: hashTableKey.value,
					type: getTypeName(hashTableKey.type),
				}
				wentThroughPath.push(pathCopy.shift());
			}
			if (!getTypeInformation(current.type).passedByReference) {
				Little.runtime.throwError(ErrorMessage('Cannot write to a property to values of a static type. Only objects can have dynamic properties (${wentThroughPath.join(Little.keywords.PROPERTY_ACCESS_SIGN)} is `${current.type}`)'));
			}
			if (!HashTables.hashTableHasKey(HashTables.getHashTableOf(current.address, storage), path[path.length - 1], storage)) {
				HashTables.objectAddKey(current.address, path[path.length - 1], retrieve(value), getTypeInformation(type).pointer, storage.storeString(doc), storage);
			} else if (externs.instanceProperties.properties.exists(path[path.length - 1])) {
				Little.runtime.throwError(ErrorMessage('Cannot write to an extern property (${path[path.length - 1]})'));
			} else {
				HashTables.objectSetKey(current.address, path[path.length - 1], {value: value != null ? retrieve(value) : null, type: type != null ? getTypeInformation(type).pointer : null, doc: doc != null ? storage.storeString(doc) : null}, storage);
			}
		}
	}

	/**
		Writes a new value to an **existing** path specified by `path`.
		
		If any part of the path does not exist, an error will be thrown in `Little`'s runtime.

		@param path An array of strings representing the path to the value
		@param value The value to write. If `null`, the original value will be preserved
		@param type The type of the value. If `null`, the original type will be preserved
		@param doc The documentation of the value. If `null`, the original documentation will be preserved
	**/
	public function set(path:Array<String>, ?value:InterpTokens, ?type:String, ?doc:String) {

		if (path.length == 0) {
			Little.runtime.throwError(ErrorMessage('Cannot set the value of an empty path'));
			// Does not make sense to have a path of length 0, but still more useful than a quiet return/crash.
		}

		if (path.length == 1) {
			if (referrer.exists(path[0])) {
				referrer.set(path[0], { address: value != null ? retrieve(value) : null, type: type != null ? type : null});
			} else {
				Little.runtime.throwError(ErrorMessage('Variable/function ${path[0]} does not exist'));
			}
		} else {
			var pathCopy = path.slice(0, path.length - 1);
			var wentThroughPath = [path[0]];
			var current = referrer.get(pathCopy.shift());
			while (pathCopy.length > 0) {
				if (!getTypeInformation(current.type).passedByReference) {
					Little.runtime.throwError(ErrorMessage('Cannot set properties to values of a static type. Only objects can have dynamic properties (${wentThroughPath.join(Little.keywords.PROPERTY_ACCESS_SIGN)} is `${current.type}`)'));
				}
				if (!HashTables.hashTableHasKey(HashTables.getHashTableOf(current.address, storage), pathCopy[0], storage)) {
					var a = wentThroughPath.concat([pathCopy[0]]).join(Little.keywords.PROPERTY_ACCESS_SIGN);
					Little.runtime.throwError(ErrorMessage('Cannot set a property of ${a}, since ${pathCopy[0]} does not exist (did you forget to define ${a}?)'));
				}
				var hashTableKey = HashTables.hashTableGetKey(HashTables.getHashTableOf(current.address, storage), pathCopy[0], storage);
				current = {
					address: hashTableKey.value,
					type: getTypeName(hashTableKey.type),
				}
				wentThroughPath.push(pathCopy.shift());
			}
			if (!getTypeInformation(current.type).passedByReference) {
				Little.runtime.throwError(ErrorMessage('Cannot set properties to values of a static type. Only objects can have dynamic properties (${wentThroughPath.join(Little.keywords.PROPERTY_ACCESS_SIGN)} is `${current.type}`)'));
			}
			if (HashTables.hashTableHasKey(HashTables.getHashTableOf(current.address, storage), path[path.length - 1], storage)) {
				HashTables.objectSetKey(current.address, path[path.length - 1], {value: value != null ? retrieve(value) : null, type: type != null ? getTypeInformation(type).pointer : null, doc: doc != null ? storage.storeString(doc) : null}, storage);
			} else if (externs.instanceProperties.properties.exists(path[path.length - 1])) {
				Little.runtime.throwError(ErrorMessage('Cannot set an extern property (${path[path.length - 1]})'));
			} else {
				Little.runtime.throwError(ErrorMessage('Cannot set the value of ${path.join(Little.keywords.PROPERTY_ACCESS_SIGN)}, since ${path[path.length - 1]} does not exist.'));
			}
		}
	}

	/**
		Allocate `size` bytes of memory.
	    @param size The number of bytes to allocate
	    @return A pointer to the allocated memory
	**/
	public function allocate(size:Int):MemoryPointer {
		if (size <= 0) Little.runtime.throwError(ErrorMessage('Cannot allocate ${size} bytes'));
		return storage.storeBytes(size);
	}
	

	/**
		Returns information about types in Little at runtime.

		@param name The name of the type. Allows property access (for example, `pack.Type`)
		@return An object containing information about the type.
	**/
	public function getTypeInformation(name:String):TypeInfo {

		// First, check for primitive types which are pre-allocated
		// in the constant pool
		var p = switch name {
			case (_ == Little.keywords.TYPE_INT => true): constants.INT;
			case (_ == Little.keywords.TYPE_FLOAT => true): constants.FLOAT;
			case (_ == Little.keywords.TYPE_BOOLEAN => true): constants.BOOL;
			case (_ == Little.keywords.TYPE_DYNAMIC => true): constants.DYNAMIC;
			case (_ == Little.keywords.TYPE_MODULE => true): constants.TYPE;
			case (_ == Little.keywords.TYPE_UNKNOWN => true): constants.UNKNOWN;
			case _: MemoryPointer.fromInt(0);
		}
		if (p.rawLocation != 0) {
			return {
				pointer: p,
				typeName: switch p.rawLocation {
					case 11 /* int */: Little.keywords.TYPE_INT;
					case 12 /* float */: Little.keywords.TYPE_FLOAT;
					case 13 /* bool */: Little.keywords.TYPE_BOOLEAN;
					case 14 /* dynamic */: Little.keywords.TYPE_DYNAMIC;
					case 15 /* type */: Little.keywords.TYPE_MODULE;
					case 16 /* unknown */: Little.keywords.TYPE_UNKNOWN;
					case _: throw "How did we get here? 5";
				},
				passedByReference: p.rawLocation >= 14 && p.rawLocation <= 15,
				isExternal: false,
				instanceFields: [],
				staticFields: [],
				defaultInstanceSize: switch p.rawLocation {
					case 11 /* int */: 4;
					case 12 /* float */: 8;
					case 13 /* bool */: 1;
					case 14 /* dynamic */: -1;
					case 15 /* type */: -1;
					case 16 /* unknown */: -1;
					case _: throw "How did we get here? 51";
				}
			}
		}

		// If it's not a primitive type, the next priority is external types.
		// The easiest way to get a valid type is to check the typeToPointer map
		if (externs.typeToPointer.exists(name)) {

			var instProps = externs.createPathFor(externs.instanceProperties, ...name.split(Little.keywords.PROPERTY_ACCESS_SIGN));
			var statProps = externs.createPathFor(externs.globalProperties, ...name.split(Little.keywords.PROPERTY_ACCESS_SIGN));
			var instances = new Map<String, {type:MemoryPointer, doc:MemoryPointer}>();
			var statics = new Map<String, {type:MemoryPointer, doc:MemoryPointer}>();

			for (key => value in instProps.properties) 
				instances[key] = {type: value.type, doc: value.doc};
			for (key => value in statProps.properties)
				statics[key] = {type: value.type, doc: value.doc};


			return {
				pointer: externs.typeToPointer[name],
				typeName: name,
				passedByReference: true,
				isExternal: true,
				instanceFields: instances,
				staticFields: statics,
				defaultInstanceSize: 4 + POINTER_SIZE, // Objects take 8 bytes in-place
			}
		}
		
		var reference = referrer.get(name);
		var typeInfo = storage.readType(reference.address);

		return typeInfo;
	}

	/**
		Returns the name of the type at the given pointer.
		@param pointer The pointer to the type
		@return The name of the type
	**/
	public function getTypeName(pointer:MemoryPointer):String {
		// Externs prioritized:
		if (externs.pointerToType.exists(pointer)) {
			return externs.pointerToType[pointer];
			
		}
		// Then, constants:
		if (constants.hasPointer(pointer)) {
			return constants.getFromPointer(pointer).extractIdentifier();
		}

		return storage.readType(pointer).typeName;
	}
}

/**
	Represents runtime information about a type.
**/
typedef TypeInfo = {
	pointer:MemoryPointer,
	typeName:String,
	passedByReference:Bool,
	isExternal:Bool,
	instanceFields:Map<String, {type:MemoryPointer, doc:MemoryPointer}>,
    staticFields:Map<String, {type:MemoryPointer, doc:MemoryPointer}>,
	defaultInstanceSize:Int
}