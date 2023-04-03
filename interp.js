(function ($global) { "use strict";
var $hxClasses = {},$estr = function() { return js_Boot.__string_rec(this,''); },$hxEnums = $hxEnums || {},$_;
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	this.r = new RegExp(r,opt.split("u").join(""));
};
$hxClasses["EReg"] = EReg;
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
	,matchedPos: function() {
		if(this.r.m == null) {
			throw haxe_Exception.thrown("No string matched");
		}
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,split: function(s) {
		var d = "#__delim__#";
		return s.replace(this.r,d).split(d);
	}
	,__class__: EReg
};
var HxOverrides = function() { };
$hxClasses["HxOverrides"] = HxOverrides;
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
HxOverrides.remove = function(a,obj) {
	var i = a.indexOf(obj);
	if(i == -1) {
		return false;
	}
	a.splice(i,1);
	return true;
};
HxOverrides.now = function() {
	return Date.now();
};
var Main = function() { };
$hxClasses["Main"] = Main;
Main.__name__ = true;
Main.main = function() {
	var text = window.document.getElementById("input");
	var output = window.document.getElementById("output-parser");
	var stdout = window.document.getElementById("output");
	haxe_Log.trace(text,{ fileName : "src/Main.hx", lineNumber : 30, className : "Main", methodName : "main", customParams : [output]});
	text.addEventListener("keyup",function(_) {
		try {
			var tmp = little_parser_Parser.parse(little_lexer_Lexer.lex(text.value));
			output.innerHTML = little_tools_PrettyPrinter.printParserAst(tmp);
		} catch( _g ) {
		}
		try {
			little_Little.run(text.value,true);
			stdout.innerHTML = little_interpreter_Runtime.stdout;
		} catch( _g ) {
		}
	});
	var tmp = little_parser_Parser.parse(little_lexer_Lexer.lex(text.value));
	output.innerHTML = little_tools_PrettyPrinter.printParserAst(tmp);
	text.innerHTML = Main.code;
};
Math.__name__ = true;
var Reflect = function() { };
$hxClasses["Reflect"] = Reflect;
Reflect.__name__ = true;
Reflect.field = function(o,field) {
	try {
		return o[field];
	} catch( _g ) {
		return null;
	}
};
Reflect.isFunction = function(f) {
	if(typeof(f) == "function") {
		return !(f.__name__ || f.__ename__);
	} else {
		return false;
	}
};
var Std = function() { };
$hxClasses["Std"] = Std;
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	if(x != null) {
		var _g = 0;
		var _g1 = x.length;
		while(_g < _g1) {
			var i = _g++;
			var c = x.charCodeAt(i);
			if(c <= 8 || c >= 14 && c != 32 && c != 45) {
				var nc = x.charCodeAt(i + 1);
				var v = parseInt(x,nc == 120 || nc == 88 ? 16 : 10);
				if(isNaN(v)) {
					return null;
				} else {
					return v;
				}
			}
		}
	}
	return null;
};
var StringBuf = function() {
	this.b = "";
};
$hxClasses["StringBuf"] = StringBuf;
StringBuf.__name__ = true;
StringBuf.prototype = {
	__class__: StringBuf
};
var StringTools = function() { };
$hxClasses["StringTools"] = StringTools;
StringTools.__name__ = true;
StringTools.startsWith = function(s,start) {
	if(s.length >= start.length) {
		return s.lastIndexOf(start,0) == 0;
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
$hxClasses["Type"] = Type;
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
Type.enumEq = function(a,b) {
	if(a == b) {
		return true;
	}
	try {
		var e = a.__enum__;
		if(e == null || e != b.__enum__) {
			return false;
		}
		if(a._hx_index != b._hx_index) {
			return false;
		}
		var enm = $hxEnums[e];
		var params = enm.__constructs__[a._hx_index].__params__;
		var _g = 0;
		while(_g < params.length) {
			var f = params[_g];
			++_g;
			if(!Type.enumEq(a[f],b[f])) {
				return false;
			}
		}
	} catch( _g ) {
		return false;
	}
	return true;
};
Type.enumParameters = function(e) {
	var enm = $hxEnums[e.__enum__];
	var params = enm.__constructs__[e._hx_index].__params__;
	if(params != null) {
		var _g = [];
		var _g1 = 0;
		while(_g1 < params.length) {
			var p = params[_g1];
			++_g1;
			_g.push(e[p]);
		}
		return _g;
	} else {
		return [];
	}
};
var haxe_StackItem = $hxEnums["haxe.StackItem"] = { __ename__:true,__constructs__:null
	,CFunction: {_hx_name:"CFunction",_hx_index:0,__enum__:"haxe.StackItem",toString:$estr}
	,Module: ($_=function(m) { return {_hx_index:1,m:m,__enum__:"haxe.StackItem",toString:$estr}; },$_._hx_name="Module",$_.__params__ = ["m"],$_)
	,FilePos: ($_=function(s,file,line,column) { return {_hx_index:2,s:s,file:file,line:line,column:column,__enum__:"haxe.StackItem",toString:$estr}; },$_._hx_name="FilePos",$_.__params__ = ["s","file","line","column"],$_)
	,Method: ($_=function(classname,method) { return {_hx_index:3,classname:classname,method:method,__enum__:"haxe.StackItem",toString:$estr}; },$_._hx_name="Method",$_.__params__ = ["classname","method"],$_)
	,LocalFunction: ($_=function(v) { return {_hx_index:4,v:v,__enum__:"haxe.StackItem",toString:$estr}; },$_._hx_name="LocalFunction",$_.__params__ = ["v"],$_)
};
haxe_StackItem.__constructs__ = [haxe_StackItem.CFunction,haxe_StackItem.Module,haxe_StackItem.FilePos,haxe_StackItem.Method,haxe_StackItem.LocalFunction];
var haxe_CallStack = {};
haxe_CallStack.toString = function(stack) {
	var b = new StringBuf();
	var _g = 0;
	var _g1 = stack;
	while(_g < _g1.length) {
		var s = _g1[_g];
		++_g;
		b.b += "\nCalled from ";
		haxe_CallStack.itemToString(b,s);
	}
	return b.b;
};
haxe_CallStack.subtract = function(this1,stack) {
	var startIndex = -1;
	var i = -1;
	while(++i < this1.length) {
		var _g = 0;
		var _g1 = stack.length;
		while(_g < _g1) {
			var j = _g++;
			if(haxe_CallStack.equalItems(this1[i],stack[j])) {
				if(startIndex < 0) {
					startIndex = i;
				}
				++i;
				if(i >= this1.length) {
					break;
				}
			} else {
				startIndex = -1;
			}
		}
		if(startIndex >= 0) {
			break;
		}
	}
	if(startIndex >= 0) {
		return this1.slice(0,startIndex);
	} else {
		return this1;
	}
};
haxe_CallStack.equalItems = function(item1,item2) {
	if(item1 == null) {
		if(item2 == null) {
			return true;
		} else {
			return false;
		}
	} else {
		switch(item1._hx_index) {
		case 0:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 0) {
				return true;
			} else {
				return false;
			}
			break;
		case 1:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 1) {
				var m2 = item2.m;
				var m1 = item1.m;
				return m1 == m2;
			} else {
				return false;
			}
			break;
		case 2:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 2) {
				var item21 = item2.s;
				var file2 = item2.file;
				var line2 = item2.line;
				var col2 = item2.column;
				var col1 = item1.column;
				var line1 = item1.line;
				var file1 = item1.file;
				var item11 = item1.s;
				if(file1 == file2 && line1 == line2 && col1 == col2) {
					return haxe_CallStack.equalItems(item11,item21);
				} else {
					return false;
				}
			} else {
				return false;
			}
			break;
		case 3:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 3) {
				var class2 = item2.classname;
				var method2 = item2.method;
				var method1 = item1.method;
				var class1 = item1.classname;
				if(class1 == class2) {
					return method1 == method2;
				} else {
					return false;
				}
			} else {
				return false;
			}
			break;
		case 4:
			if(item2 == null) {
				return false;
			} else if(item2._hx_index == 4) {
				var v2 = item2.v;
				var v1 = item1.v;
				return v1 == v2;
			} else {
				return false;
			}
			break;
		}
	}
};
haxe_CallStack.itemToString = function(b,s) {
	switch(s._hx_index) {
	case 0:
		b.b += "a C function";
		break;
	case 1:
		var m = s.m;
		b.b += "module ";
		b.b += m == null ? "null" : "" + m;
		break;
	case 2:
		var s1 = s.s;
		var file = s.file;
		var line = s.line;
		var col = s.column;
		if(s1 != null) {
			haxe_CallStack.itemToString(b,s1);
			b.b += " (";
		}
		b.b += file == null ? "null" : "" + file;
		b.b += " line ";
		b.b += line == null ? "null" : "" + line;
		if(col != null) {
			b.b += " column ";
			b.b += col == null ? "null" : "" + col;
		}
		if(s1 != null) {
			b.b += ")";
		}
		break;
	case 3:
		var cname = s.classname;
		var meth = s.method;
		b.b += Std.string(cname == null ? "<unknown>" : cname);
		b.b += ".";
		b.b += meth == null ? "null" : "" + meth;
		break;
	case 4:
		var n = s.v;
		b.b += "local function #";
		b.b += n == null ? "null" : "" + n;
		break;
	}
};
var haxe_IMap = function() { };
$hxClasses["haxe.IMap"] = haxe_IMap;
haxe_IMap.__name__ = true;
var haxe_Exception = function(message,previous,native) {
	Error.call(this,message);
	this.message = message;
	this.__previousException = previous;
	this.__nativeException = native != null ? native : this;
	this.__skipStack = 0;
	var old = Error.prepareStackTrace;
	Error.prepareStackTrace = function(e) { return e.stack; }
	if(((native) instanceof Error)) {
		this.stack = native.stack;
	} else {
		var e = null;
		if(Error.captureStackTrace) {
			Error.captureStackTrace(this,haxe_Exception);
			e = this;
		} else {
			e = new Error();
			if(typeof(e.stack) == "undefined") {
				try { throw e; } catch(_) {}
				this.__skipStack++;
			}
		}
		this.stack = e.stack;
	}
	Error.prepareStackTrace = old;
};
$hxClasses["haxe.Exception"] = haxe_Exception;
haxe_Exception.__name__ = true;
haxe_Exception.caught = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value;
	} else if(((value) instanceof Error)) {
		return new haxe_Exception(value.message,null,value);
	} else {
		return new haxe_ValueException(value,null,value);
	}
};
haxe_Exception.thrown = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value.get_native();
	} else if(((value) instanceof Error)) {
		return value;
	} else {
		var e = new haxe_ValueException(value);
		e.__skipStack++;
		return e;
	}
};
haxe_Exception.__super__ = Error;
haxe_Exception.prototype = $extend(Error.prototype,{
	toString: function() {
		return this.get_message();
	}
	,details: function() {
		if(this.get_previous() == null) {
			var tmp = "Exception: " + this.toString();
			var tmp1 = this.get_stack();
			return tmp + (tmp1 == null ? "null" : haxe_CallStack.toString(tmp1));
		} else {
			var result = "";
			var e = this;
			var prev = null;
			while(e != null) {
				if(prev == null) {
					var result1 = "Exception: " + e.get_message();
					var tmp = e.get_stack();
					result = result1 + (tmp == null ? "null" : haxe_CallStack.toString(tmp)) + result;
				} else {
					var prevStack = haxe_CallStack.subtract(e.get_stack(),prev.get_stack());
					result = "Exception: " + e.get_message() + (prevStack == null ? "null" : haxe_CallStack.toString(prevStack)) + "\n\nNext " + result;
				}
				prev = e;
				e = e.get_previous();
			}
			return result;
		}
	}
	,__shiftStack: function() {
		this.__skipStack++;
	}
	,get_message: function() {
		return this.message;
	}
	,get_previous: function() {
		return this.__previousException;
	}
	,get_native: function() {
		return this.__nativeException;
	}
	,get_stack: function() {
		var _g = this.__exceptionStack;
		if(_g == null) {
			var value = haxe_NativeStackTrace.toHaxe(haxe_NativeStackTrace.normalize(this.stack),this.__skipStack);
			this.setProperty("__exceptionStack",value);
			return value;
		} else {
			var s = _g;
			return s;
		}
	}
	,setProperty: function(name,value) {
		try {
			Object.defineProperty(this,name,{ value : value});
		} catch( _g ) {
			this[name] = value;
		}
	}
	,__class__: haxe_Exception
});
var haxe_Log = function() { };
$hxClasses["haxe.Log"] = haxe_Log;
haxe_Log.__name__ = true;
haxe_Log.formatOutput = function(v,infos) {
	var str = Std.string(v);
	if(infos == null) {
		return str;
	}
	var pstr = infos.fileName + ":" + infos.lineNumber;
	if(infos.customParams != null) {
		var _g = 0;
		var _g1 = infos.customParams;
		while(_g < _g1.length) {
			var v = _g1[_g];
			++_g;
			str += ", " + Std.string(v);
		}
	}
	return pstr + ": " + str;
};
haxe_Log.trace = function(v,infos) {
	var str = haxe_Log.formatOutput(v,infos);
	if(typeof(console) != "undefined" && console.log != null) {
		console.log(str);
	}
};
var haxe_NativeStackTrace = function() { };
$hxClasses["haxe.NativeStackTrace"] = haxe_NativeStackTrace;
haxe_NativeStackTrace.__name__ = true;
haxe_NativeStackTrace.toHaxe = function(s,skip) {
	if(skip == null) {
		skip = 0;
	}
	if(s == null) {
		return [];
	} else if(typeof(s) == "string") {
		var stack = s.split("\n");
		if(stack[0] == "Error") {
			stack.shift();
		}
		var m = [];
		var _g = 0;
		var _g1 = stack.length;
		while(_g < _g1) {
			var i = _g++;
			if(skip > i) {
				continue;
			}
			var line = stack[i];
			var matched = line.match(/^    at ([A-Za-z0-9_. ]+) \(([^)]+):([0-9]+):([0-9]+)\)$/);
			if(matched != null) {
				var path = matched[1].split(".");
				if(path[0] == "$hxClasses") {
					path.shift();
				}
				var meth = path.pop();
				var file = matched[2];
				var line1 = Std.parseInt(matched[3]);
				var column = Std.parseInt(matched[4]);
				m.push(haxe_StackItem.FilePos(meth == "Anonymous function" ? haxe_StackItem.LocalFunction() : meth == "Global code" ? null : haxe_StackItem.Method(path.join("."),meth),file,line1,column));
			} else {
				m.push(haxe_StackItem.Module(StringTools.trim(line)));
			}
		}
		return m;
	} else if(skip > 0 && Array.isArray(s)) {
		return s.slice(skip);
	} else {
		return s;
	}
};
haxe_NativeStackTrace.normalize = function(stack,skipItems) {
	if(skipItems == null) {
		skipItems = 0;
	}
	if(Array.isArray(stack) && skipItems > 0) {
		return stack.slice(skipItems);
	} else if(typeof(stack) == "string") {
		switch(stack.substring(0,6)) {
		case "Error\n":case "Error:":
			++skipItems;
			break;
		default:
		}
		return haxe_NativeStackTrace.skipLines(stack,skipItems);
	} else {
		return stack;
	}
};
haxe_NativeStackTrace.skipLines = function(stack,skip,pos) {
	if(pos == null) {
		pos = 0;
	}
	if(skip > 0) {
		pos = stack.indexOf("\n",pos);
		if(pos < 0) {
			return "";
		} else {
			return haxe_NativeStackTrace.skipLines(stack,--skip,pos + 1);
		}
	} else {
		return stack.substring(pos);
	}
};
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
	this.__skipStack++;
};
$hxClasses["haxe.ValueException"] = haxe_ValueException;
haxe_ValueException.__name__ = true;
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
	__class__: haxe_ValueException
});
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
$hxClasses["haxe.ds.StringMap"] = haxe_ds_StringMap;
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.prototype = {
	__class__: haxe_ds_StringMap
};
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
$hxClasses["haxe.iterators.ArrayIterator"] = haxe_iterators_ArrayIterator;
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
$hxClasses["js.Boot"] = js_Boot;
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
var little_interpreter_KeywordConfig = function(VARIABLE_DECLARATION,FUNCTION_DECLARATION,TYPE_DECL_OR_CAST,FUNCTION_RETURN,NULL_VALUE,TRUE_VALUE,FALSE_VALUE,TYPE_DYNAMIC,TYPE_VOID,TYPE_INT,TYPE_FLOAT,TYPE_BOOLEAN,TYPE_STRING,TYPE_MODULE,MAIN_MODULE_NAME,REGISTERED_MODULE_NAME,PRINT_FUNCTION_NAME,RAISE_ERROR_FUNCTION_NAME,READ_FUNCTION_NAME,RUN_CODE_FUNCTION_NAME,TYPE_UNKNOWN,CONDITION_TYPES,SPECIAL_OR_MULTICHAR_SIGNS,PROPERTY_ACCESS_SIGN,EQUALS_SIGN,NOT_EQUALS_SIGN,XOR_SIGN,OR_SIGN,AND_SIGN,FOR_LOOP_IDENTIFIERS) {
	this.FOR_LOOP_IDENTIFIERS = { FROM : "from", TO : "to", JUMP : "jump"};
	this.AND_SIGN = "&&";
	this.OR_SIGN = "||";
	this.XOR_SIGN = "^^";
	this.NOT_EQUALS_SIGN = "!=";
	this.EQUALS_SIGN = "==";
	this.PROPERTY_ACCESS_SIGN = ".";
	this.SPECIAL_OR_MULTICHAR_SIGNS = ["++","--","**","+=","-=",">=","<=","==","&&","||","^^","!="];
	this.CONDITION_TYPES = [];
	this.TYPE_UNKNOWN = "Unknown";
	this.RUN_CODE_FUNCTION_NAME = "run";
	this.READ_FUNCTION_NAME = "read";
	this.RAISE_ERROR_FUNCTION_NAME = "error";
	this.PRINT_FUNCTION_NAME = "print";
	this.REGISTERED_MODULE_NAME = "Registered";
	this.MAIN_MODULE_NAME = "Main";
	this.TYPE_MODULE = "Type";
	this.TYPE_STRING = "Characters";
	this.TYPE_BOOLEAN = "Boolean";
	this.TYPE_FLOAT = "Decimal";
	this.TYPE_INT = "Number";
	this.TYPE_VOID = "Void";
	this.TYPE_DYNAMIC = "Anything";
	this.FALSE_VALUE = "false";
	this.TRUE_VALUE = "true";
	this.NULL_VALUE = "nothing";
	this.FUNCTION_RETURN = "return";
	this.TYPE_DECL_OR_CAST = "as";
	this.FUNCTION_DECLARATION = "action";
	this.VARIABLE_DECLARATION = "define";
	if(VARIABLE_DECLARATION != null) {
		this.VARIABLE_DECLARATION = VARIABLE_DECLARATION;
	}
	if(FUNCTION_DECLARATION != null) {
		this.FUNCTION_DECLARATION = FUNCTION_DECLARATION;
	}
	if(TYPE_DECL_OR_CAST != null) {
		this.TYPE_DECL_OR_CAST = TYPE_DECL_OR_CAST;
	}
	if(FUNCTION_RETURN != null) {
		this.FUNCTION_RETURN = FUNCTION_RETURN;
	}
	if(NULL_VALUE != null) {
		this.NULL_VALUE = NULL_VALUE;
	}
	if(TRUE_VALUE != null) {
		this.TRUE_VALUE = TRUE_VALUE;
	}
	if(FALSE_VALUE != null) {
		this.FALSE_VALUE = FALSE_VALUE;
	}
	if(TYPE_DYNAMIC != null) {
		this.TYPE_DYNAMIC = TYPE_DYNAMIC;
	}
	if(TYPE_VOID != null) {
		this.TYPE_VOID = TYPE_VOID;
	}
	if(TYPE_INT != null) {
		this.TYPE_INT = TYPE_INT;
	}
	if(TYPE_FLOAT != null) {
		this.TYPE_FLOAT = TYPE_FLOAT;
	}
	if(TYPE_BOOLEAN != null) {
		this.TYPE_BOOLEAN = TYPE_BOOLEAN;
	}
	if(TYPE_STRING != null) {
		this.TYPE_STRING = TYPE_STRING;
	}
	if(TYPE_MODULE != null) {
		this.TYPE_MODULE = TYPE_MODULE;
	}
	if(MAIN_MODULE_NAME != null) {
		this.MAIN_MODULE_NAME = MAIN_MODULE_NAME;
	}
	if(REGISTERED_MODULE_NAME != null) {
		this.REGISTERED_MODULE_NAME = REGISTERED_MODULE_NAME;
	}
	if(PRINT_FUNCTION_NAME != null) {
		this.PRINT_FUNCTION_NAME = PRINT_FUNCTION_NAME;
	}
	if(RAISE_ERROR_FUNCTION_NAME != null) {
		this.RAISE_ERROR_FUNCTION_NAME = RAISE_ERROR_FUNCTION_NAME;
	}
	if(READ_FUNCTION_NAME != null) {
		this.READ_FUNCTION_NAME = READ_FUNCTION_NAME;
	}
	if(RUN_CODE_FUNCTION_NAME != null) {
		this.RUN_CODE_FUNCTION_NAME = RUN_CODE_FUNCTION_NAME;
	}
	if(TYPE_UNKNOWN != null) {
		this.TYPE_UNKNOWN = TYPE_UNKNOWN;
	}
	if(CONDITION_TYPES != null) {
		this.CONDITION_TYPES = CONDITION_TYPES;
	}
	if(SPECIAL_OR_MULTICHAR_SIGNS != null) {
		this.SPECIAL_OR_MULTICHAR_SIGNS = SPECIAL_OR_MULTICHAR_SIGNS;
	}
	if(PROPERTY_ACCESS_SIGN != null) {
		this.PROPERTY_ACCESS_SIGN = PROPERTY_ACCESS_SIGN;
	}
	if(EQUALS_SIGN != null) {
		this.EQUALS_SIGN = EQUALS_SIGN;
	}
	if(NOT_EQUALS_SIGN != null) {
		this.NOT_EQUALS_SIGN = NOT_EQUALS_SIGN;
	}
	if(XOR_SIGN != null) {
		this.XOR_SIGN = XOR_SIGN;
	}
	if(OR_SIGN != null) {
		this.OR_SIGN = OR_SIGN;
	}
	if(AND_SIGN != null) {
		this.AND_SIGN = AND_SIGN;
	}
	if(FOR_LOOP_IDENTIFIERS != null) {
		this.FOR_LOOP_IDENTIFIERS = FOR_LOOP_IDENTIFIERS;
	}
};
$hxClasses["little.interpreter.KeywordConfig"] = little_interpreter_KeywordConfig;
little_interpreter_KeywordConfig.__name__ = true;
little_interpreter_KeywordConfig.prototype = {
	__class__: little_interpreter_KeywordConfig
};
var little_Keywords = function() { };
$hxClasses["little.Keywords"] = little_Keywords;
little_Keywords.__name__ = true;
little_Keywords.switchSet = function(set) {
	little_Keywords.VARIABLE_DECLARATION = set.VARIABLE_DECLARATION;
	little_Keywords.FUNCTION_DECLARATION = set.FUNCTION_DECLARATION;
	little_Keywords.TYPE_DECL_OR_CAST = set.TYPE_DECL_OR_CAST;
	little_Keywords.FUNCTION_RETURN = set.FUNCTION_RETURN;
	little_Keywords.NULL_VALUE = set.NULL_VALUE;
	little_Keywords.TRUE_VALUE = set.TRUE_VALUE;
	little_Keywords.FALSE_VALUE = set.FALSE_VALUE;
	little_Keywords.TYPE_DYNAMIC = set.TYPE_DYNAMIC;
	little_Keywords.TYPE_VOID = set.TYPE_VOID;
	little_Keywords.TYPE_INT = set.TYPE_INT;
	little_Keywords.TYPE_FLOAT = set.TYPE_FLOAT;
	little_Keywords.TYPE_BOOLEAN = set.TYPE_BOOLEAN;
	little_Keywords.TYPE_STRING = set.TYPE_STRING;
	little_Keywords.TYPE_MODULE = set.TYPE_MODULE;
	little_Keywords.MAIN_MODULE_NAME = set.MAIN_MODULE_NAME;
	little_Keywords.REGISTERED_MODULE_NAME = set.REGISTERED_MODULE_NAME;
	little_Keywords.PRINT_FUNCTION_NAME = set.PRINT_FUNCTION_NAME;
	little_Keywords.RAISE_ERROR_FUNCTION_NAME = set.RAISE_ERROR_FUNCTION_NAME;
	little_Keywords.READ_FUNCTION_NAME = set.READ_FUNCTION_NAME;
	little_Keywords.RUN_CODE_FUNCTION_NAME = set.RAISE_ERROR_FUNCTION_NAME;
	little_Keywords.TYPE_UNKNOWN = set.TYPE_UNKNOWN;
	little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS = set.SPECIAL_OR_MULTICHAR_SIGNS;
	little_Keywords.PROPERTY_ACCESS_SIGN = set.PROPERTY_ACCESS_SIGN;
	little_Keywords.EQUALS_SIGN = set.EQUALS_SIGN;
	little_Keywords.NOT_EQUALS_SIGN = set.NOT_EQUALS_SIGN;
	little_Keywords.XOR_SIGN = set.XOR_SIGN;
	little_Keywords.OR_SIGN = set.OR_SIGN;
	little_Keywords.AND_SIGN = set.AND_SIGN;
	little_Keywords.FOR_LOOP_IDENTIFIERS = set.FOR_LOOP_IDENTIFIERS;
};
var little_tools_Plugins = function() { };
$hxClasses["little.tools.Plugins"] = little_tools_Plugins;
little_tools_Plugins.__name__ = true;
little_tools_Plugins.registerHaxeClass = function(stats) {
	if(stats.length == 0) {
		return;
	}
	var fieldValues_h = Object.create(null);
	var fieldFunctions_h = Object.create(null);
	var name = stats[0].className;
	var cls = $hxClasses[name];
	var _g = 0;
	while(_g < stats.length) {
		var s = stats[_g];
		++_g;
		var field = s.name;
		var value = Reflect.field(cls,field);
		if(Reflect.isFunction(value)) {
			fieldFunctions_h[field] = value;
		} else {
			fieldValues_h[field] = value;
		}
	}
	var motherObj = new little_interpreter_MemoryObject(little_parser_ParserTokens.Module(stats[0].className),new haxe_ds_StringMap(),null,little_parser_ParserTokens.Identifier(little_Keywords.TYPE_MODULE),true);
	var _g = 0;
	while(_g < stats.length) {
		var instance = [stats[_g]];
		++_g;
		switch(instance[0].fieldType) {
		case "function":
			var value = little_parser_ParserTokens.External((function(instance) {
				return function(args) {
					var func = fieldFunctions_h[instance[0].name];
					var _g = [];
					var _g1 = 0;
					while(_g1 < args.length) {
						var arg = args[_g1];
						++_g1;
						_g.push(little_tools_Conversion.toHaxeValue(arg));
					}
					return little_tools_Conversion.toLittleValue(func.apply(null,_g));
				};
			})(instance));
			var type = little_parser_ParserTokens.Identifier(little_tools_Conversion.toLittleType(instance[0].returnType));
			var params = [];
			var _g1 = 0;
			var _g2 = instance[0].parameters;
			while(_g1 < _g2.length) {
				var param = _g2[_g1];
				++_g1;
				params.push(little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier(param.name),little_parser_ParserTokens.Identifier(param.type)));
			}
			var this1 = motherObj.props;
			var k = instance[0].name;
			var v = new little_interpreter_MemoryObject(value,new haxe_ds_StringMap(),params,type,true);
			this1.h[k] = v;
			break;
		case "var":
			var value1 = little_tools_Conversion.toLittleValue(fieldValues_h[instance[0].name]);
			var type1 = little_parser_ParserTokens.Identifier(little_tools_Conversion.toLittleType(instance[0].returnType));
			var this2 = motherObj.props;
			var k1 = instance[0].name;
			var v1 = new little_interpreter_MemoryObject(value1,new haxe_ds_StringMap(),null,type1,true);
			this2.h[k1] = v1;
			break;
		}
	}
	little_interpreter_Interpreter.memory.h[stats[0].className] = motherObj;
};
little_tools_Plugins.registerVariable = function(variableName,variableModuleName,allowWriting,staticValue,valueGetter,valueSetter) {
	if(allowWriting == null) {
		allowWriting = false;
	}
	var this1 = little_interpreter_Interpreter.memory;
	var v = new little_interpreter_MemoryObject(little_parser_ParserTokens.External(function(params) {
		var currentModuleName = little_Little.runtime.currentModule;
		if(variableModuleName != null) {
			little_Little.runtime.currentModule = variableModuleName;
		}
		try {
			var val = staticValue != null ? staticValue : valueGetter();
			little_Little.runtime.currentModule = currentModuleName;
			return val;
		} catch( _g ) {
			var e = haxe_Exception.caught(_g);
			little_Little.runtime.currentModule = currentModuleName;
			return little_parser_ParserTokens.ErrorMessage("External Variable Error: " + e.details());
		}
	}),new haxe_ds_StringMap(),null,null,true);
	this1.h[variableName] = v;
	if(valueSetter != null) {
		little_interpreter_Interpreter.memory.h[variableName].valueSetter = function(v) {
			return little_interpreter_Interpreter.memory.h[variableName].set_value(valueSetter(v));
		};
	}
};
little_tools_Plugins.registerFunction = function(actionName,actionModuleName,expectedParameters,callback) {
	var params = typeof(expectedParameters) == "string" ? little_parser_Parser.parse(little_lexer_Lexer.lex(expectedParameters)) : expectedParameters;
	var memObject = new little_interpreter_MemoryObject(little_parser_ParserTokens.External(function(params) {
		var currentModuleName = little_Little.runtime.currentModule;
		if(actionModuleName != null) {
			little_Little.runtime.currentModule = actionModuleName;
		}
		try {
			var val = callback(params);
			little_Little.runtime.currentModule = currentModuleName;
			return val;
		} catch( _g ) {
			var e = haxe_Exception.caught(_g);
			little_Little.runtime.currentModule = currentModuleName;
			return little_parser_ParserTokens.ErrorMessage("External Function Error: " + e.details());
		}
	}),new haxe_ds_StringMap(),expectedParameters,null,true);
	if(actionModuleName != null) {
		var this1 = little_interpreter_Interpreter.memory;
		var v = new little_interpreter_MemoryObject(little_parser_ParserTokens.Module(actionModuleName),new haxe_ds_StringMap(),null,little_parser_ParserTokens.Identifier(little_Keywords.TYPE_MODULE),true);
		this1.h[actionModuleName] = v;
		little_interpreter_Interpreter.memory.h[actionModuleName].props.h[actionName] = memObject;
	} else {
		little_interpreter_Interpreter.memory.h[actionName] = memObject;
	}
};
little_tools_Plugins.registerCondition = function(conditionName,expectedConditionPattern,callback) {
	little_Keywords.CONDITION_TYPES.push(conditionName);
	var params = typeof(expectedConditionPattern) == "string" ? little_parser_Parser.parse(little_lexer_Lexer.lex(expectedConditionPattern)) : expectedConditionPattern;
	var this1 = little_interpreter_Interpreter.memory;
	var v = new little_interpreter_MemoryObject(little_parser_ParserTokens.ExternalCondition(function(con,body) {
		try {
			return callback(con,body);
		} catch( _g ) {
			var e = haxe_Exception.caught(_g);
			return little_parser_ParserTokens.ErrorMessage("External Condition Error: " + e.details());
		}
	}),new haxe_ds_StringMap(),expectedConditionPattern,null,true,true);
	this1.h[conditionName] = v;
};
var little_interpreter_Runtime = function() { };
$hxClasses["little.interpreter.Runtime"] = little_interpreter_Runtime;
little_interpreter_Runtime.__name__ = true;
little_interpreter_Runtime.throwError = function(token,layer) {
	if(layer == null) {
		layer = "Interpreter";
	}
	little_interpreter_Runtime.callStack.push(token);
	var module = little_interpreter_Runtime.currentModule;
	var title = "";
	var reason = little_tools_TextTools.replaceLast(little_tools_TextTools.remove(Std.string(token),$hxEnums[token.__enum__].__constructs__[token._hx_index]._hx_name).substring(1),")","");
	var content = "" + (little_Little.debug ? layer.toUpperCase() + ": " : "") + "ERROR: Module " + little_interpreter_Runtime.currentModule + ", Line " + little_interpreter_Runtime.line + ":  " + reason;
	little_interpreter_Runtime.stdout += "\n" + content;
	little_interpreter_Runtime.exitCode = little_tools_Layer.getIndexOf(layer);
	var _g = 0;
	var _g1 = little_interpreter_Runtime.onErrorThrown;
	while(_g < _g1.length) {
		var func = _g1[_g];
		++_g;
		func(module,little_interpreter_Runtime.line,title,reason);
	}
};
little_interpreter_Runtime.print = function(item) {
	little_interpreter_Runtime.stdout += "\n" + (little_Little.debug ? "Interpreter".toUpperCase() + ": " : "") + "Module " + little_interpreter_Runtime.currentModule + ", Line " + little_interpreter_Runtime.line + ":  " + (item == null ? "null" : "" + item);
};
var little_Little = function() { };
$hxClasses["little.Little"] = little_Little;
little_Little.__name__ = true;
little_Little.loadModule = function(code,name) {
	little_interpreter_Interpreter.errorThrown = false;
	little_interpreter_Runtime.line = 0;
};
little_Little.run = function(code,debug) {
	little_interpreter_Interpreter.errorThrown = false;
	little_interpreter_Runtime.line = 0;
	little_interpreter_Runtime.callStack = [];
	little_interpreter_Runtime.stdout = "";
	little_interpreter_Runtime.currentModule = little_Keywords.MAIN_MODULE_NAME;
	var previous = little_Little.debug;
	if(debug != null) {
		little_Little.debug = debug;
	}
	little_interpreter_Interpreter.memory = new haxe_ds_StringMap();
	little_tools_PrepareRun.addFunctions();
	little_tools_PrepareRun.addConditions();
	little_interpreter_Interpreter.interpret(little_parser_Parser.parse(little_lexer_Lexer.lex(code)),new little_interpreter_RunConfig(null,null,null,null,null));
	if(debug != null) {
		little_Little.debug = previous;
	}
};
var little_interpreter_Interpreter = function() { };
$hxClasses["little.interpreter.Interpreter"] = little_interpreter_Interpreter;
little_interpreter_Interpreter.__name__ = true;
little_interpreter_Interpreter.interpret = function(tokens,runConfig) {
	little_interpreter_Interpreter.currentConfig = runConfig;
	if(tokens == null || tokens.length == 0) {
		return little_parser_ParserTokens.NullValue;
	}
	var e = tokens[0];
	if($hxEnums[e.__enum__].__constructs__[e._hx_index]._hx_name != "Module") {
		tokens.unshift(little_parser_ParserTokens.Module(runConfig.defaultModuleName));
	}
	return little_interpreter_Interpreter.runTokens(tokens,runConfig.prioritizeVariableDeclarations,runConfig.prioritizeFunctionDeclarations,runConfig.strictTyping);
};
little_interpreter_Interpreter.runTokens = function(tokens,preParseVars,preParseFuncs,strict,memory) {
	if(memory == null) {
		memory = little_interpreter_Interpreter.memory;
	}
	var returnVal = null;
	var i = 0;
	while(i < tokens.length) {
		var token = tokens[i];
		if(token == null) {
			++i;
			continue;
		}
		switch(token._hx_index) {
		case 0:
			var line = token.line;
			little_interpreter_Runtime.line = line;
			break;
		case 1:
			break;
		case 2:
			var name = token.name;
			var type = token.type;
			var object = little_interpreter_Interpreter.accessObject(name,memory);
			object = new little_interpreter_MemoryObject(little_parser_ParserTokens.NullValue,null,null,type);
			returnVal = object.value;
			break;
		case 3:
			var name1 = token.name;
			var params = token.params;
			var type1 = token.type;
			var object1 = little_interpreter_Interpreter.accessObject(name1,memory);
			object1 = new little_interpreter_MemoryObject(little_parser_ParserTokens.NullValue,new haxe_ds_StringMap(),Type.enumParameters(params)[0],type1);
			returnVal = object1.value;
			break;
		case 4:
			var name2 = token.name;
			var exp = token.exp;
			var body = token.body;
			var type2 = token.type;
			var key = little_interpreter_Interpreter.stringifyTokenValue(name2);
			if(memory.h[key] == null) {
				returnVal = little_parser_ParserTokens.ErrorMessage("No Such Condition:  `" + little_interpreter_Interpreter.stringifyTokenValue(name2) + "`");
				little_interpreter_Runtime.throwError(returnVal);
			} else {
				var key1 = little_interpreter_Interpreter.stringifyTokenValue(name2);
				returnVal = memory.h[key1].use(little_parser_ParserTokens.PartArray([exp,body]));
				if($hxEnums[returnVal.__enum__].__constructs__[returnVal._hx_index]._hx_name == "ErrorMessage") {
					little_interpreter_Runtime.throwError(returnVal);
				}
			}
			break;
		case 5:
			var name3 = token.name;
			var str = little_interpreter_Interpreter.stringifyTokenValue(name3);
			returnVal = little_interpreter_Interpreter.evaluate(memory.h[str] != null ? memory.h[str].value : little_parser_ParserTokens.ErrorMessage("No Such Definition: `" + str + "`"));
			break;
		case 6:
			var assignees = token.assignees;
			var value = token.value;
			var type3 = token.type;
			var v = null;
			var _g = 0;
			while(_g < assignees.length) {
				var a = assignees[_g];
				++_g;
				var assignee = little_interpreter_Interpreter.accessObject(a);
				if(assignee == null) {
					continue;
				}
				if(assignee.params != null) {
					assignee.set_value(value);
				} else {
					if(v == null) {
						v = little_interpreter_Interpreter.evaluate(value);
					}
					if($hxEnums[v.__enum__].__constructs__[v._hx_index]._hx_name == "ErrorMessage") {
						assignee.set_value(little_parser_ParserTokens.NullValue);
					} else {
						assignee.set_value(v);
					}
				}
			}
			returnVal = value;
			break;
		case 9:
			var name4 = token.name;
			var params1 = token.params;
			var key2 = little_interpreter_Interpreter.stringifyTokenValue(name4);
			if(memory.h[key2] == null) {
				little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("No Such Action:  `" + little_interpreter_Interpreter.stringifyTokenValue(name4) + "`"));
			} else {
				var key3 = little_interpreter_Interpreter.stringifyTokenValue(name4);
				returnVal = memory.h[key3].use(params1);
				if($hxEnums[returnVal.__enum__].__constructs__[returnVal._hx_index]._hx_name == "ErrorMessage") {
					little_interpreter_Runtime.throwError(returnVal);
				}
			}
			break;
		case 10:
			var value1 = token.value;
			var type4 = token.type;
			return little_interpreter_Interpreter.evaluate(value1);
		case 12:
			var body1 = token.body;
			var type5 = token.type;
			returnVal = little_interpreter_Interpreter.runTokens(body1,preParseVars,preParseFuncs,strict);
			break;
		case 14:
			var name5 = token.name;
			var property = token.property;
			returnVal = little_interpreter_Interpreter.evaluate(token);
			break;
		case 19:
			var name6 = token.name;
			little_interpreter_Runtime.currentModule = name6;
			break;
		default:
			returnVal = little_interpreter_Interpreter.evaluate(token);
		}
		++i;
	}
	return returnVal;
};
little_interpreter_Interpreter.evaluate = function(exp,memory,dontThrow) {
	if(dontThrow == null) {
		dontThrow = false;
	}
	if(memory == null) {
		memory = little_interpreter_Interpreter.memory;
	}
	if(exp == null) {
		return little_parser_ParserTokens.NullValue;
	}
	switch(exp._hx_index) {
	case 0:
		var line = exp.line;
		little_interpreter_Runtime.line = line;
		return little_parser_ParserTokens.NullValue;
	case 1:
		return little_parser_ParserTokens.NullValue;
	case 2:
		var name = exp.name;
		var type = exp.type;
		var object = little_interpreter_Interpreter.accessObject(name,memory);
		object = new little_interpreter_MemoryObject(little_parser_ParserTokens.NullValue,null,null,type);
		return object.value;
	case 3:
		var name = exp.name;
		var params = exp.params;
		var type = exp.type;
		var object = little_interpreter_Interpreter.accessObject(name,memory);
		object = new little_interpreter_MemoryObject(little_parser_ParserTokens.NullValue,new haxe_ds_StringMap(),Type.enumParameters(params)[0],type);
		return object.value;
	case 4:
		var name = exp.name;
		var exp1 = exp.exp;
		var body = exp.body;
		var type = exp.type;
		var key = little_interpreter_Interpreter.stringifyTokenValue(name);
		if(memory.h[key] == null) {
			return little_interpreter_Interpreter.evaluate(little_parser_ParserTokens.ErrorMessage("No Such Condition:  `" + little_interpreter_Interpreter.stringifyTokenValue(name) + "`"),memory,dontThrow);
		} else {
			var key = little_interpreter_Interpreter.stringifyTokenValue(name);
			return little_interpreter_Interpreter.evaluate(memory.h[key].use(little_parser_ParserTokens.PartArray([exp1,body])),memory,dontThrow);
		}
		break;
	case 5:
		var name = exp.name;
		var str = little_interpreter_Interpreter.stringifyTokenValue(name);
		return little_interpreter_Interpreter.evaluate(memory.h[str] != null ? memory.h[str].value : little_parser_ParserTokens.ErrorMessage("No Such Definition: `" + str + "`"),memory,dontThrow);
	case 6:
		var assignees = exp.assignees;
		var value = exp.value;
		var type = exp.type;
		var v = null;
		var _g = 0;
		while(_g < assignees.length) {
			var a = assignees[_g];
			++_g;
			var assignee = little_interpreter_Interpreter.accessObject(a);
			if(assignee == null) {
				continue;
			}
			if(assignee.params != null) {
				assignee.set_value(value);
			} else {
				if(v == null) {
					v = little_interpreter_Interpreter.evaluate(value);
				}
				if($hxEnums[v.__enum__].__constructs__[v._hx_index]._hx_name == "ErrorMessage") {
					assignee.set_value(little_parser_ParserTokens.NullValue);
				} else {
					assignee.set_value(v);
				}
			}
		}
		return little_interpreter_Interpreter.evaluate(value,memory,dontThrow);
	case 7:
		var word = exp.word;
		return little_interpreter_Interpreter.evaluate(memory.h[word] != null ? memory.h[word].value : little_parser_ParserTokens.ErrorMessage("No Such Definition: `" + word + "`"),memory,dontThrow);
	case 8:
		var type = exp.type;
		return little_interpreter_Interpreter.evaluate(type,memory,dontThrow);
	case 9:
		var name = exp.name;
		var params = exp.params;
		var key = little_interpreter_Interpreter.stringifyTokenValue(name);
		if(memory.h[key] == null) {
			return little_interpreter_Interpreter.evaluate(little_parser_ParserTokens.ErrorMessage("No Such Action:  `" + little_interpreter_Interpreter.stringifyTokenValue(name) + "`"));
		}
		var key = little_interpreter_Interpreter.stringifyTokenValue(name);
		return little_interpreter_Interpreter.evaluate(memory.h[key].use(params),memory,dontThrow);
	case 10:
		var value = exp.value;
		var type = exp.type;
		return little_interpreter_Interpreter.evaluate(value,memory,dontThrow);
	case 11:
		var _g = exp.type;
		var parts = exp.parts;
		return little_interpreter_Interpreter.evaluateExpressionParts(parts);
	case 12:
		var body = exp.body;
		var type = exp.type;
		var returnVal = little_interpreter_Interpreter.runTokens(body,little_interpreter_Interpreter.currentConfig.prioritizeVariableDeclarations,little_interpreter_Interpreter.currentConfig.prioritizeFunctionDeclarations,little_interpreter_Interpreter.currentConfig.strictTyping);
		return little_interpreter_Interpreter.evaluate(returnVal,memory,dontThrow);
	case 13:
		var parts = exp.parts;
		var _g = [];
		var _g1 = 0;
		while(_g1 < parts.length) {
			var p = parts[_g1];
			++_g1;
			_g.push(little_interpreter_Interpreter.evaluate(p,memory,dontThrow));
		}
		return little_parser_ParserTokens.PartArray(_g);
	case 14:
		var _g = exp.name;
		var _g = exp.property;
		return little_interpreter_Interpreter.accessObject(exp,memory).value;
	case 15:
		var _g = exp.sign;
		return exp;
	case 16:
		var _g = exp.num;
		return exp;
	case 17:
		var _g = exp.num;
		return exp;
	case 18:
		var _g = exp.string;
		return exp;
	case 19:
		var name = exp.name;
		little_interpreter_Runtime.currentModule = name;
		return little_parser_ParserTokens.NullValue;
	case 20:
		var get = exp.get;
		return little_interpreter_Interpreter.evaluate(get([]),memory,dontThrow);
	case 22:
		var msg = exp.msg;
		if(!dontThrow) {
			little_interpreter_Runtime.throwError(exp,"Interpreter, Value Evaluator");
		}
		return exp;
	case 23:case 24:case 25:
		return exp;
	default:
		return little_interpreter_Interpreter.evaluate(little_parser_ParserTokens.ErrorMessage("Unable to evaluate token `" + Std.string(exp) + "`"),memory,dontThrow);
	}
};
little_interpreter_Interpreter.accessObject = function(exp,memory) {
	if(memory == null) {
		memory = little_interpreter_Interpreter.memory;
	}
	switch(exp._hx_index) {
	case 0:
		var line = exp.line;
		little_interpreter_Runtime.line = line;
		break;
	case 2:
		var name = exp.name;
		var type = exp.type;
		var access = null;
		access = function(object,prop,objName) {
			if(prop._hx_index == 14) {
				var _g = prop.name;
				var property = prop.property;
				objName += "" + little_Keywords.PROPERTY_ACCESS_SIGN + little_interpreter_Interpreter.stringifyTokenValue(prop);
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenValue(prop);
				if(this1.h[key] == null) {
					little_interpreter_Interpreter.evaluate(little_parser_ParserTokens.ErrorMessage("Unable to create `" + objName + little_Keywords.PROPERTY_ACCESS_SIGN + little_interpreter_Interpreter.stringifyTokenIdentifier(property) + "`: `" + objName + "` Does not contain property `" + little_interpreter_Interpreter.stringifyTokenIdentifier(property) + "`."));
					return null;
				}
				var access1 = access;
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenValue(prop);
				return access1(this1.h[key],property,objName);
			} else {
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenIdentifier(prop);
				if(this1.h[key] == null) {
					var this1 = object.props;
					var k = little_interpreter_Interpreter.stringifyTokenIdentifier(prop);
					var v = new little_interpreter_MemoryObject(little_parser_ParserTokens.NullValue,null,null,type);
					this1.h[k] = v;
				}
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenIdentifier(prop);
				return this1.h[key];
			}
		};
		if(name._hx_index == 14) {
			var name1 = name.name;
			var property = name.property;
			var access1 = access;
			var key = little_interpreter_Interpreter.stringifyTokenValue(name1);
			var obj = access1(memory.h[key],property,little_interpreter_Interpreter.stringifyTokenValue(name1));
			return obj;
		} else {
			var k = little_interpreter_Interpreter.stringifyTokenValue(name);
			var v = new little_interpreter_MemoryObject(little_parser_ParserTokens.NullValue,null,null,type);
			memory.h[k] = v;
			var key = little_interpreter_Interpreter.stringifyTokenValue(name);
			return memory.h[key];
		}
		break;
	case 3:
		var name = exp.name;
		var params = exp.params;
		var type1 = exp.type;
		var access1 = null;
		access1 = function(object,prop,objName) {
			if(prop._hx_index == 14) {
				var _g = prop.name;
				var property = prop.property;
				objName += "" + little_Keywords.PROPERTY_ACCESS_SIGN + little_interpreter_Interpreter.stringifyTokenValue(prop);
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenValue(prop);
				if(this1.h[key] == null) {
					little_interpreter_Interpreter.evaluate(little_parser_ParserTokens.ErrorMessage("Unable to create `" + objName + little_Keywords.PROPERTY_ACCESS_SIGN + little_interpreter_Interpreter.stringifyTokenIdentifier(property) + "`: `" + objName + "` Does not contain property `" + little_interpreter_Interpreter.stringifyTokenIdentifier(property) + "`."));
					return null;
				}
				var access = access1;
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenValue(prop);
				return access(this1.h[key],property,objName);
			} else {
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenIdentifier(prop);
				if(this1.h[key] == null) {
					var this1 = object.props;
					var k = little_interpreter_Interpreter.stringifyTokenIdentifier(prop);
					var v = new little_interpreter_MemoryObject(little_parser_ParserTokens.NullValue,new haxe_ds_StringMap(),Type.enumParameters(params)[0],type1);
					this1.h[k] = v;
				}
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenIdentifier(prop);
				return this1.h[key];
			}
		};
		if(name._hx_index == 14) {
			var name1 = name.name;
			var property = name.property;
			var access2 = access1;
			var key = little_interpreter_Interpreter.stringifyTokenValue(name1);
			var obj = access2(memory.h[key],property,little_interpreter_Interpreter.stringifyTokenValue(name1));
			return obj;
		} else {
			haxe_Log.trace(name,{ fileName : "src/little/interpreter/Interpreter.hx", lineNumber : 300, className : "little.interpreter.Interpreter", methodName : "accessObject", customParams : [little_interpreter_Interpreter.stringifyTokenValue(name)]});
			var k = little_interpreter_Interpreter.stringifyTokenValue(name);
			var v = new little_interpreter_MemoryObject(little_parser_ParserTokens.NullValue,new haxe_ds_StringMap(),Type.enumParameters(params)[0],type1);
			memory.h[k] = v;
			var key = little_interpreter_Interpreter.stringifyTokenValue(name);
			return memory.h[key];
		}
		break;
	case 5:
		var name = exp.name;
		var word = little_interpreter_Interpreter.stringifyTokenValue(name);
		little_interpreter_Interpreter.evaluate(memory.h[word] != null ? memory.h[word].value : little_parser_ParserTokens.ErrorMessage("No Such Definition: `" + word + "`"));
		return memory.h[word];
	case 7:
		var word = exp.word;
		little_interpreter_Interpreter.evaluate(memory.h[word] != null ? memory.h[word].value : little_parser_ParserTokens.ErrorMessage("No Such Definition: `" + word + "`"));
		return memory.h[word];
	case 9:
		var name = exp.name;
		var params1 = exp.params;
		var key = little_interpreter_Interpreter.stringifyTokenValue(name);
		if(memory.h[key] == null) {
			little_interpreter_Interpreter.evaluate(little_parser_ParserTokens.ErrorMessage("No Such Action:  `" + little_interpreter_Interpreter.stringifyTokenValue(name) + "`"));
		}
		var key = little_interpreter_Interpreter.stringifyTokenValue(name);
		return little_interpreter_Interpreter.accessObject(memory.h[key].use(params1));
	case 10:
		var value = exp.value;
		var type2 = exp.type;
		return little_interpreter_Interpreter.accessObject(value);
	case 11:
		var _g = exp.type;
		var parts = exp.parts;
		return little_interpreter_Interpreter.accessObject(little_interpreter_Interpreter.evaluateExpressionParts(parts));
	case 12:
		var body = exp.body;
		var type2 = exp.type;
		var returnVal = little_interpreter_Interpreter.runTokens(body,little_interpreter_Interpreter.currentConfig.prioritizeVariableDeclarations,little_interpreter_Interpreter.currentConfig.prioritizeFunctionDeclarations,little_interpreter_Interpreter.currentConfig.strictTyping);
		return little_interpreter_Interpreter.accessObject(little_interpreter_Interpreter.evaluate(returnVal));
	case 14:
		var n = exp.name;
		var p = exp.property;
		var str = little_interpreter_Interpreter.stringifyTokenValue(n);
		var prop = little_interpreter_Interpreter.stringifyTokenIdentifier(p);
		if(memory.h[str] == null) {
			little_interpreter_Interpreter.evaluate(little_parser_ParserTokens.ErrorMessage("Unable to access property `" + str + little_Keywords.PROPERTY_ACCESS_SIGN + prop + "` - No Such Definition: `" + str + "`"));
		}
		var obj = memory.h[str];
		var access2 = null;
		access2 = function(object,prop,objName) {
			switch(prop._hx_index) {
			case 9:
				var name = prop.name;
				var params = prop.params;
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenValue(name);
				if(this1.h[key] == null) {
					little_interpreter_Interpreter.evaluate(little_parser_ParserTokens.ErrorMessage("Unable to call `" + objName + little_Keywords.PROPERTY_ACCESS_SIGN + little_interpreter_Interpreter.stringifyTokenValue(name) + "(" + little_interpreter_Interpreter.stringifyTokenValue(params) + ")`: `" + objName + "` Does not contain property `" + little_interpreter_Interpreter.stringifyTokenIdentifier(name) + "`."));
					return null;
				}
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenValue(name);
				return new little_interpreter_MemoryObject(this1.h[key].use(params));
			case 14:
				var _g = prop.name;
				var property = prop.property;
				objName += "" + little_Keywords.PROPERTY_ACCESS_SIGN + little_interpreter_Interpreter.stringifyTokenValue(prop);
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenValue(prop);
				if(this1.h[key] == null) {
					little_interpreter_Interpreter.evaluate(little_parser_ParserTokens.ErrorMessage("Unable to access `" + objName + little_Keywords.PROPERTY_ACCESS_SIGN + little_interpreter_Interpreter.stringifyTokenIdentifier(property) + "`: `" + objName + "` Does not contain property `" + little_interpreter_Interpreter.stringifyTokenIdentifier(property) + "`."));
					return null;
				}
				var access = access2;
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenValue(prop);
				return access(this1.h[key],property,objName);
			default:
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenIdentifier(prop);
				if(this1.h[key] == null) {
					var this1 = object.props;
					var k = little_interpreter_Interpreter.stringifyTokenIdentifier(prop);
					var v = new little_interpreter_MemoryObject(little_parser_ParserTokens.NullValue);
					this1.h[k] = v;
				}
				var this1 = object.props;
				var key = little_interpreter_Interpreter.stringifyTokenIdentifier(prop);
				return this1.h[key];
			}
		};
		return access2(obj,p,str);
	case 15:
		var _g = exp.sign;
		var key = little_interpreter_Interpreter.stringifyTokenValue(exp);
		return memory.h[key];
	case 16:
		var _g = exp.num;
		var key = little_interpreter_Interpreter.stringifyTokenValue(exp);
		return memory.h[key];
	case 17:
		var _g = exp.num;
		var key = little_interpreter_Interpreter.stringifyTokenValue(exp);
		return memory.h[key];
	case 18:
		var _g = exp.string;
		var key = little_interpreter_Interpreter.stringifyTokenValue(exp);
		return memory.h[key];
	case 19:
		var name = exp.name;
		little_interpreter_Runtime.currentModule = name;
		break;
	case 23:case 24:case 25:
		var key = little_interpreter_Interpreter.stringifyTokenValue(exp);
		return memory.h[key];
	default:
		haxe_Log.trace("Token " + Std.string(exp) + " is inaccessible via memory. Returning null.",{ fileName : "src/little/interpreter/Interpreter.hx", lineNumber : 346, className : "little.interpreter.Interpreter", methodName : "accessObject"});
	}
	return null;
};
little_interpreter_Interpreter.stringifyTokenValue = function(token,memory) {
	if(memory == null) {
		memory = little_interpreter_Interpreter.memory;
	}
	switch(token._hx_index) {
	case 0:
		var line = token.line;
		return (little_interpreter_Runtime.line = line) + "";
	case 1:
		return $hxEnums[token.__enum__].__constructs__[token._hx_index]._hx_name;
	case 2:
		var name = token.name;
		var type = token.type;
		var k = little_interpreter_Interpreter.stringifyTokenValue(name);
		var v = new little_interpreter_MemoryObject(little_parser_ParserTokens.NullValue,new haxe_ds_StringMap(),null,type);
		memory.h[k] = v;
		return little_interpreter_Interpreter.stringifyTokenValue(name);
	case 3:
		var name = token.name;
		var params = token.params;
		var type = token.type;
		var k = little_interpreter_Interpreter.stringifyTokenValue(name);
		var v = new little_interpreter_MemoryObject(little_parser_ParserTokens.NullValue,new haxe_ds_StringMap(),Type.enumParameters(params)[0],type);
		memory.h[k] = v;
		return little_interpreter_Interpreter.stringifyTokenValue(name);
	case 4:
		var _g = token.name;
		var _g = token.exp;
		var _g = token.body;
		var _g = token.type;
		return little_interpreter_Interpreter.stringifyTokenValue(little_interpreter_Interpreter.evaluate(token,memory));
	case 5:
		var name = token.name;
		var str = little_interpreter_Interpreter.stringifyTokenValue(name);
		return little_interpreter_Interpreter.stringifyTokenValue(memory.h[str] != null ? memory.h[str].value : little_parser_ParserTokens.ErrorMessage("No Such Definition: `" + str + "`"));
	case 6:
		var _g = token.assignees;
		var _g = token.type;
		var value = token.value;
		return little_interpreter_Interpreter.stringifyTokenValue(value);
	case 7:
		var word = token.word;
		return word;
	case 8:
		var _g = token.type;
		return little_interpreter_Interpreter.stringifyTokenValue(little_interpreter_Interpreter.evaluate(token,memory));
	case 9:
		var name = token.name;
		var params = token.params;
		var str = little_interpreter_Interpreter.stringifyTokenValue(name);
		return little_interpreter_Interpreter.stringifyTokenValue(memory.h[str] != null ? memory.h[str].use(params) : little_parser_ParserTokens.ErrorMessage("No Such Action: `" + str + "`"));
	case 10:
		var value = token.value;
		var type = token.type;
		return little_interpreter_Interpreter.stringifyTokenValue(value);
	case 11:
		var parts = token.parts;
		var type = token.type;
		return little_interpreter_Interpreter.stringifyTokenValue(little_interpreter_Interpreter.evaluate(token));
	case 12:
		var body = token.body;
		var type = token.type;
		return little_interpreter_Interpreter.stringifyTokenValue(little_interpreter_Interpreter.runTokens(body,little_interpreter_Interpreter.currentConfig.prioritizeVariableDeclarations,little_interpreter_Interpreter.currentConfig.prioritizeFunctionDeclarations,little_interpreter_Interpreter.currentConfig.strictTyping));
	case 13:
		var parts = token.parts;
		var _g = [];
		var _g1 = 0;
		while(_g1 < parts.length) {
			var p = parts[_g1];
			++_g1;
			_g.push(little_interpreter_Interpreter.stringifyTokenValue(little_interpreter_Interpreter.evaluate(p)));
		}
		return _g.join(",");
	case 14:
		var _g = token.name;
		var _g = token.property;
		return little_interpreter_Interpreter.stringifyTokenValue(little_interpreter_Interpreter.evaluate(token,memory));
	case 15:
		var sign = token.sign;
		return sign;
	case 16:
		var num = token.num;
		return num;
	case 17:
		var num = token.num;
		return num;
	case 18:
		var string = token.string;
		return string;
	case 19:
		var name = token.name;
		return little_interpreter_Runtime.currentModule = name;
	case 20:
		var _g = token.get;
		return little_interpreter_Interpreter.stringifyTokenValue(little_interpreter_Interpreter.evaluate(token,memory));
	case 21:
		var _g = token.use;
		return little_interpreter_Interpreter.stringifyTokenValue(little_interpreter_Interpreter.evaluate(token,memory));
	case 22:
		var msg = token.msg;
		return msg;
	case 23:
		return little_Keywords.NULL_VALUE;
	case 24:
		return little_Keywords.TRUE_VALUE;
	case 25:
		return little_Keywords.FALSE_VALUE;
	}
};
little_interpreter_Interpreter.stringifyTokenIdentifier = function(token,prop,memory) {
	if(prop == null) {
		prop = false;
	}
	if(memory == null) {
		memory = little_interpreter_Interpreter.memory;
	}
	switch(token._hx_index) {
	case 0:
		var line = token.line;
		little_interpreter_Runtime.line = line;
		return "\n";
	case 1:
		return ",";
	case 2:
		var name = token.name;
		var type = token.type;
		return little_interpreter_Interpreter.stringifyTokenIdentifier(name);
	case 3:
		var name = token.name;
		var params = token.params;
		var type = token.type;
		return little_interpreter_Interpreter.stringifyTokenIdentifier(name);
	case 4:
		var name = token.name;
		var exp = token.exp;
		var body = token.body;
		var type = token.type;
		return little_interpreter_Interpreter.stringifyTokenIdentifier(name);
	case 5:
		var name = token.name;
		return little_interpreter_Interpreter.stringifyTokenIdentifier(name);
	case 6:
		var _g = token.value;
		var _g = token.type;
		var assignees = token.assignees;
		return little_interpreter_Interpreter.stringifyTokenIdentifier(assignees[0]);
	case 7:
		var word = token.word;
		return word;
	case 8:
		var type = token.type;
		return little_interpreter_Interpreter.stringifyTokenIdentifier(type);
	case 9:
		var name = token.name;
		var params = token.params;
		if(prop) {
			return little_interpreter_Interpreter.stringifyTokenValue(name);
		}
		var str = little_interpreter_Interpreter.stringifyTokenValue(name);
		return little_interpreter_Interpreter.stringifyTokenIdentifier(memory.h[str] != null ? memory.h[str].use(params) : little_parser_ParserTokens.ErrorMessage("No Such Action: `" + str + "`"));
	case 10:
		var value = token.value;
		var type = token.type;
		return little_interpreter_Interpreter.stringifyTokenIdentifier(value);
	case 11:
		var parts = token.parts;
		var type = token.type;
		return little_interpreter_Interpreter.stringifyTokenIdentifier(little_interpreter_Interpreter.evaluate(token));
	case 12:
		var body = token.body;
		var type = token.type;
		return little_interpreter_Interpreter.stringifyTokenIdentifier(little_interpreter_Interpreter.runTokens(body,little_interpreter_Interpreter.currentConfig.prioritizeVariableDeclarations,little_interpreter_Interpreter.currentConfig.prioritizeFunctionDeclarations,little_interpreter_Interpreter.currentConfig.strictTyping));
	case 13:
		var parts = token.parts;
		var _g = [];
		var _g1 = 0;
		while(_g1 < parts.length) {
			var p = parts[_g1];
			++_g1;
			_g.push(little_interpreter_Interpreter.stringifyTokenValue(little_interpreter_Interpreter.evaluate(p)));
		}
		return _g.join(",");
	case 14:
		var name = token.name;
		var property = token.property;
		return little_interpreter_Interpreter.stringifyTokenIdentifier(name);
	case 15:
		var sign = token.sign;
		return sign;
	case 16:
		var num = token.num;
		return num;
	case 17:
		var num = token.num;
		return num;
	case 18:
		var string = token.string;
		return string;
	case 19:
		var word = token.name;
		return word;
	case 20:
		var _g = token.get;
		little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("" + Std.string(token) + " \"does not have\" a token identifier. it must be bound to one (for example, as a definiton's value."),"Interpreter, Token Identifier Stringifier");
		return "";
	case 21:
		var _g = token.use;
		little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("" + Std.string(token) + " \"does not have\" a token identifier. it must be bound to one (for example, as a definiton's value."),"Interpreter, Token Identifier Stringifier");
		return "";
	case 22:
		var msg = token.msg;
		return $hxEnums[token.__enum__].__constructs__[token._hx_index]._hx_name;
	case 23:
		return little_Keywords.NULL_VALUE;
	case 24:
		return little_Keywords.TRUE_VALUE;
	case 25:
		return little_Keywords.FALSE_VALUE;
	}
};
little_interpreter_Interpreter.evaluateExpressionParts = function(parts,memory) {
	if(memory == null) {
		memory = little_interpreter_Interpreter.memory;
	}
	parts = little_interpreter_Interpreter.forceCorrectOrderOfOperations(parts);
	var value = "";
	var valueType = little_Keywords.TYPE_UNKNOWN;
	var mode = "+";
	var _g = 0;
	while(_g < parts.length) {
		var token = parts[_g];
		++_g;
		haxe_Log.trace(token,{ fileName : "src/little/interpreter/Interpreter.hx", lineNumber : 481, className : "little.interpreter.Interpreter", methodName : "evaluateExpressionParts"});
		var val = little_interpreter_Interpreter.evaluate(token);
		haxe_Log.trace(val,{ fileName : "src/little/interpreter/Interpreter.hx", lineNumber : 483, className : "little.interpreter.Interpreter", methodName : "evaluateExpressionParts"});
		switch(val._hx_index) {
		case 15:
			var sign = val.sign;
			mode = sign;
			break;
		case 16:
			var num = val.num;
			if(valueType == little_Keywords.TYPE_UNKNOWN) {
				valueType = little_Keywords.TYPE_INT;
				switch(mode) {
				case "+":
					value = "" + Std.parseInt(num);
					break;
				case "-":
					value = "" + -Std.parseInt(num);
					break;
				default:
					return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + mode + " " + little_Keywords.TYPE_INT + "(" + num + ")` At the start of an expression");
				}
			} else if(valueType == little_Keywords.TYPE_FLOAT || valueType == little_Keywords.TYPE_INT || valueType == little_Keywords.TYPE_BOOLEAN) {
				if(valueType == little_Keywords.TYPE_BOOLEAN) {
					valueType = little_Keywords.TYPE_INT;
					value = little_tools_TextTools.replace(little_tools_TextTools.replace(little_tools_TextTools.replace(value,little_Keywords.TRUE_VALUE,"1"),little_Keywords.FALSE_VALUE,"0"),little_Keywords.NULL_VALUE,"0");
				}
				switch(mode) {
				case "*":
					value = "" + parseFloat(value) * Std.parseInt(num);
					break;
				case "+":
					value = "" + (parseFloat(value) + Std.parseInt(num));
					break;
				case "-":
					value = "" + (parseFloat(value) - Std.parseInt(num));
					break;
				case "/":
					valueType = little_Keywords.TYPE_FLOAT;
					value = "" + Std.parseInt(value) / Std.parseInt(num);
					break;
				case "!=":case "<":case "<=":case "==":case ">":case ">=":
					valueType = little_Keywords.TYPE_BOOLEAN;
					switch(mode) {
					case "!=":
						value = "" + Std.string(value != num);
						break;
					case "<":
						value = "" + Std.string(parseFloat(value) < Std.parseInt(num));
						break;
					case "<=":
						value = "" + Std.string(parseFloat(value) <= Std.parseInt(num));
						break;
					case "==":
						value = "" + Std.string(value == num);
						break;
					case ">":
						value = "" + Std.string(parseFloat(value) > Std.parseInt(num));
						break;
					case ">=":
						value = "" + Std.string(parseFloat(value) >= Std.parseInt(num));
						break;
					default:
						return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_INT + "(" + num + ")`");
					}
					break;
				case "^":
					value = "" + Math.pow(Std.parseInt(value),Std.parseInt(num));
					break;
				default:
					return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_INT + "(" + num + ")`");
				}
			} else if(valueType == little_Keywords.TYPE_STRING) {
				switch(mode) {
				case "*":
					value = little_tools_TextTools.multiply(value,Std.parseInt(num));
					break;
				case "+":
					value += num;
					break;
				case "-":
					value = little_tools_TextTools.replaceLast(value,num,"");
					break;
				case "!=":case "<":case "<=":case "==":case ">":case ">=":
					valueType = little_Keywords.TYPE_BOOLEAN;
					switch(mode) {
					case "!=":
						value = "true";
						break;
					case "==":
						value = "false";
						break;
					default:
						return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_INT + "(" + num + ")`");
					}
					break;
				default:
					return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_INT + "(" + num + ")`");
				}
			}
			break;
		case 17:
			var num1 = val.num;
			if(valueType == little_Keywords.TYPE_UNKNOWN) {
				valueType = little_Keywords.TYPE_FLOAT;
				switch(mode) {
				case "+":
					value = "" + parseFloat(num1);
					break;
				case "-":
					value = "" + -parseFloat(num1);
					break;
				default:
					return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + mode + " " + little_Keywords.TYPE_FLOAT + "(" + num1 + ")` At the start of an expression");
				}
			} else if(valueType == little_Keywords.TYPE_FLOAT || valueType == little_Keywords.TYPE_INT || valueType == little_Keywords.TYPE_BOOLEAN) {
				if(valueType == little_Keywords.TYPE_BOOLEAN) {
					value = little_tools_TextTools.replace(little_tools_TextTools.replace(little_tools_TextTools.replace(value,little_Keywords.TRUE_VALUE,"1"),little_Keywords.FALSE_VALUE,"0"),little_Keywords.NULL_VALUE,"0");
				}
				valueType = little_Keywords.TYPE_FLOAT;
				switch(mode) {
				case "*":
					value = "" + parseFloat(value) * parseFloat(num1);
					break;
				case "+":
					value = "" + (parseFloat(value) + parseFloat(num1));
					break;
				case "-":
					value = "" + (parseFloat(value) - parseFloat(num1));
					break;
				case "/":
					value = "" + parseFloat(value) / parseFloat(num1);
					break;
				case "!=":case "<":case "<=":case "==":case ">":case ">=":
					valueType = little_Keywords.TYPE_BOOLEAN;
					switch(mode) {
					case "!=":
						value = "" + Std.string(value != num1);
						break;
					case "<":
						value = "" + Std.string(parseFloat(value) < parseFloat(num1));
						break;
					case "<=":
						value = "" + Std.string(parseFloat(value) <= parseFloat(num1));
						break;
					case "==":
						value = "" + Std.string(value == num1);
						break;
					case ">":
						value = "" + Std.string(parseFloat(value) > parseFloat(num1));
						break;
					case ">=":
						value = "" + Std.string(parseFloat(value) >= parseFloat(num1));
						break;
					default:
						return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_FLOAT + "(" + num1 + ")`");
					}
					break;
				case "^":
					value = "" + Math.pow(parseFloat(value),parseFloat(num1));
					break;
				default:
					return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_FLOAT + "(" + num1 + ")`");
				}
			} else if(valueType == little_Keywords.TYPE_STRING) {
				switch(mode) {
				case "+":
					value += num1;
					break;
				case "-":
					value = little_tools_TextTools.replaceLast(value,num1,"");
					break;
				case "!=":case "<":case "<=":case "==":case ">":case ">=":
					valueType = little_Keywords.TYPE_BOOLEAN;
					switch(mode) {
					case "!=":
						value = "true";
						break;
					case "==":
						value = "false";
						break;
					default:
						return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_FLOAT + "(" + num1 + ")`");
					}
					break;
				default:
					return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_FLOAT + "(" + num1 + ")`");
				}
			}
			break;
		case 18:
			var string = val.string;
			valueType = little_Keywords.TYPE_STRING;
			switch(mode) {
			case "+":
				value += string;
				break;
			case "-":
				value = little_tools_TextTools.replaceLast(value,string,"");
				break;
			case "!=":case "<":case "<=":case "==":case ">":case ">=":
				valueType = little_Keywords.TYPE_BOOLEAN;
				switch(mode) {
				case "!=":
					value = "" + Std.string(value != string);
					break;
				case "<":
					value = "" + Std.string(value.length < string.length);
					break;
				case "<=":
					value = "" + Std.string(value.length <= string.length);
					break;
				case "==":
					value = "" + Std.string(value == string);
					break;
				case ">":
					value = "" + Std.string(value.length > string.length);
					break;
				case ">=":
					value = "" + Std.string(value.length >= string.length);
					break;
				default:
					return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_STRING + "(" + string + ")`");
				}
				break;
			default:
				return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_STRING + "(" + string + ")`");
			}
			break;
		case 22:
			var _g1 = val.msg;
			little_interpreter_Runtime.throwError(val,"Interpreter, Value Evaluator");
			break;
		case 24:case 25:
			if(valueType == little_Keywords.TYPE_UNKNOWN) {
				valueType = little_Keywords.TYPE_BOOLEAN;
				value = Std.string(val == little_parser_ParserTokens.TrueValue);
			} else if(valueType == little_Keywords.TYPE_BOOLEAN) {
				var bool = val == little_parser_ParserTokens.TrueValue;
				switch(mode) {
				case "&&":
					value = Std.string(little_tools_TextTools.parseBool(value) && bool);
					break;
				case "==":
					value = Std.string(little_tools_TextTools.parseBool(value) == bool);
					break;
				case "!=":case "^^":
					value = Std.string(little_tools_TextTools.parseBool(value) != bool);
					break;
				case "||":
					value = Std.string(little_tools_TextTools.parseBool(value) || bool);
					break;
				default:
					return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_BOOLEAN + "(" + (bool == null ? "null" : "" + bool) + ")`");
				}
			} else if(valueType == little_Keywords.TYPE_INT || valueType == little_Keywords.TYPE_FLOAT) {
				var num2 = val == little_parser_ParserTokens.TrueValue ? 1 : 0;
				switch(mode) {
				case "*":
					value = "" + parseFloat(value) * num2;
					break;
				case "+":
					value = "" + (parseFloat(value) + num2);
					break;
				case "-":
					value = "" + (parseFloat(value) - num2);
					break;
				case "/":
					valueType = little_Keywords.TYPE_FLOAT;
					value = "" + Std.parseInt(value) / num2;
					break;
				case "!=":case "<":case "<=":case "==":case ">":case ">=":
					valueType = little_Keywords.TYPE_BOOLEAN;
					switch(mode) {
					case "!=":
						value = "" + Std.string(value != (num2 == null ? "null" : "" + num2));
						break;
					case "<":
						value = "" + Std.string(parseFloat(value) < num2);
						break;
					case "<=":
						value = "" + Std.string(parseFloat(value) <= num2);
						break;
					case "==":
						value = "" + Std.string(value == (num2 == null ? "null" : "" + num2));
						break;
					case ">":
						value = "" + Std.string(parseFloat(value) > num2);
						break;
					case ">=":
						value = "" + Std.string(parseFloat(value) >= num2);
						break;
					default:
						return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_BOOLEAN + "(" + num2 + ")`");
					}
					break;
				case "^":
					value = "" + Math.pow(Std.parseInt(value),num2);
					break;
				default:
					return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_BOOLEAN + "(" + Std.string(val == little_parser_ParserTokens.TrueValue) + ")`");
				}
			} else if(valueType == little_Keywords.TYPE_STRING) {
				var bool1 = val == little_parser_ParserTokens.TrueValue ? "true" : "false";
				switch(mode) {
				case "*":
					value = little_tools_TextTools.multiply(value,little_tools_TextTools.parseBool(bool1) ? 1 : 0);
					break;
				case "+":
					value += bool1;
					break;
				case "-":
					value = little_tools_TextTools.replaceLast(value,bool1,"");
					break;
				case "!=":case "<":case "<=":case "==":case ">":case ">=":
					valueType = little_Keywords.TYPE_BOOLEAN;
					switch(mode) {
					case "!=":
						value = "true";
						break;
					case "==":
						value = "false";
						break;
					default:
						return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_BOOLEAN + "(" + bool1 + ")`");
					}
					break;
				default:
					return little_parser_ParserTokens.ErrorMessage("Cannot preform `" + valueType + "(" + value + ") " + mode + " " + little_Keywords.TYPE_BOOLEAN + "(" + Std.string(val == little_parser_ParserTokens.TrueValue) + ")`");
				}
			}
			break;
		default:
		}
	}
	var _hx_tmp;
	var _hx_tmp1;
	var _hx_tmp2;
	if(valueType == little_Keywords.TYPE_INT == true) {
		return little_parser_ParserTokens.Number(value);
	} else {
		_hx_tmp2 = valueType == little_Keywords.TYPE_FLOAT;
		if(_hx_tmp2 == true) {
			return little_parser_ParserTokens.Decimal(value);
		} else {
			_hx_tmp1 = valueType == little_Keywords.TYPE_BOOLEAN;
			if(_hx_tmp1 == true) {
				if(value == "true") {
					return little_parser_ParserTokens.TrueValue;
				} else {
					return little_parser_ParserTokens.FalseValue;
				}
			} else {
				_hx_tmp = valueType == little_Keywords.TYPE_STRING;
				if(_hx_tmp == true) {
					return little_parser_ParserTokens.Characters(value);
				} else {
					return little_parser_ParserTokens.NullValue;
				}
			}
		}
	}
};
little_interpreter_Interpreter.forceCorrectOrderOfOperations = function(pre) {
	if(pre.length == 3) {
		return pre;
	}
	var post = [];
	var i = 0;
	while(i < pre.length) {
		var token = pre[i];
		if(token._hx_index == 15) {
			if(token.sign == "^") {
				++i;
				post.push(little_parser_ParserTokens.Expression([post.pop(),token,pre[i]],null));
			} else {
				post.push(token);
			}
		} else {
			post.push(token);
		}
		++i;
	}
	pre = post.slice();
	post = [];
	var i = 0;
	while(i < pre.length) {
		var token = pre[i];
		if(token._hx_index == 15) {
			switch(token.sign) {
			case "*":case "/":
				++i;
				post.push(little_parser_ParserTokens.Expression([post.pop(),token,pre[i]],null));
				break;
			default:
				post.push(token);
			}
		} else {
			post.push(token);
		}
		++i;
	}
	return post;
};
var little_interpreter_MemoryObject = function(value,props,params,type,external,condition) {
	this.condition = false;
	this.external = false;
	this.type = null;
	this.params = null;
	this.props = new haxe_ds_StringMap();
	this.setterListeners = [];
	this.value = little_parser_ParserTokens.NullValue;
	this.set_value(value == null ? little_parser_ParserTokens.NullValue : value);
	this.props = props == null ? new haxe_ds_StringMap() : props;
	this.set_params(params);
	this.type = type;
	this.external = external == null ? false : external;
	this.condition = condition == null ? false : condition;
};
$hxClasses["little.interpreter.MemoryObject"] = little_interpreter_MemoryObject;
little_interpreter_MemoryObject.__name__ = true;
little_interpreter_MemoryObject.prototype = {
	set_value: function(val) {
		this.value = this.valueSetter(val);
		var _g = 0;
		var _g1 = this.setterListeners;
		while(_g < _g1.length) {
			var setter = _g1[_g];
			++_g;
			setter(this.value);
		}
		return this.value;
	}
	,valueSetter: function(val) {
		return val;
	}
	,set_params: function(parameters) {
		if(parameters == null) {
			return this.params = null;
		}
		return this.params = parameters.filter(function(p) {
			switch(p._hx_index) {
			case 0:
				var _g = p.line;
				return false;
			case 1:
				return false;
			default:
				return true;
			}
		});
	}
	,use: function(parameters) {
		if(this.condition) {
			var e = this.value;
			if($hxEnums[e.__enum__].__constructs__[e._hx_index]._hx_name != "ExternalCondition") {
				return little_parser_ParserTokens.ErrorMessage("Undefined external condition");
			}
			if($hxEnums[parameters.__enum__].__constructs__[parameters._hx_index]._hx_name != "PartArray") {
				return little_parser_ParserTokens.ErrorMessage("Incorrect parameter group format, given group format: " + $hxEnums[parameters.__enum__].__constructs__[parameters._hx_index]._hx_name + ", expectedFormat: " + Std.string(little_parser_ParserTokens.PartArray));
			}
			var con = Type.enumParameters(Type.enumParameters(parameters)[0][0])[0];
			var body = Type.enumParameters(Type.enumParameters(parameters)[0][1])[0];
			if(this.params != null) {
				var given = [];
				if(con.length != 0) {
					var currentParam = [];
					var _params = con;
					var _g = 0;
					while(_g < _params.length) {
						var value = _params[_g];
						++_g;
						switch(value._hx_index) {
						case 0:
							var _g1 = value.line;
							given.push(little_parser_ParserTokens.Expression(currentParam.slice(),null));
							currentParam = [];
							break;
						case 1:
							given.push(little_parser_ParserTokens.Expression(currentParam.slice(),null));
							currentParam = [];
							break;
						default:
							currentParam.push(value);
						}
					}
					if(currentParam.length != 0) {
						given.push(little_parser_ParserTokens.Expression(currentParam.slice(),null));
					}
				}
				if(given.length != this.params.length) {
					return little_parser_ParserTokens.ErrorMessage("Incorrect number of expressions in condition, expected: " + this.params.length + " (" + little_tools_PrettyPrinter.parseParamsString(this.params) + "), given: " + given.length + " (" + little_tools_PrettyPrinter.parseParamsString(given,false) + ")");
				}
				con = given;
				var _g = this.value;
				if(_g._hx_index == 21) {
					var use = _g.use;
					return use(con,body);
				} else {
					return little_parser_ParserTokens.ErrorMessage("Incorrect external condition value format, expected: ExternalCondition, given: " + Std.string(this.value));
				}
			} else {
				var _g = this.value;
				if(_g._hx_index == 21) {
					var use = _g.use;
					return use(con,body);
				} else {
					return little_parser_ParserTokens.ErrorMessage("Incorrect external condition value format, expected: ExternalCondition, given: " + Std.string(this.value));
				}
			}
		}
		if(this.params == null) {
			return little_parser_ParserTokens.ErrorMessage("Cannot call definition");
		}
		if($hxEnums[parameters.__enum__].__constructs__[parameters._hx_index]._hx_name != "PartArray") {
			return little_parser_ParserTokens.ErrorMessage("Incorrect parameter group format, given group format: " + $hxEnums[parameters.__enum__].__constructs__[parameters._hx_index]._hx_name + ", expectedFormat: " + Std.string(little_parser_ParserTokens.PartArray));
		}
		var given = [];
		if(Type.enumParameters(parameters)[0].length != 0) {
			var currentParam = [];
			var _params = Type.enumParameters(parameters)[0];
			var _g = 0;
			while(_g < _params.length) {
				var value = _params[_g];
				++_g;
				switch(value._hx_index) {
				case 0:
					var _g1 = value.line;
					given.push(little_parser_ParserTokens.Expression(currentParam.slice(),null));
					currentParam = [];
					break;
				case 1:
					given.push(little_parser_ParserTokens.Expression(currentParam.slice(),null));
					currentParam = [];
					break;
				default:
					currentParam.push(value);
				}
			}
			if(currentParam.length != 0) {
				given.push(little_parser_ParserTokens.Expression(currentParam.slice(),null));
			}
		}
		if(given.length != this.params.length) {
			return little_parser_ParserTokens.ErrorMessage("Incorrect number of parameters, expected: " + this.params.length + " (" + little_tools_PrettyPrinter.parseParamsString(this.params) + "), given: " + given.length + " (" + little_tools_PrettyPrinter.parseParamsString(given,false) + ")");
		}
		var _g = [];
		var _g1 = 0;
		while(_g1 < given.length) {
			var element = given[_g1];
			++_g1;
			_g.push(little_interpreter_Interpreter.evaluate(element));
		}
		given = _g;
		if(this.external) {
			var e = this.value;
			if($hxEnums[e.__enum__].__constructs__[e._hx_index]._hx_name != "External") {
				return little_parser_ParserTokens.ErrorMessage("Undefined external function");
			}
			return Type.enumParameters(this.value)[0](given);
		} else {
			var paramsDecl = [];
			var _g = 0;
			var _g1 = given.length;
			while(_g < _g1) {
				var i = _g++;
				paramsDecl.push(little_parser_ParserTokens.Write([this.params[i]],given[i],null));
			}
			paramsDecl.push(little_parser_ParserTokens.SplitLine);
			var body = null;
			var e = this.value;
			if($hxEnums[e.__enum__].__constructs__[e._hx_index]._hx_name == "Block") {
				body = Type.enumParameters(this.value)[0];
				body = paramsDecl.concat(body);
			} else {
				paramsDecl.push(this.value);
				body = paramsDecl;
			}
			return little_interpreter_Interpreter.runTokens(body,null,null,null);
		}
	}
	,__class__: little_interpreter_MemoryObject
};
var little_interpreter_RunConfig = function(prioritizeFunctionDeclarations,prioritizeVariableDeclarations,strictTyping,defaultModuleName,keywordConfig) {
	this.keywordConfig = null;
	this.defaultModuleName = "Main";
	this.strictTyping = false;
	this.prioritizeVariableDeclarations = false;
	this.prioritizeFunctionDeclarations = false;
	if(prioritizeFunctionDeclarations != null) {
		this.prioritizeFunctionDeclarations = prioritizeFunctionDeclarations;
	}
	if(prioritizeVariableDeclarations != null) {
		this.prioritizeVariableDeclarations = prioritizeVariableDeclarations;
	}
	if(strictTyping != null) {
		this.strictTyping = strictTyping;
	}
	if(defaultModuleName != null) {
		this.defaultModuleName = defaultModuleName;
	}
	if(keywordConfig != null) {
		this.keywordConfig = keywordConfig;
	}
};
$hxClasses["little.interpreter.RunConfig"] = little_interpreter_RunConfig;
little_interpreter_RunConfig.__name__ = true;
little_interpreter_RunConfig.prototype = {
	__class__: little_interpreter_RunConfig
};
var little_lexer_Lexer = function() { };
$hxClasses["little.lexer.Lexer"] = little_lexer_Lexer;
little_lexer_Lexer.__name__ = true;
little_lexer_Lexer.lex = function(code) {
	var tokens = [];
	var i = 0;
	while(i < code.length) {
		var char = code.charAt(i);
		if(char == "\"") {
			var string = "";
			++i;
			while(i < code.length && code.charAt(i) != "\"") {
				string += code.charAt(i);
				++i;
			}
			tokens.push(little_lexer_LexerTokens.Characters(string));
		} else if(little_tools_TextTools.contains("1234567890.",char)) {
			var num = char;
			++i;
			while(i < code.length && little_tools_TextTools.contains("1234567890.",code.charAt(i))) {
				num += code.charAt(i);
				++i;
			}
			--i;
			if(num == ".") {
				tokens.push(little_lexer_LexerTokens.Sign("."));
			} else {
				tokens.push(little_lexer_LexerTokens.Number(num));
			}
		} else if(char == "\n") {
			tokens.push(little_lexer_LexerTokens.Newline);
		} else if(char == ";" || char == ",") {
			tokens.push(little_lexer_LexerTokens.SplitLine);
		} else if(little_lexer_Lexer.signs.indexOf(char) != -1) {
			var sign = char;
			++i;
			while(i < code.length && little_lexer_Lexer.signs.indexOf(code.charAt(i)) != -1) {
				sign += code.charAt(i);
				++i;
			}
			--i;
			tokens.push(little_lexer_LexerTokens.Sign(sign));
		} else if(new EReg("[^+-.!@#$%%^&*0-9 \t\n\r;,\\(\\)\\[\\]\\{\\}]","").match(char)) {
			var name = char;
			++i;
			while(i < code.length && new EReg("[^+-.!@#$%%^&*0-9 \t\n\r;,\\(\\)\\[\\]\\{\\}]","").match(code.charAt(i))) {
				name += code.charAt(i);
				++i;
			}
			--i;
			tokens.push(little_lexer_LexerTokens.Identifier(name));
		}
		++i;
	}
	tokens = little_lexer_Lexer.separateBooleanIdentifiers(tokens);
	tokens = little_lexer_Lexer.mergeOrSplitKnownSigns(tokens);
	return tokens;
};
little_lexer_Lexer.separateBooleanIdentifiers = function(tokens) {
	var result = new Array(tokens.length);
	var _g = 0;
	var _g1 = tokens.length;
	while(_g < _g1) {
		var i = _g++;
		var token = tokens[i];
		result[i] = Type.enumEq(token,little_lexer_LexerTokens.Identifier(little_Keywords.TRUE_VALUE)) || Type.enumEq(token,little_lexer_LexerTokens.Identifier(little_Keywords.FALSE_VALUE)) ? little_lexer_LexerTokens.Boolean(Type.enumParameters(token)[0]) : Type.enumEq(token,little_lexer_LexerTokens.Identifier(little_Keywords.NULL_VALUE)) ? little_lexer_LexerTokens.NullValue : token;
	}
	return result;
};
little_lexer_Lexer.mergeOrSplitKnownSigns = function(tokens) {
	var post = [];
	var i = 0;
	while(i < tokens.length) {
		var token = tokens[i];
		if(token._hx_index == 1) {
			var char = token.char;
			little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS = little_tools_TextTools.sortByLength(little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS);
			little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS.reverse();
			var shouldContinue = false;
			while(char.length > 0) {
				shouldContinue = false;
				var _g = 0;
				var _g1 = little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS;
				while(_g < _g1.length) {
					var sign = _g1[_g];
					++_g;
					if(StringTools.startsWith(char,sign)) {
						char = char.substring(sign.length);
						post.push(little_lexer_LexerTokens.Sign(sign));
						shouldContinue = true;
						break;
					}
				}
				if(shouldContinue) {
					continue;
				}
				post.push(little_lexer_LexerTokens.Sign(char.charAt(0)));
				char = char.substring(1);
			}
		} else {
			post.push(token);
		}
		++i;
	}
	return post;
};
var little_lexer_LexerTokens = $hxEnums["little.lexer.LexerTokens"] = { __ename__:true,__constructs__:null
	,Identifier: ($_=function(name) { return {_hx_index:0,name:name,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Identifier",$_.__params__ = ["name"],$_)
	,Sign: ($_=function(char) { return {_hx_index:1,char:char,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Sign",$_.__params__ = ["char"],$_)
	,Number: ($_=function(num) { return {_hx_index:2,num:num,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Number",$_.__params__ = ["num"],$_)
	,Boolean: ($_=function(value) { return {_hx_index:3,value:value,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Boolean",$_.__params__ = ["value"],$_)
	,Characters: ($_=function(string) { return {_hx_index:4,string:string,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Characters",$_.__params__ = ["string"],$_)
	,NullValue: {_hx_name:"NullValue",_hx_index:5,__enum__:"little.lexer.LexerTokens",toString:$estr}
	,Newline: {_hx_name:"Newline",_hx_index:6,__enum__:"little.lexer.LexerTokens",toString:$estr}
	,SplitLine: {_hx_name:"SplitLine",_hx_index:7,__enum__:"little.lexer.LexerTokens",toString:$estr}
};
little_lexer_LexerTokens.__constructs__ = [little_lexer_LexerTokens.Identifier,little_lexer_LexerTokens.Sign,little_lexer_LexerTokens.Number,little_lexer_LexerTokens.Boolean,little_lexer_LexerTokens.Characters,little_lexer_LexerTokens.NullValue,little_lexer_LexerTokens.Newline,little_lexer_LexerTokens.SplitLine];
var little_parser_Parser = function() { };
$hxClasses["little.parser.Parser"] = little_parser_Parser;
little_parser_Parser.__name__ = true;
little_parser_Parser.parse = function(lexerTokens) {
	var tokens = [];
	var line = 1;
	var i = 0;
	while(i < lexerTokens.length) {
		var token = lexerTokens[i];
		switch(token._hx_index) {
		case 0:
			var name = token.name;
			tokens.push(little_parser_ParserTokens.Identifier(name));
			break;
		case 1:
			var char = token.char;
			tokens.push(little_parser_ParserTokens.Sign(char));
			break;
		case 2:
			var num = token.num;
			if(little_tools_TextTools.countOccurrencesOf(num,".") == 0) {
				tokens.push(little_parser_ParserTokens.Number(num));
			} else if(little_tools_TextTools.countOccurrencesOf(num,".") == 1) {
				tokens.push(little_parser_ParserTokens.Decimal(num));
			}
			break;
		case 3:
			var value = token.value;
			if(value == little_Keywords.FALSE_VALUE) {
				tokens.push(little_parser_ParserTokens.FalseValue);
			} else if(value == little_Keywords.TRUE_VALUE) {
				tokens.push(little_parser_ParserTokens.TrueValue);
			}
			break;
		case 4:
			var string = token.string;
			tokens.push(little_parser_ParserTokens.Characters(string));
			break;
		case 5:
			tokens.push(little_parser_ParserTokens.NullValue);
			break;
		case 6:
			tokens.push(little_parser_ParserTokens.SetLine(line));
			++line;
			break;
		case 7:
			tokens.push(little_parser_ParserTokens.SplitLine);
			break;
		}
		++i;
	}
	tokens = little_parser_Parser.mergeBlocks(tokens);
	tokens = little_parser_Parser.mergeExpressions(tokens);
	tokens = little_parser_Parser.mergeTypeDecls(tokens);
	tokens = little_parser_Parser.mergeComplexStructures(tokens);
	tokens = little_parser_Parser.mergeCalls(tokens);
	tokens = little_parser_Parser.mergePropertyOperations(tokens);
	tokens = little_parser_Parser.mergeWrites(tokens);
	return tokens;
};
little_parser_Parser.mergeBlocks = function(pre) {
	if(pre == null) {
		return null;
	}
	var post = [];
	var i = 0;
	while(i < pre.length) {
		var token = pre[i];
		switch(token._hx_index) {
		case 0:
			var line = token.line;
			little_parser_Parser.setLine(line);
			post.push(token);
			break;
		case 1:
			little_parser_Parser.nextPart();
			post.push(token);
			break;
		case 11:
			var parts = token.parts;
			var type = token.type;
			post.push(little_parser_ParserTokens.Expression(little_parser_Parser.mergeBlocks(parts),null));
			break;
		case 12:
			var body = token.body;
			var type1 = token.type;
			post.push(little_parser_ParserTokens.Block(little_parser_Parser.mergeBlocks(body),null));
			break;
		case 15:
			if(token.sign == "{") {
				var blockStartLine = little_parser_Parser.get_line();
				var blockBody = [];
				var blockStack = 1;
				while(i + 1 < pre.length) {
					var lookahead = pre[i + 1];
					if(Type.enumEq(lookahead,little_parser_ParserTokens.Sign("{"))) {
						++blockStack;
						blockBody.push(lookahead);
					} else if(Type.enumEq(lookahead,little_parser_ParserTokens.Sign("}"))) {
						--blockStack;
						if(blockStack == 0) {
							break;
						}
						blockBody.push(lookahead);
					} else {
						blockBody.push(lookahead);
					}
					++i;
				}
				if(i + 1 == pre.length) {
					little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Unclosed code block, starting at line " + blockStartLine));
					return null;
				}
				post.push(little_parser_ParserTokens.Block(little_parser_Parser.mergeBlocks(blockBody),null));
				++i;
			} else {
				post.push(token);
			}
			break;
		default:
			post.push(token);
		}
		++i;
	}
	little_parser_Parser.resetLines();
	return post;
};
little_parser_Parser.mergeExpressions = function(pre) {
	if(pre == null) {
		return null;
	}
	var post = [];
	var i = 0;
	while(i < pre.length) {
		var token = pre[i];
		switch(token._hx_index) {
		case 0:
			var line = token.line;
			little_parser_Parser.setLine(line);
			post.push(token);
			break;
		case 1:
			little_parser_Parser.nextPart();
			post.push(token);
			break;
		case 11:
			var parts = token.parts;
			var type = token.type;
			post.push(little_parser_ParserTokens.Expression(little_parser_Parser.mergeExpressions(parts),null));
			break;
		case 12:
			var body = token.body;
			var type1 = token.type;
			post.push(little_parser_ParserTokens.Block(little_parser_Parser.mergeExpressions(body),null));
			break;
		case 15:
			if(token.sign == "(") {
				var expressionStartLine = little_parser_Parser.get_line();
				var expressionBody = [];
				var expressionStack = 1;
				while(i + 1 < pre.length) {
					var lookahead = pre[i + 1];
					if(Type.enumEq(lookahead,little_parser_ParserTokens.Sign("("))) {
						++expressionStack;
						expressionBody.push(lookahead);
					} else if(Type.enumEq(lookahead,little_parser_ParserTokens.Sign(")"))) {
						--expressionStack;
						if(expressionStack == 0) {
							break;
						}
						expressionBody.push(lookahead);
					} else {
						expressionBody.push(lookahead);
					}
					++i;
				}
				if(i + 1 == pre.length) {
					little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Unclosed expression, starting at line " + expressionStartLine));
					return null;
				}
				post.push(little_parser_ParserTokens.Expression(little_parser_Parser.mergeExpressions(expressionBody),null));
				++i;
			} else {
				post.push(token);
			}
			break;
		default:
			post.push(token);
		}
		++i;
	}
	little_parser_Parser.resetLines();
	return post;
};
little_parser_Parser.mergeTypeDecls = function(pre) {
	if(pre == null) {
		return null;
	}
	var post = [];
	var i = 0;
	while(i < pre.length) {
		var token = pre[i];
		switch(token._hx_index) {
		case 0:
			var line = token.line;
			little_parser_Parser.setLine(line);
			post.push(token);
			break;
		case 1:
			little_parser_Parser.nextPart();
			post.push(token);
			break;
		case 7:
			var word = token.word;
			if(word == little_Keywords.TYPE_DECL_OR_CAST && i + 1 < pre.length) {
				var lookahead = pre[i + 1];
				post.push(little_parser_ParserTokens.TypeDeclaration(lookahead));
				++i;
			} else if(word == little_Keywords.TYPE_DECL_OR_CAST) {
				if(i + 1 == pre.length) {
					little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Incomplete type declaration, make sure to input a type after the " + little_Keywords.TYPE_DECL_OR_CAST + "."));
					return null;
				}
			} else {
				post.push(token);
			}
			break;
		case 11:
			var parts = token.parts;
			var type = token.type;
			post.push(little_parser_ParserTokens.Expression(little_parser_Parser.mergeTypeDecls(parts),null));
			break;
		case 12:
			var body = token.body;
			var type1 = token.type;
			post.push(little_parser_ParserTokens.Block(little_parser_Parser.mergeTypeDecls(body),null));
			break;
		default:
			post.push(token);
		}
		++i;
	}
	little_parser_Parser.resetLines();
	return post;
};
little_parser_Parser.mergeComplexStructures = function(pre) {
	if(pre == null) {
		return null;
	}
	var post = [];
	var i = 0;
	while(i < pre.length) {
		var token = pre[i];
		switch(token._hx_index) {
		case 0:
			var line = token.line;
			little_parser_Parser.setLine(line);
			post.push(token);
			break;
		case 1:
			little_parser_Parser.nextPart();
			post.push(token);
			break;
		case 7:
			var _g = token.word;
			var _hx_tmp;
			var _hx_tmp1;
			var _hx_tmp2;
			if(_g == little_Keywords.VARIABLE_DECLARATION == true) {
				++i;
				if(i >= pre.length) {
					little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Missing variable name, variable is cut off by the end of the file, block or expression."),"Parser");
					return null;
				}
				var name = [];
				var pushToName = true;
				var type = null;
				_hx_loop2: while(i < pre.length) {
					var lookahead = pre[i];
					switch(lookahead._hx_index) {
					case 0:
						var _g1 = lookahead.line;
						--i;
						break _hx_loop2;
					case 1:
						--i;
						break _hx_loop2;
					case 8:
						var typeToken = lookahead.type;
						if(name.length == 0) {
							little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Missing variable name before type declaration."),"Parser");
							return null;
						}
						type = typeToken;
						break _hx_loop2;
					case 11:
						var body = lookahead.parts;
						var type1 = lookahead.type;
						if(pushToName) {
							name.push(little_parser_ParserTokens.Expression(little_parser_Parser.mergeComplexStructures(body),type1));
							pushToName = false;
						} else if(type1 == null) {
							type1 = little_parser_ParserTokens.Expression(little_parser_Parser.mergeComplexStructures(body),type1);
						} else {
							--i;
							break _hx_loop2;
						}
						break;
					case 12:
						var body1 = lookahead.body;
						var type2 = lookahead.type;
						if(pushToName) {
							name.push(little_parser_ParserTokens.Block(little_parser_Parser.mergeComplexStructures(body1),type2));
							pushToName = false;
						} else if(type2 == null) {
							type2 = little_parser_ParserTokens.Block(little_parser_Parser.mergeComplexStructures(body1),type2);
						} else {
							--i;
							break _hx_loop2;
						}
						break;
					case 15:
						var _g2 = lookahead.sign;
						var _hx_tmp3;
						if(_g2 == "=") {
							--i;
							break _hx_loop2;
						} else {
							_hx_tmp3 = _g2 == little_Keywords.PROPERTY_ACCESS_SIGN;
							if(_hx_tmp3 == true) {
								pushToName = true;
								name.push(lookahead);
							} else if(pushToName) {
								name.push(lookahead);
								pushToName = false;
							} else if(type == null && $hxEnums[lookahead.__enum__].__constructs__[lookahead._hx_index]._hx_name == "TypeDeclaration") {
								type = lookahead;
							} else {
								--i;
								break _hx_loop2;
							}
						}
						break;
					default:
						if(pushToName) {
							name.push(lookahead);
							pushToName = false;
						} else if(type == null && $hxEnums[lookahead.__enum__].__constructs__[lookahead._hx_index]._hx_name == "TypeDeclaration") {
							type = lookahead;
						} else {
							--i;
							break _hx_loop2;
						}
					}
					++i;
				}
				post.push(little_parser_ParserTokens.Define(name.length == 1 ? name[0] : little_parser_ParserTokens.PartArray(name),type));
			} else {
				_hx_tmp2 = _g == little_Keywords.FUNCTION_DECLARATION;
				if(_hx_tmp2 == true) {
					++i;
					if(i >= pre.length) {
						little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Missing function name, function is cut off by the end of the file, block or expression."),"Parser");
						return null;
					}
					var name1 = [];
					var pushToName1 = true;
					var params = null;
					var type3 = null;
					_hx_loop3: while(i < pre.length) {
						var lookahead1 = pre[i];
						switch(lookahead1._hx_index) {
						case 8:
							var typeToken1 = lookahead1.type;
							if(name1.length == 0) {
								little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Missing function name & parameters before type declaration."),"Parser");
								return null;
							} else if(params == null) {
								little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Missing function parameters before type declaration."),"Parser");
								return null;
							}
							type3 = typeToken1;
							break _hx_loop3;
						case 11:
							var body2 = lookahead1.parts;
							var type4 = lookahead1.type;
							if(pushToName1) {
								name1.push(little_parser_ParserTokens.Expression(little_parser_Parser.mergeComplexStructures(body2),type4));
								pushToName1 = false;
							} else if(params == null) {
								params = little_parser_ParserTokens.Expression(little_parser_Parser.mergeComplexStructures(body2),type4);
							} else if(type4 == null) {
								type4 = little_parser_ParserTokens.Expression(little_parser_Parser.mergeComplexStructures(body2),type4);
							} else {
								break _hx_loop3;
							}
							break;
						case 12:
							var body3 = lookahead1.body;
							var type5 = lookahead1.type;
							if(pushToName1) {
								name1.push(little_parser_ParserTokens.Block(little_parser_Parser.mergeComplexStructures(body3),type5));
								pushToName1 = false;
							} else if(params == null) {
								params = little_parser_ParserTokens.Block(little_parser_Parser.mergeComplexStructures(body3),type5);
							} else if(type5 == null) {
								type5 = little_parser_ParserTokens.Block(little_parser_Parser.mergeComplexStructures(body3),type5);
							} else {
								break _hx_loop3;
							}
							break;
						case 15:
							var _g3 = lookahead1.sign;
							var _hx_tmp4;
							if(_g3 == "=") {
								--i;
								break _hx_loop3;
							} else {
								_hx_tmp4 = _g3 == little_Keywords.PROPERTY_ACCESS_SIGN;
								if(_hx_tmp4 == true) {
									if(params != null) {
										--i;
										break _hx_loop3;
									}
									pushToName1 = true;
									name1.push(lookahead1);
								} else if(pushToName1) {
									name1.push(lookahead1);
									pushToName1 = false;
								} else if(params == null) {
									params = lookahead1;
								} else if(type3 == null && $hxEnums[lookahead1.__enum__].__constructs__[lookahead1._hx_index]._hx_name == "TypeDeclaration") {
									type3 = lookahead1;
								} else {
									break _hx_loop3;
								}
							}
							break;
						default:
							if(pushToName1) {
								name1.push(lookahead1);
								pushToName1 = false;
							} else if(params == null) {
								params = lookahead1;
							} else if(type3 == null && $hxEnums[lookahead1.__enum__].__constructs__[lookahead1._hx_index]._hx_name == "TypeDeclaration") {
								type3 = lookahead1;
							} else {
								break _hx_loop3;
							}
						}
						++i;
					}
					post.push(little_parser_ParserTokens.Action(name1.length == 1 ? name1[0] : little_parser_ParserTokens.PartArray(name1),params,type3));
				} else {
					_hx_tmp1 = little_Keywords.CONDITION_TYPES.indexOf(_g) != -1;
					if(_hx_tmp1 == true) {
						++i;
						if(i >= pre.length) {
							little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Missing condition name, condition is cut off by the end of the file, block or expression."),"Parser");
							return null;
						}
						var name2 = little_parser_ParserTokens.Identifier(Type.enumParameters(token)[0]);
						var exp = null;
						var body4 = null;
						var type6 = null;
						_hx_loop4: while(i < pre.length) {
							var lookahead2 = pre[i];
							switch(lookahead2._hx_index) {
							case 0:
								var _g4 = lookahead2.line;
								break;
							case 1:
								break;
							case 11:
								var parts = lookahead2.parts;
								var type7 = lookahead2.type;
								if(exp == null) {
									exp = little_parser_ParserTokens.Expression(little_parser_Parser.mergeComplexStructures(parts),type7);
								} else if(body4 == null) {
									body4 = little_parser_ParserTokens.Expression(little_parser_Parser.mergeComplexStructures(parts),type7);
								} else {
									break _hx_loop4;
								}
								break;
							case 12:
								var b = lookahead2.body;
								var type8 = lookahead2.type;
								if(exp == null) {
									exp = little_parser_ParserTokens.Block(little_parser_Parser.mergeComplexStructures(b),type8);
								} else if(body4 == null) {
									body4 = little_parser_ParserTokens.Block(little_parser_Parser.mergeComplexStructures(b),type8);
								} else {
									break _hx_loop4;
								}
								break;
							default:
								if(exp == null) {
									exp = lookahead2;
								} else if(body4 == null) {
									body4 = lookahead2;
								} else {
									break _hx_loop4;
								}
							}
							++i;
						}
						if(i-- < pre.length) {
							var _g5 = pre[i + 1];
							switch(_g5._hx_index) {
							case 8:
								var _g6 = _g5.type;
								type6 = pre[i + 1];
								++i;
								break;
							case 12:
								var _g7 = _g5.body;
								var _g8 = _g5.type;
								type6 = pre[i + 1];
								++i;
								break;
							default:
							}
						}
						post.push(little_parser_ParserTokens.Condition(name2,exp,body4,type6));
					} else {
						_hx_tmp = _g == little_Keywords.FUNCTION_RETURN;
						if(_hx_tmp == true) {
							++i;
							if(i >= pre.length) {
								little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Missing return value, value is cut off by the end of the file, block or expression."),"Parser");
								return null;
							}
							var valueToReturn = [];
							_hx_loop5: while(i < pre.length) {
								var lookahead3 = pre[i];
								switch(lookahead3._hx_index) {
								case 0:
									var _g9 = lookahead3.line;
									--i;
									break _hx_loop5;
								case 1:
									--i;
									break _hx_loop5;
								case 11:
									var body5 = lookahead3.parts;
									var type9 = lookahead3.type;
									valueToReturn.push(little_parser_ParserTokens.Expression(little_parser_Parser.mergeComplexStructures(body5),type9));
									break;
								case 12:
									var body6 = lookahead3.body;
									var type10 = lookahead3.type;
									valueToReturn.push(little_parser_ParserTokens.Block(little_parser_Parser.mergeComplexStructures(body6),type10));
									break;
								default:
									valueToReturn.push(lookahead3);
								}
								++i;
							}
							post.push(little_parser_ParserTokens.Return(valueToReturn.length == 1 ? valueToReturn[0] : little_parser_ParserTokens.Expression(valueToReturn.slice(),null),null));
						} else {
							post.push(token);
						}
					}
				}
			}
			break;
		case 11:
			var parts1 = token.parts;
			var type11 = token.type;
			post.push(little_parser_ParserTokens.Expression(little_parser_Parser.mergeComplexStructures(parts1),null));
			break;
		case 12:
			var body7 = token.body;
			var type12 = token.type;
			post.push(little_parser_ParserTokens.Block(little_parser_Parser.mergeComplexStructures(body7),null));
			break;
		default:
			post.push(token);
		}
		++i;
	}
	little_parser_Parser.resetLines();
	return post;
};
little_parser_Parser.mergeCalls = function(pre) {
	if(pre == null) {
		return null;
	}
	var post = [];
	var i = 0;
	while(i < pre.length) {
		if(pre[i] == null) {
			++i;
			continue;
		}
		var token = pre[i];
		switch(token._hx_index) {
		case 0:
			var line = token.line;
			little_parser_Parser.setLine(line);
			post.push(token);
			break;
		case 1:
			little_parser_Parser.nextPart();
			post.push(token);
			break;
		case 2:
			var name = token.name;
			var type = token.type;
			post.push(little_parser_ParserTokens.Define(little_parser_Parser.mergeCalls([name])[0],type));
			break;
		case 3:
			var name1 = token.name;
			var params = token.params;
			var type1 = token.type;
			post.push(little_parser_ParserTokens.Action(little_parser_Parser.mergeCalls([name1])[0],little_parser_Parser.mergeCalls([params])[0],type1));
			break;
		case 4:
			var name2 = token.name;
			var exp = token.exp;
			var body = token.body;
			var type2 = token.type;
			post.push(little_parser_ParserTokens.Condition(little_parser_Parser.mergeCalls([name2])[0],little_parser_Parser.mergeCalls([exp])[0],little_parser_Parser.mergeCalls([body])[0],type2));
			break;
		case 10:
			var value = token.value;
			var type3 = token.type;
			post.push(little_parser_ParserTokens.Return(little_parser_Parser.mergeCalls([value])[0],type3));
			break;
		case 11:
			var parts = token.parts;
			var type4 = token.type;
			parts = little_parser_Parser.mergeCalls(parts);
			if(i == 0) {
				post.push(little_parser_ParserTokens.Expression(parts,type4));
			} else {
				var lookbehind = pre[i - 1];
				switch(lookbehind._hx_index) {
				case 0:
					var _g = lookbehind.line;
					post.push(little_parser_ParserTokens.Expression(parts,type4));
					break;
				case 1:
					post.push(little_parser_ParserTokens.Expression(parts,type4));
					break;
				case 15:
					var _g1 = lookbehind.sign;
					post.push(little_parser_ParserTokens.Expression(parts,type4));
					break;
				default:
					var previous = post.pop();
					token = little_parser_ParserTokens.PartArray(parts);
					post.push(little_parser_ParserTokens.ActionCall(previous,token));
				}
			}
			break;
		case 12:
			var body1 = token.body;
			var type5 = token.type;
			post.push(little_parser_ParserTokens.Block(little_parser_Parser.mergeCalls(body1),type5));
			break;
		case 13:
			var parts1 = token.parts;
			post.push(little_parser_ParserTokens.PartArray(little_parser_Parser.mergeCalls(parts1)));
			break;
		default:
			post.push(token);
		}
		++i;
	}
	little_parser_Parser.resetLines();
	return post;
};
little_parser_Parser.mergePropertyOperations = function(pre) {
	if(pre == null) {
		return null;
	}
	var post = [];
	var i = pre.length - 1;
	while(i >= 0) {
		var token = pre[i];
		switch(token._hx_index) {
		case 0:
			var line = token.line;
			little_parser_Parser.setLine(line);
			post.unshift(token);
			break;
		case 1:
			little_parser_Parser.nextPart();
			post.unshift(token);
			break;
		case 2:
			var name = token.name;
			var type = token.type;
			post.unshift(little_parser_ParserTokens.Define(little_parser_Parser.mergePropertyOperations($hxEnums[name.__enum__].__constructs__[name._hx_index]._hx_name == "PartArray" ? Type.enumParameters(name)[0] : [name])[0],type));
			break;
		case 3:
			var name1 = token.name;
			var params = token.params;
			var type1 = token.type;
			post.unshift(little_parser_ParserTokens.Action(little_parser_Parser.mergePropertyOperations($hxEnums[name1.__enum__].__constructs__[name1._hx_index]._hx_name == "PartArray" ? Type.enumParameters(name1)[0] : [name1])[0],little_parser_Parser.mergePropertyOperations([params])[0],type1));
			break;
		case 4:
			var name2 = token.name;
			var exp = token.exp;
			var body = token.body;
			var type2 = token.type;
			post.unshift(little_parser_ParserTokens.Condition(little_parser_Parser.mergePropertyOperations([name2])[0],little_parser_Parser.mergePropertyOperations([exp])[0],little_parser_Parser.mergePropertyOperations([body])[0],type2));
			break;
		case 6:
			var assignees = token.assignees;
			var value = token.value;
			var type3 = token.type;
			post.unshift(little_parser_ParserTokens.Write(little_parser_Parser.mergePropertyOperations(assignees),little_parser_Parser.mergePropertyOperations([value])[0],type3));
			break;
		case 9:
			var name3 = token.name;
			var params1 = token.params;
			post.unshift(little_parser_ParserTokens.ActionCall(little_parser_Parser.mergePropertyOperations([name3])[0],little_parser_Parser.mergePropertyOperations([params1])[0]));
			break;
		case 10:
			var value1 = token.value;
			var type4 = token.type;
			post.unshift(little_parser_ParserTokens.Return(little_parser_Parser.mergePropertyOperations([value1])[0],type4));
			break;
		case 11:
			var parts = token.parts;
			var type5 = token.type;
			post.unshift(little_parser_ParserTokens.Expression(little_parser_Parser.mergePropertyOperations(parts),type5));
			break;
		case 12:
			var body1 = token.body;
			var type6 = token.type;
			post.unshift(little_parser_ParserTokens.Block(little_parser_Parser.mergePropertyOperations(body1),type6));
			break;
		case 13:
			var parts1 = token.parts;
			post.unshift(little_parser_ParserTokens.PartArray(little_parser_Parser.mergePropertyOperations(parts1)));
			break;
		case 15:
			if(token.sign == little_Keywords.PROPERTY_ACCESS_SIGN == true) {
				if(i-- <= 0) {
					little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Property access cut off by the start of file, block or expression."),"Parser");
					return null;
				}
				var lookbehind = pre[i];
				switch(lookbehind._hx_index) {
				case 0:
					var _g = lookbehind.line;
					little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Property access cut off by the start of a line, or by a line split (; or ,)."),"Parser");
					return null;
				case 1:
					little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Property access cut off by the start of a line, or by a line split (; or ,)."),"Parser");
					return null;
				case 15:
					var s = lookbehind.sign;
					little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Cannot access the property of a sign (" + s + "). Was the property access cut off by accident?"));
					return null;
				default:
					var field = post.shift();
					post.unshift(little_parser_ParserTokens.PropertyAccess(lookbehind,field));
				}
			} else {
				post.unshift(token);
			}
			break;
		default:
			post.unshift(token);
		}
		--i;
	}
	little_parser_Parser.resetLines();
	return post;
};
little_parser_Parser.mergeWrites = function(pre) {
	if(pre == null) {
		return null;
	}
	var post = [];
	var potentialAssignee = little_parser_ParserTokens.NullValue;
	var i = 0;
	while(i < pre.length) {
		var token = pre[i];
		switch(token._hx_index) {
		case 0:
			var line = token.line;
			little_parser_Parser.setLine(line);
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = token;
			break;
		case 1:
			little_parser_Parser.nextPart();
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = token;
			break;
		case 2:
			var name = token.name;
			var type = token.type;
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = little_parser_ParserTokens.Define(little_parser_Parser.mergeWrites([name])[0],type);
			break;
		case 3:
			var name1 = token.name;
			var params = token.params;
			var type1 = token.type;
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = little_parser_ParserTokens.Action(little_parser_Parser.mergeWrites([name1])[0],little_parser_Parser.mergeWrites([params])[0],type1);
			break;
		case 4:
			var name2 = token.name;
			var exp = token.exp;
			var body = token.body;
			var type2 = token.type;
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = little_parser_ParserTokens.Condition(little_parser_Parser.mergeWrites([name2])[0],little_parser_Parser.mergeWrites([exp])[0],little_parser_Parser.mergeWrites([body])[0],type2);
			break;
		case 9:
			var name3 = token.name;
			var params1 = token.params;
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = little_parser_ParserTokens.ActionCall(little_parser_Parser.mergeWrites([name3])[0],little_parser_Parser.mergeWrites([params1])[0]);
			break;
		case 10:
			var value = token.value;
			var type3 = token.type;
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = little_parser_ParserTokens.Return(little_parser_Parser.mergeWrites([value])[0],type3);
			break;
		case 11:
			var parts = token.parts;
			var type4 = token.type;
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = little_parser_ParserTokens.Expression(little_parser_Parser.mergeWrites(parts),type4);
			break;
		case 12:
			var body1 = token.body;
			var type5 = token.type;
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = little_parser_ParserTokens.Block(little_parser_Parser.mergeWrites(body1),type5);
			break;
		case 13:
			var parts1 = token.parts;
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = little_parser_ParserTokens.PartArray(little_parser_Parser.mergeWrites(parts1));
			break;
		case 14:
			var name4 = token.name;
			var property = token.property;
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = little_parser_ParserTokens.PropertyAccess(little_parser_Parser.mergeWrites([name4])[0],little_parser_Parser.mergeWrites([property])[0]);
			break;
		case 15:
			if(token.sign == "=") {
				if(i + 1 >= pre.length) {
					little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Missing value after the `=`"),"Parser");
					return null;
				}
				var currentAssignee = [potentialAssignee];
				var assignees = [currentAssignee.length == 1 ? currentAssignee[0] : little_parser_ParserTokens.Expression(currentAssignee.slice(),null)];
				currentAssignee = [];
				_hx_loop2: while(i + 1 < pre.length) {
					var lookahead = pre[i + 1];
					switch(lookahead._hx_index) {
					case 0:
						var _g = lookahead.line;
						break _hx_loop2;
					case 1:
						break _hx_loop2;
					case 15:
						if(lookahead.sign == "=") {
							var assignee = currentAssignee.length == 1 ? currentAssignee[0] : little_parser_ParserTokens.Expression(currentAssignee.slice(),null);
							assignees.push(assignee);
							currentAssignee = [];
						} else {
							currentAssignee.push(lookahead);
						}
						break;
					default:
						currentAssignee.push(lookahead);
					}
					++i;
				}
				if(currentAssignee.length == 0) {
					little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("Missing value after the last `=`"),"Parser");
					return null;
				}
				var value1 = currentAssignee.length == 1 ? currentAssignee[0] : little_parser_ParserTokens.Expression(currentAssignee,null);
				var fValue = little_parser_Parser.mergeWrites([value1]);
				var v = fValue.length == 1 ? fValue[0] : little_parser_ParserTokens.Expression(fValue,null);
				post.push(little_parser_ParserTokens.Write(assignees,v,null));
				potentialAssignee = null;
			} else {
				if(potentialAssignee != null) {
					post.push(potentialAssignee);
				}
				potentialAssignee = token;
			}
			break;
		default:
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = token;
		}
		++i;
	}
	if(potentialAssignee != null) {
		post.push(potentialAssignee);
	}
	post.shift();
	little_parser_Parser.resetLines();
	return post;
};
little_parser_Parser.get_line = function() {
	return little_interpreter_Runtime.line;
};
little_parser_Parser.set_line = function(l) {
	return little_interpreter_Runtime.line = l;
};
little_parser_Parser.setLine = function(l) {
	little_parser_Parser.set_line(l);
	little_parser_Parser.linePart = 0;
};
little_parser_Parser.nextPart = function() {
	little_parser_Parser.linePart++;
};
little_parser_Parser.resetLines = function() {
	little_parser_Parser.set_line(0);
	little_parser_Parser.linePart = 0;
};
var little_parser_ParserTokens = $hxEnums["little.parser.ParserTokens"] = { __ename__:true,__constructs__:null
	,SetLine: ($_=function(line) { return {_hx_index:0,line:line,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="SetLine",$_.__params__ = ["line"],$_)
	,SplitLine: {_hx_name:"SplitLine",_hx_index:1,__enum__:"little.parser.ParserTokens",toString:$estr}
	,Define: ($_=function(name,type) { return {_hx_index:2,name:name,type:type,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Define",$_.__params__ = ["name","type"],$_)
	,Action: ($_=function(name,params,type) { return {_hx_index:3,name:name,params:params,type:type,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Action",$_.__params__ = ["name","params","type"],$_)
	,Condition: ($_=function(name,exp,body,type) { return {_hx_index:4,name:name,exp:exp,body:body,type:type,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Condition",$_.__params__ = ["name","exp","body","type"],$_)
	,Read: ($_=function(name) { return {_hx_index:5,name:name,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Read",$_.__params__ = ["name"],$_)
	,Write: ($_=function(assignees,value,type) { return {_hx_index:6,assignees:assignees,value:value,type:type,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Write",$_.__params__ = ["assignees","value","type"],$_)
	,Identifier: ($_=function(word) { return {_hx_index:7,word:word,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Identifier",$_.__params__ = ["word"],$_)
	,TypeDeclaration: ($_=function(type) { return {_hx_index:8,type:type,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="TypeDeclaration",$_.__params__ = ["type"],$_)
	,ActionCall: ($_=function(name,params) { return {_hx_index:9,name:name,params:params,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="ActionCall",$_.__params__ = ["name","params"],$_)
	,Return: ($_=function(value,type) { return {_hx_index:10,value:value,type:type,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Return",$_.__params__ = ["value","type"],$_)
	,Expression: ($_=function(parts,type) { return {_hx_index:11,parts:parts,type:type,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Expression",$_.__params__ = ["parts","type"],$_)
	,Block: ($_=function(body,type) { return {_hx_index:12,body:body,type:type,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Block",$_.__params__ = ["body","type"],$_)
	,PartArray: ($_=function(parts) { return {_hx_index:13,parts:parts,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="PartArray",$_.__params__ = ["parts"],$_)
	,PropertyAccess: ($_=function(name,property) { return {_hx_index:14,name:name,property:property,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="PropertyAccess",$_.__params__ = ["name","property"],$_)
	,Sign: ($_=function(sign) { return {_hx_index:15,sign:sign,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Sign",$_.__params__ = ["sign"],$_)
	,Number: ($_=function(num) { return {_hx_index:16,num:num,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Number",$_.__params__ = ["num"],$_)
	,Decimal: ($_=function(num) { return {_hx_index:17,num:num,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Decimal",$_.__params__ = ["num"],$_)
	,Characters: ($_=function(string) { return {_hx_index:18,string:string,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Characters",$_.__params__ = ["string"],$_)
	,Module: ($_=function(name) { return {_hx_index:19,name:name,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Module",$_.__params__ = ["name"],$_)
	,External: ($_=function(get) { return {_hx_index:20,get:get,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="External",$_.__params__ = ["get"],$_)
	,ExternalCondition: ($_=function(use) { return {_hx_index:21,use:use,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="ExternalCondition",$_.__params__ = ["use"],$_)
	,ErrorMessage: ($_=function(msg) { return {_hx_index:22,msg:msg,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="ErrorMessage",$_.__params__ = ["msg"],$_)
	,NullValue: {_hx_name:"NullValue",_hx_index:23,__enum__:"little.parser.ParserTokens",toString:$estr}
	,TrueValue: {_hx_name:"TrueValue",_hx_index:24,__enum__:"little.parser.ParserTokens",toString:$estr}
	,FalseValue: {_hx_name:"FalseValue",_hx_index:25,__enum__:"little.parser.ParserTokens",toString:$estr}
};
little_parser_ParserTokens.__constructs__ = [little_parser_ParserTokens.SetLine,little_parser_ParserTokens.SplitLine,little_parser_ParserTokens.Define,little_parser_ParserTokens.Action,little_parser_ParserTokens.Condition,little_parser_ParserTokens.Read,little_parser_ParserTokens.Write,little_parser_ParserTokens.Identifier,little_parser_ParserTokens.TypeDeclaration,little_parser_ParserTokens.ActionCall,little_parser_ParserTokens.Return,little_parser_ParserTokens.Expression,little_parser_ParserTokens.Block,little_parser_ParserTokens.PartArray,little_parser_ParserTokens.PropertyAccess,little_parser_ParserTokens.Sign,little_parser_ParserTokens.Number,little_parser_ParserTokens.Decimal,little_parser_ParserTokens.Characters,little_parser_ParserTokens.Module,little_parser_ParserTokens.External,little_parser_ParserTokens.ExternalCondition,little_parser_ParserTokens.ErrorMessage,little_parser_ParserTokens.NullValue,little_parser_ParserTokens.TrueValue,little_parser_ParserTokens.FalseValue];
var little_tools_Conversion = function() { };
$hxClasses["little.tools.Conversion"] = little_tools_Conversion;
little_tools_Conversion.__name__ = true;
little_tools_Conversion.toLittleValue = function(val) {
	var e = Type.typeof(val);
	var type = little_tools_Conversion.toLittleType($hxEnums[e.__enum__].__constructs__[e._hx_index]._hx_name.substring(1));
	var _hx_tmp;
	var _hx_tmp1;
	var _hx_tmp2;
	if(type == little_Keywords.TYPE_BOOLEAN == true) {
		if(val) {
			return little_parser_ParserTokens.TrueValue;
		} else {
			return little_parser_ParserTokens.FalseValue;
		}
	} else {
		_hx_tmp2 = type == little_Keywords.TYPE_FLOAT;
		if(_hx_tmp2 == true) {
			return little_parser_ParserTokens.Decimal(Std.string(val));
		} else {
			_hx_tmp1 = type == little_Keywords.TYPE_INT;
			if(_hx_tmp1 == true) {
				return little_parser_ParserTokens.Number(Std.string(val));
			} else {
				_hx_tmp = type == little_Keywords.TYPE_STRING;
				if(_hx_tmp == true) {
					return little_parser_ParserTokens.Characters(Std.string(val));
				} else {
					return little_parser_ParserTokens.NullValue;
				}
			}
		}
	}
};
little_tools_Conversion.toHaxeValue = function(val) {
	val = little_interpreter_Interpreter.evaluate(val);
	switch(val._hx_index) {
	case 16:
		var num = val.num;
		return Std.parseInt(num);
	case 17:
		var num = val.num;
		return parseFloat(num);
	case 18:
		var string = val.string;
		return string;
	case 22:
		var msg = val.msg;
		haxe_Log.trace("WARNING: " + msg + ". Returning null",{ fileName : "src/little/tools/Conversion.hx", lineNumber : 37, className : "little.tools.Conversion", methodName : "toHaxeValue"});
		return null;
	case 23:
		return null;
	case 24:
		return true;
	case 25:
		return false;
	default:
		haxe_Log.trace("WARNING: Unparsable token: " + Std.string(val) + ". Returning null",{ fileName : "src/little/tools/Conversion.hx", lineNumber : 47, className : "little.tools.Conversion", methodName : "toHaxeValue"});
		return null;
	}
};
little_tools_Conversion.toLittleType = function(type) {
	switch(type) {
	case "Bool":
		return little_Keywords.TYPE_BOOLEAN;
	case "Float":
		return little_Keywords.TYPE_FLOAT;
	case "Int":
		return little_Keywords.TYPE_INT;
	case "String":
		return little_Keywords.TYPE_STRING;
	default:
		return little_Keywords.TYPE_DYNAMIC;
	}
};
var little_tools_Data = function() { };
$hxClasses["little.tools.Data"] = little_tools_Data;
little_tools_Data.__name__ = true;
var little_tools_Layer = {};
little_tools_Layer.getIndexOf = function(layer) {
	switch(layer) {
	case "Interpreter":
		return 3;
	case "Interpreter, Expression Evaluator":
		return 5;
	case "Interpreter, Token Identifier Stringifier":
		return 6;
	case "Interpreter, Token Value Stringifier":
		return 6;
	case "Interpreter, Value Evaluator":
		return 4;
	case "Lexer":
		return 1;
	case "Parser":
		return 2;
	default:
		return 999999999;
	}
};
var little_tools_PrepareRun = function() { };
$hxClasses["little.tools.PrepareRun"] = little_tools_PrepareRun;
little_tools_PrepareRun.__name__ = true;
little_tools_PrepareRun.addFunctions = function() {
	little_Little.plugin.registerFunction(little_Keywords.PRINT_FUNCTION_NAME,null,[little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier("item"),null)],function(params) {
		little_interpreter_Runtime.print(little_interpreter_Interpreter.stringifyTokenValue(little_interpreter_Interpreter.evaluate(params[0])));
		return little_parser_ParserTokens.NullValue;
	});
	little_Little.plugin.registerFunction(little_Keywords.RAISE_ERROR_FUNCTION_NAME,null,[little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier("message"),null)],function(params) {
		little_interpreter_Runtime.throwError(little_interpreter_Interpreter.evaluate(params[0]));
		return little_parser_ParserTokens.NullValue;
	});
	little_Little.plugin.registerFunction(little_Keywords.READ_FUNCTION_NAME,null,[little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier("string"),little_parser_ParserTokens.Identifier(little_Keywords.TYPE_STRING))],function(params) {
		return little_parser_ParserTokens.Read(little_parser_ParserTokens.Identifier(little_interpreter_Interpreter.stringifyTokenValue(params[0])));
	});
	little_Little.plugin.registerFunction(little_Keywords.RUN_CODE_FUNCTION_NAME,null,[little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier("code"),little_parser_ParserTokens.Identifier(little_Keywords.TYPE_STRING))],function(params) {
		return little_interpreter_Interpreter.interpret(little_parser_Parser.parse(little_lexer_Lexer.lex(Type.enumParameters(params[0])[0])),little_interpreter_Interpreter.currentConfig);
	});
	little_Little.plugin.registerHaxeClass([{ className : "Math", name : "PI", fieldType : "var", parameters : [], returnType : "Float", allowWrite : false},{ className : "Math", name : "NEGATIVE_INFINITY", fieldType : "var", parameters : [], returnType : "Float", allowWrite : false},{ className : "Math", name : "get_NEGATIVE_INFINITY", parameters : [], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "POSITIVE_INFINITY", fieldType : "var", parameters : [], returnType : "Float", allowWrite : false},{ className : "Math", name : "get_POSITIVE_INFINITY", parameters : [], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "NaN", fieldType : "var", parameters : [], returnType : "Float", allowWrite : false},{ className : "Math", name : "get_NaN", parameters : [], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "abs", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "acos", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "asin", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "atan", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "atan2", parameters : [{ name : "y", type : "Float", optional : false},{ name : "x", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "ceil", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Int", fieldType : "function", allowWrite : false},{ className : "Math", name : "cos", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "exp", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "floor", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Int", fieldType : "function", allowWrite : false},{ className : "Math", name : "log", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "max", parameters : [{ name : "a", type : "Float", optional : false},{ name : "b", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "min", parameters : [{ name : "a", type : "Float", optional : false},{ name : "b", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "pow", parameters : [{ name : "v", type : "Float", optional : false},{ name : "exp", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "random", parameters : [], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "round", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Int", fieldType : "function", allowWrite : false},{ className : "Math", name : "sin", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "sqrt", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "tan", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "ffloor", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "fceil", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "fround", parameters : [{ name : "v", type : "Float", optional : false}], returnType : "Float", fieldType : "function", allowWrite : false},{ className : "Math", name : "isFinite", parameters : [{ name : "f", type : "Float", optional : false}], returnType : "Bool", fieldType : "function", allowWrite : false},{ className : "Math", name : "isNaN", parameters : [{ name : "f", type : "Float", optional : false}], returnType : "Bool", fieldType : "function", allowWrite : false}]);
	little_Little.plugin.registerHaxeClass([{ className : "StringTools", name : "urlEncode", parameters : [{ name : "s", type : "String", optional : false}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "urlDecode", parameters : [{ name : "s", type : "String", optional : false}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "htmlEscape", parameters : [{ name : "s", type : "String", optional : false},{ name : "quotes", type : "Null<Bool>", optional : true}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "htmlUnescape", parameters : [{ name : "s", type : "String", optional : false}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "contains", parameters : [{ name : "s", type : "String", optional : false},{ name : "value", type : "String", optional : false}], returnType : "Bool", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "startsWith", parameters : [{ name : "s", type : "String", optional : false},{ name : "start", type : "String", optional : false}], returnType : "Bool", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "endsWith", parameters : [{ name : "s", type : "String", optional : false},{ name : "end", type : "String", optional : false}], returnType : "Bool", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "isSpace", parameters : [{ name : "s", type : "String", optional : false},{ name : "pos", type : "Int", optional : false}], returnType : "Bool", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "ltrim", parameters : [{ name : "s", type : "String", optional : false}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "rtrim", parameters : [{ name : "s", type : "String", optional : false}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "trim", parameters : [{ name : "s", type : "String", optional : false}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "lpad", parameters : [{ name : "s", type : "String", optional : false},{ name : "c", type : "String", optional : false},{ name : "l", type : "Int", optional : false}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "rpad", parameters : [{ name : "s", type : "String", optional : false},{ name : "c", type : "String", optional : false},{ name : "l", type : "Int", optional : false}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "replace", parameters : [{ name : "s", type : "String", optional : false},{ name : "sub", type : "String", optional : false},{ name : "by", type : "String", optional : false}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "hex", parameters : [{ name : "n", type : "Int", optional : false},{ name : "digits", type : "Null<Int>", optional : true}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "fastCodeAt", parameters : [{ name : "s", type : "String", optional : false},{ name : "index", type : "Int", optional : false}], returnType : "Int", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "unsafeCodeAt", parameters : [{ name : "s", type : "String", optional : false},{ name : "index", type : "Int", optional : false}], returnType : "Int", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "iterator", parameters : [{ name : "s", type : "String", optional : false}], returnType : "StringIterator", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "keyValueIterator", parameters : [{ name : "s", type : "String", optional : false}], returnType : "StringKeyValueIterator", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "isEof", parameters : [{ name : "c", type : "Int", optional : false}], returnType : "Bool", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "quoteUnixArg", parameters : [{ name : "argument", type : "String", optional : false}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "winMetaCharacters", fieldType : "var", parameters : [], returnType : "Array<Int>", allowWrite : true},{ className : "StringTools", name : "quoteWinArg", parameters : [{ name : "argument", type : "String", optional : false},{ name : "escapeMetaCharacters", type : "Bool", optional : false}], returnType : "String", fieldType : "function", allowWrite : false},{ className : "StringTools", name : "MIN_SURROGATE_CODE_POINT", fieldType : "var", parameters : [], returnType : "Int", allowWrite : false},{ className : "StringTools", name : "utf16CodePointAt", parameters : [{ name : "s", type : "String", optional : false},{ name : "index", type : "Int", optional : false}], returnType : "Int", fieldType : "function", allowWrite : false}]);
};
little_tools_PrepareRun.addConditions = function() {
	little_Little.plugin.registerCondition("while",[little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier("rule"),little_parser_ParserTokens.Identifier(little_Keywords.TYPE_BOOLEAN))],function(params,body) {
		var val = little_parser_ParserTokens.NullValue;
		var safetyNet = 0;
		while(little_tools_Conversion.toHaxeValue(little_interpreter_Interpreter.evaluateExpressionParts(params))) {
			val = little_interpreter_Interpreter.interpret(body,little_interpreter_Interpreter.currentConfig);
			++safetyNet;
		}
		return val;
	});
	little_Little.plugin.registerCondition("if",[little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier("rule"),little_parser_ParserTokens.Identifier(little_Keywords.TYPE_BOOLEAN))],function(params,body) {
		var val = little_parser_ParserTokens.NullValue;
		if(little_tools_Conversion.toHaxeValue(little_interpreter_Interpreter.evaluateExpressionParts(params))) {
			val = little_interpreter_Interpreter.interpret(body,little_interpreter_Interpreter.currentConfig);
		}
		return val;
	});
	little_Little.plugin.registerCondition("for",null,function(params,body) {
		var val = little_parser_ParserTokens.NullValue;
		var fp = [];
		var _g = 0;
		while(_g < params.length) {
			var p = params[_g];
			++_g;
			if(p._hx_index == 9) {
				var _g1 = p.name;
				var _g2 = p.params;
				var _hx_tmp;
				var _hx_tmp1;
				if(Type.enumParameters(_g1)[0] == little_Keywords.FOR_LOOP_IDENTIFIERS.FROM == true) {
					var params1 = _g2;
					fp.push(little_parser_ParserTokens.Identifier(little_Keywords.FOR_LOOP_IDENTIFIERS.FROM));
					fp.push(little_parser_ParserTokens.Expression(Type.enumParameters(params1)[0],null));
				} else {
					_hx_tmp1 = Type.enumParameters(_g1)[0] == little_Keywords.FOR_LOOP_IDENTIFIERS.TO;
					if(_hx_tmp1 == true) {
						var params2 = _g2;
						fp.push(little_parser_ParserTokens.Identifier(little_Keywords.FOR_LOOP_IDENTIFIERS.TO));
						fp.push(little_parser_ParserTokens.Expression(Type.enumParameters(params2)[0],null));
					} else {
						_hx_tmp = Type.enumParameters(_g1)[0] == little_Keywords.FOR_LOOP_IDENTIFIERS.JUMP;
						if(_hx_tmp == true) {
							var params3 = _g2;
							fp.push(little_parser_ParserTokens.Identifier(little_Keywords.FOR_LOOP_IDENTIFIERS.JUMP));
							fp.push(little_parser_ParserTokens.Expression(Type.enumParameters(params3)[0],null));
						} else {
							fp.push(p);
						}
					}
				}
			} else {
				fp.push(p);
			}
		}
		params = fp;
		var handle = little_interpreter_Interpreter.accessObject(params[0]);
		if(handle == null) {
			little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("`for` loop must start with a variable to count on (expected definition/block, found: `" + Std.string(params[0]) + "`)"));
			return val;
		}
		var from = null;
		var to = null;
		var jump = 1;
		var parserForLoop = null;
		parserForLoop = function(token,next) {
			switch(token._hx_index) {
			case 7:
				var _g = token.word;
				var _hx_tmp;
				var _hx_tmp1;
				if(_g == little_Keywords.FOR_LOOP_IDENTIFIERS.FROM == true) {
					var val = little_tools_Conversion.toHaxeValue(little_interpreter_Interpreter.evaluate(next));
					if(typeof(val) == "number" || typeof(val) == "number" && ((val | 0) === val)) {
						from = val;
					} else {
						var parserForLoop1 = "`for` loop's `" + little_Keywords.FOR_LOOP_IDENTIFIERS.FROM + "` argument must be of type " + little_Keywords.TYPE_INT + "/" + little_Keywords.TYPE_FLOAT + " (given: " + little_interpreter_Interpreter.stringifyTokenValue(next) + " as ";
						var e = little_interpreter_Interpreter.evaluate(next);
						little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage(parserForLoop1 + $hxEnums[e.__enum__].__constructs__[e._hx_index]._hx_name + ")"));
					}
				} else {
					_hx_tmp1 = _g == little_Keywords.FOR_LOOP_IDENTIFIERS.TO;
					if(_hx_tmp1 == true) {
						var val = little_tools_Conversion.toHaxeValue(little_interpreter_Interpreter.evaluate(next));
						if(typeof(val) == "number" || typeof(val) == "number" && ((val | 0) === val)) {
							to = val;
						} else {
							var parserForLoop1 = "`for` loop's `" + little_Keywords.FOR_LOOP_IDENTIFIERS.TO + "` argument must be of type " + little_Keywords.TYPE_INT + "/" + little_Keywords.TYPE_FLOAT + " (given: " + little_interpreter_Interpreter.stringifyTokenValue(next) + " as ";
							var e = little_interpreter_Interpreter.evaluate(next);
							little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage(parserForLoop1 + $hxEnums[e.__enum__].__constructs__[e._hx_index]._hx_name + ")"));
						}
					} else {
						_hx_tmp = _g == little_Keywords.FOR_LOOP_IDENTIFIERS.JUMP;
						if(_hx_tmp == true) {
							var val = little_tools_Conversion.toHaxeValue(little_interpreter_Interpreter.evaluate(next));
							if(typeof(val) == "number" || typeof(val) == "number" && ((val | 0) === val)) {
								if(val < 0) {
									little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("`for` loop's `" + little_Keywords.FOR_LOOP_IDENTIFIERS.JUMP + "` argument must be positive (given: " + little_interpreter_Interpreter.stringifyTokenValue(next) + "). Notice - the usage of the `" + little_Keywords.FOR_LOOP_IDENTIFIERS.JUMP + "` argument switches from increasing to decreasing the value of `" + Std.string(Type.enumParameters(params[0])[0]) + "` if `" + little_Keywords.FOR_LOOP_IDENTIFIERS.FROM + "` is larger than `" + little_Keywords.FOR_LOOP_IDENTIFIERS.TO + "`. Defaulting to 1"));
								} else {
									jump = val;
								}
							} else {
								var parserForLoop1 = "`for` loop's `" + little_Keywords.FOR_LOOP_IDENTIFIERS.JUMP + "` argument must be of type " + little_Keywords.TYPE_INT + "/" + little_Keywords.TYPE_FLOAT + " (given: " + little_interpreter_Interpreter.stringifyTokenValue(next) + " as ";
								var e = little_interpreter_Interpreter.evaluate(next);
								little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage(parserForLoop1 + $hxEnums[e.__enum__].__constructs__[e._hx_index]._hx_name + "). Defaulting to `1`"));
							}
						}
					}
				}
				break;
			case 12:
				var _g = token.body;
				var _g = token.type;
				var ident = little_interpreter_Interpreter.evaluate(token);
				parserForLoop($hxEnums[ident.__enum__].__constructs__[ident._hx_index]._hx_name == "Characters" ? little_parser_ParserTokens.Identifier(Type.enumParameters(ident)[0]) : ident,next);
				break;
			default:
			}
		};
		var i = 1;
		while(i < fp.length) {
			var token = fp[i];
			var next = [];
			var lookahead = fp[i + 1];
			while(!Type.enumEq(lookahead,little_parser_ParserTokens.Identifier(little_Keywords.FOR_LOOP_IDENTIFIERS.TO)) && !Type.enumEq(lookahead,little_parser_ParserTokens.Identifier(little_Keywords.FOR_LOOP_IDENTIFIERS.JUMP))) {
				next.push(lookahead);
				lookahead = fp[++i + 1];
				if(lookahead == null) {
					break;
				}
			}
			--i;
			parserForLoop(token,little_parser_ParserTokens.Expression(next,null));
			i += 2;
		}
		if(from == null) {
			little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("`for` loop must contain a `" + little_Keywords.FOR_LOOP_IDENTIFIERS.FROM + "` argument."));
			return val;
		}
		if(from == null) {
			little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("`for` loop must contain a `" + little_Keywords.FOR_LOOP_IDENTIFIERS.TO + "` argument."));
			return val;
		}
		if(from < to) {
			while(from < to) {
				val = little_interpreter_Interpreter.interpret([little_parser_ParserTokens.Write([params[0]],from == (from | 0) ? little_parser_ParserTokens.Number("" + from) : little_parser_ParserTokens.Decimal("" + from),null)].concat(body),little_interpreter_Interpreter.currentConfig);
				from += jump;
			}
		} else {
			while(from > to) {
				val = little_interpreter_Interpreter.interpret([little_parser_ParserTokens.Write([params[0]],from == (from | 0) ? little_parser_ParserTokens.Number("" + from) : little_parser_ParserTokens.Decimal("" + from),null)].concat(body),little_interpreter_Interpreter.currentConfig);
				from -= jump;
			}
		}
		return val;
	});
	little_Little.plugin.registerCondition("after",[little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier("rule"),little_parser_ParserTokens.Identifier(little_Keywords.TYPE_BOOLEAN))],function(params,body) {
		var val = little_parser_ParserTokens.NullValue;
		var handle = little_interpreter_Interpreter.accessObject(Type.enumParameters(params[0])[0][0]);
		if(handle == null) {
			little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("`after` condition must start with a variable to watch (expected definition, found: `" + Type.enumParameters(params[0])[0][0] + "`)"));
			return val;
		}
		var dispatchAndRemove = null;
		dispatchAndRemove = function(set) {
			if(little_tools_Conversion.toHaxeValue(little_interpreter_Interpreter.evaluateExpressionParts(params))) {
				little_interpreter_Interpreter.interpret(body,little_interpreter_Interpreter.currentConfig);
				HxOverrides.remove(handle.setterListeners,dispatchAndRemove);
			}
		};
		handle.setterListeners.push(dispatchAndRemove);
		return val;
	});
	little_Little.plugin.registerCondition("whenever",[little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier("rule"),little_parser_ParserTokens.Identifier(little_Keywords.TYPE_BOOLEAN))],function(params,body) {
		var val = little_parser_ParserTokens.NullValue;
		var handle = little_interpreter_Interpreter.accessObject(Type.enumParameters(params[0])[0][0]);
		if(handle == null) {
			little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("`whenever` condition must start with a variable to watch (expected definition, found: `" + Type.enumParameters(params[0])[0][0] + "`)"));
			return val;
		}
		var dispatchAndRemove = function(set) {
			if(little_tools_Conversion.toHaxeValue(little_interpreter_Interpreter.evaluateExpressionParts(params))) {
				little_interpreter_Interpreter.interpret(body,little_interpreter_Interpreter.currentConfig);
			}
		};
		handle.setterListeners.push(dispatchAndRemove);
		return val;
	});
};
var little_tools_PrettyPrinter = function() { };
$hxClasses["little.tools.PrettyPrinter"] = little_tools_PrettyPrinter;
little_tools_PrettyPrinter.__name__ = true;
little_tools_PrettyPrinter.printParserAst = function(ast,spacingBetweenNodes) {
	if(spacingBetweenNodes == null) {
		spacingBetweenNodes = 6;
	}
	if(ast == null) {
		return "null (look for errors in input)";
	}
	little_tools_PrettyPrinter.s = little_tools_TextTools.multiply(" ",spacingBetweenNodes);
	var unfilteredResult = little_tools_PrettyPrinter.getTree(little_parser_ParserTokens.Expression(ast,null),[],0,true);
	var filtered = "";
	var _g = 0;
	var _g1 = unfilteredResult.split("\n");
	while(_g < _g1.length) {
		var line = _g1[_g];
		++_g;
		if(line == "└─── Expression") {
			continue;
		}
		filtered += line.substring(spacingBetweenNodes - 1) + "\n";
	}
	return "\nAst\n" + filtered;
};
little_tools_PrettyPrinter.prefixFA = function(pArray) {
	var prefix = "";
	var _g = 0;
	var _g1 = little_tools_PrettyPrinter.l;
	while(_g < _g1) {
		var i = _g++;
		if(pArray[i] == 1) {
			prefix += "│" + little_tools_PrettyPrinter.s.substring(1);
		} else {
			prefix += little_tools_PrettyPrinter.s;
		}
	}
	return prefix;
};
little_tools_PrettyPrinter.pushIndex = function(pArray,i) {
	var arr = pArray.slice();
	arr[i + 1] = 1;
	return arr;
};
little_tools_PrettyPrinter.getTree = function(root,prefix,level,last) {
	little_tools_PrettyPrinter.l = level;
	var t = last ? "└" : "├";
	var c = "├";
	var d = "───";
	if(root == null) {
		return "";
	}
	switch(root._hx_index) {
	case 0:
		var line = root.line;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " SetLine(" + line + ")\n";
	case 1:
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " SplitLine\n";
	case 2:
		var name = root.name;
		var type = root.type;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Definition Creation\n" + little_tools_PrettyPrinter.getTree(name,type == null ? prefix.slice() : little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,type == null) + little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
	case 3:
		var name = root.name;
		var params = root.params;
		var type = root.type;
		var title = "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Action Creation\n";
		title += little_tools_PrettyPrinter.getTree(name,prefix.slice(),level + 1,false);
		title += little_tools_PrettyPrinter.getTree(params,prefix.slice(),level + 1,type == null);
		title += little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
		return title;
	case 4:
		var name = root.name;
		var exp = root.exp;
		var body = root.body;
		var type = root.type;
		var title = "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Condition\n";
		title += little_tools_PrettyPrinter.getTree(name,prefix.slice(),level + 1,false);
		title += little_tools_PrettyPrinter.getTree(exp,little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false);
		title += little_tools_PrettyPrinter.getTree(body,prefix.slice(),level + 1,type == null);
		title += little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
		return title;
	case 5:
		var name = root.name;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Read: " + Std.string(name) + "\n";
	case 6:
		var assignees = root.assignees;
		var value = root.value;
		var type = root.type;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Definition Write\n" + little_tools_PrettyPrinter.getTree(little_parser_ParserTokens.PartArray(assignees),little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false) + little_tools_PrettyPrinter.getTree(value,prefix.slice(),level + 1,type == null) + little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
	case 7:
		var value = root.word;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + value + "\n";
	case 8:
		var type = root.type;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Type Declaration\n" + little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
	case 9:
		var name = root.name;
		var params = root.params;
		var title = "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Action Call\n";
		title += little_tools_PrettyPrinter.getTree(name,little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false);
		title += little_tools_PrettyPrinter.getTree(params,prefix.slice(),level + 1,true);
		return title;
	case 10:
		var value = root.value;
		var type = root.type;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Return\n" + little_tools_PrettyPrinter.getTree(value,prefix.slice(),level + 1,type == null) + little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
	case 11:
		var parts = root.parts;
		var type = root.type;
		if(parts.length == 0) {
			return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " <empty expression>\n";
		}
		var strParts = ["" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Expression\n" + little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,false)];
		var _g = [];
		var _g1 = 0;
		var _g2 = parts.length - 1;
		while(_g1 < _g2) {
			var i = _g1++;
			_g.push(little_tools_PrettyPrinter.getTree(parts[i],little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false));
		}
		var strParts1 = strParts.concat(_g);
		strParts1.push(little_tools_PrettyPrinter.getTree(parts[parts.length - 1],prefix.slice(),level + 1,true));
		return strParts1.join("");
	case 12:
		var body = root.body;
		var type = root.type;
		if(body.length == 0) {
			return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " <empty block>\n";
		}
		var strParts = ["" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Block\n" + little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,false)];
		var _g = [];
		var _g1 = 0;
		var _g2 = body.length - 1;
		while(_g1 < _g2) {
			var i = _g1++;
			_g.push(little_tools_PrettyPrinter.getTree(body[i],little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false));
		}
		var strParts1 = strParts.concat(_g);
		strParts1.push(little_tools_PrettyPrinter.getTree(body[body.length - 1],prefix.slice(),level + 1,true));
		return strParts1.join("");
	case 13:
		var body = root.parts;
		if(body.length == 0) {
			return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " <empty array>\n";
		}
		var strParts = ["" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Part Array\n"];
		var _g = [];
		var _g1 = 0;
		var _g2 = body.length - 1;
		while(_g1 < _g2) {
			var i = _g1++;
			_g.push(little_tools_PrettyPrinter.getTree(body[i],little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false));
		}
		var strParts1 = strParts.concat(_g);
		strParts1.push(little_tools_PrettyPrinter.getTree(body[body.length - 1],prefix.slice(),level + 1,true));
		return strParts1.join("");
	case 14:
		var name = root.name;
		var property = root.property;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Property Access\n" + little_tools_PrettyPrinter.getTree(name,little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false) + little_tools_PrettyPrinter.getTree(property,prefix.slice(),level + 1,true);
	case 15:
		var value = root.sign;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + value + "\n";
	case 16:
		var num = root.num;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + num + "\n";
	case 17:
		var num = root.num;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + num + "\n";
	case 18:
		var string = root.string;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " \"" + string + "\"\n";
	case 19:
		var name = root.name;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Module: " + name + "\n";
	case 20:
		var haxeValue = root.get;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " External Haxe Value Identifier: [" + Std.string(haxeValue) + "]\n";
	case 21:
		var use = root.use;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " External Haxe Condition Identifier: [" + Std.string(use) + "]\n";
	case 22:
		var name = root.msg;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Error: " + name + "\n";
	case 23:
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + little_Keywords.NULL_VALUE + "\n";
	case 24:
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + little_Keywords.TRUE_VALUE + "\n";
	case 25:
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + little_Keywords.FALSE_VALUE + "\n";
	}
};
little_tools_PrettyPrinter.parseParamsString = function(params,isExpected) {
	if(isExpected == null) {
		isExpected = true;
	}
	if(isExpected) {
		var str = [];
		var _g = 0;
		while(_g < params.length) {
			var param = params[_g];
			++_g;
			if(param._hx_index == 2) {
				var name = param.name;
				var type = param.type;
				str.push("" + little_interpreter_Interpreter.stringifyTokenValue(name) + " " + little_Keywords.TYPE_DECL_OR_CAST + " " + little_interpreter_Interpreter.stringifyTokenValue(type != null ? type : little_parser_ParserTokens.Identifier(little_Keywords.TYPE_DYNAMIC)));
			}
		}
		if(str.length == 0) {
			return "no parameters";
		}
		return str.join(", ");
	} else {
		var str = [];
		var _g = 0;
		while(_g < params.length) {
			var param = params[_g];
			++_g;
			str.push(little_interpreter_Interpreter.stringifyTokenIdentifier(param));
		}
		if(str.length == 0) {
			return "no parameters";
		}
		return str.join(", ");
	}
};
var little_tools__$TextTools_MultilangFonts = function() {
	this.serif = "assets/texter/TextTools/serif.ttf";
	this.sans = "assets/texter/TextTools/sans.ttf";
};
$hxClasses["little.tools._TextTools.MultilangFonts"] = little_tools__$TextTools_MultilangFonts;
little_tools__$TextTools_MultilangFonts.__name__ = true;
little_tools__$TextTools_MultilangFonts.prototype = {
	__class__: little_tools__$TextTools_MultilangFonts
};
var little_tools_TextTools = function() { };
$hxClasses["little.tools.TextTools"] = little_tools_TextTools;
little_tools_TextTools.__name__ = true;
little_tools_TextTools.replaceLast = function(string,replace,by) {
	var place = string.lastIndexOf(replace);
	var result = string.substring(0,place) + by + string.substring(place + replace.length);
	return result;
};
little_tools_TextTools.replaceFirst = function(string,replace,by) {
	var place = string.indexOf(replace);
	var result = string.substring(0,place) + by + string.substring(place + replace.length);
	return result;
};
little_tools_TextTools.splitOnFirst = function(string,delimiter) {
	var place = string.indexOf(delimiter);
	var result = [];
	result.push(string.substring(0,place));
	result.push(string.substring(place + delimiter.length));
	return result;
};
little_tools_TextTools.splitOnLast = function(string,delimiter) {
	var place = string.lastIndexOf(delimiter);
	var result = [];
	result.push(string.substring(0,place));
	result.push(string.substring(place + delimiter.length));
	return result;
};
little_tools_TextTools.splitOnParagraph = function(text) {
	return new EReg("<p>|</p>|\n\n|\r\n\r\n","g").split(text);
};
little_tools_TextTools.filter = function(text,filter) {
	if(((filter) instanceof EReg)) {
		var pattern = filter;
		text = text.replace(pattern.r,"");
		return text;
	}
	var patternType = filter;
	if(little_tools_TextTools.replaceFirst(text,"/","") != patternType) {
		var regexDetector = new EReg("^~?/(.*)/(.*)$","s");
		regexDetector.match(patternType);
		return filter(text,new EReg(regexDetector.matched(1),regexDetector.matched(2)));
	}
	switch(patternType.toLowerCase()) {
	case "alpha":
		return filter(text,new EReg("[^a-zA-Z]","g"));
	case "alphanumeric":
		return filter(text,new EReg("[^a-zA-Z0-9]","g"));
	case "numeric":
		return filter(text,new EReg("[^0-9]","g"));
	}
	return text;
};
little_tools_TextTools.indexesOf = function(string,sub) {
	var indexArray = [];
	var removedLength = 0;
	var index = string.indexOf(sub);
	while(index != -1) {
		indexArray.push({ startIndex : index + removedLength, endIndex : index + sub.length + removedLength - 1});
		removedLength += sub.length;
		string = string.substring(0,index) + string.substring(index + sub.length,string.length);
		index = string.indexOf(sub);
	}
	return indexArray;
};
little_tools_TextTools.indexesOfSubs = function(string,subs) {
	var indexArray = [];
	var orgString = string;
	var _g = 0;
	while(_g < subs.length) {
		var sub = subs[_g];
		++_g;
		var removedLength = 0;
		var index = string.indexOf(sub);
		while(index != -1) {
			indexArray.push({ startIndex : index + removedLength, endIndex : index + sub.length + removedLength});
			removedLength += sub.length;
			string = string.substring(0,index) + string.substring(index + sub.length,string.length);
			index = string.indexOf(sub);
		}
		string = orgString;
	}
	return indexArray;
};
little_tools_TextTools.indexesFromArray = function(string,subs) {
	return little_tools_TextTools.indexesOfSubs(string,subs);
};
little_tools_TextTools.indexesFromEReg = function(string,ereg) {
	var indexArray = [];
	while(ereg.match(string)) {
		var info = ereg.matchedPos();
		var by = little_tools_TextTools.multiply("⨔",info.len);
		string = string.replace(ereg.r,by);
		indexArray.push({ startIndex : info.pos, endIndex : info.pos + info.len});
	}
	return indexArray;
};
little_tools_TextTools.multiply = function(string,times) {
	var stringcopy = string;
	if(times <= 0) {
		return "";
	}
	while(--times > 0) string += stringcopy;
	return string;
};
little_tools_TextTools.subtract = function(string,by) {
	return little_tools_TextTools.replaceLast(string,by,"");
};
little_tools_TextTools.loremIpsum = function(paragraphs,length) {
	if(length == null) {
		length = -1;
	}
	if(paragraphs == null) {
		paragraphs = 1;
	}
	var text = StringTools.replace(little_tools_TextTools.loremIpsumText,"\t","");
	var loremArray = new EReg("<p>|</p>|\n\n|\r\n\r\n","g").split(text);
	var loremText = loremArray.join("\n\n");
	if(paragraphs > loremArray.length) {
		var multiplier = Math.ceil(paragraphs / loremArray.length);
		loremText = little_tools_TextTools.multiply(little_tools_TextTools.loremIpsumText,multiplier);
		loremArray = new EReg("<p>|</p>|\n\n|\r\n\r\n","g").split(loremText);
	}
	while(loremArray.length > paragraphs) loremArray.pop();
	var loremString = loremArray.join("\n\n");
	if(length != -1) {
		return loremString.substring(0,length);
	}
	return loremString;
};
little_tools_TextTools.sortByLength = function(array) {
	array.sort(function(a,b) {
		return a.length - b.length;
	});
	return array;
};
little_tools_TextTools.sortByValue = function(array) {
	array.sort(function(a,b) {
		return a - b | 0;
	});
	return array;
};
little_tools_TextTools.sortByIntValue = function(array) {
	array.sort(function(a,b) {
		return a - b;
	});
	return array;
};
little_tools_TextTools.getLineIndexOfChar = function(string,index) {
	var lines = string.split("\n");
	var lineIndex = 0;
	var _g = 0;
	var _g1 = lines.length;
	while(_g < _g1) {
		var i = _g++;
		if(index < lines[i].length) {
			lineIndex = i;
			break;
		}
		index -= lines[i].length;
	}
	return lineIndex;
};
little_tools_TextTools.countOccurrencesOf = function(string,sub) {
	var count = 0;
	while(little_tools_TextTools.contains(string,sub)) {
		++count;
		string = little_tools_TextTools.replaceFirst(string,sub,"");
	}
	return count;
};
little_tools_TextTools.contains = function(string,contains) {
	if(string == null) {
		return false;
	}
	return string.indexOf(contains) != -1;
};
little_tools_TextTools.remove = function(string,sub) {
	return little_tools_TextTools.replace(string,sub,"");
};
little_tools_TextTools.replace = function(string,replace,$with) {
	if(replace == null || $with == null) {
		return string;
	}
	return StringTools.replace(string,replace,$with);
};
little_tools_TextTools.reverse = function(string) {
	var returnedString = "";
	var _g = 1;
	var _g1 = string.length + 1;
	while(_g < _g1) {
		var i = _g++;
		returnedString += string.charAt(string.length - 1);
	}
	return returnedString;
};
little_tools_TextTools.insert = function(string,substring,at) {
	return string.substring(0,at + 1) + substring + string.substring(at + 1);
};
little_tools_TextTools.parseBool = function(string) {
	if(string == "true") {
		return true;
	} else if(string == "false") {
		return false;
	} else {
		return null;
	}
};
var little_tools_TextDirection = $hxEnums["little.tools.TextDirection"] = { __ename__:true,__constructs__:null
	,RTL: {_hx_name:"RTL",_hx_index:0,__enum__:"little.tools.TextDirection",toString:$estr}
	,LTR: {_hx_name:"LTR",_hx_index:1,__enum__:"little.tools.TextDirection",toString:$estr}
	,UNDETERMINED: {_hx_name:"UNDETERMINED",_hx_index:2,__enum__:"little.tools.TextDirection",toString:$estr}
};
little_tools_TextDirection.__constructs__ = [little_tools_TextDirection.RTL,little_tools_TextDirection.LTR,little_tools_TextDirection.UNDETERMINED];
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
$hxClasses["Math"] = Math;
String.prototype.__class__ = $hxClasses["String"] = String;
String.__name__ = true;
$hxClasses["Array"] = Array;
Array.__name__ = true;
js_Boot.__toStr = ({ }).toString;
Main.code = "action הדפס() = {print(5)}, הדפס()";
little_Keywords.VARIABLE_DECLARATION = "define";
little_Keywords.FUNCTION_DECLARATION = "action";
little_Keywords.TYPE_DECL_OR_CAST = "as";
little_Keywords.FUNCTION_RETURN = "return";
little_Keywords.NULL_VALUE = "nothing";
little_Keywords.TRUE_VALUE = "true";
little_Keywords.FALSE_VALUE = "false";
little_Keywords.TYPE_DYNAMIC = "Anything";
little_Keywords.TYPE_VOID = "Void";
little_Keywords.TYPE_INT = "Number";
little_Keywords.TYPE_FLOAT = "Decimal";
little_Keywords.TYPE_BOOLEAN = "Boolean";
little_Keywords.TYPE_STRING = "Characters";
little_Keywords.TYPE_MODULE = "Type";
little_Keywords.MAIN_MODULE_NAME = "Main";
little_Keywords.REGISTERED_MODULE_NAME = "Registered";
little_Keywords.PRINT_FUNCTION_NAME = "print";
little_Keywords.RAISE_ERROR_FUNCTION_NAME = "error";
little_Keywords.READ_FUNCTION_NAME = "read";
little_Keywords.RUN_CODE_FUNCTION_NAME = "run";
little_Keywords.TYPE_UNKNOWN = "Unknown";
little_Keywords.CONDITION_TYPES = [];
little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS = ["++","--","**","+=","-=",">=","<=","==","&&","||","^^","!="];
little_Keywords.PROPERTY_ACCESS_SIGN = ".";
little_Keywords.EQUALS_SIGN = "==";
little_Keywords.NOT_EQUALS_SIGN = "!=";
little_Keywords.XOR_SIGN = "^^";
little_Keywords.OR_SIGN = "||";
little_Keywords.AND_SIGN = "&&";
little_Keywords.FOR_LOOP_IDENTIFIERS = { FROM : "from", TO : "to", JUMP : "jump"};
little_Keywords.defaultKeywordSet = new little_interpreter_KeywordConfig("define","action","as","return","nothing","true","false","Anything","Void","Number","Decimal","Boolean","Characters","Type","Main","Registered","print","error","read","run","Unknown",null,["++","--","**","+=","-=",">=","<=","==","&&","||","^^","!="],".","==","!=","^^","||","&&",{ FROM : "from", TO : "to", JUMP : "jump"});
little_interpreter_Runtime.line = 0;
little_interpreter_Runtime.exitCode = 0;
little_interpreter_Runtime.onLineChanged = [];
little_interpreter_Runtime.onTokenInterpreted = [];
little_interpreter_Runtime.onErrorThrown = [];
little_interpreter_Runtime.stdout = "";
little_interpreter_Runtime.callStack = [];
little_Little.runtime = little_interpreter_Runtime;
little_Little.plugin = little_tools_Plugins;
little_Little.debug = false;
little_interpreter_Interpreter.errorThrown = false;
little_lexer_Lexer.signs = ["!","#","$","%","&","'","(",")","*","+","-",".","/",":","<","=",">","?","@","[","\\","]","^","_","`","{","|","}","~","^","√"];
little_parser_Parser.linePart = 0;
little_tools_Layer.LEXER = "Lexer";
little_tools_Layer.PARSER = "Parser";
little_tools_Layer.INTERPRETER = "Interpreter";
little_tools_Layer.INTERPRETER_TOKEN_VALUE_STRINGIFIER = "Interpreter, Token Value Stringifier";
little_tools_Layer.INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER = "Interpreter, Token Identifier Stringifier";
little_tools_Layer.INTERPRETER_VALUE_EVALUATOR = "Interpreter, Value Evaluator";
little_tools_Layer.INTERPRETER_EXPRESSION_EVALUATOR = "Interpreter, Expression Evaluator";
little_tools_PrettyPrinter.s = "";
little_tools_PrettyPrinter.l = 0;
little_tools_TextTools.fonts = new little_tools__$TextTools_MultilangFonts();
little_tools_TextTools.loremIpsumText = "\r\n\t\tLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque finibus condimentum magna, eget porttitor libero aliquam non. Praesent commodo, augue nec hendrerit tincidunt, urna felis lobortis mi, non cursus libero tellus quis tellus. Vivamus ornare convallis tristique. Integer nec ornare libero. Phasellus feugiat facilisis faucibus. Vivamus porta id neque id placerat. Proin convallis vel felis et pharetra. Quisque magna justo, ullamcorper quis scelerisque eu, tincidunt vitae lectus. Nunc sed turpis justo. Aliquam porttitor, purus sit amet faucibus bibendum, ligula elit molestie purus, eu volutpat turpis sapien ac tellus. Fusce mauris arcu, volutpat ut aliquam ut, ultrices id ante. Morbi quis consectetur turpis. Integer semper lacinia urna id laoreet.\r\n\r\n\t\tUt mollis eget eros eu tempor. Phasellus nulla velit, sollicitudin eget massa a, tristique rutrum turpis. Vestibulum in dolor at elit pellentesque finibus. Nulla pharetra felis a varius molestie. Nam magna lectus, eleifend ac sagittis id, ornare id nibh. Praesent congue est non iaculis consectetur. Nullam dictum augue sit amet dignissim fringilla. Aenean semper justo velit. Sed nec lectus facilisis, sodales diam eget, imperdiet nunc. Quisque elementum nulla non orci interdum pharetra id quis arcu. Phasellus eu nunc lectus. Nam tellus tortor, pellentesque eget faucibus eu, laoreet quis odio. Pellentesque posuere in enim a blandit.\r\n\r\n\t\tDuis dignissim neque et ex iaculis, ac consequat diam gravida. In mi ex, blandit eget velit non, euismod feugiat arcu. Nulla nec fermentum neque, eget elementum mauris. Vivamus urna ligula, faucibus at facilisis sed, commodo sit amet urna. Sed porttitor feugiat purus ac tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam sollicitudin lacinia turpis quis placerat. Donec eget velit nibh. Duis vehicula orci lectus, eget rutrum arcu tincidunt et. Vestibulum ut pharetra lectus. Quisque lacinia nunc rhoncus neque venenatis consequat. Nulla rutrum ultricies sapien, sed semper lectus accumsan nec. Phasellus commodo faucibus lacinia. Donec auctor condimentum ligula. Sed quis viverra mauris.\r\n\r\n\t\tQuisque maximus justo dui, eget pretium lorem accumsan ac. Praesent eleifend faucibus orci et varius. Ut et molestie turpis, eu porta neque. Quisque vehicula, libero in tincidunt facilisis, purus eros pulvinar leo, sit amet eleifend justo ligula tempor lectus. Donec ac tortor sed ipsum tincidunt pulvinar id nec eros. In luctus purus cursus est dictum, ac sollicitudin turpis maximus. Maecenas a nisl velit. Nulla gravida lectus vel ultricies gravida. Proin vel bibendum magna. Donec aliquam ultricies quam, quis tempor nunc pharetra ut.\r\n\r\n\t\tPellentesque sit amet dui est. Aliquam erat volutpat. Integer vitae ullamcorper est, ut eleifend augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque congue velit felis, vitae elementum nulla faucibus id. Donec lectus nibh, commodo eget nunc id, feugiat sagittis massa. In hac habitasse platea dictumst. Pellentesque volutpat molestie ultrices.\r\n\t";
Main.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

//# sourceMappingURL=interp.js.map