(function ($hx_exports, $global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); },$hxEnums = $hxEnums || {},$_;
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	this.r = new RegExp(r,opt.split("u").join(""));
};
EReg.__name__ = true;
EReg.prototype = {
	match: function(s) {
		if(this.r.global) {
			this.r.lastIndex = 0;
		}
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
	,matched: function(n) {
		if(this.r.m != null && n >= 0 && n < this.r.m.length) {
			return this.r.m[n];
		} else {
			throw haxe_Exception.thrown("EReg::matched");
		}
	}
	,__class__: EReg
};
var HxOverrides = function() { };
HxOverrides.__name__ = true;
HxOverrides.cca = function(s,index) {
	var x = s.charCodeAt(index);
	if(x != x) {
		return undefined;
	}
	return x;
};
HxOverrides.substr = function(s,pos,len) {
	if(len == null) {
		len = s.length;
	} else if(len < 0) {
		if(pos == 0) {
			len = s.length + len;
		} else {
			return "";
		}
	}
	return s.substr(pos,len);
};
HxOverrides.now = function() {
	return Date.now();
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var a = 18;
	LittleInterpreter.registerVariable("a",a);
	Little.interpreter.run("define e = 19");
	console.log("src/Main.hx:15:",little_interpreter_Memory.variableMemory == null ? "null" : haxe_ds_StringMap.stringify(little_interpreter_Memory.variableMemory.h));
	a = 19;
	console.log("src/Main.hx:17:",little_Runtime.getMemorySnapshot());
};
Math.__name__ = true;
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var StringTools = function() { };
StringTools.__name__ = true;
StringTools.startsWith = function(s,start) {
	if(s.length >= start.length) {
		return s.lastIndexOf(start,0) == 0;
	} else {
		return false;
	}
};
StringTools.endsWith = function(s,end) {
	var elen = end.length;
	var slen = s.length;
	if(slen >= elen) {
		return s.indexOf(end,slen - elen) == slen - elen;
	} else {
		return false;
	}
};
StringTools.isSpace = function(s,pos) {
	var c = HxOverrides.cca(s,pos);
	if(!(c > 8 && c < 14)) {
		return c == 32;
	} else {
		return true;
	}
};
StringTools.ltrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,r)) ++r;
	if(r > 0) {
		return HxOverrides.substr(s,r,l - r);
	} else {
		return s;
	}
};
StringTools.rtrim = function(s) {
	var l = s.length;
	var r = 0;
	while(r < l && StringTools.isSpace(s,l - r - 1)) ++r;
	if(r > 0) {
		return HxOverrides.substr(s,0,l - r);
	} else {
		return s;
	}
};
StringTools.trim = function(s) {
	return StringTools.ltrim(StringTools.rtrim(s));
};
StringTools.replace = function(s,sub,by) {
	return s.split(sub).join(by);
};
var ValueType = $hxEnums["ValueType"] = { __ename__:true,__constructs__:null
	,TNull: {_hx_name:"TNull",_hx_index:0,__enum__:"ValueType",toString:$estr}
	,TInt: {_hx_name:"TInt",_hx_index:1,__enum__:"ValueType",toString:$estr}
	,TFloat: {_hx_name:"TFloat",_hx_index:2,__enum__:"ValueType",toString:$estr}
	,TBool: {_hx_name:"TBool",_hx_index:3,__enum__:"ValueType",toString:$estr}
	,TObject: {_hx_name:"TObject",_hx_index:4,__enum__:"ValueType",toString:$estr}
	,TFunction: {_hx_name:"TFunction",_hx_index:5,__enum__:"ValueType",toString:$estr}
	,TClass: ($_=function(c) { return {_hx_index:6,c:c,__enum__:"ValueType",toString:$estr}; },$_._hx_name="TClass",$_.__params__ = ["c"],$_)
	,TEnum: ($_=function(e) { return {_hx_index:7,e:e,__enum__:"ValueType",toString:$estr}; },$_._hx_name="TEnum",$_.__params__ = ["e"],$_)
	,TUnknown: {_hx_name:"TUnknown",_hx_index:8,__enum__:"ValueType",toString:$estr}
};
ValueType.__constructs__ = [ValueType.TNull,ValueType.TInt,ValueType.TFloat,ValueType.TBool,ValueType.TObject,ValueType.TFunction,ValueType.TClass,ValueType.TEnum,ValueType.TUnknown];
var Type = function() { };
Type.__name__ = true;
Type.typeof = function(v) {
	switch(typeof(v)) {
	case "boolean":
		return ValueType.TBool;
	case "function":
		if(v.__name__ || v.__ename__) {
			return ValueType.TObject;
		}
		return ValueType.TFunction;
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) {
			return ValueType.TInt;
		}
		return ValueType.TFloat;
	case "object":
		if(v == null) {
			return ValueType.TNull;
		}
		var e = v.__enum__;
		if(e != null) {
			return ValueType.TEnum($hxEnums[e]);
		}
		var c = js_Boot.getClass(v);
		if(c != null) {
			return ValueType.TClass(c);
		}
		return ValueType.TObject;
	case "string":
		return ValueType.TClass(String);
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
};
var haxe_Exception = function(message,previous,native) {
	Error.call(this,message);
	this.message = message;
	this.__previousException = previous;
	this.__nativeException = native != null ? native : this;
};
haxe_Exception.__name__ = true;
haxe_Exception.thrown = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value.get_native();
	} else if(((value) instanceof Error)) {
		return value;
	} else {
		var e = new haxe_ValueException(value);
		return e;
	}
};
haxe_Exception.__super__ = Error;
haxe_Exception.prototype = $extend(Error.prototype,{
	get_native: function() {
		return this.__nativeException;
	}
	,__class__: haxe_Exception
});
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
};
haxe_ValueException.__name__ = true;
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
	__class__: haxe_ValueException
});
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.stringify = function(h) {
	var s = "{";
	var first = true;
	for (var key in h) {
		if (first) first = false; else s += ',';
		s += key + ' => ' + Std.string(h[key]);
	}
	return s + "}";
};
haxe_ds_StringMap.prototype = {
	__class__: haxe_ds_StringMap
};
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.__name__ = true;
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
	,__class__: haxe_iterators_ArrayIterator
};
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if(o == null) {
		return null;
	} else if(((o) instanceof Array)) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o.__enum__) {
			var e = $hxEnums[o.__enum__];
			var con = e.__constructs__[o._hx_index];
			var n = con._hx_name;
			if(con.__params__) {
				s = s + "\t";
				return n + "(" + ((function($this) {
					var $r;
					var _g = [];
					{
						var _g1 = 0;
						var _g2 = con.__params__;
						while(true) {
							if(!(_g1 < _g2.length)) {
								break;
							}
							var p = _g2[_g1];
							_g1 = _g1 + 1;
							_g.push(js_Boot.__string_rec(o[p],s));
						}
					}
					$r = _g;
					return $r;
				}(this))).join(",") + ")";
			} else {
				return n;
			}
		}
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g = 0;
			var _g1 = o.length;
			while(_g < _g1) {
				var i = _g++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( _g ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) {
			str += ", \n";
		}
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var LittleInterpreter = $hx_exports["LittleInterpreter"] = function() { };
LittleInterpreter.__name__ = true;
LittleInterpreter.registerVariable = function(name,value) {
	var e = Type.typeof(value);
	var hType = $hxEnums[e.__enum__].__constructs__[e._hx_index]._hx_name.substring(1);
	var v = new little_interpreter_features_LittleVariable();
	v.name = name;
	v.set_basicValue(value);
	v.valueTree.h["%basicValue%"] = value;
	var tmp;
	switch(hType) {
	case "Bool":
		tmp = "Boolean";
		break;
	case "Dynamic":
		tmp = "Everything";
		break;
	case "Float":
		tmp = "Decimal";
		break;
	case "Int":
		tmp = "Number";
		break;
	case "String":
		tmp = "Letters";
		break;
	default:
		tmp = "Unknown";
	}
	v.type = tmp;
	if(v.type == "Unknown") {
		little_Runtime.safeThrow(new little_exceptions_VariableRegistrationError(v.name,hType));
		return;
	}
	v.scope = { scope : little_interpreter_constraints_VariableScope.GLOBAL, info : "Registered externally"};
	little_interpreter_Memory.safePush(v);
	LittleInterpreter.registeredVariables.h[name] = v;
};
LittleInterpreter.registerFunction = function(name,func) {
};
LittleInterpreter.registerObject = function(name,obj) {
};
LittleInterpreter.registerClass = function(name,cls) {
};
LittleInterpreter.run = function(code) {
	LittleInterpreter.currentLine = 1;
	little_interpreter_Memory.clear();
	code = StringTools.replace(code,"\r","");
	code = StringTools.replace(code,";","\n");
	code = StringTools.replace(code,"    ","\t");
	var _this_r = new RegExp("\n{2,}","g".split("u").join(""));
	code = code.replace(_this_r,"\n");
	var codeLines = code.split("\n");
	var currentIndent = 0;
	var lastIndent = 0;
	var blockNumber = 0;
	var currentlyClass = false;
	var _g = 0;
	while(_g < codeLines.length) {
		var l = codeLines[_g];
		++_g;
		lastIndent = currentIndent;
		currentIndent = 0;
		while(StringTools.startsWith(l,"\t")) {
			l = l.substring(1);
			++currentIndent;
		}
		if(lastIndent != currentIndent) {
			++blockNumber;
		}
		var lv = little_Interpreter_detectVariables(l);
		if(lv != null) {
			little_interpreter_Memory.safePush(lv);
		}
		little_Interpreter_detectPrint(l);
		LittleInterpreter.currentLine++;
	}
};
function little_Interpreter_detectVariables(line) {
	var v = new little_interpreter_features_LittleVariable();
	line = " " + StringTools.trim(line);
	if(line.indexOf(" define ") == -1) {
		return null;
	}
	var defParts = line.split(" define ");
	var parts = defParts[1].split("=");
	if(parts[0].indexOf(":") != -1) {
		var type = StringTools.replace(parts[0].split(":")[1]," ","");
		var name = StringTools.replace(parts[0].split(":")[0]," ","");
		if(type == "") {
			little_Runtime.safeThrow(new little_exceptions_MissingTypeDeclaration(name));
			return null;
		}
		v.name = name;
		v.type = type;
	}
	if(parts[0].indexOf(":") == -1) {
		v.name = StringTools.replace(parts[0]," ","");
		v.type = "Everything";
	}
	if(parts[1] != null) {
		var valueType = little_interpreter_features_Typer.getValueType(StringTools.trim(parts[1]));
		if(valueType != v.type && v.type != "Everything") {
			little_Runtime.safeThrow(new little_exceptions_DefinitionTypeMismatch(v.name,v.type,valueType));
		}
		v.set_basicValue(little_interpreter_features_Evaluator.getValueOf(StringTools.trim(parts[1])));
		v.valueTree = little_Interpreter_processVariableValueTree(v.get_basicValue());
	}
	if(parts[1] == null) {
		v.set_basicValue({ });
		var this1 = v.valueTree;
		var v1 = v.get_basicValue();
		this1.h["%basicValue%"] = v1;
	}
	return v;
}
function little_Interpreter_processVariableValueTree(val) {
	return { };
}
function little_Interpreter_detectPrint(line) {
	if(line.indexOf("print(") == -1 && !StringTools.endsWith(line,")")) {
		return;
	}
	line = line.substring(6);
	if(!StringTools.endsWith(line,")")) {
		little_Runtime.safeThrow(new little_exceptions_Typo("When using the print function, you need to end it with a )"));
		return;
	}
	line = line.substring(0,line.length - 1);
	var value = little_interpreter_features_Evaluator.getValueOf(line);
	little_Runtime.print(value);
}
var little_interpreter_ExceptionStack = function() {
	this.stack = [];
};
little_interpreter_ExceptionStack.__name__ = true;
little_interpreter_ExceptionStack.prototype = {
	push: function(e) {
		if(this.last == null) {
			this.last = e;
		}
		if(this.first == null) {
			this.first = e;
		}
		this.last = e;
		this.stack.push(e);
	}
	,__class__: little_interpreter_ExceptionStack
};
var little_Runtime = function() { };
little_Runtime.__name__ = true;
little_Runtime.getMemorySnapshot = function() {
	return haxe_ds_StringMap.stringify(little_interpreter_Memory.variableMemory.h);
};
little_Runtime.safeThrow = function(exception) {
	little_Runtime.exceptionStack.push(exception);
	little_Runtime.print("Error! (from line " + little_Runtime.get_currentLine() + "):\n\t---\n\t" + exception.get_content() + "\n\t---");
};
little_Runtime.print = function(expression) {
	$global.console.log("Line " + little_Runtime.get_currentLine() + ": " + expression);
};
little_Runtime.get_currentLine = function() {
	return LittleInterpreter.currentLine;
};
var little_Transpiler = function() { };
little_Transpiler.__name__ = true;
var Little = $hx_exports["Little"] = function() { };
Little.__name__ = true;
var little_exceptions_DefinitionTypeMismatch = function(name,originalType,wrongType) {
	this.type = "Definition Type Mismatch";
	this.details = "You tried to set the definition: \n\n\t\t" + name + "\n\n\tof type: \n\n\t\t" + originalType + "\n\n\twith a value of type: \n\n\t\t" + wrongType + "\n\n\tOnce a definition is set, it's value can only be set again with the same type.";
};
little_exceptions_DefinitionTypeMismatch.__name__ = true;
little_exceptions_DefinitionTypeMismatch.prototype = {
	get_content: function() {
		return "" + this.type + ": " + this.details;
	}
	,__class__: little_exceptions_DefinitionTypeMismatch
};
var little_exceptions_MissingTypeDeclaration = function(varName) {
	this.type = "Missing Type Declaration";
	this.details = "When initializing " + varName + ", you left the type after the : empty.\n\tIf you don't want to specify a type, remove the : after the definition's name.";
};
little_exceptions_MissingTypeDeclaration.__name__ = true;
little_exceptions_MissingTypeDeclaration.prototype = {
	get_content: function() {
		return "" + this.type + ": " + this.details;
	}
	,__class__: little_exceptions_MissingTypeDeclaration
};
var little_exceptions_Typo = function(details) {
	this.type = "Typo";
	this.details = details;
};
little_exceptions_Typo.__name__ = true;
little_exceptions_Typo.prototype = {
	get_content: function() {
		return "" + this.type + ": " + this.details;
	}
	,__class__: little_exceptions_Typo
};
var little_exceptions_VariableRegistrationError = function(name,registeredType) {
	this.type = "Variable Registration Error";
	var _this_r = new RegExp("aeiou","g".split("u").join(""));
	this.details = "You tried to register the variable " + name + " as a" + (registeredType.charAt(0).replace(_this_r,"").length == 0 ? "n" : "") + " " + registeredType + ", but that type dosn't have a non-Haxe counterpart.";
};
little_exceptions_VariableRegistrationError.__name__ = true;
little_exceptions_VariableRegistrationError.prototype = {
	get_content: function() {
		return "" + this.type + ": " + this.details;
	}
	,__class__: little_exceptions_VariableRegistrationError
};
var little_interpreter_Memory = function() { };
little_interpreter_Memory.__name__ = true;
little_interpreter_Memory.safePush = function(v) {
	if(Object.prototype.hasOwnProperty.call(little_interpreter_Memory.variableMemory.h,v.name)) {
		if(little_interpreter_Memory.variableMemory.h[v.name].type != v.type) {
			little_Runtime.safeThrow(new little_exceptions_DefinitionTypeMismatch(v.name,little_interpreter_Memory.variableMemory.h[v.name].type,v.type));
		}
		little_interpreter_Memory.variableMemory.h[v.name] = v;
	} else {
		little_interpreter_Memory.variableMemory.h[v.name] = v;
	}
};
little_interpreter_Memory.hasLoadedVar = function(variableName) {
	return Object.prototype.hasOwnProperty.call(little_interpreter_Memory.variableMemory.h,variableName);
};
little_interpreter_Memory.getLoadedVar = function(variableName) {
	return little_interpreter_Memory.variableMemory.h[variableName];
};
little_interpreter_Memory.clear = function() {
	return little_interpreter_Memory.variableMemory = new haxe_ds_StringMap();
};
var little_interpreter_constraints_VariableScope = $hxEnums["little.interpreter.constraints.VariableScope"] = { __ename__:true,__constructs__:null
	,GLOBAL: {_hx_name:"GLOBAL",_hx_index:0,__enum__:"little.interpreter.constraints.VariableScope",toString:$estr}
	,MODULE: {_hx_name:"MODULE",_hx_index:1,__enum__:"little.interpreter.constraints.VariableScope",toString:$estr}
	,CLASS: {_hx_name:"CLASS",_hx_index:2,__enum__:"little.interpreter.constraints.VariableScope",toString:$estr}
	,Method: ($_=function(methodNumber) { return {_hx_index:3,methodNumber:methodNumber,__enum__:"little.interpreter.constraints.VariableScope",toString:$estr}; },$_._hx_name="Method",$_.__params__ = ["methodNumber"],$_)
	,Block: ($_=function(blockNumber) { return {_hx_index:4,blockNumber:blockNumber,__enum__:"little.interpreter.constraints.VariableScope",toString:$estr}; },$_._hx_name="Block",$_.__params__ = ["blockNumber"],$_)
	,Inline: ($_=function(lineNumber) { return {_hx_index:5,lineNumber:lineNumber,__enum__:"little.interpreter.constraints.VariableScope",toString:$estr}; },$_._hx_name="Inline",$_.__params__ = ["lineNumber"],$_)
};
little_interpreter_constraints_VariableScope.__constructs__ = [little_interpreter_constraints_VariableScope.GLOBAL,little_interpreter_constraints_VariableScope.MODULE,little_interpreter_constraints_VariableScope.CLASS,little_interpreter_constraints_VariableScope.Method,little_interpreter_constraints_VariableScope.Block,little_interpreter_constraints_VariableScope.Inline];
var little_interpreter_features_Evaluator = function() { };
little_interpreter_features_Evaluator.__name__ = true;
little_interpreter_features_Evaluator.getValueOf = function(value) {
	var numberDetector = new EReg("([0-9.])","");
	var stringDetector = new EReg("\"[^\"]*\"","");
	var booleanDetector = new EReg("true|false","");
	if(numberDetector.match(value)) {
		return numberDetector.matched(1);
	} else if(stringDetector.match(value)) {
		return stringDetector.matched(1);
	} else if(booleanDetector.match(value)) {
		return booleanDetector.matched(1);
	} else if(little_interpreter_Memory.hasLoadedVar(value)) {
		return little_interpreter_Memory.getLoadedVar(value).toString();
	}
	return "Nothing";
};
var little_interpreter_features_LittleVariable = function() {
	this.valueTree = new haxe_ds_StringMap();
};
little_interpreter_features_LittleVariable.__name__ = true;
little_interpreter_features_LittleVariable.prototype = {
	get_basicValue: function() {
		return this.basicValue;
	}
	,set_basicValue: function(value) {
		return this.basicValue = value;
	}
	,toString: function() {
		return "" + Std.string(this.get_basicValue());
	}
	,__class__: little_interpreter_features_LittleVariable
};
var little_interpreter_features_Typer = function() { };
little_interpreter_features_Typer.__name__ = true;
little_interpreter_features_Typer.getValueType = function(value) {
	var instanceDetector = new EReg("new +([a-zA-z0-9_]+)","");
	var numberDetector = new EReg("([0-9.])","");
	var stringDetector = new EReg("\".*\"","");
	var booleanDetector = new EReg("true|false","");
	if(instanceDetector.match(value)) {
		return instanceDetector.matched(1);
	} else if(numberDetector.match(value)) {
		if(value.indexOf(".") != -1) {
			return "Decimal";
		} else {
			return "Number";
		}
	} else if(stringDetector.match(value)) {
		return "Letters";
	} else if(booleanDetector.match(value)) {
		return "Boolean";
	} else if(value.indexOf(".") != -1) {
		var object = value.substring(0,value.indexOf("."));
		value = value.substring(value.indexOf(".") + 1);
		if(value == "") {
			little_Runtime.safeThrow(new little_exceptions_Typo("While trying to access a definition inside " + object + ", you didn't specify a property name (the property name is the part after the dot)."));
		}
	}
	return "";
};
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
js_Boot.__toStr = ({ }).toString;
LittleInterpreter.currentLine = 1;
LittleInterpreter.registeredVariables = new haxe_ds_StringMap();
little_Runtime.exceptionStack = new little_interpreter_ExceptionStack();
little_Runtime.currentLine = 0;
Little.interpreter = LittleInterpreter;
Little.runtime = little_Runtime;
Little.transpiler = little_Transpiler;
little_interpreter_Memory.variableMemory = new haxe_ds_StringMap();
Main.main();
})(typeof exports != "undefined" ? exports : typeof window != "undefined" ? window : typeof self != "undefined" ? self : this, typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

//# sourceMappingURL=interp.js.map