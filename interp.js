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
			little_Little.run(text.value);
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
var _$TextTools_MultilangFonts = function() {
	this.serif = "assets/texter/TextTools/serif.ttf";
	this.sans = "assets/texter/TextTools/sans.ttf";
};
$hxClasses["_TextTools.MultilangFonts"] = _$TextTools_MultilangFonts;
_$TextTools_MultilangFonts.__name__ = true;
_$TextTools_MultilangFonts.prototype = {
	__class__: _$TextTools_MultilangFonts
};
var TextTools = function() { };
$hxClasses["TextTools"] = TextTools;
TextTools.__name__ = true;
TextTools.replaceLast = function(string,replace,by) {
	var place = string.lastIndexOf(replace);
	var result = string.substring(0,place) + by + string.substring(place + replace.length);
	return result;
};
TextTools.replaceFirst = function(string,replace,by) {
	var place = string.indexOf(replace);
	var result = string.substring(0,place) + by + string.substring(place + replace.length);
	return result;
};
TextTools.splitOnFirst = function(string,delimiter) {
	var place = string.indexOf(delimiter);
	var result = [];
	result.push(string.substring(0,place));
	result.push(string.substring(place + delimiter.length));
	return result;
};
TextTools.splitOnLast = function(string,delimiter) {
	var place = string.lastIndexOf(delimiter);
	var result = [];
	result.push(string.substring(0,place));
	result.push(string.substring(place + delimiter.length));
	return result;
};
TextTools.splitOnParagraph = function(text) {
	return new EReg("<p>|</p>|\n\n|\r\n\r\n","g").split(text);
};
TextTools.filter = function(text,filter) {
	if(((filter) instanceof EReg)) {
		var pattern = filter;
		text = text.replace(pattern.r,"");
		return text;
	}
	var patternType = filter;
	if(TextTools.replaceFirst(text,"/","") != patternType) {
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
TextTools.indexesOf = function(string,sub) {
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
TextTools.indexesOfSubs = function(string,subs) {
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
TextTools.indexesFromArray = function(string,subs) {
	return TextTools.indexesOfSubs(string,subs);
};
TextTools.indexesFromEReg = function(string,ereg) {
	var indexArray = [];
	while(ereg.match(string)) {
		var info = ereg.matchedPos();
		var by = TextTools.multiply("⨔",info.len);
		string = string.replace(ereg.r,by);
		indexArray.push({ startIndex : info.pos, endIndex : info.pos + info.len});
	}
	return indexArray;
};
TextTools.multiply = function(string,times) {
	var stringcopy = string;
	if(times <= 0) {
		return "";
	}
	while(--times > 0) string += stringcopy;
	return string;
};
TextTools.subtract = function(string,by) {
	return TextTools.replaceLast(string,by,"");
};
TextTools.loremIpsum = function(paragraphs,length) {
	if(length == null) {
		length = -1;
	}
	if(paragraphs == null) {
		paragraphs = 1;
	}
	var text = StringTools.replace(TextTools.loremIpsumText,"\t","");
	var loremArray = new EReg("<p>|</p>|\n\n|\r\n\r\n","g").split(text);
	var loremText = loremArray.join("\n\n");
	if(paragraphs > loremArray.length) {
		var multiplier = Math.ceil(paragraphs / loremArray.length);
		loremText = TextTools.multiply(TextTools.loremIpsumText,multiplier);
		loremArray = new EReg("<p>|</p>|\n\n|\r\n\r\n","g").split(loremText);
	}
	while(loremArray.length > paragraphs) loremArray.pop();
	var loremString = loremArray.join("\n\n");
	if(length != -1) {
		return loremString.substring(0,length);
	}
	return loremString;
};
TextTools.sortByLength = function(array) {
	array.sort(function(a,b) {
		return a.length - b.length;
	});
	return array;
};
TextTools.sortByValue = function(array) {
	array.sort(function(a,b) {
		return a - b | 0;
	});
	return array;
};
TextTools.sortByIntValue = function(array) {
	array.sort(function(a,b) {
		return a - b;
	});
	return array;
};
TextTools.getLineIndexOfChar = function(string,index) {
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
TextTools.countOccurrencesOf = function(string,sub) {
	var count = 0;
	while(TextTools.contains(string,sub)) {
		++count;
		string = TextTools.replaceFirst(string,sub,"");
	}
	return count;
};
TextTools.contains = function(string,contains) {
	if(string == null) {
		return false;
	}
	return string.indexOf(contains) != -1;
};
TextTools.remove = function(string,sub) {
	return TextTools.replace(string,sub,"");
};
TextTools.replace = function(string,replace,$with) {
	if(replace == null || $with == null) {
		return string;
	}
	return StringTools.replace(string,replace,$with);
};
TextTools.reverse = function(string) {
	var returnedString = "";
	var _g = 1;
	var _g1 = string.length + 1;
	while(_g < _g1) {
		var i = _g++;
		returnedString += string.charAt(string.length - 1);
	}
	return returnedString;
};
TextTools.insert = function(string,substring,at) {
	return string.substring(0,at + 1) + substring + string.substring(at + 1);
};
var TextDirection = $hxEnums["TextDirection"] = { __ename__:true,__constructs__:null
	,RTL: {_hx_name:"RTL",_hx_index:0,__enum__:"TextDirection",toString:$estr}
	,LTR: {_hx_name:"LTR",_hx_index:1,__enum__:"TextDirection",toString:$estr}
	,UNDETERMINED: {_hx_name:"UNDETERMINED",_hx_index:2,__enum__:"TextDirection",toString:$estr}
};
TextDirection.__constructs__ = [TextDirection.RTL,TextDirection.LTR,TextDirection.UNDETERMINED];
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
var haxe_ds_IntMap = function() {
	this.h = { };
};
$hxClasses["haxe.ds.IntMap"] = haxe_ds_IntMap;
haxe_ds_IntMap.__name__ = true;
haxe_ds_IntMap.prototype = {
	__class__: haxe_ds_IntMap
};
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
var little_Keywords = function() { };
$hxClasses["little.Keywords"] = little_Keywords;
little_Keywords.__name__ = true;
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
	var reason = TextTools.replaceLast(TextTools.remove(Std.string(token),$hxEnums[token.__enum__].__constructs__[token._hx_index]._hx_name).substring(1),")","");
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
			var name3 = token.name;
			var params1 = token.params;
			var key2 = little_interpreter_Interpreter.stringifyTokenValue(name3);
			if(memory.h[key2] == null) {
				little_interpreter_Runtime.throwError(little_parser_ParserTokens.ErrorMessage("No Such Action:  `" + little_interpreter_Interpreter.stringifyTokenValue(name3) + "`"));
			} else {
				var key3 = little_interpreter_Interpreter.stringifyTokenValue(name3);
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
		case 15:
			var name4 = token.name;
			var property = token.property;
			returnVal = little_interpreter_Interpreter.evaluate(token);
			break;
		case 20:
			var name5 = token.name;
			little_interpreter_Runtime.currentModule = name5;
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
	if($hxEnums[exp.__enum__].__constructs__[exp._hx_index]._hx_name == "ErrorMessage") {
		if(!dontThrow) {
			little_interpreter_Runtime.throwError(exp,"Interpreter, Value Evaluator");
		}
		return exp;
	}
	switch(exp._hx_index) {
	case 0:
		var line = exp.line;
		little_interpreter_Runtime.line = line;
		break;
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
	case 9:
		var name = exp.name;
		var params = exp.params;
		var key = little_interpreter_Interpreter.stringifyTokenValue(name);
		if(memory.h[key] == null) {
			return little_parser_ParserTokens.ErrorMessage("No Such Action:  `" + little_interpreter_Interpreter.stringifyTokenValue(name) + "`");
		}
		var key = little_interpreter_Interpreter.stringifyTokenValue(name);
		return little_interpreter_Interpreter.evaluate(memory.h[key].use(params),memory,dontThrow);
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
	case 15:
		var _g = exp.name;
		var _g = exp.property;
		return little_interpreter_Interpreter.accessObject(exp,memory).value;
	case 16:
		var _g = exp.sign;
		return exp;
	case 17:
		var _g = exp.num;
		return exp;
	case 18:
		var _g = exp.num;
		return exp;
	case 19:
		var _g = exp.string;
		return exp;
	case 20:
		var name = exp.name;
		little_interpreter_Runtime.currentModule = name;
		break;
	case 21:
		var get = exp.get;
		return little_interpreter_Interpreter.evaluate(get([]),memory,dontThrow);
	case 24:case 25:case 26:
		return exp;
	default:
	}
	return little_parser_ParserTokens.ErrorMessage("Unable to evaluate token `" + Std.string(exp) + "`");
};
little_interpreter_Interpreter.accessObject = function(exp,memory) {
	if(memory == null) {
		memory = little_interpreter_Interpreter.memory;
	}
	switch(exp._hx_index) {
	case 2:
		var name = exp.name;
		var type = exp.type;
		var access = null;
		access = function(object,prop,objName) {
			if(prop._hx_index == 15) {
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
		if(name._hx_index == 15) {
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
			if(prop._hx_index == 15) {
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
		if(name._hx_index == 15) {
			var name1 = name.name;
			var property = name.property;
			var access2 = access1;
			var key = little_interpreter_Interpreter.stringifyTokenValue(name1);
			var obj = access2(memory.h[key],property,little_interpreter_Interpreter.stringifyTokenValue(name1));
			return obj;
		} else {
			haxe_Log.trace(name,{ fileName : "src/little/interpreter/Interpreter.hx", lineNumber : 273, className : "little.interpreter.Interpreter", methodName : "accessObject", customParams : [little_interpreter_Interpreter.stringifyTokenValue(name)]});
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
	case 11:
		var _g = exp.type;
		var parts = exp.parts;
		return little_interpreter_Interpreter.accessObject(little_interpreter_Interpreter.evaluateExpressionParts(parts));
	case 12:
		var body = exp.body;
		var type2 = exp.type;
		var returnVal = little_interpreter_Interpreter.runTokens(body,little_interpreter_Interpreter.currentConfig.prioritizeVariableDeclarations,little_interpreter_Interpreter.currentConfig.prioritizeFunctionDeclarations,little_interpreter_Interpreter.currentConfig.strictTyping);
		return little_interpreter_Interpreter.accessObject(little_interpreter_Interpreter.evaluate(returnVal));
	case 15:
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
			case 15:
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
	case 16:
		var _g = exp.sign;
		var key = little_interpreter_Interpreter.stringifyTokenValue(exp);
		return memory.h[key];
	case 17:
		var _g = exp.num;
		var key = little_interpreter_Interpreter.stringifyTokenValue(exp);
		return memory.h[key];
	case 18:
		var _g = exp.num;
		var key = little_interpreter_Interpreter.stringifyTokenValue(exp);
		return memory.h[key];
	case 19:
		var _g = exp.string;
		var key = little_interpreter_Interpreter.stringifyTokenValue(exp);
		return memory.h[key];
	case 24:case 25:case 26:
		var key = little_interpreter_Interpreter.stringifyTokenValue(exp);
		return memory.h[key];
	default:
	}
	return null;
};
little_interpreter_Interpreter.stringifyTokenValue = function(token,memory) {
	if(memory == null) {
		memory = little_interpreter_Interpreter.memory;
	}
	switch(token._hx_index) {
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
	case 9:
		var name = token.name;
		var params = token.params;
		var str = little_interpreter_Interpreter.stringifyTokenValue(name);
		return little_interpreter_Interpreter.stringifyTokenValue(memory.h[str] != null ? memory.h[str].use(params) : little_parser_ParserTokens.ErrorMessage("No Such Action: `" + str + "`"));
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
	case 15:
		var name = token.name;
		var property = token.property;
		return little_interpreter_Interpreter.stringifyTokenValue(name);
	case 17:
		var num = token.num;
		return num;
	case 18:
		var num = token.num;
		return num;
	case 19:
		var string = token.string;
		return string;
	case 20:
		var word = token.name;
		return word;
	case 24:
		return little_Keywords.NULL_VALUE;
	case 25:
		return little_Keywords.TRUE_VALUE;
	case 26:
		return little_Keywords.FALSE_VALUE;
	default:
	}
	return "Something went wrong";
};
little_interpreter_Interpreter.stringifyTokenIdentifier = function(token,prop,memory) {
	if(prop == null) {
		prop = false;
	}
	if(memory == null) {
		memory = little_interpreter_Interpreter.memory;
	}
	switch(token._hx_index) {
	case 2:
		var name = token.name;
		var type = token.type;
		return little_interpreter_Interpreter.stringifyTokenIdentifier(name);
	case 3:
		var name = token.name;
		var params = token.params;
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
	case 9:
		var name = token.name;
		var params = token.params;
		if(prop) {
			return little_interpreter_Interpreter.stringifyTokenValue(name);
		}
		var str = little_interpreter_Interpreter.stringifyTokenValue(name);
		return little_interpreter_Interpreter.stringifyTokenIdentifier(memory.h[str] != null ? memory.h[str].use(params) : little_parser_ParserTokens.ErrorMessage("No Such Action: `" + str + "`"));
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
	case 15:
		var name = token.name;
		var property = token.property;
		return little_interpreter_Interpreter.stringifyTokenIdentifier(name);
	case 17:
		var num = token.num;
		return num;
	case 18:
		var num = token.num;
		return num;
	case 19:
		var string = token.string;
		return string;
	case 20:
		var word = token.name;
		return word;
	case 24:
		return little_Keywords.NULL_VALUE;
	case 25:
		return little_Keywords.TRUE_VALUE;
	case 26:
		return little_Keywords.FALSE_VALUE;
	default:
	}
	return "Something went wrong";
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
		var val = little_interpreter_Interpreter.evaluate(token);
		switch(val._hx_index) {
		case 16:
			var sign = val.sign;
			mode = sign;
			break;
		case 17:
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
					value = "" + Std.parseInt(value) * Std.parseInt(num);
					break;
				case "+":
					value = "" + (Std.parseInt(value) + Std.parseInt(num));
					break;
				case "-":
					value = "" + (Std.parseInt(value) - Std.parseInt(num));
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
						value = "" + Std.string(Std.parseInt(value) < Std.parseInt(num));
						break;
					case "<=":
						value = "" + Std.string(Std.parseInt(value) <= Std.parseInt(num));
						break;
					case "==":
						value = "" + Std.string(value == num);
						break;
					case ">":
						value = "" + Std.string(Std.parseInt(value) > Std.parseInt(num));
						break;
					case ">=":
						value = "" + Std.string(Std.parseInt(value) >= Std.parseInt(num));
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
		case 18:
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
		case 19:
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
		case 23:
			var _g1 = val.msg;
			little_interpreter_Runtime.throwError(val,"Interpreter, Value Evaluator");
			break;
		case 25:case 26:
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
					value = "" + Std.parseInt(value) * num2;
					break;
				case "+":
					value = "" + (Std.parseInt(value) + num2);
					break;
				case "-":
					value = "" + (Std.parseInt(value) - num2);
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
		if(token._hx_index == 16) {
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
		if(token._hx_index == 16) {
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
var little_interpreter_KeywordConfig = function(VARIABLE_DECLARATION,FUNCTION_DECLARATION,TYPE_CHECK_OR_CAST,FUNCTION_RETURN,NULL_VALUE,TRUE_VALUE,FALSE_VALUE,TYPE_DYNAMIC,TYPE_VOID,TYPE_INT,TYPE_FLOAT,TYPE_BOOLEAN,TYPE_STRING,MAIN_MODULE_NAME,REGISTERED_MODULE_NAME,PRINT_FUNCTION_NAME,RAISE_ERROR_FUNCTION_NAME,TYPE_UNKNOWN,CONDITION_TYPES) {
	this.CONDITION_TYPES = ["if","while","whenever","for"];
	this.TYPE_UNKNOWN = "Unknown";
	this.RAISE_ERROR_FUNCTION_NAME = "stop";
	this.PRINT_FUNCTION_NAME = "print";
	this.REGISTERED_MODULE_NAME = "Registered";
	this.MAIN_MODULE_NAME = "Main";
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
	this.TYPE_CHECK_OR_CAST = "as";
	this.FUNCTION_DECLARATION = "action";
	this.VARIABLE_DECLARATION = "define";
	if(VARIABLE_DECLARATION != null) {
		this.VARIABLE_DECLARATION = VARIABLE_DECLARATION;
	}
	if(FUNCTION_DECLARATION != null) {
		this.FUNCTION_DECLARATION = FUNCTION_DECLARATION;
	}
	if(TYPE_CHECK_OR_CAST != null) {
		this.TYPE_CHECK_OR_CAST = TYPE_CHECK_OR_CAST;
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
	if(TYPE_UNKNOWN != null) {
		this.TYPE_UNKNOWN = TYPE_UNKNOWN;
	}
	if(CONDITION_TYPES != null) {
		this.CONDITION_TYPES = CONDITION_TYPES;
	}
};
$hxClasses["little.interpreter.KeywordConfig"] = little_interpreter_KeywordConfig;
little_interpreter_KeywordConfig.__name__ = true;
little_interpreter_KeywordConfig.prototype = {
	__class__: little_interpreter_KeywordConfig
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
				if(_g._hx_index == 22) {
					var use = _g.use;
					return use(con,body);
				} else {
					return little_parser_ParserTokens.ErrorMessage("Incorrect external condition value format, expected: ExternalCondition, given: " + Std.string(this.value));
				}
			} else {
				var _g = this.value;
				if(_g._hx_index == 22) {
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
		} else if(TextTools.contains("1234567890.",char)) {
			var num = char;
			++i;
			while(i < code.length && TextTools.contains("1234567890.",code.charAt(i))) {
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
		} else if(new EReg("[^+-.!@#$%%^&*0-9 \t\n;,\\(\\)\\[\\]\\{\\}]","").match(char)) {
			var name = char;
			++i;
			while(i < code.length && new EReg("[^+-.!@#$%%^&*0-9 \t\n;,\\(\\)\\[\\]\\{\\}]","").match(code.charAt(i))) {
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
			little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS = TextTools.sortByLength(little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS);
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
			if(TextTools.countOccurrencesOf(num,".") == 0) {
				tokens.push(little_parser_ParserTokens.Number(num));
			} else if(TextTools.countOccurrencesOf(num,".") == 1) {
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
little_parser_Parser.mergeTypeDecls = function(pre) {
	if(pre == null) {
		return null;
	}
	var post = [];
	var i = 0;
	while(i < pre.length) {
		var token = pre[i];
		switch(token._hx_index) {
		case 7:
			var word = token.word;
			if(word == little_Keywords.TYPE_DECL_OR_CAST && i + 1 < pre.length) {
				var lookahead = pre[i + 1];
				post.push(little_parser_ParserTokens.TypeDeclaration(lookahead));
				++i;
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
	return post;
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
		case 16:
			if(token.sign == "{") {
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
		case 16:
			if(token.sign == "(") {
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
		case 7:
			var _g = token.word;
			var _hx_tmp;
			var _hx_tmp1;
			var _hx_tmp2;
			if(_g == little_Keywords.VARIABLE_DECLARATION == true) {
				++i;
				if(i >= pre.length) {
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
					case 16:
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
						return null;
					}
					var name1 = [];
					var pushToName1 = true;
					var params = null;
					var type3 = null;
					_hx_loop3: while(i < pre.length) {
						var lookahead1 = pre[i];
						switch(lookahead1._hx_index) {
						case 0:
							var _g3 = lookahead1.line;
							--i;
							break _hx_loop3;
						case 1:
							--i;
							break _hx_loop3;
						case 8:
							var typeToken1 = lookahead1.type;
							if(name1.length == 0) {
								return null;
							} else if(type3 == null) {
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
						case 16:
							var _g4 = lookahead1.sign;
							var _hx_tmp4;
							if(_g4 == "=") {
								--i;
								break _hx_loop3;
							} else {
								_hx_tmp4 = _g4 == little_Keywords.PROPERTY_ACCESS_SIGN;
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
								var _g5 = lookahead2.line;
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
							var _g6 = pre[i + 1];
							switch(_g6._hx_index) {
							case 8:
								var _g7 = _g6.type;
								type6 = pre[i + 1];
								break;
							case 12:
								var _g8 = _g6.body;
								var _g9 = _g6.type;
								type6 = pre[i + 1];
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
								return null;
							}
							var valueToReturn = [];
							_hx_loop5: while(i < pre.length) {
								var lookahead3 = pre[i];
								switch(lookahead3._hx_index) {
								case 0:
									var _g10 = lookahead3.line;
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
				case 16:
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
		case 9:
			var name3 = token.name;
			var params1 = token.params;
			post.unshift(little_parser_ParserTokens.ActionCall(little_parser_Parser.mergePropertyOperations([name3])[0],little_parser_Parser.mergePropertyOperations([params1])[0]));
			break;
		case 10:
			var value = token.value;
			var type3 = token.type;
			post.unshift(little_parser_ParserTokens.Return(little_parser_Parser.mergePropertyOperations([value])[0],type3));
			break;
		case 12:
			var body1 = token.body;
			var type4 = token.type;
			post.unshift(little_parser_ParserTokens.Block(little_parser_Parser.mergePropertyOperations(body1),type4));
			break;
		case 13:
			var parts = token.parts;
			post.unshift(little_parser_ParserTokens.PartArray(little_parser_Parser.mergePropertyOperations(parts)));
			break;
		case 16:
			if(token.sign == little_Keywords.PROPERTY_ACCESS_SIGN == true) {
				if(i-- >= pre.length) {
					return null;
				}
				var lookbehind = pre[i];
				switch(lookbehind._hx_index) {
				case 0:
					var _g = lookbehind.line;
					return null;
				case 1:
					return null;
				case 16:
					var _g1 = lookbehind.sign;
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
	return post;
};
little_parser_Parser.mergeWrites = function(pre) {
	if(pre == null) {
		return null;
	}
	var post = [];
	var potentialAssignee = little_parser_ParserTokens.NullValue;
	var i = 0;
	_hx_loop1: while(i < pre.length) {
		var token = pre[i];
		switch(token._hx_index) {
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
		case 15:
			var name4 = token.name;
			var property = token.property;
			if(potentialAssignee != null) {
				post.push(potentialAssignee);
			}
			potentialAssignee = little_parser_ParserTokens.PropertyAccess(little_parser_Parser.mergeWrites([name4])[0],little_parser_Parser.mergeWrites([property])[0]);
			break;
		case 16:
			if(token.sign == "=") {
				if(i + 1 >= pre.length) {
					break _hx_loop1;
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
					case 16:
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
				var value1 = currentAssignee.length == 1 ? currentAssignee[0] : little_parser_ParserTokens.Expression(currentAssignee,null);
				post.push(little_parser_ParserTokens.Write(assignees,value1,null));
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
	return post;
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
	,Parameter: ($_=function(name,type) { return {_hx_index:14,name:name,type:type,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Parameter",$_.__params__ = ["name","type"],$_)
	,PropertyAccess: ($_=function(name,property) { return {_hx_index:15,name:name,property:property,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="PropertyAccess",$_.__params__ = ["name","property"],$_)
	,Sign: ($_=function(sign) { return {_hx_index:16,sign:sign,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Sign",$_.__params__ = ["sign"],$_)
	,Number: ($_=function(num) { return {_hx_index:17,num:num,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Number",$_.__params__ = ["num"],$_)
	,Decimal: ($_=function(num) { return {_hx_index:18,num:num,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Decimal",$_.__params__ = ["num"],$_)
	,Characters: ($_=function(string) { return {_hx_index:19,string:string,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Characters",$_.__params__ = ["string"],$_)
	,Module: ($_=function(name) { return {_hx_index:20,name:name,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Module",$_.__params__ = ["name"],$_)
	,External: ($_=function(get) { return {_hx_index:21,get:get,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="External",$_.__params__ = ["get"],$_)
	,ExternalCondition: ($_=function(use) { return {_hx_index:22,use:use,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="ExternalCondition",$_.__params__ = ["use"],$_)
	,ErrorMessage: ($_=function(msg) { return {_hx_index:23,msg:msg,__enum__:"little.parser.ParserTokens",toString:$estr}; },$_._hx_name="ErrorMessage",$_.__params__ = ["msg"],$_)
	,NullValue: {_hx_name:"NullValue",_hx_index:24,__enum__:"little.parser.ParserTokens",toString:$estr}
	,TrueValue: {_hx_name:"TrueValue",_hx_index:25,__enum__:"little.parser.ParserTokens",toString:$estr}
	,FalseValue: {_hx_name:"FalseValue",_hx_index:26,__enum__:"little.parser.ParserTokens",toString:$estr}
};
little_parser_ParserTokens.__constructs__ = [little_parser_ParserTokens.SetLine,little_parser_ParserTokens.SplitLine,little_parser_ParserTokens.Define,little_parser_ParserTokens.Action,little_parser_ParserTokens.Condition,little_parser_ParserTokens.Read,little_parser_ParserTokens.Write,little_parser_ParserTokens.Identifier,little_parser_ParserTokens.TypeDeclaration,little_parser_ParserTokens.ActionCall,little_parser_ParserTokens.Return,little_parser_ParserTokens.Expression,little_parser_ParserTokens.Block,little_parser_ParserTokens.PartArray,little_parser_ParserTokens.Parameter,little_parser_ParserTokens.PropertyAccess,little_parser_ParserTokens.Sign,little_parser_ParserTokens.Number,little_parser_ParserTokens.Decimal,little_parser_ParserTokens.Characters,little_parser_ParserTokens.Module,little_parser_ParserTokens.External,little_parser_ParserTokens.ExternalCondition,little_parser_ParserTokens.ErrorMessage,little_parser_ParserTokens.NullValue,little_parser_ParserTokens.TrueValue,little_parser_ParserTokens.FalseValue];
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
	case 17:
		var num = val.num;
		return Std.parseInt(num);
	case 18:
		var num = val.num;
		return parseFloat(num);
	case 19:
		var string = val.string;
		return string;
	case 23:
		var msg = val.msg;
		haxe_Log.trace("WARNING: " + msg + ". Returning null",{ fileName : "src/little/tools/Conversion.hx", lineNumber : 37, className : "little.tools.Conversion", methodName : "toHaxeValue"});
		return null;
	case 24:
		return null;
	case 25:
		return true;
	case 26:
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
	little_Little.plugin.registerFunction("print",null,[little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier("item"),null)],function(params) {
		little_interpreter_Runtime.print(little_interpreter_Interpreter.stringifyTokenValue(little_interpreter_Interpreter.evaluate(params[0])));
		return little_parser_ParserTokens.NullValue;
	});
	little_Little.plugin.registerFunction("error",null,[little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier("message"),null)],function(params) {
		little_interpreter_Runtime.throwError(little_interpreter_Interpreter.evaluate(params[0]));
		return little_parser_ParserTokens.NullValue;
	});
	little_Little.plugin.registerFunction("read",null,[little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier("string"),little_parser_ParserTokens.Identifier(little_Keywords.TYPE_STRING))],function(params) {
		return little_parser_ParserTokens.Read(little_parser_ParserTokens.Identifier(little_interpreter_Interpreter.stringifyTokenValue(params[0])));
	});
	little_Little.plugin.registerFunction("run",null,[little_parser_ParserTokens.Define(little_parser_ParserTokens.Identifier("code"),little_parser_ParserTokens.Identifier(little_Keywords.TYPE_STRING))],function(params) {
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
	little_tools_PrettyPrinter.s = TextTools.multiply(" ",spacingBetweenNodes);
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
		var type = root.type;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Parameter\n" + little_tools_PrettyPrinter.getTree(name,prefix.slice(),level + 1,false) + little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
	case 15:
		var name = root.name;
		var property = root.property;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Property Access\n" + little_tools_PrettyPrinter.getTree(name,little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false) + little_tools_PrettyPrinter.getTree(property,prefix.slice(),level + 1,true);
	case 16:
		var value = root.sign;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + value + "\n";
	case 17:
		var num = root.num;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + num + "\n";
	case 18:
		var num = root.num;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + num + "\n";
	case 19:
		var string = root.string;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " \"" + string + "\"\n";
	case 20:
		var name = root.name;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Module: " + name + "\n";
	case 21:
		var haxeValue = root.get;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " External Haxe Value Identifier: [" + Std.string(haxeValue) + "]\n";
	case 22:
		var use = root.use;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " External Haxe Condition Identifier: [" + Std.string(use) + "]\n";
	case 23:
		var name = root.msg;
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Error: " + name + "\n";
	case 24:
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + little_Keywords.NULL_VALUE + "\n";
	case 25:
		return "" + little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + little_Keywords.TRUE_VALUE + "\n";
	case 26:
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
			str.push(little_interpreter_Interpreter.stringifyTokenValue(param));
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
var texter_general_Char = {};
texter_general_Char.get_charCode = function(this1) {
	var this2 = texter_general_CharTools.charToValue;
	var key = texter_general_Char._new(this1);
	return this2.h[key];
};
texter_general_Char.set_charCode = function(this1,i) {
	this1 = texter_general_CharTools.charFromValue.h[i];
	var this1 = texter_general_CharTools.charToValue;
	var key = texter_general_Char._new(texter_general_CharTools.charFromValue.h[i]);
	return this1.h[key];
};
texter_general_Char.get_character = function(this1) {
	return this1;
};
texter_general_Char.set_character = function(this1,string) {
	this1 = string;
	return this1;
};
texter_general_Char._new = function(string,int) {
	var this1;
	if(string != null && string.length != 0) {
		this1 = string.charAt(0);
		return this1;
	} else if(int != null) {
		this1 = texter_general_CharTools.charFromValue.h[int];
		return this1;
	}
	this1 = "";
	return this1;
};
texter_general_Char.fromInt = function(int) {
	return texter_general_CharTools.charFromValue.h[int];
};
texter_general_Char.fromString = function(string) {
	return texter_general_Char._new(string);
};
texter_general_Char.toString = function(this1) {
	return this1;
};
texter_general_Char.toInt = function(this1) {
	var this2 = texter_general_CharTools.charToValue;
	var key = texter_general_Char._new(this1);
	return this2.h[key];
};
var texter_general_CharTools = function() { };
$hxClasses["texter.general.CharTools"] = texter_general_CharTools;
texter_general_CharTools.__name__ = true;
texter_general_CharTools.toCharArray = function(string) {
	var _g = [];
	var _g1 = 0;
	var _g2 = string.length;
	while(_g1 < _g2) {
		var i = _g1++;
		_g.push(texter_general_Char._new(string.charAt(i)));
	}
	return _g;
};
texter_general_CharTools.fromCharArray = function(charArray) {
	return charArray.join("");
};
texter_general_CharTools.isRTL = function(char) {
	if(char == "" || char == null) {
		return false;
	}
	if(!(char == texter_general_CharTools.RLI || char == texter_general_CharTools.RLO)) {
		return texter_general_CharTools.allRtlChars.indexOf(char) != -1;
	} else {
		return true;
	}
};
texter_general_CharTools.isLTR = function(char) {
	if(!texter_general_CharTools.isRTL(char) && !texter_general_CharTools.isSoft(char)) {
		return char != texter_general_CharTools.RLM;
	} else {
		return false;
	}
};
texter_general_CharTools.isSoft = function(char) {
	if(!(char == texter_general_CharTools.ZEROWIDTHSPACE || char == texter_general_CharTools.PDF || char == texter_general_CharTools.PDI)) {
		return texter_general_CharTools.softChars.indexOf(char) != -1;
	} else {
		return true;
	}
};
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
TextTools.fonts = new _$TextTools_MultilangFonts();
TextTools.loremIpsumText = "\r\n\t\tLorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque finibus condimentum magna, eget porttitor libero aliquam non. Praesent commodo, augue nec hendrerit tincidunt, urna felis lobortis mi, non cursus libero tellus quis tellus. Vivamus ornare convallis tristique. Integer nec ornare libero. Phasellus feugiat facilisis faucibus. Vivamus porta id neque id placerat. Proin convallis vel felis et pharetra. Quisque magna justo, ullamcorper quis scelerisque eu, tincidunt vitae lectus. Nunc sed turpis justo. Aliquam porttitor, purus sit amet faucibus bibendum, ligula elit molestie purus, eu volutpat turpis sapien ac tellus. Fusce mauris arcu, volutpat ut aliquam ut, ultrices id ante. Morbi quis consectetur turpis. Integer semper lacinia urna id laoreet.\r\n\r\n\t\tUt mollis eget eros eu tempor. Phasellus nulla velit, sollicitudin eget massa a, tristique rutrum turpis. Vestibulum in dolor at elit pellentesque finibus. Nulla pharetra felis a varius molestie. Nam magna lectus, eleifend ac sagittis id, ornare id nibh. Praesent congue est non iaculis consectetur. Nullam dictum augue sit amet dignissim fringilla. Aenean semper justo velit. Sed nec lectus facilisis, sodales diam eget, imperdiet nunc. Quisque elementum nulla non orci interdum pharetra id quis arcu. Phasellus eu nunc lectus. Nam tellus tortor, pellentesque eget faucibus eu, laoreet quis odio. Pellentesque posuere in enim a blandit.\r\n\r\n\t\tDuis dignissim neque et ex iaculis, ac consequat diam gravida. In mi ex, blandit eget velit non, euismod feugiat arcu. Nulla nec fermentum neque, eget elementum mauris. Vivamus urna ligula, faucibus at facilisis sed, commodo sit amet urna. Sed porttitor feugiat purus ac tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aliquam sollicitudin lacinia turpis quis placerat. Donec eget velit nibh. Duis vehicula orci lectus, eget rutrum arcu tincidunt et. Vestibulum ut pharetra lectus. Quisque lacinia nunc rhoncus neque venenatis consequat. Nulla rutrum ultricies sapien, sed semper lectus accumsan nec. Phasellus commodo faucibus lacinia. Donec auctor condimentum ligula. Sed quis viverra mauris.\r\n\r\n\t\tQuisque maximus justo dui, eget pretium lorem accumsan ac. Praesent eleifend faucibus orci et varius. Ut et molestie turpis, eu porta neque. Quisque vehicula, libero in tincidunt facilisis, purus eros pulvinar leo, sit amet eleifend justo ligula tempor lectus. Donec ac tortor sed ipsum tincidunt pulvinar id nec eros. In luctus purus cursus est dictum, ac sollicitudin turpis maximus. Maecenas a nisl velit. Nulla gravida lectus vel ultricies gravida. Proin vel bibendum magna. Donec aliquam ultricies quam, quis tempor nunc pharetra ut.\r\n\r\n\t\tPellentesque sit amet dui est. Aliquam erat volutpat. Integer vitae ullamcorper est, ut eleifend augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Quisque congue velit felis, vitae elementum nulla faucibus id. Donec lectus nibh, commodo eget nunc id, feugiat sagittis massa. In hac habitasse platea dictumst. Pellentesque volutpat molestie ultrices.\r\n\t";
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
texter_general_CharTools.allRtlChars = "ابپتٹثجچحخدڈذرڑزژسشصضطظعغفقکگلمنںوہھءیےیهونملگکقفغعظطضصشسژزرذدخحچجثتپباءހށނރބޅކއވމފދތލގޏސޑޒޓޔޕޖޗޘޙޚޛޜޝޞޟޠޡޢޣޤޥަާިީުޫެޭޮޯްޱآأؤإئابةتثجحخدذرزسشصضطظعغفقكلمنهويىًٌٍَُِّْـאבגדהוזחטיךכלםמןנסעףפץצקרשתװױײ׳״𐡀𐡁𐡂𐡃𐡄𐡅𐡆𐡇𐡈𐡉𐡊𐡋𐡌𐡍𐡎𐡏𐡐𐡑𐡒𐡓𐡔𐡕𐡗𐡘𐡙𐡚𐡛𐡜𐡝𐡞𐡟یهونملگکقفغعظطضصشسژزرذدخحچجثتپباء";
texter_general_CharTools.rtlLetters = new EReg(texter_general_CharTools.allRtlChars,"gi");
texter_general_CharTools.numericChars = new EReg("[0-9]","g");
texter_general_CharTools.generalMarks = ["!","\"","#","$","%","&","'","(",")","*","+",",","-",".","/",":",";","<","=",">","?","@","[","\\","]","^","_","`","{","|","}","~","^"];
texter_general_CharTools.softChars = ["!","\"","#","$","%","&","'","(",")","*","+",",","-",".","/",":",";","<","=",">","?","@","[","\\","]","^","_","`","{","|","}","~","^"," ","\t"];
texter_general_CharTools.numbers = ["0","1","2","3","4","5","6","7","8","9"];
texter_general_CharTools.NEWLINE = "\n";
texter_general_CharTools.TAB = "\t";
texter_general_CharTools.ZEROWIDTHSPACE = "​";
texter_general_CharTools.RLM = "‏";
texter_general_CharTools.LRI = "⁦";
texter_general_CharTools.RLI = "⁧";
texter_general_CharTools.FSI = "⁨";
texter_general_CharTools.LRE = "‪";
texter_general_CharTools.RLE = "‫";
texter_general_CharTools.LRO = "‭";
texter_general_CharTools.RLO = "‮";
texter_general_CharTools.PDF = "‬";
texter_general_CharTools.PDI = "⁩";
texter_general_CharTools.charToValue = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 0;
	}
	{
		var key = texter_general_Char._new("\x01");
		_g.h[key] = 1;
	}
	{
		var key = texter_general_Char._new("\x02");
		_g.h[key] = 2;
	}
	{
		var key = texter_general_Char._new("\x03");
		_g.h[key] = 3;
	}
	{
		var key = texter_general_Char._new("\x04");
		_g.h[key] = 4;
	}
	{
		var key = texter_general_Char._new("\x05");
		_g.h[key] = 5;
	}
	{
		var key = texter_general_Char._new("\x06");
		_g.h[key] = 6;
	}
	{
		var key = texter_general_Char._new("\x07");
		_g.h[key] = 7;
	}
	{
		var key = texter_general_Char._new("\x08");
		_g.h[key] = 8;
	}
	{
		var key = texter_general_Char._new("\t");
		_g.h[key] = 9;
	}
	{
		var key = texter_general_Char._new("\x0B");
		_g.h[key] = 11;
	}
	{
		var key = texter_general_Char._new("\x0C");
		_g.h[key] = 12;
	}
	{
		var key = texter_general_Char._new("\x0E");
		_g.h[key] = 14;
	}
	{
		var key = texter_general_Char._new("\x0F");
		_g.h[key] = 15;
	}
	{
		var key = texter_general_Char._new("\x10");
		_g.h[key] = 16;
	}
	{
		var key = texter_general_Char._new("\x11");
		_g.h[key] = 17;
	}
	{
		var key = texter_general_Char._new("\x12");
		_g.h[key] = 18;
	}
	{
		var key = texter_general_Char._new("\x13");
		_g.h[key] = 19;
	}
	{
		var key = texter_general_Char._new("\x14");
		_g.h[key] = 20;
	}
	{
		var key = texter_general_Char._new("\x15");
		_g.h[key] = 21;
	}
	{
		var key = texter_general_Char._new("\x16");
		_g.h[key] = 22;
	}
	{
		var key = texter_general_Char._new("\x17");
		_g.h[key] = 23;
	}
	{
		var key = texter_general_Char._new("\x18");
		_g.h[key] = 24;
	}
	{
		var key = texter_general_Char._new("\x19");
		_g.h[key] = 25;
	}
	{
		var key = texter_general_Char._new("\x1A");
		_g.h[key] = 26;
	}
	{
		var key = texter_general_Char._new("\x1B");
		_g.h[key] = 27;
	}
	{
		var key = texter_general_Char._new("\x1C");
		_g.h[key] = 28;
	}
	{
		var key = texter_general_Char._new("\x1D");
		_g.h[key] = 29;
	}
	{
		var key = texter_general_Char._new("\x1E");
		_g.h[key] = 30;
	}
	{
		var key = texter_general_Char._new("\x1F");
		_g.h[key] = 31;
	}
	{
		var key = texter_general_Char._new(" ");
		_g.h[key] = 32;
	}
	{
		var key = texter_general_Char._new("!");
		_g.h[key] = 33;
	}
	{
		var key = texter_general_Char._new("\"");
		_g.h[key] = 34;
	}
	{
		var key = texter_general_Char._new("#");
		_g.h[key] = 35;
	}
	{
		var key = texter_general_Char._new("$");
		_g.h[key] = 36;
	}
	{
		var key = texter_general_Char._new("%");
		_g.h[key] = 37;
	}
	{
		var key = texter_general_Char._new("&");
		_g.h[key] = 38;
	}
	{
		var key = texter_general_Char._new("'");
		_g.h[key] = 39;
	}
	{
		var key = texter_general_Char._new("(");
		_g.h[key] = 40;
	}
	{
		var key = texter_general_Char._new(")");
		_g.h[key] = 41;
	}
	{
		var key = texter_general_Char._new("*");
		_g.h[key] = 42;
	}
	{
		var key = texter_general_Char._new("+");
		_g.h[key] = 43;
	}
	{
		var key = texter_general_Char._new(",");
		_g.h[key] = 44;
	}
	{
		var key = texter_general_Char._new("-");
		_g.h[key] = 45;
	}
	{
		var key = texter_general_Char._new(".");
		_g.h[key] = 46;
	}
	{
		var key = texter_general_Char._new("/");
		_g.h[key] = 47;
	}
	{
		var key = texter_general_Char._new("0");
		_g.h[key] = 48;
	}
	{
		var key = texter_general_Char._new("1");
		_g.h[key] = 49;
	}
	{
		var key = texter_general_Char._new("2");
		_g.h[key] = 50;
	}
	{
		var key = texter_general_Char._new("3");
		_g.h[key] = 51;
	}
	{
		var key = texter_general_Char._new("4");
		_g.h[key] = 52;
	}
	{
		var key = texter_general_Char._new("5");
		_g.h[key] = 53;
	}
	{
		var key = texter_general_Char._new("6");
		_g.h[key] = 54;
	}
	{
		var key = texter_general_Char._new("7");
		_g.h[key] = 55;
	}
	{
		var key = texter_general_Char._new("8");
		_g.h[key] = 56;
	}
	{
		var key = texter_general_Char._new("9");
		_g.h[key] = 57;
	}
	{
		var key = texter_general_Char._new(":");
		_g.h[key] = 58;
	}
	{
		var key = texter_general_Char._new(";");
		_g.h[key] = 59;
	}
	{
		var key = texter_general_Char._new("<");
		_g.h[key] = 60;
	}
	{
		var key = texter_general_Char._new("=");
		_g.h[key] = 61;
	}
	{
		var key = texter_general_Char._new(">");
		_g.h[key] = 62;
	}
	{
		var key = texter_general_Char._new("?");
		_g.h[key] = 63;
	}
	{
		var key = texter_general_Char._new("@");
		_g.h[key] = 64;
	}
	{
		var key = texter_general_Char._new("A");
		_g.h[key] = 65;
	}
	{
		var key = texter_general_Char._new("B");
		_g.h[key] = 66;
	}
	{
		var key = texter_general_Char._new("C");
		_g.h[key] = 67;
	}
	{
		var key = texter_general_Char._new("D");
		_g.h[key] = 68;
	}
	{
		var key = texter_general_Char._new("E");
		_g.h[key] = 69;
	}
	{
		var key = texter_general_Char._new("F");
		_g.h[key] = 70;
	}
	{
		var key = texter_general_Char._new("G");
		_g.h[key] = 71;
	}
	{
		var key = texter_general_Char._new("H");
		_g.h[key] = 72;
	}
	{
		var key = texter_general_Char._new("I");
		_g.h[key] = 73;
	}
	{
		var key = texter_general_Char._new("J");
		_g.h[key] = 74;
	}
	{
		var key = texter_general_Char._new("K");
		_g.h[key] = 75;
	}
	{
		var key = texter_general_Char._new("L");
		_g.h[key] = 76;
	}
	{
		var key = texter_general_Char._new("M");
		_g.h[key] = 77;
	}
	{
		var key = texter_general_Char._new("N");
		_g.h[key] = 78;
	}
	{
		var key = texter_general_Char._new("O");
		_g.h[key] = 79;
	}
	{
		var key = texter_general_Char._new("P");
		_g.h[key] = 80;
	}
	{
		var key = texter_general_Char._new("Q");
		_g.h[key] = 81;
	}
	{
		var key = texter_general_Char._new("R");
		_g.h[key] = 82;
	}
	{
		var key = texter_general_Char._new("S");
		_g.h[key] = 83;
	}
	{
		var key = texter_general_Char._new("T");
		_g.h[key] = 84;
	}
	{
		var key = texter_general_Char._new("U");
		_g.h[key] = 85;
	}
	{
		var key = texter_general_Char._new("V");
		_g.h[key] = 86;
	}
	{
		var key = texter_general_Char._new("W");
		_g.h[key] = 87;
	}
	{
		var key = texter_general_Char._new("X");
		_g.h[key] = 88;
	}
	{
		var key = texter_general_Char._new("Y");
		_g.h[key] = 89;
	}
	{
		var key = texter_general_Char._new("Z");
		_g.h[key] = 90;
	}
	{
		var key = texter_general_Char._new("[");
		_g.h[key] = 91;
	}
	{
		var key = texter_general_Char._new("\\");
		_g.h[key] = 92;
	}
	{
		var key = texter_general_Char._new("]");
		_g.h[key] = 93;
	}
	{
		var key = texter_general_Char._new("^");
		_g.h[key] = 94;
	}
	{
		var key = texter_general_Char._new("_");
		_g.h[key] = 95;
	}
	{
		var key = texter_general_Char._new("`");
		_g.h[key] = 96;
	}
	{
		var key = texter_general_Char._new("a");
		_g.h[key] = 97;
	}
	{
		var key = texter_general_Char._new("b");
		_g.h[key] = 98;
	}
	{
		var key = texter_general_Char._new("c");
		_g.h[key] = 99;
	}
	{
		var key = texter_general_Char._new("d");
		_g.h[key] = 100;
	}
	{
		var key = texter_general_Char._new("e");
		_g.h[key] = 101;
	}
	{
		var key = texter_general_Char._new("f");
		_g.h[key] = 102;
	}
	{
		var key = texter_general_Char._new("g");
		_g.h[key] = 103;
	}
	{
		var key = texter_general_Char._new("h");
		_g.h[key] = 104;
	}
	{
		var key = texter_general_Char._new("i");
		_g.h[key] = 105;
	}
	{
		var key = texter_general_Char._new("j");
		_g.h[key] = 106;
	}
	{
		var key = texter_general_Char._new("k");
		_g.h[key] = 107;
	}
	{
		var key = texter_general_Char._new("l");
		_g.h[key] = 108;
	}
	{
		var key = texter_general_Char._new("m");
		_g.h[key] = 109;
	}
	{
		var key = texter_general_Char._new("n");
		_g.h[key] = 110;
	}
	{
		var key = texter_general_Char._new("o");
		_g.h[key] = 111;
	}
	{
		var key = texter_general_Char._new("p");
		_g.h[key] = 112;
	}
	{
		var key = texter_general_Char._new("q");
		_g.h[key] = 113;
	}
	{
		var key = texter_general_Char._new("r");
		_g.h[key] = 114;
	}
	{
		var key = texter_general_Char._new("s");
		_g.h[key] = 115;
	}
	{
		var key = texter_general_Char._new("t");
		_g.h[key] = 116;
	}
	{
		var key = texter_general_Char._new("u");
		_g.h[key] = 117;
	}
	{
		var key = texter_general_Char._new("v");
		_g.h[key] = 118;
	}
	{
		var key = texter_general_Char._new("w");
		_g.h[key] = 119;
	}
	{
		var key = texter_general_Char._new("x");
		_g.h[key] = 120;
	}
	{
		var key = texter_general_Char._new("y");
		_g.h[key] = 121;
	}
	{
		var key = texter_general_Char._new("z");
		_g.h[key] = 122;
	}
	{
		var key = texter_general_Char._new("{");
		_g.h[key] = 123;
	}
	{
		var key = texter_general_Char._new("|");
		_g.h[key] = 124;
	}
	{
		var key = texter_general_Char._new("}");
		_g.h[key] = 125;
	}
	{
		var key = texter_general_Char._new("~");
		_g.h[key] = 126;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 127;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 128;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 129;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 130;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 131;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 132;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 133;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 134;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 135;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 136;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 137;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 138;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 139;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 140;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 141;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 142;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 143;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 144;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 145;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 146;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 147;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 148;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 149;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 150;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 151;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 152;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 153;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 154;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 155;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 156;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 157;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 158;
	}
	{
		var key = texter_general_Char._new("");
		_g.h[key] = 159;
	}
	{
		var key = texter_general_Char._new(" ");
		_g.h[key] = 160;
	}
	{
		var key = texter_general_Char._new("¡");
		_g.h[key] = 161;
	}
	{
		var key = texter_general_Char._new("¢");
		_g.h[key] = 162;
	}
	{
		var key = texter_general_Char._new("£");
		_g.h[key] = 163;
	}
	{
		var key = texter_general_Char._new("¤");
		_g.h[key] = 164;
	}
	{
		var key = texter_general_Char._new("¥");
		_g.h[key] = 165;
	}
	{
		var key = texter_general_Char._new("¦");
		_g.h[key] = 166;
	}
	{
		var key = texter_general_Char._new("§");
		_g.h[key] = 167;
	}
	{
		var key = texter_general_Char._new("¨");
		_g.h[key] = 168;
	}
	{
		var key = texter_general_Char._new("©");
		_g.h[key] = 169;
	}
	{
		var key = texter_general_Char._new("ª");
		_g.h[key] = 170;
	}
	{
		var key = texter_general_Char._new("«");
		_g.h[key] = 171;
	}
	{
		var key = texter_general_Char._new("¬");
		_g.h[key] = 172;
	}
	{
		var key = texter_general_Char._new("­");
		_g.h[key] = 173;
	}
	{
		var key = texter_general_Char._new("®");
		_g.h[key] = 174;
	}
	{
		var key = texter_general_Char._new("¯");
		_g.h[key] = 175;
	}
	{
		var key = texter_general_Char._new("°");
		_g.h[key] = 176;
	}
	{
		var key = texter_general_Char._new("±");
		_g.h[key] = 177;
	}
	{
		var key = texter_general_Char._new("²");
		_g.h[key] = 178;
	}
	{
		var key = texter_general_Char._new("³");
		_g.h[key] = 179;
	}
	{
		var key = texter_general_Char._new("´");
		_g.h[key] = 180;
	}
	{
		var key = texter_general_Char._new("µ");
		_g.h[key] = 181;
	}
	{
		var key = texter_general_Char._new("¶");
		_g.h[key] = 182;
	}
	{
		var key = texter_general_Char._new("·");
		_g.h[key] = 183;
	}
	{
		var key = texter_general_Char._new("¸");
		_g.h[key] = 184;
	}
	{
		var key = texter_general_Char._new("¹");
		_g.h[key] = 185;
	}
	{
		var key = texter_general_Char._new("º");
		_g.h[key] = 186;
	}
	{
		var key = texter_general_Char._new("»");
		_g.h[key] = 187;
	}
	{
		var key = texter_general_Char._new("¼");
		_g.h[key] = 188;
	}
	{
		var key = texter_general_Char._new("½");
		_g.h[key] = 189;
	}
	{
		var key = texter_general_Char._new("¾");
		_g.h[key] = 190;
	}
	{
		var key = texter_general_Char._new("¿");
		_g.h[key] = 191;
	}
	{
		var key = texter_general_Char._new("À");
		_g.h[key] = 192;
	}
	{
		var key = texter_general_Char._new("Á");
		_g.h[key] = 193;
	}
	{
		var key = texter_general_Char._new("Â");
		_g.h[key] = 194;
	}
	{
		var key = texter_general_Char._new("Ã");
		_g.h[key] = 195;
	}
	{
		var key = texter_general_Char._new("Ä");
		_g.h[key] = 196;
	}
	{
		var key = texter_general_Char._new("Å");
		_g.h[key] = 197;
	}
	{
		var key = texter_general_Char._new("Æ");
		_g.h[key] = 198;
	}
	{
		var key = texter_general_Char._new("Ç");
		_g.h[key] = 199;
	}
	{
		var key = texter_general_Char._new("È");
		_g.h[key] = 200;
	}
	{
		var key = texter_general_Char._new("É");
		_g.h[key] = 201;
	}
	{
		var key = texter_general_Char._new("Ê");
		_g.h[key] = 202;
	}
	{
		var key = texter_general_Char._new("Ë");
		_g.h[key] = 203;
	}
	{
		var key = texter_general_Char._new("Ì");
		_g.h[key] = 204;
	}
	{
		var key = texter_general_Char._new("Í");
		_g.h[key] = 205;
	}
	{
		var key = texter_general_Char._new("Î");
		_g.h[key] = 206;
	}
	{
		var key = texter_general_Char._new("Ï");
		_g.h[key] = 207;
	}
	{
		var key = texter_general_Char._new("Ð");
		_g.h[key] = 208;
	}
	{
		var key = texter_general_Char._new("Ñ");
		_g.h[key] = 209;
	}
	{
		var key = texter_general_Char._new("Ò");
		_g.h[key] = 210;
	}
	{
		var key = texter_general_Char._new("Ó");
		_g.h[key] = 211;
	}
	{
		var key = texter_general_Char._new("Ô");
		_g.h[key] = 212;
	}
	{
		var key = texter_general_Char._new("Õ");
		_g.h[key] = 213;
	}
	{
		var key = texter_general_Char._new("Ö");
		_g.h[key] = 214;
	}
	{
		var key = texter_general_Char._new("×");
		_g.h[key] = 215;
	}
	{
		var key = texter_general_Char._new("Ø");
		_g.h[key] = 216;
	}
	{
		var key = texter_general_Char._new("Ù");
		_g.h[key] = 217;
	}
	{
		var key = texter_general_Char._new("Ú");
		_g.h[key] = 218;
	}
	{
		var key = texter_general_Char._new("Û");
		_g.h[key] = 219;
	}
	{
		var key = texter_general_Char._new("Ü");
		_g.h[key] = 220;
	}
	{
		var key = texter_general_Char._new("Ý");
		_g.h[key] = 221;
	}
	{
		var key = texter_general_Char._new("Þ");
		_g.h[key] = 222;
	}
	{
		var key = texter_general_Char._new("ß");
		_g.h[key] = 223;
	}
	{
		var key = texter_general_Char._new("à");
		_g.h[key] = 224;
	}
	{
		var key = texter_general_Char._new("á");
		_g.h[key] = 225;
	}
	{
		var key = texter_general_Char._new("â");
		_g.h[key] = 226;
	}
	{
		var key = texter_general_Char._new("ã");
		_g.h[key] = 227;
	}
	{
		var key = texter_general_Char._new("ä");
		_g.h[key] = 228;
	}
	{
		var key = texter_general_Char._new("å");
		_g.h[key] = 229;
	}
	{
		var key = texter_general_Char._new("æ");
		_g.h[key] = 230;
	}
	{
		var key = texter_general_Char._new("ç");
		_g.h[key] = 231;
	}
	{
		var key = texter_general_Char._new("è");
		_g.h[key] = 232;
	}
	{
		var key = texter_general_Char._new("é");
		_g.h[key] = 233;
	}
	{
		var key = texter_general_Char._new("ê");
		_g.h[key] = 234;
	}
	{
		var key = texter_general_Char._new("ë");
		_g.h[key] = 235;
	}
	{
		var key = texter_general_Char._new("ì");
		_g.h[key] = 236;
	}
	{
		var key = texter_general_Char._new("í");
		_g.h[key] = 237;
	}
	{
		var key = texter_general_Char._new("î");
		_g.h[key] = 238;
	}
	{
		var key = texter_general_Char._new("ï");
		_g.h[key] = 239;
	}
	{
		var key = texter_general_Char._new("ð");
		_g.h[key] = 240;
	}
	{
		var key = texter_general_Char._new("ñ");
		_g.h[key] = 241;
	}
	{
		var key = texter_general_Char._new("ò");
		_g.h[key] = 242;
	}
	{
		var key = texter_general_Char._new("ó");
		_g.h[key] = 243;
	}
	{
		var key = texter_general_Char._new("ô");
		_g.h[key] = 244;
	}
	{
		var key = texter_general_Char._new("õ");
		_g.h[key] = 245;
	}
	{
		var key = texter_general_Char._new("ö");
		_g.h[key] = 246;
	}
	{
		var key = texter_general_Char._new("÷");
		_g.h[key] = 247;
	}
	{
		var key = texter_general_Char._new("ø");
		_g.h[key] = 248;
	}
	{
		var key = texter_general_Char._new("ù");
		_g.h[key] = 249;
	}
	{
		var key = texter_general_Char._new("ú");
		_g.h[key] = 250;
	}
	{
		var key = texter_general_Char._new("û");
		_g.h[key] = 251;
	}
	{
		var key = texter_general_Char._new("ü");
		_g.h[key] = 252;
	}
	{
		var key = texter_general_Char._new("ý");
		_g.h[key] = 253;
	}
	{
		var key = texter_general_Char._new("þ");
		_g.h[key] = 254;
	}
	{
		var key = texter_general_Char._new("ÿ");
		_g.h[key] = 255;
	}
	{
		var key = texter_general_Char._new("Ā");
		_g.h[key] = 256;
	}
	{
		var key = texter_general_Char._new("ā");
		_g.h[key] = 257;
	}
	{
		var key = texter_general_Char._new("Ă");
		_g.h[key] = 258;
	}
	{
		var key = texter_general_Char._new("ă");
		_g.h[key] = 259;
	}
	{
		var key = texter_general_Char._new("Ą");
		_g.h[key] = 260;
	}
	{
		var key = texter_general_Char._new("ą");
		_g.h[key] = 261;
	}
	{
		var key = texter_general_Char._new("Ć");
		_g.h[key] = 262;
	}
	{
		var key = texter_general_Char._new("ć");
		_g.h[key] = 263;
	}
	{
		var key = texter_general_Char._new("Ĉ");
		_g.h[key] = 264;
	}
	{
		var key = texter_general_Char._new("ĉ");
		_g.h[key] = 265;
	}
	{
		var key = texter_general_Char._new("Ċ");
		_g.h[key] = 266;
	}
	{
		var key = texter_general_Char._new("ċ");
		_g.h[key] = 267;
	}
	{
		var key = texter_general_Char._new("Č");
		_g.h[key] = 268;
	}
	{
		var key = texter_general_Char._new("č");
		_g.h[key] = 269;
	}
	{
		var key = texter_general_Char._new("Ď");
		_g.h[key] = 270;
	}
	{
		var key = texter_general_Char._new("ď");
		_g.h[key] = 271;
	}
	{
		var key = texter_general_Char._new("Đ");
		_g.h[key] = 272;
	}
	{
		var key = texter_general_Char._new("đ");
		_g.h[key] = 273;
	}
	{
		var key = texter_general_Char._new("Ē");
		_g.h[key] = 274;
	}
	{
		var key = texter_general_Char._new("ē");
		_g.h[key] = 275;
	}
	{
		var key = texter_general_Char._new("Ĕ");
		_g.h[key] = 276;
	}
	{
		var key = texter_general_Char._new("ĕ");
		_g.h[key] = 277;
	}
	{
		var key = texter_general_Char._new("Ė");
		_g.h[key] = 278;
	}
	{
		var key = texter_general_Char._new("ė");
		_g.h[key] = 279;
	}
	{
		var key = texter_general_Char._new("Ę");
		_g.h[key] = 280;
	}
	{
		var key = texter_general_Char._new("ę");
		_g.h[key] = 281;
	}
	{
		var key = texter_general_Char._new("Ě");
		_g.h[key] = 282;
	}
	{
		var key = texter_general_Char._new("ě");
		_g.h[key] = 283;
	}
	{
		var key = texter_general_Char._new("Ĝ");
		_g.h[key] = 284;
	}
	{
		var key = texter_general_Char._new("ĝ");
		_g.h[key] = 285;
	}
	{
		var key = texter_general_Char._new("Ğ");
		_g.h[key] = 286;
	}
	{
		var key = texter_general_Char._new("ğ");
		_g.h[key] = 287;
	}
	{
		var key = texter_general_Char._new("Ġ");
		_g.h[key] = 288;
	}
	{
		var key = texter_general_Char._new("ġ");
		_g.h[key] = 289;
	}
	{
		var key = texter_general_Char._new("Ģ");
		_g.h[key] = 290;
	}
	{
		var key = texter_general_Char._new("ģ");
		_g.h[key] = 291;
	}
	{
		var key = texter_general_Char._new("Ĥ");
		_g.h[key] = 292;
	}
	{
		var key = texter_general_Char._new("ĥ");
		_g.h[key] = 293;
	}
	{
		var key = texter_general_Char._new("Ħ");
		_g.h[key] = 294;
	}
	{
		var key = texter_general_Char._new("ħ");
		_g.h[key] = 295;
	}
	{
		var key = texter_general_Char._new("Ĩ");
		_g.h[key] = 296;
	}
	{
		var key = texter_general_Char._new("ĩ");
		_g.h[key] = 297;
	}
	{
		var key = texter_general_Char._new("Ī");
		_g.h[key] = 298;
	}
	{
		var key = texter_general_Char._new("ī");
		_g.h[key] = 299;
	}
	{
		var key = texter_general_Char._new("Ĭ");
		_g.h[key] = 300;
	}
	{
		var key = texter_general_Char._new("ĭ");
		_g.h[key] = 301;
	}
	{
		var key = texter_general_Char._new("Į");
		_g.h[key] = 302;
	}
	{
		var key = texter_general_Char._new("į");
		_g.h[key] = 303;
	}
	{
		var key = texter_general_Char._new("İ");
		_g.h[key] = 304;
	}
	{
		var key = texter_general_Char._new("ı");
		_g.h[key] = 305;
	}
	{
		var key = texter_general_Char._new("Ĳ");
		_g.h[key] = 306;
	}
	{
		var key = texter_general_Char._new("ĳ");
		_g.h[key] = 307;
	}
	{
		var key = texter_general_Char._new("Ĵ");
		_g.h[key] = 308;
	}
	{
		var key = texter_general_Char._new("ĵ");
		_g.h[key] = 309;
	}
	{
		var key = texter_general_Char._new("Ķ");
		_g.h[key] = 310;
	}
	{
		var key = texter_general_Char._new("ķ");
		_g.h[key] = 311;
	}
	{
		var key = texter_general_Char._new("ĸ");
		_g.h[key] = 312;
	}
	{
		var key = texter_general_Char._new("Ĺ");
		_g.h[key] = 313;
	}
	{
		var key = texter_general_Char._new("ĺ");
		_g.h[key] = 314;
	}
	{
		var key = texter_general_Char._new("Ļ");
		_g.h[key] = 315;
	}
	{
		var key = texter_general_Char._new("ļ");
		_g.h[key] = 316;
	}
	{
		var key = texter_general_Char._new("Ľ");
		_g.h[key] = 317;
	}
	{
		var key = texter_general_Char._new("ľ");
		_g.h[key] = 318;
	}
	{
		var key = texter_general_Char._new("Ŀ");
		_g.h[key] = 319;
	}
	{
		var key = texter_general_Char._new("ŀ");
		_g.h[key] = 320;
	}
	{
		var key = texter_general_Char._new("Ł");
		_g.h[key] = 321;
	}
	{
		var key = texter_general_Char._new("ł");
		_g.h[key] = 322;
	}
	{
		var key = texter_general_Char._new("Ń");
		_g.h[key] = 323;
	}
	{
		var key = texter_general_Char._new("ń");
		_g.h[key] = 324;
	}
	{
		var key = texter_general_Char._new("Ņ");
		_g.h[key] = 325;
	}
	{
		var key = texter_general_Char._new("ņ");
		_g.h[key] = 326;
	}
	{
		var key = texter_general_Char._new("Ň");
		_g.h[key] = 327;
	}
	{
		var key = texter_general_Char._new("ň");
		_g.h[key] = 328;
	}
	{
		var key = texter_general_Char._new("ŉ");
		_g.h[key] = 329;
	}
	{
		var key = texter_general_Char._new("Ŋ");
		_g.h[key] = 330;
	}
	{
		var key = texter_general_Char._new("ŋ");
		_g.h[key] = 331;
	}
	{
		var key = texter_general_Char._new("Ō");
		_g.h[key] = 332;
	}
	{
		var key = texter_general_Char._new("ō");
		_g.h[key] = 333;
	}
	{
		var key = texter_general_Char._new("Ŏ");
		_g.h[key] = 334;
	}
	{
		var key = texter_general_Char._new("ŏ");
		_g.h[key] = 335;
	}
	{
		var key = texter_general_Char._new("Ő");
		_g.h[key] = 336;
	}
	{
		var key = texter_general_Char._new("ő");
		_g.h[key] = 337;
	}
	{
		var key = texter_general_Char._new("Œ");
		_g.h[key] = 338;
	}
	{
		var key = texter_general_Char._new("œ");
		_g.h[key] = 339;
	}
	{
		var key = texter_general_Char._new("Ŕ");
		_g.h[key] = 340;
	}
	{
		var key = texter_general_Char._new("ŕ");
		_g.h[key] = 341;
	}
	{
		var key = texter_general_Char._new("Ŗ");
		_g.h[key] = 342;
	}
	{
		var key = texter_general_Char._new("ŗ");
		_g.h[key] = 343;
	}
	{
		var key = texter_general_Char._new("Ř");
		_g.h[key] = 344;
	}
	{
		var key = texter_general_Char._new("ř");
		_g.h[key] = 345;
	}
	{
		var key = texter_general_Char._new("Ś");
		_g.h[key] = 346;
	}
	{
		var key = texter_general_Char._new("ś");
		_g.h[key] = 347;
	}
	{
		var key = texter_general_Char._new("Ŝ");
		_g.h[key] = 348;
	}
	{
		var key = texter_general_Char._new("ŝ");
		_g.h[key] = 349;
	}
	{
		var key = texter_general_Char._new("Ş");
		_g.h[key] = 350;
	}
	{
		var key = texter_general_Char._new("ş");
		_g.h[key] = 351;
	}
	{
		var key = texter_general_Char._new("Š");
		_g.h[key] = 352;
	}
	{
		var key = texter_general_Char._new("š");
		_g.h[key] = 353;
	}
	{
		var key = texter_general_Char._new("Ţ");
		_g.h[key] = 354;
	}
	{
		var key = texter_general_Char._new("ţ");
		_g.h[key] = 355;
	}
	{
		var key = texter_general_Char._new("Ť");
		_g.h[key] = 356;
	}
	{
		var key = texter_general_Char._new("ť");
		_g.h[key] = 357;
	}
	{
		var key = texter_general_Char._new("Ŧ");
		_g.h[key] = 358;
	}
	{
		var key = texter_general_Char._new("ŧ");
		_g.h[key] = 359;
	}
	{
		var key = texter_general_Char._new("Ũ");
		_g.h[key] = 360;
	}
	{
		var key = texter_general_Char._new("ũ");
		_g.h[key] = 361;
	}
	{
		var key = texter_general_Char._new("Ū");
		_g.h[key] = 362;
	}
	{
		var key = texter_general_Char._new("ū");
		_g.h[key] = 363;
	}
	{
		var key = texter_general_Char._new("Ŭ");
		_g.h[key] = 364;
	}
	{
		var key = texter_general_Char._new("ŭ");
		_g.h[key] = 365;
	}
	{
		var key = texter_general_Char._new("Ů");
		_g.h[key] = 366;
	}
	{
		var key = texter_general_Char._new("ů");
		_g.h[key] = 367;
	}
	{
		var key = texter_general_Char._new("Ű");
		_g.h[key] = 368;
	}
	{
		var key = texter_general_Char._new("ű");
		_g.h[key] = 369;
	}
	{
		var key = texter_general_Char._new("Ų");
		_g.h[key] = 370;
	}
	{
		var key = texter_general_Char._new("ų");
		_g.h[key] = 371;
	}
	{
		var key = texter_general_Char._new("Ŵ");
		_g.h[key] = 372;
	}
	{
		var key = texter_general_Char._new("ŵ");
		_g.h[key] = 373;
	}
	{
		var key = texter_general_Char._new("Ŷ");
		_g.h[key] = 374;
	}
	{
		var key = texter_general_Char._new("ŷ");
		_g.h[key] = 375;
	}
	{
		var key = texter_general_Char._new("Ÿ");
		_g.h[key] = 376;
	}
	{
		var key = texter_general_Char._new("Ź");
		_g.h[key] = 377;
	}
	{
		var key = texter_general_Char._new("ź");
		_g.h[key] = 378;
	}
	{
		var key = texter_general_Char._new("Ż");
		_g.h[key] = 379;
	}
	{
		var key = texter_general_Char._new("ż");
		_g.h[key] = 380;
	}
	{
		var key = texter_general_Char._new("Ž");
		_g.h[key] = 381;
	}
	{
		var key = texter_general_Char._new("ž");
		_g.h[key] = 382;
	}
	{
		var key = texter_general_Char._new("ſ");
		_g.h[key] = 383;
	}
	{
		var key = texter_general_Char._new("ƀ");
		_g.h[key] = 384;
	}
	{
		var key = texter_general_Char._new("Ɓ");
		_g.h[key] = 385;
	}
	{
		var key = texter_general_Char._new("Ƃ");
		_g.h[key] = 386;
	}
	{
		var key = texter_general_Char._new("ƃ");
		_g.h[key] = 387;
	}
	{
		var key = texter_general_Char._new("Ƅ");
		_g.h[key] = 388;
	}
	{
		var key = texter_general_Char._new("ƅ");
		_g.h[key] = 389;
	}
	{
		var key = texter_general_Char._new("Ɔ");
		_g.h[key] = 390;
	}
	{
		var key = texter_general_Char._new("Ƈ");
		_g.h[key] = 391;
	}
	{
		var key = texter_general_Char._new("ƈ");
		_g.h[key] = 392;
	}
	{
		var key = texter_general_Char._new("Ɖ");
		_g.h[key] = 393;
	}
	{
		var key = texter_general_Char._new("Ɗ");
		_g.h[key] = 394;
	}
	{
		var key = texter_general_Char._new("Ƌ");
		_g.h[key] = 395;
	}
	{
		var key = texter_general_Char._new("ƌ");
		_g.h[key] = 396;
	}
	{
		var key = texter_general_Char._new("ƍ");
		_g.h[key] = 397;
	}
	{
		var key = texter_general_Char._new("Ǝ");
		_g.h[key] = 398;
	}
	{
		var key = texter_general_Char._new("Ə");
		_g.h[key] = 399;
	}
	{
		var key = texter_general_Char._new("Ɛ");
		_g.h[key] = 400;
	}
	{
		var key = texter_general_Char._new("Ƒ");
		_g.h[key] = 401;
	}
	{
		var key = texter_general_Char._new("ƒ");
		_g.h[key] = 402;
	}
	{
		var key = texter_general_Char._new("Ɠ");
		_g.h[key] = 403;
	}
	{
		var key = texter_general_Char._new("Ɣ");
		_g.h[key] = 404;
	}
	{
		var key = texter_general_Char._new("ƕ");
		_g.h[key] = 405;
	}
	{
		var key = texter_general_Char._new("Ɩ");
		_g.h[key] = 406;
	}
	{
		var key = texter_general_Char._new("Ɨ");
		_g.h[key] = 407;
	}
	{
		var key = texter_general_Char._new("Ƙ");
		_g.h[key] = 408;
	}
	{
		var key = texter_general_Char._new("ƙ");
		_g.h[key] = 409;
	}
	{
		var key = texter_general_Char._new("ƚ");
		_g.h[key] = 410;
	}
	{
		var key = texter_general_Char._new("ƛ");
		_g.h[key] = 411;
	}
	{
		var key = texter_general_Char._new("Ɯ");
		_g.h[key] = 412;
	}
	{
		var key = texter_general_Char._new("Ɲ");
		_g.h[key] = 413;
	}
	{
		var key = texter_general_Char._new("ƞ");
		_g.h[key] = 414;
	}
	{
		var key = texter_general_Char._new("Ɵ");
		_g.h[key] = 415;
	}
	{
		var key = texter_general_Char._new("Ơ");
		_g.h[key] = 416;
	}
	{
		var key = texter_general_Char._new("ơ");
		_g.h[key] = 417;
	}
	{
		var key = texter_general_Char._new("Ƣ");
		_g.h[key] = 418;
	}
	{
		var key = texter_general_Char._new("ƣ");
		_g.h[key] = 419;
	}
	{
		var key = texter_general_Char._new("Ƥ");
		_g.h[key] = 420;
	}
	{
		var key = texter_general_Char._new("ƥ");
		_g.h[key] = 421;
	}
	{
		var key = texter_general_Char._new("Ʀ");
		_g.h[key] = 422;
	}
	{
		var key = texter_general_Char._new("Ƨ");
		_g.h[key] = 423;
	}
	{
		var key = texter_general_Char._new("ƨ");
		_g.h[key] = 424;
	}
	{
		var key = texter_general_Char._new("Ʃ");
		_g.h[key] = 425;
	}
	{
		var key = texter_general_Char._new("ƪ");
		_g.h[key] = 426;
	}
	{
		var key = texter_general_Char._new("ƫ");
		_g.h[key] = 427;
	}
	{
		var key = texter_general_Char._new("Ƭ");
		_g.h[key] = 428;
	}
	{
		var key = texter_general_Char._new("ƭ");
		_g.h[key] = 429;
	}
	{
		var key = texter_general_Char._new("Ʈ");
		_g.h[key] = 430;
	}
	{
		var key = texter_general_Char._new("Ư");
		_g.h[key] = 431;
	}
	{
		var key = texter_general_Char._new("ư");
		_g.h[key] = 432;
	}
	{
		var key = texter_general_Char._new("Ʊ");
		_g.h[key] = 433;
	}
	{
		var key = texter_general_Char._new("Ʋ");
		_g.h[key] = 434;
	}
	{
		var key = texter_general_Char._new("Ƴ");
		_g.h[key] = 435;
	}
	{
		var key = texter_general_Char._new("ƴ");
		_g.h[key] = 436;
	}
	{
		var key = texter_general_Char._new("Ƶ");
		_g.h[key] = 437;
	}
	{
		var key = texter_general_Char._new("ƶ");
		_g.h[key] = 438;
	}
	{
		var key = texter_general_Char._new("Ʒ");
		_g.h[key] = 439;
	}
	{
		var key = texter_general_Char._new("Ƹ");
		_g.h[key] = 440;
	}
	{
		var key = texter_general_Char._new("ƹ");
		_g.h[key] = 441;
	}
	{
		var key = texter_general_Char._new("ƺ");
		_g.h[key] = 442;
	}
	{
		var key = texter_general_Char._new("ƻ");
		_g.h[key] = 443;
	}
	{
		var key = texter_general_Char._new("Ƽ");
		_g.h[key] = 444;
	}
	{
		var key = texter_general_Char._new("ƽ");
		_g.h[key] = 445;
	}
	{
		var key = texter_general_Char._new("ƾ");
		_g.h[key] = 446;
	}
	{
		var key = texter_general_Char._new("ƿ");
		_g.h[key] = 447;
	}
	{
		var key = texter_general_Char._new("ǀ");
		_g.h[key] = 448;
	}
	{
		var key = texter_general_Char._new("ǁ");
		_g.h[key] = 449;
	}
	{
		var key = texter_general_Char._new("ǂ");
		_g.h[key] = 450;
	}
	{
		var key = texter_general_Char._new("ǃ");
		_g.h[key] = 451;
	}
	{
		var key = texter_general_Char._new("Ǆ");
		_g.h[key] = 452;
	}
	{
		var key = texter_general_Char._new("ǅ");
		_g.h[key] = 453;
	}
	{
		var key = texter_general_Char._new("ǆ");
		_g.h[key] = 454;
	}
	{
		var key = texter_general_Char._new("Ǉ");
		_g.h[key] = 455;
	}
	{
		var key = texter_general_Char._new("ǈ");
		_g.h[key] = 456;
	}
	{
		var key = texter_general_Char._new("ǉ");
		_g.h[key] = 457;
	}
	{
		var key = texter_general_Char._new("Ǌ");
		_g.h[key] = 458;
	}
	{
		var key = texter_general_Char._new("ǋ");
		_g.h[key] = 459;
	}
	{
		var key = texter_general_Char._new("ǌ");
		_g.h[key] = 460;
	}
	{
		var key = texter_general_Char._new("Ǎ");
		_g.h[key] = 461;
	}
	{
		var key = texter_general_Char._new("ǎ");
		_g.h[key] = 462;
	}
	{
		var key = texter_general_Char._new("Ǐ");
		_g.h[key] = 463;
	}
	{
		var key = texter_general_Char._new("ǐ");
		_g.h[key] = 464;
	}
	{
		var key = texter_general_Char._new("Ǒ");
		_g.h[key] = 465;
	}
	{
		var key = texter_general_Char._new("ǒ");
		_g.h[key] = 466;
	}
	{
		var key = texter_general_Char._new("Ǔ");
		_g.h[key] = 467;
	}
	{
		var key = texter_general_Char._new("ǔ");
		_g.h[key] = 468;
	}
	{
		var key = texter_general_Char._new("Ǖ");
		_g.h[key] = 469;
	}
	{
		var key = texter_general_Char._new("ǖ");
		_g.h[key] = 470;
	}
	{
		var key = texter_general_Char._new("Ǘ");
		_g.h[key] = 471;
	}
	{
		var key = texter_general_Char._new("ǘ");
		_g.h[key] = 472;
	}
	{
		var key = texter_general_Char._new("Ǚ");
		_g.h[key] = 473;
	}
	{
		var key = texter_general_Char._new("ǚ");
		_g.h[key] = 474;
	}
	{
		var key = texter_general_Char._new("Ǜ");
		_g.h[key] = 475;
	}
	{
		var key = texter_general_Char._new("ǜ");
		_g.h[key] = 476;
	}
	{
		var key = texter_general_Char._new("ǝ");
		_g.h[key] = 477;
	}
	{
		var key = texter_general_Char._new("Ǟ");
		_g.h[key] = 478;
	}
	{
		var key = texter_general_Char._new("ǟ");
		_g.h[key] = 479;
	}
	{
		var key = texter_general_Char._new("Ǡ");
		_g.h[key] = 480;
	}
	{
		var key = texter_general_Char._new("ǡ");
		_g.h[key] = 481;
	}
	{
		var key = texter_general_Char._new("Ǣ");
		_g.h[key] = 482;
	}
	{
		var key = texter_general_Char._new("ǣ");
		_g.h[key] = 483;
	}
	{
		var key = texter_general_Char._new("Ǥ");
		_g.h[key] = 484;
	}
	{
		var key = texter_general_Char._new("ǥ");
		_g.h[key] = 485;
	}
	{
		var key = texter_general_Char._new("Ǧ");
		_g.h[key] = 486;
	}
	{
		var key = texter_general_Char._new("ǧ");
		_g.h[key] = 487;
	}
	{
		var key = texter_general_Char._new("Ǩ");
		_g.h[key] = 488;
	}
	{
		var key = texter_general_Char._new("ǩ");
		_g.h[key] = 489;
	}
	{
		var key = texter_general_Char._new("Ǫ");
		_g.h[key] = 490;
	}
	{
		var key = texter_general_Char._new("ǫ");
		_g.h[key] = 491;
	}
	{
		var key = texter_general_Char._new("Ǭ");
		_g.h[key] = 492;
	}
	{
		var key = texter_general_Char._new("ǭ");
		_g.h[key] = 493;
	}
	{
		var key = texter_general_Char._new("Ǯ");
		_g.h[key] = 494;
	}
	{
		var key = texter_general_Char._new("ǯ");
		_g.h[key] = 495;
	}
	{
		var key = texter_general_Char._new("ǰ");
		_g.h[key] = 496;
	}
	{
		var key = texter_general_Char._new("Ǳ");
		_g.h[key] = 497;
	}
	{
		var key = texter_general_Char._new("ǲ");
		_g.h[key] = 498;
	}
	{
		var key = texter_general_Char._new("ǳ");
		_g.h[key] = 499;
	}
	{
		var key = texter_general_Char._new("Ǵ");
		_g.h[key] = 500;
	}
	{
		var key = texter_general_Char._new("ǵ");
		_g.h[key] = 501;
	}
	{
		var key = texter_general_Char._new("Ƕ");
		_g.h[key] = 502;
	}
	{
		var key = texter_general_Char._new("Ƿ");
		_g.h[key] = 503;
	}
	{
		var key = texter_general_Char._new("Ǹ");
		_g.h[key] = 504;
	}
	{
		var key = texter_general_Char._new("ǹ");
		_g.h[key] = 505;
	}
	{
		var key = texter_general_Char._new("Ǻ");
		_g.h[key] = 506;
	}
	{
		var key = texter_general_Char._new("ǻ");
		_g.h[key] = 507;
	}
	{
		var key = texter_general_Char._new("Ǽ");
		_g.h[key] = 508;
	}
	{
		var key = texter_general_Char._new("ǽ");
		_g.h[key] = 509;
	}
	{
		var key = texter_general_Char._new("Ǿ");
		_g.h[key] = 510;
	}
	{
		var key = texter_general_Char._new("ǿ");
		_g.h[key] = 511;
	}
	{
		var key = texter_general_Char._new("Ȁ");
		_g.h[key] = 512;
	}
	{
		var key = texter_general_Char._new("ȁ");
		_g.h[key] = 513;
	}
	{
		var key = texter_general_Char._new("Ȃ");
		_g.h[key] = 514;
	}
	{
		var key = texter_general_Char._new("ȃ");
		_g.h[key] = 515;
	}
	{
		var key = texter_general_Char._new("Ȅ");
		_g.h[key] = 516;
	}
	{
		var key = texter_general_Char._new("ȅ");
		_g.h[key] = 517;
	}
	{
		var key = texter_general_Char._new("Ȇ");
		_g.h[key] = 518;
	}
	{
		var key = texter_general_Char._new("ȇ");
		_g.h[key] = 519;
	}
	{
		var key = texter_general_Char._new("Ȉ");
		_g.h[key] = 520;
	}
	{
		var key = texter_general_Char._new("ȉ");
		_g.h[key] = 521;
	}
	{
		var key = texter_general_Char._new("Ȋ");
		_g.h[key] = 522;
	}
	{
		var key = texter_general_Char._new("ȋ");
		_g.h[key] = 523;
	}
	{
		var key = texter_general_Char._new("Ȍ");
		_g.h[key] = 524;
	}
	{
		var key = texter_general_Char._new("ȍ");
		_g.h[key] = 525;
	}
	{
		var key = texter_general_Char._new("Ȏ");
		_g.h[key] = 526;
	}
	{
		var key = texter_general_Char._new("ȏ");
		_g.h[key] = 527;
	}
	{
		var key = texter_general_Char._new("Ȑ");
		_g.h[key] = 528;
	}
	{
		var key = texter_general_Char._new("ȑ");
		_g.h[key] = 529;
	}
	{
		var key = texter_general_Char._new("Ȓ");
		_g.h[key] = 530;
	}
	{
		var key = texter_general_Char._new("ȓ");
		_g.h[key] = 531;
	}
	{
		var key = texter_general_Char._new("Ȕ");
		_g.h[key] = 532;
	}
	{
		var key = texter_general_Char._new("ȕ");
		_g.h[key] = 533;
	}
	{
		var key = texter_general_Char._new("Ȗ");
		_g.h[key] = 534;
	}
	{
		var key = texter_general_Char._new("ȗ");
		_g.h[key] = 535;
	}
	{
		var key = texter_general_Char._new("Ș");
		_g.h[key] = 536;
	}
	{
		var key = texter_general_Char._new("ș");
		_g.h[key] = 537;
	}
	{
		var key = texter_general_Char._new("Ț");
		_g.h[key] = 538;
	}
	{
		var key = texter_general_Char._new("ț");
		_g.h[key] = 539;
	}
	{
		var key = texter_general_Char._new("Ȝ");
		_g.h[key] = 540;
	}
	{
		var key = texter_general_Char._new("ȝ");
		_g.h[key] = 541;
	}
	{
		var key = texter_general_Char._new("Ȟ");
		_g.h[key] = 542;
	}
	{
		var key = texter_general_Char._new("ȟ");
		_g.h[key] = 543;
	}
	{
		var key = texter_general_Char._new("Ƞ");
		_g.h[key] = 544;
	}
	{
		var key = texter_general_Char._new("ȡ");
		_g.h[key] = 545;
	}
	{
		var key = texter_general_Char._new("Ȣ");
		_g.h[key] = 546;
	}
	{
		var key = texter_general_Char._new("ȣ");
		_g.h[key] = 547;
	}
	{
		var key = texter_general_Char._new("Ȥ");
		_g.h[key] = 548;
	}
	{
		var key = texter_general_Char._new("ȥ");
		_g.h[key] = 549;
	}
	{
		var key = texter_general_Char._new("Ȧ");
		_g.h[key] = 550;
	}
	{
		var key = texter_general_Char._new("ȧ");
		_g.h[key] = 551;
	}
	{
		var key = texter_general_Char._new("Ȩ");
		_g.h[key] = 552;
	}
	{
		var key = texter_general_Char._new("ȩ");
		_g.h[key] = 553;
	}
	{
		var key = texter_general_Char._new("Ȫ");
		_g.h[key] = 554;
	}
	{
		var key = texter_general_Char._new("ȫ");
		_g.h[key] = 555;
	}
	{
		var key = texter_general_Char._new("Ȭ");
		_g.h[key] = 556;
	}
	{
		var key = texter_general_Char._new("ȭ");
		_g.h[key] = 557;
	}
	{
		var key = texter_general_Char._new("Ȯ");
		_g.h[key] = 558;
	}
	{
		var key = texter_general_Char._new("ȯ");
		_g.h[key] = 559;
	}
	{
		var key = texter_general_Char._new("Ȱ");
		_g.h[key] = 560;
	}
	{
		var key = texter_general_Char._new("ȱ");
		_g.h[key] = 561;
	}
	{
		var key = texter_general_Char._new("Ȳ");
		_g.h[key] = 562;
	}
	{
		var key = texter_general_Char._new("ȳ");
		_g.h[key] = 563;
	}
	{
		var key = texter_general_Char._new("ȴ");
		_g.h[key] = 564;
	}
	{
		var key = texter_general_Char._new("ȵ");
		_g.h[key] = 565;
	}
	{
		var key = texter_general_Char._new("ȶ");
		_g.h[key] = 566;
	}
	{
		var key = texter_general_Char._new("ȷ");
		_g.h[key] = 567;
	}
	{
		var key = texter_general_Char._new("ȸ");
		_g.h[key] = 568;
	}
	{
		var key = texter_general_Char._new("ȹ");
		_g.h[key] = 569;
	}
	{
		var key = texter_general_Char._new("Ⱥ");
		_g.h[key] = 570;
	}
	{
		var key = texter_general_Char._new("Ȼ");
		_g.h[key] = 571;
	}
	{
		var key = texter_general_Char._new("ȼ");
		_g.h[key] = 572;
	}
	{
		var key = texter_general_Char._new("Ƚ");
		_g.h[key] = 573;
	}
	{
		var key = texter_general_Char._new("Ⱦ");
		_g.h[key] = 574;
	}
	{
		var key = texter_general_Char._new("ȿ");
		_g.h[key] = 575;
	}
	{
		var key = texter_general_Char._new("ɀ");
		_g.h[key] = 576;
	}
	{
		var key = texter_general_Char._new("Ɂ");
		_g.h[key] = 577;
	}
	{
		var key = texter_general_Char._new("ɂ");
		_g.h[key] = 578;
	}
	{
		var key = texter_general_Char._new("Ƀ");
		_g.h[key] = 579;
	}
	{
		var key = texter_general_Char._new("Ʉ");
		_g.h[key] = 580;
	}
	{
		var key = texter_general_Char._new("Ʌ");
		_g.h[key] = 581;
	}
	{
		var key = texter_general_Char._new("Ɇ");
		_g.h[key] = 582;
	}
	{
		var key = texter_general_Char._new("ɇ");
		_g.h[key] = 583;
	}
	{
		var key = texter_general_Char._new("Ɉ");
		_g.h[key] = 584;
	}
	{
		var key = texter_general_Char._new("ɉ");
		_g.h[key] = 585;
	}
	{
		var key = texter_general_Char._new("Ɋ");
		_g.h[key] = 586;
	}
	{
		var key = texter_general_Char._new("ɋ");
		_g.h[key] = 587;
	}
	{
		var key = texter_general_Char._new("Ɍ");
		_g.h[key] = 588;
	}
	{
		var key = texter_general_Char._new("ɍ");
		_g.h[key] = 589;
	}
	{
		var key = texter_general_Char._new("Ɏ");
		_g.h[key] = 590;
	}
	{
		var key = texter_general_Char._new("ɏ");
		_g.h[key] = 591;
	}
	{
		var key = texter_general_Char._new("ɐ");
		_g.h[key] = 592;
	}
	{
		var key = texter_general_Char._new("ɑ");
		_g.h[key] = 593;
	}
	{
		var key = texter_general_Char._new("ɒ");
		_g.h[key] = 594;
	}
	{
		var key = texter_general_Char._new("ɓ");
		_g.h[key] = 595;
	}
	{
		var key = texter_general_Char._new("ɔ");
		_g.h[key] = 596;
	}
	{
		var key = texter_general_Char._new("ɕ");
		_g.h[key] = 597;
	}
	{
		var key = texter_general_Char._new("ɖ");
		_g.h[key] = 598;
	}
	{
		var key = texter_general_Char._new("ɗ");
		_g.h[key] = 599;
	}
	{
		var key = texter_general_Char._new("ɘ");
		_g.h[key] = 600;
	}
	{
		var key = texter_general_Char._new("ə");
		_g.h[key] = 601;
	}
	{
		var key = texter_general_Char._new("ɚ");
		_g.h[key] = 602;
	}
	{
		var key = texter_general_Char._new("ɛ");
		_g.h[key] = 603;
	}
	{
		var key = texter_general_Char._new("ɜ");
		_g.h[key] = 604;
	}
	{
		var key = texter_general_Char._new("ɝ");
		_g.h[key] = 605;
	}
	{
		var key = texter_general_Char._new("ɞ");
		_g.h[key] = 606;
	}
	{
		var key = texter_general_Char._new("ɟ");
		_g.h[key] = 607;
	}
	{
		var key = texter_general_Char._new("ɠ");
		_g.h[key] = 608;
	}
	{
		var key = texter_general_Char._new("ɡ");
		_g.h[key] = 609;
	}
	{
		var key = texter_general_Char._new("ɢ");
		_g.h[key] = 610;
	}
	{
		var key = texter_general_Char._new("ɣ");
		_g.h[key] = 611;
	}
	{
		var key = texter_general_Char._new("ɤ");
		_g.h[key] = 612;
	}
	{
		var key = texter_general_Char._new("ɥ");
		_g.h[key] = 613;
	}
	{
		var key = texter_general_Char._new("ɦ");
		_g.h[key] = 614;
	}
	{
		var key = texter_general_Char._new("ɧ");
		_g.h[key] = 615;
	}
	{
		var key = texter_general_Char._new("ɨ");
		_g.h[key] = 616;
	}
	{
		var key = texter_general_Char._new("ɩ");
		_g.h[key] = 617;
	}
	{
		var key = texter_general_Char._new("ɪ");
		_g.h[key] = 618;
	}
	{
		var key = texter_general_Char._new("ɫ");
		_g.h[key] = 619;
	}
	{
		var key = texter_general_Char._new("ɬ");
		_g.h[key] = 620;
	}
	{
		var key = texter_general_Char._new("ɭ");
		_g.h[key] = 621;
	}
	{
		var key = texter_general_Char._new("ɮ");
		_g.h[key] = 622;
	}
	{
		var key = texter_general_Char._new("ɯ");
		_g.h[key] = 623;
	}
	{
		var key = texter_general_Char._new("ɰ");
		_g.h[key] = 624;
	}
	{
		var key = texter_general_Char._new("ɱ");
		_g.h[key] = 625;
	}
	{
		var key = texter_general_Char._new("ɲ");
		_g.h[key] = 626;
	}
	{
		var key = texter_general_Char._new("ɳ");
		_g.h[key] = 627;
	}
	{
		var key = texter_general_Char._new("ɴ");
		_g.h[key] = 628;
	}
	{
		var key = texter_general_Char._new("ɵ");
		_g.h[key] = 629;
	}
	{
		var key = texter_general_Char._new("ɶ");
		_g.h[key] = 630;
	}
	{
		var key = texter_general_Char._new("ɷ");
		_g.h[key] = 631;
	}
	{
		var key = texter_general_Char._new("ɸ");
		_g.h[key] = 632;
	}
	{
		var key = texter_general_Char._new("ɹ");
		_g.h[key] = 633;
	}
	{
		var key = texter_general_Char._new("ɺ");
		_g.h[key] = 634;
	}
	{
		var key = texter_general_Char._new("ɻ");
		_g.h[key] = 635;
	}
	{
		var key = texter_general_Char._new("ɼ");
		_g.h[key] = 636;
	}
	{
		var key = texter_general_Char._new("ɽ");
		_g.h[key] = 637;
	}
	{
		var key = texter_general_Char._new("ɾ");
		_g.h[key] = 638;
	}
	{
		var key = texter_general_Char._new("ɿ");
		_g.h[key] = 639;
	}
	{
		var key = texter_general_Char._new("ʀ");
		_g.h[key] = 640;
	}
	{
		var key = texter_general_Char._new("ʁ");
		_g.h[key] = 641;
	}
	{
		var key = texter_general_Char._new("ʂ");
		_g.h[key] = 642;
	}
	{
		var key = texter_general_Char._new("ʃ");
		_g.h[key] = 643;
	}
	{
		var key = texter_general_Char._new("ʄ");
		_g.h[key] = 644;
	}
	{
		var key = texter_general_Char._new("ʅ");
		_g.h[key] = 645;
	}
	{
		var key = texter_general_Char._new("ʆ");
		_g.h[key] = 646;
	}
	{
		var key = texter_general_Char._new("ʇ");
		_g.h[key] = 647;
	}
	{
		var key = texter_general_Char._new("ʈ");
		_g.h[key] = 648;
	}
	{
		var key = texter_general_Char._new("ʉ");
		_g.h[key] = 649;
	}
	{
		var key = texter_general_Char._new("ʊ");
		_g.h[key] = 650;
	}
	{
		var key = texter_general_Char._new("ʋ");
		_g.h[key] = 651;
	}
	{
		var key = texter_general_Char._new("ʌ");
		_g.h[key] = 652;
	}
	{
		var key = texter_general_Char._new("ʍ");
		_g.h[key] = 653;
	}
	{
		var key = texter_general_Char._new("ʎ");
		_g.h[key] = 654;
	}
	{
		var key = texter_general_Char._new("ʏ");
		_g.h[key] = 655;
	}
	{
		var key = texter_general_Char._new("ʐ");
		_g.h[key] = 656;
	}
	{
		var key = texter_general_Char._new("ʑ");
		_g.h[key] = 657;
	}
	{
		var key = texter_general_Char._new("ʒ");
		_g.h[key] = 658;
	}
	{
		var key = texter_general_Char._new("ʓ");
		_g.h[key] = 659;
	}
	{
		var key = texter_general_Char._new("ʔ");
		_g.h[key] = 660;
	}
	{
		var key = texter_general_Char._new("ʕ");
		_g.h[key] = 661;
	}
	{
		var key = texter_general_Char._new("ʖ");
		_g.h[key] = 662;
	}
	{
		var key = texter_general_Char._new("ʗ");
		_g.h[key] = 663;
	}
	{
		var key = texter_general_Char._new("ʘ");
		_g.h[key] = 664;
	}
	{
		var key = texter_general_Char._new("ʙ");
		_g.h[key] = 665;
	}
	{
		var key = texter_general_Char._new("ʚ");
		_g.h[key] = 666;
	}
	{
		var key = texter_general_Char._new("ʛ");
		_g.h[key] = 667;
	}
	{
		var key = texter_general_Char._new("ʜ");
		_g.h[key] = 668;
	}
	{
		var key = texter_general_Char._new("ʝ");
		_g.h[key] = 669;
	}
	{
		var key = texter_general_Char._new("ʞ");
		_g.h[key] = 670;
	}
	{
		var key = texter_general_Char._new("ʟ");
		_g.h[key] = 671;
	}
	{
		var key = texter_general_Char._new("ʠ");
		_g.h[key] = 672;
	}
	{
		var key = texter_general_Char._new("ʡ");
		_g.h[key] = 673;
	}
	{
		var key = texter_general_Char._new("ʢ");
		_g.h[key] = 674;
	}
	{
		var key = texter_general_Char._new("ʣ");
		_g.h[key] = 675;
	}
	{
		var key = texter_general_Char._new("ʤ");
		_g.h[key] = 676;
	}
	{
		var key = texter_general_Char._new("ʥ");
		_g.h[key] = 677;
	}
	{
		var key = texter_general_Char._new("ʦ");
		_g.h[key] = 678;
	}
	{
		var key = texter_general_Char._new("ʧ");
		_g.h[key] = 679;
	}
	{
		var key = texter_general_Char._new("ʨ");
		_g.h[key] = 680;
	}
	{
		var key = texter_general_Char._new("ʩ");
		_g.h[key] = 681;
	}
	{
		var key = texter_general_Char._new("ʪ");
		_g.h[key] = 682;
	}
	{
		var key = texter_general_Char._new("ʫ");
		_g.h[key] = 683;
	}
	{
		var key = texter_general_Char._new("ʬ");
		_g.h[key] = 684;
	}
	{
		var key = texter_general_Char._new("ʭ");
		_g.h[key] = 685;
	}
	{
		var key = texter_general_Char._new("ʮ");
		_g.h[key] = 686;
	}
	{
		var key = texter_general_Char._new("ʯ");
		_g.h[key] = 687;
	}
	{
		var key = texter_general_Char._new("ʰ");
		_g.h[key] = 688;
	}
	{
		var key = texter_general_Char._new("ʱ");
		_g.h[key] = 689;
	}
	{
		var key = texter_general_Char._new("ʲ");
		_g.h[key] = 690;
	}
	{
		var key = texter_general_Char._new("ʳ");
		_g.h[key] = 691;
	}
	{
		var key = texter_general_Char._new("ʴ");
		_g.h[key] = 692;
	}
	{
		var key = texter_general_Char._new("ʵ");
		_g.h[key] = 693;
	}
	{
		var key = texter_general_Char._new("ʶ");
		_g.h[key] = 694;
	}
	{
		var key = texter_general_Char._new("ʷ");
		_g.h[key] = 695;
	}
	{
		var key = texter_general_Char._new("ʸ");
		_g.h[key] = 696;
	}
	{
		var key = texter_general_Char._new("ʹ");
		_g.h[key] = 697;
	}
	{
		var key = texter_general_Char._new("ʺ");
		_g.h[key] = 698;
	}
	{
		var key = texter_general_Char._new("ʻ");
		_g.h[key] = 699;
	}
	{
		var key = texter_general_Char._new("ʼ");
		_g.h[key] = 700;
	}
	{
		var key = texter_general_Char._new("ʽ");
		_g.h[key] = 701;
	}
	{
		var key = texter_general_Char._new("ʾ");
		_g.h[key] = 702;
	}
	{
		var key = texter_general_Char._new("ʿ");
		_g.h[key] = 703;
	}
	{
		var key = texter_general_Char._new("ˀ");
		_g.h[key] = 704;
	}
	{
		var key = texter_general_Char._new("ˁ");
		_g.h[key] = 705;
	}
	{
		var key = texter_general_Char._new("˂");
		_g.h[key] = 706;
	}
	{
		var key = texter_general_Char._new("˃");
		_g.h[key] = 707;
	}
	{
		var key = texter_general_Char._new("˄");
		_g.h[key] = 708;
	}
	{
		var key = texter_general_Char._new("˅");
		_g.h[key] = 709;
	}
	{
		var key = texter_general_Char._new("ˆ");
		_g.h[key] = 710;
	}
	{
		var key = texter_general_Char._new("ˇ");
		_g.h[key] = 711;
	}
	{
		var key = texter_general_Char._new("ˈ");
		_g.h[key] = 712;
	}
	{
		var key = texter_general_Char._new("ˉ");
		_g.h[key] = 713;
	}
	{
		var key = texter_general_Char._new("ˊ");
		_g.h[key] = 714;
	}
	{
		var key = texter_general_Char._new("ˋ");
		_g.h[key] = 715;
	}
	{
		var key = texter_general_Char._new("ˌ");
		_g.h[key] = 716;
	}
	{
		var key = texter_general_Char._new("ˍ");
		_g.h[key] = 717;
	}
	{
		var key = texter_general_Char._new("ˎ");
		_g.h[key] = 718;
	}
	{
		var key = texter_general_Char._new("ˏ");
		_g.h[key] = 719;
	}
	{
		var key = texter_general_Char._new("ː");
		_g.h[key] = 720;
	}
	{
		var key = texter_general_Char._new("ˑ");
		_g.h[key] = 721;
	}
	{
		var key = texter_general_Char._new("˒");
		_g.h[key] = 722;
	}
	{
		var key = texter_general_Char._new("˓");
		_g.h[key] = 723;
	}
	{
		var key = texter_general_Char._new("˔");
		_g.h[key] = 724;
	}
	{
		var key = texter_general_Char._new("˕");
		_g.h[key] = 725;
	}
	{
		var key = texter_general_Char._new("˖");
		_g.h[key] = 726;
	}
	{
		var key = texter_general_Char._new("˗");
		_g.h[key] = 727;
	}
	{
		var key = texter_general_Char._new("˘");
		_g.h[key] = 728;
	}
	{
		var key = texter_general_Char._new("˙");
		_g.h[key] = 729;
	}
	{
		var key = texter_general_Char._new("˚");
		_g.h[key] = 730;
	}
	{
		var key = texter_general_Char._new("˛");
		_g.h[key] = 731;
	}
	{
		var key = texter_general_Char._new("˜");
		_g.h[key] = 732;
	}
	{
		var key = texter_general_Char._new("˝");
		_g.h[key] = 733;
	}
	{
		var key = texter_general_Char._new("˞");
		_g.h[key] = 734;
	}
	{
		var key = texter_general_Char._new("˟");
		_g.h[key] = 735;
	}
	{
		var key = texter_general_Char._new("ˠ");
		_g.h[key] = 736;
	}
	{
		var key = texter_general_Char._new("ˡ");
		_g.h[key] = 737;
	}
	{
		var key = texter_general_Char._new("ˢ");
		_g.h[key] = 738;
	}
	{
		var key = texter_general_Char._new("ˣ");
		_g.h[key] = 739;
	}
	{
		var key = texter_general_Char._new("ˤ");
		_g.h[key] = 740;
	}
	{
		var key = texter_general_Char._new("˥");
		_g.h[key] = 741;
	}
	{
		var key = texter_general_Char._new("˦");
		_g.h[key] = 742;
	}
	{
		var key = texter_general_Char._new("˧");
		_g.h[key] = 743;
	}
	{
		var key = texter_general_Char._new("˨");
		_g.h[key] = 744;
	}
	{
		var key = texter_general_Char._new("˩");
		_g.h[key] = 745;
	}
	{
		var key = texter_general_Char._new("˪");
		_g.h[key] = 746;
	}
	{
		var key = texter_general_Char._new("˫");
		_g.h[key] = 747;
	}
	{
		var key = texter_general_Char._new("ˬ");
		_g.h[key] = 748;
	}
	{
		var key = texter_general_Char._new("˭");
		_g.h[key] = 749;
	}
	{
		var key = texter_general_Char._new("ˮ");
		_g.h[key] = 750;
	}
	{
		var key = texter_general_Char._new("˯");
		_g.h[key] = 751;
	}
	{
		var key = texter_general_Char._new("˰");
		_g.h[key] = 752;
	}
	{
		var key = texter_general_Char._new("˱");
		_g.h[key] = 753;
	}
	{
		var key = texter_general_Char._new("˲");
		_g.h[key] = 754;
	}
	{
		var key = texter_general_Char._new("˳");
		_g.h[key] = 755;
	}
	{
		var key = texter_general_Char._new("˴");
		_g.h[key] = 756;
	}
	{
		var key = texter_general_Char._new("˵");
		_g.h[key] = 757;
	}
	{
		var key = texter_general_Char._new("˶");
		_g.h[key] = 758;
	}
	{
		var key = texter_general_Char._new("˷");
		_g.h[key] = 759;
	}
	{
		var key = texter_general_Char._new("˸");
		_g.h[key] = 760;
	}
	{
		var key = texter_general_Char._new("˹");
		_g.h[key] = 761;
	}
	{
		var key = texter_general_Char._new("˺");
		_g.h[key] = 762;
	}
	{
		var key = texter_general_Char._new("˻");
		_g.h[key] = 763;
	}
	{
		var key = texter_general_Char._new("˼");
		_g.h[key] = 764;
	}
	{
		var key = texter_general_Char._new("˽");
		_g.h[key] = 765;
	}
	{
		var key = texter_general_Char._new("˾");
		_g.h[key] = 766;
	}
	{
		var key = texter_general_Char._new("˿");
		_g.h[key] = 767;
	}
	{
		var key = texter_general_Char._new("̀");
		_g.h[key] = 768;
	}
	{
		var key = texter_general_Char._new("́");
		_g.h[key] = 769;
	}
	{
		var key = texter_general_Char._new("̂");
		_g.h[key] = 770;
	}
	{
		var key = texter_general_Char._new("̃");
		_g.h[key] = 771;
	}
	{
		var key = texter_general_Char._new("̄");
		_g.h[key] = 772;
	}
	{
		var key = texter_general_Char._new("̅");
		_g.h[key] = 773;
	}
	{
		var key = texter_general_Char._new("̆");
		_g.h[key] = 774;
	}
	{
		var key = texter_general_Char._new("̇");
		_g.h[key] = 775;
	}
	{
		var key = texter_general_Char._new("̈");
		_g.h[key] = 776;
	}
	{
		var key = texter_general_Char._new("̉");
		_g.h[key] = 777;
	}
	{
		var key = texter_general_Char._new("̊");
		_g.h[key] = 778;
	}
	{
		var key = texter_general_Char._new("̋");
		_g.h[key] = 779;
	}
	{
		var key = texter_general_Char._new("̌");
		_g.h[key] = 780;
	}
	{
		var key = texter_general_Char._new("̍");
		_g.h[key] = 781;
	}
	{
		var key = texter_general_Char._new("̎");
		_g.h[key] = 782;
	}
	{
		var key = texter_general_Char._new("̏");
		_g.h[key] = 783;
	}
	{
		var key = texter_general_Char._new("̐");
		_g.h[key] = 784;
	}
	{
		var key = texter_general_Char._new("̑");
		_g.h[key] = 785;
	}
	{
		var key = texter_general_Char._new("̒");
		_g.h[key] = 786;
	}
	{
		var key = texter_general_Char._new("̓");
		_g.h[key] = 787;
	}
	{
		var key = texter_general_Char._new("̔");
		_g.h[key] = 788;
	}
	{
		var key = texter_general_Char._new("̕");
		_g.h[key] = 789;
	}
	{
		var key = texter_general_Char._new("̖");
		_g.h[key] = 790;
	}
	{
		var key = texter_general_Char._new("̗");
		_g.h[key] = 791;
	}
	{
		var key = texter_general_Char._new("̘");
		_g.h[key] = 792;
	}
	{
		var key = texter_general_Char._new("̙");
		_g.h[key] = 793;
	}
	{
		var key = texter_general_Char._new("̚");
		_g.h[key] = 794;
	}
	{
		var key = texter_general_Char._new("̛");
		_g.h[key] = 795;
	}
	{
		var key = texter_general_Char._new("̜");
		_g.h[key] = 796;
	}
	{
		var key = texter_general_Char._new("̝");
		_g.h[key] = 797;
	}
	{
		var key = texter_general_Char._new("̞");
		_g.h[key] = 798;
	}
	{
		var key = texter_general_Char._new("̟");
		_g.h[key] = 799;
	}
	{
		var key = texter_general_Char._new("̠");
		_g.h[key] = 800;
	}
	{
		var key = texter_general_Char._new("̡");
		_g.h[key] = 801;
	}
	{
		var key = texter_general_Char._new("̢");
		_g.h[key] = 802;
	}
	{
		var key = texter_general_Char._new("̣");
		_g.h[key] = 803;
	}
	{
		var key = texter_general_Char._new("̤");
		_g.h[key] = 804;
	}
	{
		var key = texter_general_Char._new("̥");
		_g.h[key] = 805;
	}
	{
		var key = texter_general_Char._new("̦");
		_g.h[key] = 806;
	}
	{
		var key = texter_general_Char._new("̧");
		_g.h[key] = 807;
	}
	{
		var key = texter_general_Char._new("̨");
		_g.h[key] = 808;
	}
	{
		var key = texter_general_Char._new("̩");
		_g.h[key] = 809;
	}
	{
		var key = texter_general_Char._new("̪");
		_g.h[key] = 810;
	}
	{
		var key = texter_general_Char._new("̫");
		_g.h[key] = 811;
	}
	{
		var key = texter_general_Char._new("̬");
		_g.h[key] = 812;
	}
	{
		var key = texter_general_Char._new("̭");
		_g.h[key] = 813;
	}
	{
		var key = texter_general_Char._new("̮");
		_g.h[key] = 814;
	}
	{
		var key = texter_general_Char._new("̯");
		_g.h[key] = 815;
	}
	{
		var key = texter_general_Char._new("̰");
		_g.h[key] = 816;
	}
	{
		var key = texter_general_Char._new("̱");
		_g.h[key] = 817;
	}
	{
		var key = texter_general_Char._new("̲");
		_g.h[key] = 818;
	}
	{
		var key = texter_general_Char._new("̳");
		_g.h[key] = 819;
	}
	{
		var key = texter_general_Char._new("̴");
		_g.h[key] = 820;
	}
	{
		var key = texter_general_Char._new("̵");
		_g.h[key] = 821;
	}
	{
		var key = texter_general_Char._new("̶");
		_g.h[key] = 822;
	}
	{
		var key = texter_general_Char._new("̷");
		_g.h[key] = 823;
	}
	{
		var key = texter_general_Char._new("̸");
		_g.h[key] = 824;
	}
	{
		var key = texter_general_Char._new("̹");
		_g.h[key] = 825;
	}
	{
		var key = texter_general_Char._new("̺");
		_g.h[key] = 826;
	}
	{
		var key = texter_general_Char._new("̻");
		_g.h[key] = 827;
	}
	{
		var key = texter_general_Char._new("̼");
		_g.h[key] = 828;
	}
	{
		var key = texter_general_Char._new("̽");
		_g.h[key] = 829;
	}
	{
		var key = texter_general_Char._new("̾");
		_g.h[key] = 830;
	}
	{
		var key = texter_general_Char._new("̿");
		_g.h[key] = 831;
	}
	{
		var key = texter_general_Char._new("̀");
		_g.h[key] = 832;
	}
	{
		var key = texter_general_Char._new("́");
		_g.h[key] = 833;
	}
	{
		var key = texter_general_Char._new("͂");
		_g.h[key] = 834;
	}
	{
		var key = texter_general_Char._new("̓");
		_g.h[key] = 835;
	}
	{
		var key = texter_general_Char._new("̈́");
		_g.h[key] = 836;
	}
	{
		var key = texter_general_Char._new("ͅ");
		_g.h[key] = 837;
	}
	{
		var key = texter_general_Char._new("͆");
		_g.h[key] = 838;
	}
	{
		var key = texter_general_Char._new("͇");
		_g.h[key] = 839;
	}
	{
		var key = texter_general_Char._new("͈");
		_g.h[key] = 840;
	}
	{
		var key = texter_general_Char._new("͉");
		_g.h[key] = 841;
	}
	{
		var key = texter_general_Char._new("͊");
		_g.h[key] = 842;
	}
	{
		var key = texter_general_Char._new("͋");
		_g.h[key] = 843;
	}
	{
		var key = texter_general_Char._new("͌");
		_g.h[key] = 844;
	}
	{
		var key = texter_general_Char._new("͍");
		_g.h[key] = 845;
	}
	{
		var key = texter_general_Char._new("͎");
		_g.h[key] = 846;
	}
	{
		var key = texter_general_Char._new("͏");
		_g.h[key] = 847;
	}
	{
		var key = texter_general_Char._new("͐");
		_g.h[key] = 848;
	}
	{
		var key = texter_general_Char._new("͑");
		_g.h[key] = 849;
	}
	{
		var key = texter_general_Char._new("͒");
		_g.h[key] = 850;
	}
	{
		var key = texter_general_Char._new("͓");
		_g.h[key] = 851;
	}
	{
		var key = texter_general_Char._new("͔");
		_g.h[key] = 852;
	}
	{
		var key = texter_general_Char._new("͕");
		_g.h[key] = 853;
	}
	{
		var key = texter_general_Char._new("͖");
		_g.h[key] = 854;
	}
	{
		var key = texter_general_Char._new("͗");
		_g.h[key] = 855;
	}
	{
		var key = texter_general_Char._new("͘");
		_g.h[key] = 856;
	}
	{
		var key = texter_general_Char._new("͙");
		_g.h[key] = 857;
	}
	{
		var key = texter_general_Char._new("͚");
		_g.h[key] = 858;
	}
	{
		var key = texter_general_Char._new("͛");
		_g.h[key] = 859;
	}
	{
		var key = texter_general_Char._new("͜");
		_g.h[key] = 860;
	}
	{
		var key = texter_general_Char._new("͝");
		_g.h[key] = 861;
	}
	{
		var key = texter_general_Char._new("͞");
		_g.h[key] = 862;
	}
	{
		var key = texter_general_Char._new("͟");
		_g.h[key] = 863;
	}
	{
		var key = texter_general_Char._new("͠");
		_g.h[key] = 864;
	}
	{
		var key = texter_general_Char._new("͡");
		_g.h[key] = 865;
	}
	{
		var key = texter_general_Char._new("͢");
		_g.h[key] = 866;
	}
	{
		var key = texter_general_Char._new("ͣ");
		_g.h[key] = 867;
	}
	{
		var key = texter_general_Char._new("ͤ");
		_g.h[key] = 868;
	}
	{
		var key = texter_general_Char._new("ͥ");
		_g.h[key] = 869;
	}
	{
		var key = texter_general_Char._new("ͦ");
		_g.h[key] = 870;
	}
	{
		var key = texter_general_Char._new("ͧ");
		_g.h[key] = 871;
	}
	{
		var key = texter_general_Char._new("ͨ");
		_g.h[key] = 872;
	}
	{
		var key = texter_general_Char._new("ͩ");
		_g.h[key] = 873;
	}
	{
		var key = texter_general_Char._new("ͪ");
		_g.h[key] = 874;
	}
	{
		var key = texter_general_Char._new("ͫ");
		_g.h[key] = 875;
	}
	{
		var key = texter_general_Char._new("ͬ");
		_g.h[key] = 876;
	}
	{
		var key = texter_general_Char._new("ͭ");
		_g.h[key] = 877;
	}
	{
		var key = texter_general_Char._new("ͮ");
		_g.h[key] = 878;
	}
	{
		var key = texter_general_Char._new("ͯ");
		_g.h[key] = 879;
	}
	{
		var key = texter_general_Char._new("Ͱ");
		_g.h[key] = 880;
	}
	{
		var key = texter_general_Char._new("ͱ");
		_g.h[key] = 881;
	}
	{
		var key = texter_general_Char._new("Ͳ");
		_g.h[key] = 882;
	}
	{
		var key = texter_general_Char._new("ͳ");
		_g.h[key] = 883;
	}
	{
		var key = texter_general_Char._new("ʹ");
		_g.h[key] = 884;
	}
	{
		var key = texter_general_Char._new("͵");
		_g.h[key] = 885;
	}
	{
		var key = texter_general_Char._new("Ͷ");
		_g.h[key] = 886;
	}
	{
		var key = texter_general_Char._new("ͷ");
		_g.h[key] = 887;
	}
	{
		var key = texter_general_Char._new("͸");
		_g.h[key] = 888;
	}
	{
		var key = texter_general_Char._new("͹");
		_g.h[key] = 889;
	}
	{
		var key = texter_general_Char._new("ͺ");
		_g.h[key] = 890;
	}
	{
		var key = texter_general_Char._new("ͻ");
		_g.h[key] = 891;
	}
	{
		var key = texter_general_Char._new("ͼ");
		_g.h[key] = 892;
	}
	{
		var key = texter_general_Char._new("ͽ");
		_g.h[key] = 893;
	}
	{
		var key = texter_general_Char._new(";");
		_g.h[key] = 894;
	}
	{
		var key = texter_general_Char._new("Ϳ");
		_g.h[key] = 895;
	}
	{
		var key = texter_general_Char._new("΀");
		_g.h[key] = 896;
	}
	{
		var key = texter_general_Char._new("΁");
		_g.h[key] = 897;
	}
	{
		var key = texter_general_Char._new("΂");
		_g.h[key] = 898;
	}
	{
		var key = texter_general_Char._new("΃");
		_g.h[key] = 899;
	}
	{
		var key = texter_general_Char._new("΄");
		_g.h[key] = 900;
	}
	{
		var key = texter_general_Char._new("΅");
		_g.h[key] = 901;
	}
	{
		var key = texter_general_Char._new("Ά");
		_g.h[key] = 902;
	}
	{
		var key = texter_general_Char._new("·");
		_g.h[key] = 903;
	}
	{
		var key = texter_general_Char._new("Έ");
		_g.h[key] = 904;
	}
	{
		var key = texter_general_Char._new("Ή");
		_g.h[key] = 905;
	}
	{
		var key = texter_general_Char._new("Ί");
		_g.h[key] = 906;
	}
	{
		var key = texter_general_Char._new("΋");
		_g.h[key] = 907;
	}
	{
		var key = texter_general_Char._new("Ό");
		_g.h[key] = 908;
	}
	{
		var key = texter_general_Char._new("΍");
		_g.h[key] = 909;
	}
	{
		var key = texter_general_Char._new("Ύ");
		_g.h[key] = 910;
	}
	{
		var key = texter_general_Char._new("Ώ");
		_g.h[key] = 911;
	}
	{
		var key = texter_general_Char._new("ΐ");
		_g.h[key] = 912;
	}
	{
		var key = texter_general_Char._new("Α");
		_g.h[key] = 913;
	}
	{
		var key = texter_general_Char._new("Β");
		_g.h[key] = 914;
	}
	{
		var key = texter_general_Char._new("Γ");
		_g.h[key] = 915;
	}
	{
		var key = texter_general_Char._new("Δ");
		_g.h[key] = 916;
	}
	{
		var key = texter_general_Char._new("Ε");
		_g.h[key] = 917;
	}
	{
		var key = texter_general_Char._new("Ζ");
		_g.h[key] = 918;
	}
	{
		var key = texter_general_Char._new("Η");
		_g.h[key] = 919;
	}
	{
		var key = texter_general_Char._new("Θ");
		_g.h[key] = 920;
	}
	{
		var key = texter_general_Char._new("Ι");
		_g.h[key] = 921;
	}
	{
		var key = texter_general_Char._new("Κ");
		_g.h[key] = 922;
	}
	{
		var key = texter_general_Char._new("Λ");
		_g.h[key] = 923;
	}
	{
		var key = texter_general_Char._new("Μ");
		_g.h[key] = 924;
	}
	{
		var key = texter_general_Char._new("Ν");
		_g.h[key] = 925;
	}
	{
		var key = texter_general_Char._new("Ξ");
		_g.h[key] = 926;
	}
	{
		var key = texter_general_Char._new("Ο");
		_g.h[key] = 927;
	}
	{
		var key = texter_general_Char._new("Π");
		_g.h[key] = 928;
	}
	{
		var key = texter_general_Char._new("Ρ");
		_g.h[key] = 929;
	}
	{
		var key = texter_general_Char._new("΢");
		_g.h[key] = 930;
	}
	{
		var key = texter_general_Char._new("Σ");
		_g.h[key] = 931;
	}
	{
		var key = texter_general_Char._new("Τ");
		_g.h[key] = 932;
	}
	{
		var key = texter_general_Char._new("Υ");
		_g.h[key] = 933;
	}
	{
		var key = texter_general_Char._new("Φ");
		_g.h[key] = 934;
	}
	{
		var key = texter_general_Char._new("Χ");
		_g.h[key] = 935;
	}
	{
		var key = texter_general_Char._new("Ψ");
		_g.h[key] = 936;
	}
	{
		var key = texter_general_Char._new("Ω");
		_g.h[key] = 937;
	}
	{
		var key = texter_general_Char._new("Ϊ");
		_g.h[key] = 938;
	}
	{
		var key = texter_general_Char._new("Ϋ");
		_g.h[key] = 939;
	}
	{
		var key = texter_general_Char._new("ά");
		_g.h[key] = 940;
	}
	{
		var key = texter_general_Char._new("έ");
		_g.h[key] = 941;
	}
	{
		var key = texter_general_Char._new("ή");
		_g.h[key] = 942;
	}
	{
		var key = texter_general_Char._new("ί");
		_g.h[key] = 943;
	}
	{
		var key = texter_general_Char._new("ΰ");
		_g.h[key] = 944;
	}
	{
		var key = texter_general_Char._new("α");
		_g.h[key] = 945;
	}
	{
		var key = texter_general_Char._new("β");
		_g.h[key] = 946;
	}
	{
		var key = texter_general_Char._new("γ");
		_g.h[key] = 947;
	}
	{
		var key = texter_general_Char._new("δ");
		_g.h[key] = 948;
	}
	{
		var key = texter_general_Char._new("ε");
		_g.h[key] = 949;
	}
	{
		var key = texter_general_Char._new("ζ");
		_g.h[key] = 950;
	}
	{
		var key = texter_general_Char._new("η");
		_g.h[key] = 951;
	}
	{
		var key = texter_general_Char._new("θ");
		_g.h[key] = 952;
	}
	{
		var key = texter_general_Char._new("ι");
		_g.h[key] = 953;
	}
	{
		var key = texter_general_Char._new("κ");
		_g.h[key] = 954;
	}
	{
		var key = texter_general_Char._new("λ");
		_g.h[key] = 955;
	}
	{
		var key = texter_general_Char._new("μ");
		_g.h[key] = 956;
	}
	{
		var key = texter_general_Char._new("ν");
		_g.h[key] = 957;
	}
	{
		var key = texter_general_Char._new("ξ");
		_g.h[key] = 958;
	}
	{
		var key = texter_general_Char._new("ο");
		_g.h[key] = 959;
	}
	{
		var key = texter_general_Char._new("π");
		_g.h[key] = 960;
	}
	{
		var key = texter_general_Char._new("ρ");
		_g.h[key] = 961;
	}
	{
		var key = texter_general_Char._new("ς");
		_g.h[key] = 962;
	}
	{
		var key = texter_general_Char._new("σ");
		_g.h[key] = 963;
	}
	{
		var key = texter_general_Char._new("τ");
		_g.h[key] = 964;
	}
	{
		var key = texter_general_Char._new("υ");
		_g.h[key] = 965;
	}
	{
		var key = texter_general_Char._new("φ");
		_g.h[key] = 966;
	}
	{
		var key = texter_general_Char._new("χ");
		_g.h[key] = 967;
	}
	{
		var key = texter_general_Char._new("ψ");
		_g.h[key] = 968;
	}
	{
		var key = texter_general_Char._new("ω");
		_g.h[key] = 969;
	}
	{
		var key = texter_general_Char._new("ϊ");
		_g.h[key] = 970;
	}
	{
		var key = texter_general_Char._new("ϋ");
		_g.h[key] = 971;
	}
	{
		var key = texter_general_Char._new("ό");
		_g.h[key] = 972;
	}
	{
		var key = texter_general_Char._new("ύ");
		_g.h[key] = 973;
	}
	{
		var key = texter_general_Char._new("ώ");
		_g.h[key] = 974;
	}
	{
		var key = texter_general_Char._new("Ϗ");
		_g.h[key] = 975;
	}
	{
		var key = texter_general_Char._new("ϐ");
		_g.h[key] = 976;
	}
	{
		var key = texter_general_Char._new("ϑ");
		_g.h[key] = 977;
	}
	{
		var key = texter_general_Char._new("ϒ");
		_g.h[key] = 978;
	}
	{
		var key = texter_general_Char._new("ϓ");
		_g.h[key] = 979;
	}
	{
		var key = texter_general_Char._new("ϔ");
		_g.h[key] = 980;
	}
	{
		var key = texter_general_Char._new("ϕ");
		_g.h[key] = 981;
	}
	{
		var key = texter_general_Char._new("ϖ");
		_g.h[key] = 982;
	}
	{
		var key = texter_general_Char._new("ϗ");
		_g.h[key] = 983;
	}
	{
		var key = texter_general_Char._new("Ϙ");
		_g.h[key] = 984;
	}
	{
		var key = texter_general_Char._new("ϙ");
		_g.h[key] = 985;
	}
	{
		var key = texter_general_Char._new("Ϛ");
		_g.h[key] = 986;
	}
	{
		var key = texter_general_Char._new("ϛ");
		_g.h[key] = 987;
	}
	{
		var key = texter_general_Char._new("Ϝ");
		_g.h[key] = 988;
	}
	{
		var key = texter_general_Char._new("ϝ");
		_g.h[key] = 989;
	}
	{
		var key = texter_general_Char._new("Ϟ");
		_g.h[key] = 990;
	}
	{
		var key = texter_general_Char._new("ϟ");
		_g.h[key] = 991;
	}
	{
		var key = texter_general_Char._new("Ϡ");
		_g.h[key] = 992;
	}
	{
		var key = texter_general_Char._new("ϡ");
		_g.h[key] = 993;
	}
	{
		var key = texter_general_Char._new("Ϣ");
		_g.h[key] = 994;
	}
	{
		var key = texter_general_Char._new("ϣ");
		_g.h[key] = 995;
	}
	{
		var key = texter_general_Char._new("Ϥ");
		_g.h[key] = 996;
	}
	{
		var key = texter_general_Char._new("ϥ");
		_g.h[key] = 997;
	}
	{
		var key = texter_general_Char._new("Ϧ");
		_g.h[key] = 998;
	}
	{
		var key = texter_general_Char._new("ϧ");
		_g.h[key] = 999;
	}
	{
		var key = texter_general_Char._new("Ϩ");
		_g.h[key] = 1000;
	}
	{
		var key = texter_general_Char._new("ϩ");
		_g.h[key] = 1001;
	}
	{
		var key = texter_general_Char._new("Ϫ");
		_g.h[key] = 1002;
	}
	{
		var key = texter_general_Char._new("ϫ");
		_g.h[key] = 1003;
	}
	{
		var key = texter_general_Char._new("Ϭ");
		_g.h[key] = 1004;
	}
	{
		var key = texter_general_Char._new("ϭ");
		_g.h[key] = 1005;
	}
	{
		var key = texter_general_Char._new("Ϯ");
		_g.h[key] = 1006;
	}
	{
		var key = texter_general_Char._new("ϯ");
		_g.h[key] = 1007;
	}
	{
		var key = texter_general_Char._new("ϰ");
		_g.h[key] = 1008;
	}
	{
		var key = texter_general_Char._new("ϱ");
		_g.h[key] = 1009;
	}
	{
		var key = texter_general_Char._new("ϲ");
		_g.h[key] = 1010;
	}
	{
		var key = texter_general_Char._new("ϳ");
		_g.h[key] = 1011;
	}
	{
		var key = texter_general_Char._new("ϴ");
		_g.h[key] = 1012;
	}
	{
		var key = texter_general_Char._new("ϵ");
		_g.h[key] = 1013;
	}
	{
		var key = texter_general_Char._new("϶");
		_g.h[key] = 1014;
	}
	{
		var key = texter_general_Char._new("Ϸ");
		_g.h[key] = 1015;
	}
	{
		var key = texter_general_Char._new("ϸ");
		_g.h[key] = 1016;
	}
	{
		var key = texter_general_Char._new("Ϲ");
		_g.h[key] = 1017;
	}
	{
		var key = texter_general_Char._new("Ϻ");
		_g.h[key] = 1018;
	}
	{
		var key = texter_general_Char._new("ϻ");
		_g.h[key] = 1019;
	}
	{
		var key = texter_general_Char._new("ϼ");
		_g.h[key] = 1020;
	}
	{
		var key = texter_general_Char._new("Ͻ");
		_g.h[key] = 1021;
	}
	{
		var key = texter_general_Char._new("Ͼ");
		_g.h[key] = 1022;
	}
	{
		var key = texter_general_Char._new("Ͽ");
		_g.h[key] = 1023;
	}
	{
		var key = texter_general_Char._new("Ѐ");
		_g.h[key] = 1024;
	}
	{
		var key = texter_general_Char._new("Ё");
		_g.h[key] = 1025;
	}
	{
		var key = texter_general_Char._new("Ђ");
		_g.h[key] = 1026;
	}
	{
		var key = texter_general_Char._new("Ѓ");
		_g.h[key] = 1027;
	}
	{
		var key = texter_general_Char._new("Є");
		_g.h[key] = 1028;
	}
	{
		var key = texter_general_Char._new("Ѕ");
		_g.h[key] = 1029;
	}
	{
		var key = texter_general_Char._new("І");
		_g.h[key] = 1030;
	}
	{
		var key = texter_general_Char._new("Ї");
		_g.h[key] = 1031;
	}
	{
		var key = texter_general_Char._new("Ј");
		_g.h[key] = 1032;
	}
	{
		var key = texter_general_Char._new("Љ");
		_g.h[key] = 1033;
	}
	{
		var key = texter_general_Char._new("Њ");
		_g.h[key] = 1034;
	}
	{
		var key = texter_general_Char._new("Ћ");
		_g.h[key] = 1035;
	}
	{
		var key = texter_general_Char._new("Ќ");
		_g.h[key] = 1036;
	}
	{
		var key = texter_general_Char._new("Ѝ");
		_g.h[key] = 1037;
	}
	{
		var key = texter_general_Char._new("Ў");
		_g.h[key] = 1038;
	}
	{
		var key = texter_general_Char._new("Џ");
		_g.h[key] = 1039;
	}
	{
		var key = texter_general_Char._new("А");
		_g.h[key] = 1040;
	}
	{
		var key = texter_general_Char._new("Б");
		_g.h[key] = 1041;
	}
	{
		var key = texter_general_Char._new("В");
		_g.h[key] = 1042;
	}
	{
		var key = texter_general_Char._new("Г");
		_g.h[key] = 1043;
	}
	{
		var key = texter_general_Char._new("Д");
		_g.h[key] = 1044;
	}
	{
		var key = texter_general_Char._new("Е");
		_g.h[key] = 1045;
	}
	{
		var key = texter_general_Char._new("Ж");
		_g.h[key] = 1046;
	}
	{
		var key = texter_general_Char._new("З");
		_g.h[key] = 1047;
	}
	{
		var key = texter_general_Char._new("И");
		_g.h[key] = 1048;
	}
	{
		var key = texter_general_Char._new("Й");
		_g.h[key] = 1049;
	}
	{
		var key = texter_general_Char._new("К");
		_g.h[key] = 1050;
	}
	{
		var key = texter_general_Char._new("Л");
		_g.h[key] = 1051;
	}
	{
		var key = texter_general_Char._new("М");
		_g.h[key] = 1052;
	}
	{
		var key = texter_general_Char._new("Н");
		_g.h[key] = 1053;
	}
	{
		var key = texter_general_Char._new("О");
		_g.h[key] = 1054;
	}
	{
		var key = texter_general_Char._new("П");
		_g.h[key] = 1055;
	}
	{
		var key = texter_general_Char._new("Р");
		_g.h[key] = 1056;
	}
	{
		var key = texter_general_Char._new("С");
		_g.h[key] = 1057;
	}
	{
		var key = texter_general_Char._new("Т");
		_g.h[key] = 1058;
	}
	{
		var key = texter_general_Char._new("У");
		_g.h[key] = 1059;
	}
	{
		var key = texter_general_Char._new("Ф");
		_g.h[key] = 1060;
	}
	{
		var key = texter_general_Char._new("Х");
		_g.h[key] = 1061;
	}
	{
		var key = texter_general_Char._new("Ц");
		_g.h[key] = 1062;
	}
	{
		var key = texter_general_Char._new("Ч");
		_g.h[key] = 1063;
	}
	{
		var key = texter_general_Char._new("Ш");
		_g.h[key] = 1064;
	}
	{
		var key = texter_general_Char._new("Щ");
		_g.h[key] = 1065;
	}
	{
		var key = texter_general_Char._new("Ъ");
		_g.h[key] = 1066;
	}
	{
		var key = texter_general_Char._new("Ы");
		_g.h[key] = 1067;
	}
	{
		var key = texter_general_Char._new("Ь");
		_g.h[key] = 1068;
	}
	{
		var key = texter_general_Char._new("Э");
		_g.h[key] = 1069;
	}
	{
		var key = texter_general_Char._new("Ю");
		_g.h[key] = 1070;
	}
	{
		var key = texter_general_Char._new("Я");
		_g.h[key] = 1071;
	}
	{
		var key = texter_general_Char._new("а");
		_g.h[key] = 1072;
	}
	{
		var key = texter_general_Char._new("б");
		_g.h[key] = 1073;
	}
	{
		var key = texter_general_Char._new("в");
		_g.h[key] = 1074;
	}
	{
		var key = texter_general_Char._new("г");
		_g.h[key] = 1075;
	}
	{
		var key = texter_general_Char._new("д");
		_g.h[key] = 1076;
	}
	{
		var key = texter_general_Char._new("е");
		_g.h[key] = 1077;
	}
	{
		var key = texter_general_Char._new("ж");
		_g.h[key] = 1078;
	}
	{
		var key = texter_general_Char._new("з");
		_g.h[key] = 1079;
	}
	{
		var key = texter_general_Char._new("и");
		_g.h[key] = 1080;
	}
	{
		var key = texter_general_Char._new("й");
		_g.h[key] = 1081;
	}
	{
		var key = texter_general_Char._new("к");
		_g.h[key] = 1082;
	}
	{
		var key = texter_general_Char._new("л");
		_g.h[key] = 1083;
	}
	{
		var key = texter_general_Char._new("м");
		_g.h[key] = 1084;
	}
	{
		var key = texter_general_Char._new("н");
		_g.h[key] = 1085;
	}
	{
		var key = texter_general_Char._new("о");
		_g.h[key] = 1086;
	}
	{
		var key = texter_general_Char._new("п");
		_g.h[key] = 1087;
	}
	{
		var key = texter_general_Char._new("р");
		_g.h[key] = 1088;
	}
	{
		var key = texter_general_Char._new("с");
		_g.h[key] = 1089;
	}
	{
		var key = texter_general_Char._new("т");
		_g.h[key] = 1090;
	}
	{
		var key = texter_general_Char._new("у");
		_g.h[key] = 1091;
	}
	{
		var key = texter_general_Char._new("ф");
		_g.h[key] = 1092;
	}
	{
		var key = texter_general_Char._new("х");
		_g.h[key] = 1093;
	}
	{
		var key = texter_general_Char._new("ц");
		_g.h[key] = 1094;
	}
	{
		var key = texter_general_Char._new("ч");
		_g.h[key] = 1095;
	}
	{
		var key = texter_general_Char._new("ш");
		_g.h[key] = 1096;
	}
	{
		var key = texter_general_Char._new("щ");
		_g.h[key] = 1097;
	}
	{
		var key = texter_general_Char._new("ъ");
		_g.h[key] = 1098;
	}
	{
		var key = texter_general_Char._new("ы");
		_g.h[key] = 1099;
	}
	{
		var key = texter_general_Char._new("ь");
		_g.h[key] = 1100;
	}
	{
		var key = texter_general_Char._new("э");
		_g.h[key] = 1101;
	}
	{
		var key = texter_general_Char._new("ю");
		_g.h[key] = 1102;
	}
	{
		var key = texter_general_Char._new("я");
		_g.h[key] = 1103;
	}
	{
		var key = texter_general_Char._new("ѐ");
		_g.h[key] = 1104;
	}
	{
		var key = texter_general_Char._new("ё");
		_g.h[key] = 1105;
	}
	{
		var key = texter_general_Char._new("ђ");
		_g.h[key] = 1106;
	}
	{
		var key = texter_general_Char._new("ѓ");
		_g.h[key] = 1107;
	}
	{
		var key = texter_general_Char._new("є");
		_g.h[key] = 1108;
	}
	{
		var key = texter_general_Char._new("ѕ");
		_g.h[key] = 1109;
	}
	{
		var key = texter_general_Char._new("і");
		_g.h[key] = 1110;
	}
	{
		var key = texter_general_Char._new("ї");
		_g.h[key] = 1111;
	}
	{
		var key = texter_general_Char._new("ј");
		_g.h[key] = 1112;
	}
	{
		var key = texter_general_Char._new("љ");
		_g.h[key] = 1113;
	}
	{
		var key = texter_general_Char._new("њ");
		_g.h[key] = 1114;
	}
	{
		var key = texter_general_Char._new("ћ");
		_g.h[key] = 1115;
	}
	{
		var key = texter_general_Char._new("ќ");
		_g.h[key] = 1116;
	}
	{
		var key = texter_general_Char._new("ѝ");
		_g.h[key] = 1117;
	}
	{
		var key = texter_general_Char._new("ў");
		_g.h[key] = 1118;
	}
	{
		var key = texter_general_Char._new("џ");
		_g.h[key] = 1119;
	}
	{
		var key = texter_general_Char._new("Ѡ");
		_g.h[key] = 1120;
	}
	{
		var key = texter_general_Char._new("ѡ");
		_g.h[key] = 1121;
	}
	{
		var key = texter_general_Char._new("Ѣ");
		_g.h[key] = 1122;
	}
	{
		var key = texter_general_Char._new("ѣ");
		_g.h[key] = 1123;
	}
	{
		var key = texter_general_Char._new("Ѥ");
		_g.h[key] = 1124;
	}
	{
		var key = texter_general_Char._new("ѥ");
		_g.h[key] = 1125;
	}
	{
		var key = texter_general_Char._new("Ѧ");
		_g.h[key] = 1126;
	}
	{
		var key = texter_general_Char._new("ѧ");
		_g.h[key] = 1127;
	}
	{
		var key = texter_general_Char._new("Ѩ");
		_g.h[key] = 1128;
	}
	{
		var key = texter_general_Char._new("ѩ");
		_g.h[key] = 1129;
	}
	{
		var key = texter_general_Char._new("Ѫ");
		_g.h[key] = 1130;
	}
	{
		var key = texter_general_Char._new("ѫ");
		_g.h[key] = 1131;
	}
	{
		var key = texter_general_Char._new("Ѭ");
		_g.h[key] = 1132;
	}
	{
		var key = texter_general_Char._new("ѭ");
		_g.h[key] = 1133;
	}
	{
		var key = texter_general_Char._new("Ѯ");
		_g.h[key] = 1134;
	}
	{
		var key = texter_general_Char._new("ѯ");
		_g.h[key] = 1135;
	}
	{
		var key = texter_general_Char._new("Ѱ");
		_g.h[key] = 1136;
	}
	{
		var key = texter_general_Char._new("ѱ");
		_g.h[key] = 1137;
	}
	{
		var key = texter_general_Char._new("Ѳ");
		_g.h[key] = 1138;
	}
	{
		var key = texter_general_Char._new("ѳ");
		_g.h[key] = 1139;
	}
	{
		var key = texter_general_Char._new("Ѵ");
		_g.h[key] = 1140;
	}
	{
		var key = texter_general_Char._new("ѵ");
		_g.h[key] = 1141;
	}
	{
		var key = texter_general_Char._new("Ѷ");
		_g.h[key] = 1142;
	}
	{
		var key = texter_general_Char._new("ѷ");
		_g.h[key] = 1143;
	}
	{
		var key = texter_general_Char._new("Ѹ");
		_g.h[key] = 1144;
	}
	{
		var key = texter_general_Char._new("ѹ");
		_g.h[key] = 1145;
	}
	{
		var key = texter_general_Char._new("Ѻ");
		_g.h[key] = 1146;
	}
	{
		var key = texter_general_Char._new("ѻ");
		_g.h[key] = 1147;
	}
	{
		var key = texter_general_Char._new("Ѽ");
		_g.h[key] = 1148;
	}
	{
		var key = texter_general_Char._new("ѽ");
		_g.h[key] = 1149;
	}
	{
		var key = texter_general_Char._new("Ѿ");
		_g.h[key] = 1150;
	}
	{
		var key = texter_general_Char._new("ѿ");
		_g.h[key] = 1151;
	}
	{
		var key = texter_general_Char._new("Ҁ");
		_g.h[key] = 1152;
	}
	{
		var key = texter_general_Char._new("ҁ");
		_g.h[key] = 1153;
	}
	{
		var key = texter_general_Char._new("҂");
		_g.h[key] = 1154;
	}
	{
		var key = texter_general_Char._new("҃");
		_g.h[key] = 1155;
	}
	{
		var key = texter_general_Char._new("҄");
		_g.h[key] = 1156;
	}
	{
		var key = texter_general_Char._new("҅");
		_g.h[key] = 1157;
	}
	{
		var key = texter_general_Char._new("҆");
		_g.h[key] = 1158;
	}
	{
		var key = texter_general_Char._new("҇");
		_g.h[key] = 1159;
	}
	{
		var key = texter_general_Char._new("҈");
		_g.h[key] = 1160;
	}
	{
		var key = texter_general_Char._new("҉");
		_g.h[key] = 1161;
	}
	{
		var key = texter_general_Char._new("Ҋ");
		_g.h[key] = 1162;
	}
	{
		var key = texter_general_Char._new("ҋ");
		_g.h[key] = 1163;
	}
	{
		var key = texter_general_Char._new("Ҍ");
		_g.h[key] = 1164;
	}
	{
		var key = texter_general_Char._new("ҍ");
		_g.h[key] = 1165;
	}
	{
		var key = texter_general_Char._new("Ҏ");
		_g.h[key] = 1166;
	}
	{
		var key = texter_general_Char._new("ҏ");
		_g.h[key] = 1167;
	}
	{
		var key = texter_general_Char._new("Ґ");
		_g.h[key] = 1168;
	}
	{
		var key = texter_general_Char._new("ґ");
		_g.h[key] = 1169;
	}
	{
		var key = texter_general_Char._new("Ғ");
		_g.h[key] = 1170;
	}
	{
		var key = texter_general_Char._new("ғ");
		_g.h[key] = 1171;
	}
	{
		var key = texter_general_Char._new("Ҕ");
		_g.h[key] = 1172;
	}
	{
		var key = texter_general_Char._new("ҕ");
		_g.h[key] = 1173;
	}
	{
		var key = texter_general_Char._new("Җ");
		_g.h[key] = 1174;
	}
	{
		var key = texter_general_Char._new("җ");
		_g.h[key] = 1175;
	}
	{
		var key = texter_general_Char._new("Ҙ");
		_g.h[key] = 1176;
	}
	{
		var key = texter_general_Char._new("ҙ");
		_g.h[key] = 1177;
	}
	{
		var key = texter_general_Char._new("Қ");
		_g.h[key] = 1178;
	}
	{
		var key = texter_general_Char._new("қ");
		_g.h[key] = 1179;
	}
	{
		var key = texter_general_Char._new("Ҝ");
		_g.h[key] = 1180;
	}
	{
		var key = texter_general_Char._new("ҝ");
		_g.h[key] = 1181;
	}
	{
		var key = texter_general_Char._new("Ҟ");
		_g.h[key] = 1182;
	}
	{
		var key = texter_general_Char._new("ҟ");
		_g.h[key] = 1183;
	}
	{
		var key = texter_general_Char._new("Ҡ");
		_g.h[key] = 1184;
	}
	{
		var key = texter_general_Char._new("ҡ");
		_g.h[key] = 1185;
	}
	{
		var key = texter_general_Char._new("Ң");
		_g.h[key] = 1186;
	}
	{
		var key = texter_general_Char._new("ң");
		_g.h[key] = 1187;
	}
	{
		var key = texter_general_Char._new("Ҥ");
		_g.h[key] = 1188;
	}
	{
		var key = texter_general_Char._new("ҥ");
		_g.h[key] = 1189;
	}
	{
		var key = texter_general_Char._new("Ҧ");
		_g.h[key] = 1190;
	}
	{
		var key = texter_general_Char._new("ҧ");
		_g.h[key] = 1191;
	}
	{
		var key = texter_general_Char._new("Ҩ");
		_g.h[key] = 1192;
	}
	{
		var key = texter_general_Char._new("ҩ");
		_g.h[key] = 1193;
	}
	{
		var key = texter_general_Char._new("Ҫ");
		_g.h[key] = 1194;
	}
	{
		var key = texter_general_Char._new("ҫ");
		_g.h[key] = 1195;
	}
	{
		var key = texter_general_Char._new("Ҭ");
		_g.h[key] = 1196;
	}
	{
		var key = texter_general_Char._new("ҭ");
		_g.h[key] = 1197;
	}
	{
		var key = texter_general_Char._new("Ү");
		_g.h[key] = 1198;
	}
	{
		var key = texter_general_Char._new("ү");
		_g.h[key] = 1199;
	}
	{
		var key = texter_general_Char._new("Ұ");
		_g.h[key] = 1200;
	}
	{
		var key = texter_general_Char._new("ұ");
		_g.h[key] = 1201;
	}
	{
		var key = texter_general_Char._new("Ҳ");
		_g.h[key] = 1202;
	}
	{
		var key = texter_general_Char._new("ҳ");
		_g.h[key] = 1203;
	}
	{
		var key = texter_general_Char._new("Ҵ");
		_g.h[key] = 1204;
	}
	{
		var key = texter_general_Char._new("ҵ");
		_g.h[key] = 1205;
	}
	{
		var key = texter_general_Char._new("Ҷ");
		_g.h[key] = 1206;
	}
	{
		var key = texter_general_Char._new("ҷ");
		_g.h[key] = 1207;
	}
	{
		var key = texter_general_Char._new("Ҹ");
		_g.h[key] = 1208;
	}
	{
		var key = texter_general_Char._new("ҹ");
		_g.h[key] = 1209;
	}
	{
		var key = texter_general_Char._new("Һ");
		_g.h[key] = 1210;
	}
	{
		var key = texter_general_Char._new("һ");
		_g.h[key] = 1211;
	}
	{
		var key = texter_general_Char._new("Ҽ");
		_g.h[key] = 1212;
	}
	{
		var key = texter_general_Char._new("ҽ");
		_g.h[key] = 1213;
	}
	{
		var key = texter_general_Char._new("Ҿ");
		_g.h[key] = 1214;
	}
	{
		var key = texter_general_Char._new("ҿ");
		_g.h[key] = 1215;
	}
	{
		var key = texter_general_Char._new("Ӏ");
		_g.h[key] = 1216;
	}
	{
		var key = texter_general_Char._new("Ӂ");
		_g.h[key] = 1217;
	}
	{
		var key = texter_general_Char._new("ӂ");
		_g.h[key] = 1218;
	}
	{
		var key = texter_general_Char._new("Ӄ");
		_g.h[key] = 1219;
	}
	{
		var key = texter_general_Char._new("ӄ");
		_g.h[key] = 1220;
	}
	{
		var key = texter_general_Char._new("Ӆ");
		_g.h[key] = 1221;
	}
	{
		var key = texter_general_Char._new("ӆ");
		_g.h[key] = 1222;
	}
	{
		var key = texter_general_Char._new("Ӈ");
		_g.h[key] = 1223;
	}
	{
		var key = texter_general_Char._new("ӈ");
		_g.h[key] = 1224;
	}
	{
		var key = texter_general_Char._new("Ӊ");
		_g.h[key] = 1225;
	}
	{
		var key = texter_general_Char._new("ӊ");
		_g.h[key] = 1226;
	}
	{
		var key = texter_general_Char._new("Ӌ");
		_g.h[key] = 1227;
	}
	{
		var key = texter_general_Char._new("ӌ");
		_g.h[key] = 1228;
	}
	{
		var key = texter_general_Char._new("Ӎ");
		_g.h[key] = 1229;
	}
	{
		var key = texter_general_Char._new("ӎ");
		_g.h[key] = 1230;
	}
	{
		var key = texter_general_Char._new("ӏ");
		_g.h[key] = 1231;
	}
	{
		var key = texter_general_Char._new("Ӑ");
		_g.h[key] = 1232;
	}
	{
		var key = texter_general_Char._new("ӑ");
		_g.h[key] = 1233;
	}
	{
		var key = texter_general_Char._new("Ӓ");
		_g.h[key] = 1234;
	}
	{
		var key = texter_general_Char._new("ӓ");
		_g.h[key] = 1235;
	}
	{
		var key = texter_general_Char._new("Ӕ");
		_g.h[key] = 1236;
	}
	{
		var key = texter_general_Char._new("ӕ");
		_g.h[key] = 1237;
	}
	{
		var key = texter_general_Char._new("Ӗ");
		_g.h[key] = 1238;
	}
	{
		var key = texter_general_Char._new("ӗ");
		_g.h[key] = 1239;
	}
	{
		var key = texter_general_Char._new("Ә");
		_g.h[key] = 1240;
	}
	{
		var key = texter_general_Char._new("ә");
		_g.h[key] = 1241;
	}
	{
		var key = texter_general_Char._new("Ӛ");
		_g.h[key] = 1242;
	}
	{
		var key = texter_general_Char._new("ӛ");
		_g.h[key] = 1243;
	}
	{
		var key = texter_general_Char._new("Ӝ");
		_g.h[key] = 1244;
	}
	{
		var key = texter_general_Char._new("ӝ");
		_g.h[key] = 1245;
	}
	{
		var key = texter_general_Char._new("Ӟ");
		_g.h[key] = 1246;
	}
	{
		var key = texter_general_Char._new("ӟ");
		_g.h[key] = 1247;
	}
	{
		var key = texter_general_Char._new("Ӡ");
		_g.h[key] = 1248;
	}
	{
		var key = texter_general_Char._new("ӡ");
		_g.h[key] = 1249;
	}
	{
		var key = texter_general_Char._new("Ӣ");
		_g.h[key] = 1250;
	}
	{
		var key = texter_general_Char._new("ӣ");
		_g.h[key] = 1251;
	}
	{
		var key = texter_general_Char._new("Ӥ");
		_g.h[key] = 1252;
	}
	{
		var key = texter_general_Char._new("ӥ");
		_g.h[key] = 1253;
	}
	{
		var key = texter_general_Char._new("Ӧ");
		_g.h[key] = 1254;
	}
	{
		var key = texter_general_Char._new("ӧ");
		_g.h[key] = 1255;
	}
	{
		var key = texter_general_Char._new("Ө");
		_g.h[key] = 1256;
	}
	{
		var key = texter_general_Char._new("ө");
		_g.h[key] = 1257;
	}
	{
		var key = texter_general_Char._new("Ӫ");
		_g.h[key] = 1258;
	}
	{
		var key = texter_general_Char._new("ӫ");
		_g.h[key] = 1259;
	}
	{
		var key = texter_general_Char._new("Ӭ");
		_g.h[key] = 1260;
	}
	{
		var key = texter_general_Char._new("ӭ");
		_g.h[key] = 1261;
	}
	{
		var key = texter_general_Char._new("Ӯ");
		_g.h[key] = 1262;
	}
	{
		var key = texter_general_Char._new("ӯ");
		_g.h[key] = 1263;
	}
	{
		var key = texter_general_Char._new("Ӱ");
		_g.h[key] = 1264;
	}
	{
		var key = texter_general_Char._new("ӱ");
		_g.h[key] = 1265;
	}
	{
		var key = texter_general_Char._new("Ӳ");
		_g.h[key] = 1266;
	}
	{
		var key = texter_general_Char._new("ӳ");
		_g.h[key] = 1267;
	}
	{
		var key = texter_general_Char._new("Ӵ");
		_g.h[key] = 1268;
	}
	{
		var key = texter_general_Char._new("ӵ");
		_g.h[key] = 1269;
	}
	{
		var key = texter_general_Char._new("Ӷ");
		_g.h[key] = 1270;
	}
	{
		var key = texter_general_Char._new("ӷ");
		_g.h[key] = 1271;
	}
	{
		var key = texter_general_Char._new("Ӹ");
		_g.h[key] = 1272;
	}
	{
		var key = texter_general_Char._new("ӹ");
		_g.h[key] = 1273;
	}
	{
		var key = texter_general_Char._new("Ӻ");
		_g.h[key] = 1274;
	}
	{
		var key = texter_general_Char._new("ӻ");
		_g.h[key] = 1275;
	}
	{
		var key = texter_general_Char._new("Ӽ");
		_g.h[key] = 1276;
	}
	{
		var key = texter_general_Char._new("ӽ");
		_g.h[key] = 1277;
	}
	{
		var key = texter_general_Char._new("Ӿ");
		_g.h[key] = 1278;
	}
	{
		var key = texter_general_Char._new("ӿ");
		_g.h[key] = 1279;
	}
	{
		var key = texter_general_Char._new("Ԁ");
		_g.h[key] = 1280;
	}
	{
		var key = texter_general_Char._new("ԁ");
		_g.h[key] = 1281;
	}
	{
		var key = texter_general_Char._new("Ԃ");
		_g.h[key] = 1282;
	}
	{
		var key = texter_general_Char._new("ԃ");
		_g.h[key] = 1283;
	}
	{
		var key = texter_general_Char._new("Ԅ");
		_g.h[key] = 1284;
	}
	{
		var key = texter_general_Char._new("ԅ");
		_g.h[key] = 1285;
	}
	{
		var key = texter_general_Char._new("Ԇ");
		_g.h[key] = 1286;
	}
	{
		var key = texter_general_Char._new("ԇ");
		_g.h[key] = 1287;
	}
	{
		var key = texter_general_Char._new("Ԉ");
		_g.h[key] = 1288;
	}
	{
		var key = texter_general_Char._new("ԉ");
		_g.h[key] = 1289;
	}
	{
		var key = texter_general_Char._new("Ԋ");
		_g.h[key] = 1290;
	}
	{
		var key = texter_general_Char._new("ԋ");
		_g.h[key] = 1291;
	}
	{
		var key = texter_general_Char._new("Ԍ");
		_g.h[key] = 1292;
	}
	{
		var key = texter_general_Char._new("ԍ");
		_g.h[key] = 1293;
	}
	{
		var key = texter_general_Char._new("Ԏ");
		_g.h[key] = 1294;
	}
	{
		var key = texter_general_Char._new("ԏ");
		_g.h[key] = 1295;
	}
	{
		var key = texter_general_Char._new("Ԑ");
		_g.h[key] = 1296;
	}
	{
		var key = texter_general_Char._new("ԑ");
		_g.h[key] = 1297;
	}
	{
		var key = texter_general_Char._new("Ԓ");
		_g.h[key] = 1298;
	}
	{
		var key = texter_general_Char._new("ԓ");
		_g.h[key] = 1299;
	}
	{
		var key = texter_general_Char._new("Ԕ");
		_g.h[key] = 1300;
	}
	{
		var key = texter_general_Char._new("ԕ");
		_g.h[key] = 1301;
	}
	{
		var key = texter_general_Char._new("Ԗ");
		_g.h[key] = 1302;
	}
	{
		var key = texter_general_Char._new("ԗ");
		_g.h[key] = 1303;
	}
	{
		var key = texter_general_Char._new("Ԙ");
		_g.h[key] = 1304;
	}
	{
		var key = texter_general_Char._new("ԙ");
		_g.h[key] = 1305;
	}
	{
		var key = texter_general_Char._new("Ԛ");
		_g.h[key] = 1306;
	}
	{
		var key = texter_general_Char._new("ԛ");
		_g.h[key] = 1307;
	}
	{
		var key = texter_general_Char._new("Ԝ");
		_g.h[key] = 1308;
	}
	{
		var key = texter_general_Char._new("ԝ");
		_g.h[key] = 1309;
	}
	{
		var key = texter_general_Char._new("Ԟ");
		_g.h[key] = 1310;
	}
	{
		var key = texter_general_Char._new("ԟ");
		_g.h[key] = 1311;
	}
	{
		var key = texter_general_Char._new("Ԡ");
		_g.h[key] = 1312;
	}
	{
		var key = texter_general_Char._new("ԡ");
		_g.h[key] = 1313;
	}
	{
		var key = texter_general_Char._new("Ԣ");
		_g.h[key] = 1314;
	}
	{
		var key = texter_general_Char._new("ԣ");
		_g.h[key] = 1315;
	}
	{
		var key = texter_general_Char._new("Ԥ");
		_g.h[key] = 1316;
	}
	{
		var key = texter_general_Char._new("ԥ");
		_g.h[key] = 1317;
	}
	{
		var key = texter_general_Char._new("Ԧ");
		_g.h[key] = 1318;
	}
	{
		var key = texter_general_Char._new("ԧ");
		_g.h[key] = 1319;
	}
	{
		var key = texter_general_Char._new("Ԩ");
		_g.h[key] = 1320;
	}
	{
		var key = texter_general_Char._new("ԩ");
		_g.h[key] = 1321;
	}
	{
		var key = texter_general_Char._new("Ԫ");
		_g.h[key] = 1322;
	}
	{
		var key = texter_general_Char._new("ԫ");
		_g.h[key] = 1323;
	}
	{
		var key = texter_general_Char._new("Ԭ");
		_g.h[key] = 1324;
	}
	{
		var key = texter_general_Char._new("ԭ");
		_g.h[key] = 1325;
	}
	{
		var key = texter_general_Char._new("Ԯ");
		_g.h[key] = 1326;
	}
	{
		var key = texter_general_Char._new("ԯ");
		_g.h[key] = 1327;
	}
	{
		var key = texter_general_Char._new("԰");
		_g.h[key] = 1328;
	}
	{
		var key = texter_general_Char._new("Ա");
		_g.h[key] = 1329;
	}
	{
		var key = texter_general_Char._new("Բ");
		_g.h[key] = 1330;
	}
	{
		var key = texter_general_Char._new("Գ");
		_g.h[key] = 1331;
	}
	{
		var key = texter_general_Char._new("Դ");
		_g.h[key] = 1332;
	}
	{
		var key = texter_general_Char._new("Ե");
		_g.h[key] = 1333;
	}
	{
		var key = texter_general_Char._new("Զ");
		_g.h[key] = 1334;
	}
	{
		var key = texter_general_Char._new("Է");
		_g.h[key] = 1335;
	}
	{
		var key = texter_general_Char._new("Ը");
		_g.h[key] = 1336;
	}
	{
		var key = texter_general_Char._new("Թ");
		_g.h[key] = 1337;
	}
	{
		var key = texter_general_Char._new("Ժ");
		_g.h[key] = 1338;
	}
	{
		var key = texter_general_Char._new("Ի");
		_g.h[key] = 1339;
	}
	{
		var key = texter_general_Char._new("Լ");
		_g.h[key] = 1340;
	}
	{
		var key = texter_general_Char._new("Խ");
		_g.h[key] = 1341;
	}
	{
		var key = texter_general_Char._new("Ծ");
		_g.h[key] = 1342;
	}
	{
		var key = texter_general_Char._new("Կ");
		_g.h[key] = 1343;
	}
	{
		var key = texter_general_Char._new("Հ");
		_g.h[key] = 1344;
	}
	{
		var key = texter_general_Char._new("Ձ");
		_g.h[key] = 1345;
	}
	{
		var key = texter_general_Char._new("Ղ");
		_g.h[key] = 1346;
	}
	{
		var key = texter_general_Char._new("Ճ");
		_g.h[key] = 1347;
	}
	{
		var key = texter_general_Char._new("Մ");
		_g.h[key] = 1348;
	}
	{
		var key = texter_general_Char._new("Յ");
		_g.h[key] = 1349;
	}
	{
		var key = texter_general_Char._new("Ն");
		_g.h[key] = 1350;
	}
	{
		var key = texter_general_Char._new("Շ");
		_g.h[key] = 1351;
	}
	{
		var key = texter_general_Char._new("Ո");
		_g.h[key] = 1352;
	}
	{
		var key = texter_general_Char._new("Չ");
		_g.h[key] = 1353;
	}
	{
		var key = texter_general_Char._new("Պ");
		_g.h[key] = 1354;
	}
	{
		var key = texter_general_Char._new("Ջ");
		_g.h[key] = 1355;
	}
	{
		var key = texter_general_Char._new("Ռ");
		_g.h[key] = 1356;
	}
	{
		var key = texter_general_Char._new("Ս");
		_g.h[key] = 1357;
	}
	{
		var key = texter_general_Char._new("Վ");
		_g.h[key] = 1358;
	}
	{
		var key = texter_general_Char._new("Տ");
		_g.h[key] = 1359;
	}
	{
		var key = texter_general_Char._new("Ր");
		_g.h[key] = 1360;
	}
	{
		var key = texter_general_Char._new("Ց");
		_g.h[key] = 1361;
	}
	{
		var key = texter_general_Char._new("Ւ");
		_g.h[key] = 1362;
	}
	{
		var key = texter_general_Char._new("Փ");
		_g.h[key] = 1363;
	}
	{
		var key = texter_general_Char._new("Ք");
		_g.h[key] = 1364;
	}
	{
		var key = texter_general_Char._new("Օ");
		_g.h[key] = 1365;
	}
	{
		var key = texter_general_Char._new("Ֆ");
		_g.h[key] = 1366;
	}
	{
		var key = texter_general_Char._new("՗");
		_g.h[key] = 1367;
	}
	{
		var key = texter_general_Char._new("՘");
		_g.h[key] = 1368;
	}
	{
		var key = texter_general_Char._new("ՙ");
		_g.h[key] = 1369;
	}
	{
		var key = texter_general_Char._new("՚");
		_g.h[key] = 1370;
	}
	{
		var key = texter_general_Char._new("՛");
		_g.h[key] = 1371;
	}
	{
		var key = texter_general_Char._new("՜");
		_g.h[key] = 1372;
	}
	{
		var key = texter_general_Char._new("՝");
		_g.h[key] = 1373;
	}
	{
		var key = texter_general_Char._new("՞");
		_g.h[key] = 1374;
	}
	{
		var key = texter_general_Char._new("՟");
		_g.h[key] = 1375;
	}
	{
		var key = texter_general_Char._new("ՠ");
		_g.h[key] = 1376;
	}
	{
		var key = texter_general_Char._new("ա");
		_g.h[key] = 1377;
	}
	{
		var key = texter_general_Char._new("բ");
		_g.h[key] = 1378;
	}
	{
		var key = texter_general_Char._new("գ");
		_g.h[key] = 1379;
	}
	{
		var key = texter_general_Char._new("դ");
		_g.h[key] = 1380;
	}
	{
		var key = texter_general_Char._new("ե");
		_g.h[key] = 1381;
	}
	{
		var key = texter_general_Char._new("զ");
		_g.h[key] = 1382;
	}
	{
		var key = texter_general_Char._new("է");
		_g.h[key] = 1383;
	}
	{
		var key = texter_general_Char._new("ը");
		_g.h[key] = 1384;
	}
	{
		var key = texter_general_Char._new("թ");
		_g.h[key] = 1385;
	}
	{
		var key = texter_general_Char._new("ժ");
		_g.h[key] = 1386;
	}
	{
		var key = texter_general_Char._new("ի");
		_g.h[key] = 1387;
	}
	{
		var key = texter_general_Char._new("լ");
		_g.h[key] = 1388;
	}
	{
		var key = texter_general_Char._new("խ");
		_g.h[key] = 1389;
	}
	{
		var key = texter_general_Char._new("ծ");
		_g.h[key] = 1390;
	}
	{
		var key = texter_general_Char._new("կ");
		_g.h[key] = 1391;
	}
	{
		var key = texter_general_Char._new("հ");
		_g.h[key] = 1392;
	}
	{
		var key = texter_general_Char._new("ձ");
		_g.h[key] = 1393;
	}
	{
		var key = texter_general_Char._new("ղ");
		_g.h[key] = 1394;
	}
	{
		var key = texter_general_Char._new("ճ");
		_g.h[key] = 1395;
	}
	{
		var key = texter_general_Char._new("մ");
		_g.h[key] = 1396;
	}
	{
		var key = texter_general_Char._new("յ");
		_g.h[key] = 1397;
	}
	{
		var key = texter_general_Char._new("ն");
		_g.h[key] = 1398;
	}
	{
		var key = texter_general_Char._new("շ");
		_g.h[key] = 1399;
	}
	{
		var key = texter_general_Char._new("ո");
		_g.h[key] = 1400;
	}
	{
		var key = texter_general_Char._new("չ");
		_g.h[key] = 1401;
	}
	{
		var key = texter_general_Char._new("պ");
		_g.h[key] = 1402;
	}
	{
		var key = texter_general_Char._new("ջ");
		_g.h[key] = 1403;
	}
	{
		var key = texter_general_Char._new("ռ");
		_g.h[key] = 1404;
	}
	{
		var key = texter_general_Char._new("ս");
		_g.h[key] = 1405;
	}
	{
		var key = texter_general_Char._new("վ");
		_g.h[key] = 1406;
	}
	{
		var key = texter_general_Char._new("տ");
		_g.h[key] = 1407;
	}
	{
		var key = texter_general_Char._new("ր");
		_g.h[key] = 1408;
	}
	{
		var key = texter_general_Char._new("ց");
		_g.h[key] = 1409;
	}
	{
		var key = texter_general_Char._new("ւ");
		_g.h[key] = 1410;
	}
	{
		var key = texter_general_Char._new("փ");
		_g.h[key] = 1411;
	}
	{
		var key = texter_general_Char._new("ք");
		_g.h[key] = 1412;
	}
	{
		var key = texter_general_Char._new("օ");
		_g.h[key] = 1413;
	}
	{
		var key = texter_general_Char._new("ֆ");
		_g.h[key] = 1414;
	}
	{
		var key = texter_general_Char._new("և");
		_g.h[key] = 1415;
	}
	{
		var key = texter_general_Char._new("ֈ");
		_g.h[key] = 1416;
	}
	{
		var key = texter_general_Char._new("։");
		_g.h[key] = 1417;
	}
	{
		var key = texter_general_Char._new("֊");
		_g.h[key] = 1418;
	}
	{
		var key = texter_general_Char._new("֋");
		_g.h[key] = 1419;
	}
	{
		var key = texter_general_Char._new("֌");
		_g.h[key] = 1420;
	}
	{
		var key = texter_general_Char._new("֍");
		_g.h[key] = 1421;
	}
	{
		var key = texter_general_Char._new("֎");
		_g.h[key] = 1422;
	}
	{
		var key = texter_general_Char._new("֏");
		_g.h[key] = 1423;
	}
	{
		var key = texter_general_Char._new("֐");
		_g.h[key] = 1424;
	}
	{
		var key = texter_general_Char._new("֑");
		_g.h[key] = 1425;
	}
	{
		var key = texter_general_Char._new("֒");
		_g.h[key] = 1426;
	}
	{
		var key = texter_general_Char._new("֓");
		_g.h[key] = 1427;
	}
	{
		var key = texter_general_Char._new("֔");
		_g.h[key] = 1428;
	}
	{
		var key = texter_general_Char._new("֕");
		_g.h[key] = 1429;
	}
	{
		var key = texter_general_Char._new("֖");
		_g.h[key] = 1430;
	}
	{
		var key = texter_general_Char._new("֗");
		_g.h[key] = 1431;
	}
	{
		var key = texter_general_Char._new("֘");
		_g.h[key] = 1432;
	}
	{
		var key = texter_general_Char._new("֙");
		_g.h[key] = 1433;
	}
	{
		var key = texter_general_Char._new("֚");
		_g.h[key] = 1434;
	}
	{
		var key = texter_general_Char._new("֛");
		_g.h[key] = 1435;
	}
	{
		var key = texter_general_Char._new("֜");
		_g.h[key] = 1436;
	}
	{
		var key = texter_general_Char._new("֝");
		_g.h[key] = 1437;
	}
	{
		var key = texter_general_Char._new("֞");
		_g.h[key] = 1438;
	}
	{
		var key = texter_general_Char._new("֟");
		_g.h[key] = 1439;
	}
	{
		var key = texter_general_Char._new("֠");
		_g.h[key] = 1440;
	}
	{
		var key = texter_general_Char._new("֡");
		_g.h[key] = 1441;
	}
	{
		var key = texter_general_Char._new("֢");
		_g.h[key] = 1442;
	}
	{
		var key = texter_general_Char._new("֣");
		_g.h[key] = 1443;
	}
	{
		var key = texter_general_Char._new("֤");
		_g.h[key] = 1444;
	}
	{
		var key = texter_general_Char._new("֥");
		_g.h[key] = 1445;
	}
	{
		var key = texter_general_Char._new("֦");
		_g.h[key] = 1446;
	}
	{
		var key = texter_general_Char._new("֧");
		_g.h[key] = 1447;
	}
	{
		var key = texter_general_Char._new("֨");
		_g.h[key] = 1448;
	}
	{
		var key = texter_general_Char._new("֩");
		_g.h[key] = 1449;
	}
	{
		var key = texter_general_Char._new("֪");
		_g.h[key] = 1450;
	}
	{
		var key = texter_general_Char._new("֫");
		_g.h[key] = 1451;
	}
	{
		var key = texter_general_Char._new("֬");
		_g.h[key] = 1452;
	}
	{
		var key = texter_general_Char._new("֭");
		_g.h[key] = 1453;
	}
	{
		var key = texter_general_Char._new("֮");
		_g.h[key] = 1454;
	}
	{
		var key = texter_general_Char._new("֯");
		_g.h[key] = 1455;
	}
	{
		var key = texter_general_Char._new("ְ");
		_g.h[key] = 1456;
	}
	{
		var key = texter_general_Char._new("ֱ");
		_g.h[key] = 1457;
	}
	{
		var key = texter_general_Char._new("ֲ");
		_g.h[key] = 1458;
	}
	{
		var key = texter_general_Char._new("ֳ");
		_g.h[key] = 1459;
	}
	{
		var key = texter_general_Char._new("ִ");
		_g.h[key] = 1460;
	}
	{
		var key = texter_general_Char._new("ֵ");
		_g.h[key] = 1461;
	}
	{
		var key = texter_general_Char._new("ֶ");
		_g.h[key] = 1462;
	}
	{
		var key = texter_general_Char._new("ַ");
		_g.h[key] = 1463;
	}
	{
		var key = texter_general_Char._new("ָ");
		_g.h[key] = 1464;
	}
	{
		var key = texter_general_Char._new("ֹ");
		_g.h[key] = 1465;
	}
	{
		var key = texter_general_Char._new("ֺ");
		_g.h[key] = 1466;
	}
	{
		var key = texter_general_Char._new("ֻ");
		_g.h[key] = 1467;
	}
	{
		var key = texter_general_Char._new("ּ");
		_g.h[key] = 1468;
	}
	{
		var key = texter_general_Char._new("ֽ");
		_g.h[key] = 1469;
	}
	{
		var key = texter_general_Char._new("־");
		_g.h[key] = 1470;
	}
	{
		var key = texter_general_Char._new("ֿ");
		_g.h[key] = 1471;
	}
	{
		var key = texter_general_Char._new("׀");
		_g.h[key] = 1472;
	}
	{
		var key = texter_general_Char._new("ׁ");
		_g.h[key] = 1473;
	}
	{
		var key = texter_general_Char._new("ׂ");
		_g.h[key] = 1474;
	}
	{
		var key = texter_general_Char._new("׃");
		_g.h[key] = 1475;
	}
	{
		var key = texter_general_Char._new("ׄ");
		_g.h[key] = 1476;
	}
	{
		var key = texter_general_Char._new("ׅ");
		_g.h[key] = 1477;
	}
	{
		var key = texter_general_Char._new("׆");
		_g.h[key] = 1478;
	}
	{
		var key = texter_general_Char._new("ׇ");
		_g.h[key] = 1479;
	}
	{
		var key = texter_general_Char._new("׈");
		_g.h[key] = 1480;
	}
	{
		var key = texter_general_Char._new("׉");
		_g.h[key] = 1481;
	}
	{
		var key = texter_general_Char._new("׊");
		_g.h[key] = 1482;
	}
	{
		var key = texter_general_Char._new("׋");
		_g.h[key] = 1483;
	}
	{
		var key = texter_general_Char._new("׌");
		_g.h[key] = 1484;
	}
	{
		var key = texter_general_Char._new("׍");
		_g.h[key] = 1485;
	}
	{
		var key = texter_general_Char._new("׎");
		_g.h[key] = 1486;
	}
	{
		var key = texter_general_Char._new("׏");
		_g.h[key] = 1487;
	}
	{
		var key = texter_general_Char._new("א");
		_g.h[key] = 1488;
	}
	{
		var key = texter_general_Char._new("ב");
		_g.h[key] = 1489;
	}
	{
		var key = texter_general_Char._new("ג");
		_g.h[key] = 1490;
	}
	{
		var key = texter_general_Char._new("ד");
		_g.h[key] = 1491;
	}
	{
		var key = texter_general_Char._new("ה");
		_g.h[key] = 1492;
	}
	{
		var key = texter_general_Char._new("ו");
		_g.h[key] = 1493;
	}
	{
		var key = texter_general_Char._new("ז");
		_g.h[key] = 1494;
	}
	{
		var key = texter_general_Char._new("ח");
		_g.h[key] = 1495;
	}
	{
		var key = texter_general_Char._new("ט");
		_g.h[key] = 1496;
	}
	{
		var key = texter_general_Char._new("י");
		_g.h[key] = 1497;
	}
	{
		var key = texter_general_Char._new("ך");
		_g.h[key] = 1498;
	}
	{
		var key = texter_general_Char._new("כ");
		_g.h[key] = 1499;
	}
	{
		var key = texter_general_Char._new("ל");
		_g.h[key] = 1500;
	}
	{
		var key = texter_general_Char._new("ם");
		_g.h[key] = 1501;
	}
	{
		var key = texter_general_Char._new("מ");
		_g.h[key] = 1502;
	}
	{
		var key = texter_general_Char._new("ן");
		_g.h[key] = 1503;
	}
	{
		var key = texter_general_Char._new("נ");
		_g.h[key] = 1504;
	}
	{
		var key = texter_general_Char._new("ס");
		_g.h[key] = 1505;
	}
	{
		var key = texter_general_Char._new("ע");
		_g.h[key] = 1506;
	}
	{
		var key = texter_general_Char._new("ף");
		_g.h[key] = 1507;
	}
	{
		var key = texter_general_Char._new("פ");
		_g.h[key] = 1508;
	}
	{
		var key = texter_general_Char._new("ץ");
		_g.h[key] = 1509;
	}
	{
		var key = texter_general_Char._new("צ");
		_g.h[key] = 1510;
	}
	{
		var key = texter_general_Char._new("ק");
		_g.h[key] = 1511;
	}
	{
		var key = texter_general_Char._new("ר");
		_g.h[key] = 1512;
	}
	{
		var key = texter_general_Char._new("ש");
		_g.h[key] = 1513;
	}
	{
		var key = texter_general_Char._new("ת");
		_g.h[key] = 1514;
	}
	{
		var key = texter_general_Char._new("׫");
		_g.h[key] = 1515;
	}
	{
		var key = texter_general_Char._new("׬");
		_g.h[key] = 1516;
	}
	{
		var key = texter_general_Char._new("׭");
		_g.h[key] = 1517;
	}
	{
		var key = texter_general_Char._new("׮");
		_g.h[key] = 1518;
	}
	{
		var key = texter_general_Char._new("ׯ");
		_g.h[key] = 1519;
	}
	{
		var key = texter_general_Char._new("װ");
		_g.h[key] = 1520;
	}
	{
		var key = texter_general_Char._new("ױ");
		_g.h[key] = 1521;
	}
	{
		var key = texter_general_Char._new("ײ");
		_g.h[key] = 1522;
	}
	{
		var key = texter_general_Char._new("׳");
		_g.h[key] = 1523;
	}
	{
		var key = texter_general_Char._new("״");
		_g.h[key] = 1524;
	}
	{
		var key = texter_general_Char._new("׵");
		_g.h[key] = 1525;
	}
	{
		var key = texter_general_Char._new("׶");
		_g.h[key] = 1526;
	}
	{
		var key = texter_general_Char._new("׷");
		_g.h[key] = 1527;
	}
	{
		var key = texter_general_Char._new("׸");
		_g.h[key] = 1528;
	}
	{
		var key = texter_general_Char._new("׹");
		_g.h[key] = 1529;
	}
	{
		var key = texter_general_Char._new("׺");
		_g.h[key] = 1530;
	}
	{
		var key = texter_general_Char._new("׻");
		_g.h[key] = 1531;
	}
	{
		var key = texter_general_Char._new("׼");
		_g.h[key] = 1532;
	}
	{
		var key = texter_general_Char._new("׽");
		_g.h[key] = 1533;
	}
	{
		var key = texter_general_Char._new("׾");
		_g.h[key] = 1534;
	}
	{
		var key = texter_general_Char._new("׿");
		_g.h[key] = 1535;
	}
	{
		var key = texter_general_Char._new("؀");
		_g.h[key] = 1536;
	}
	{
		var key = texter_general_Char._new("؁");
		_g.h[key] = 1537;
	}
	{
		var key = texter_general_Char._new("؂");
		_g.h[key] = 1538;
	}
	{
		var key = texter_general_Char._new("؃");
		_g.h[key] = 1539;
	}
	{
		var key = texter_general_Char._new("؄");
		_g.h[key] = 1540;
	}
	{
		var key = texter_general_Char._new("؅");
		_g.h[key] = 1541;
	}
	{
		var key = texter_general_Char._new("؆");
		_g.h[key] = 1542;
	}
	{
		var key = texter_general_Char._new("؇");
		_g.h[key] = 1543;
	}
	{
		var key = texter_general_Char._new("؈");
		_g.h[key] = 1544;
	}
	{
		var key = texter_general_Char._new("؉");
		_g.h[key] = 1545;
	}
	{
		var key = texter_general_Char._new("؊");
		_g.h[key] = 1546;
	}
	{
		var key = texter_general_Char._new("؋");
		_g.h[key] = 1547;
	}
	{
		var key = texter_general_Char._new("،");
		_g.h[key] = 1548;
	}
	{
		var key = texter_general_Char._new("؍");
		_g.h[key] = 1549;
	}
	$r = _g;
	return $r;
}(this));
texter_general_CharTools.charFromValue = (function($this) {
	var $r;
	var _g = new haxe_ds_IntMap();
	{
		var value = texter_general_Char._new(" ");
		_g.h[0] = value;
	}
	{
		var value = texter_general_Char._new("\x01");
		_g.h[1] = value;
	}
	{
		var value = texter_general_Char._new("\x02");
		_g.h[2] = value;
	}
	{
		var value = texter_general_Char._new("\x03");
		_g.h[3] = value;
	}
	{
		var value = texter_general_Char._new("\x04");
		_g.h[4] = value;
	}
	{
		var value = texter_general_Char._new("\x05");
		_g.h[5] = value;
	}
	{
		var value = texter_general_Char._new("\x06");
		_g.h[6] = value;
	}
	{
		var value = texter_general_Char._new("\x07");
		_g.h[7] = value;
	}
	{
		var value = texter_general_Char._new("\x08");
		_g.h[8] = value;
	}
	{
		var value = texter_general_Char._new("\t");
		_g.h[9] = value;
	}
	{
		var value = texter_general_Char._new("\r\n");
		_g.h[10] = value;
	}
	{
		var value = texter_general_Char._new("\x0B");
		_g.h[11] = value;
	}
	{
		var value = texter_general_Char._new("\x0C");
		_g.h[12] = value;
	}
	{
		var value = texter_general_Char._new("\r\n");
		_g.h[13] = value;
	}
	{
		var value = texter_general_Char._new("\x0E");
		_g.h[14] = value;
	}
	{
		var value = texter_general_Char._new("\x0F");
		_g.h[15] = value;
	}
	{
		var value = texter_general_Char._new("\x10");
		_g.h[16] = value;
	}
	{
		var value = texter_general_Char._new("\x11");
		_g.h[17] = value;
	}
	{
		var value = texter_general_Char._new("\x12");
		_g.h[18] = value;
	}
	{
		var value = texter_general_Char._new("\x13");
		_g.h[19] = value;
	}
	{
		var value = texter_general_Char._new("\x14");
		_g.h[20] = value;
	}
	{
		var value = texter_general_Char._new("\x15");
		_g.h[21] = value;
	}
	{
		var value = texter_general_Char._new("\x16");
		_g.h[22] = value;
	}
	{
		var value = texter_general_Char._new("\x17");
		_g.h[23] = value;
	}
	{
		var value = texter_general_Char._new("\x18");
		_g.h[24] = value;
	}
	{
		var value = texter_general_Char._new("\x19");
		_g.h[25] = value;
	}
	{
		var value = texter_general_Char._new("\x1A");
		_g.h[26] = value;
	}
	{
		var value = texter_general_Char._new("\x1B");
		_g.h[27] = value;
	}
	{
		var value = texter_general_Char._new("\x1C");
		_g.h[28] = value;
	}
	{
		var value = texter_general_Char._new("\x1D");
		_g.h[29] = value;
	}
	{
		var value = texter_general_Char._new("\x1E");
		_g.h[30] = value;
	}
	{
		var value = texter_general_Char._new("\x1F");
		_g.h[31] = value;
	}
	{
		var value = texter_general_Char._new(" ");
		_g.h[32] = value;
	}
	{
		var value = texter_general_Char._new("!");
		_g.h[33] = value;
	}
	{
		var value = texter_general_Char._new("\"");
		_g.h[34] = value;
	}
	{
		var value = texter_general_Char._new("#");
		_g.h[35] = value;
	}
	{
		var value = texter_general_Char._new("$");
		_g.h[36] = value;
	}
	{
		var value = texter_general_Char._new("%");
		_g.h[37] = value;
	}
	{
		var value = texter_general_Char._new("&");
		_g.h[38] = value;
	}
	{
		var value = texter_general_Char._new("'");
		_g.h[39] = value;
	}
	{
		var value = texter_general_Char._new("(");
		_g.h[40] = value;
	}
	{
		var value = texter_general_Char._new(")");
		_g.h[41] = value;
	}
	{
		var value = texter_general_Char._new("*");
		_g.h[42] = value;
	}
	{
		var value = texter_general_Char._new("+");
		_g.h[43] = value;
	}
	{
		var value = texter_general_Char._new(",");
		_g.h[44] = value;
	}
	{
		var value = texter_general_Char._new("-");
		_g.h[45] = value;
	}
	{
		var value = texter_general_Char._new(".");
		_g.h[46] = value;
	}
	{
		var value = texter_general_Char._new("/");
		_g.h[47] = value;
	}
	{
		var value = texter_general_Char._new("0");
		_g.h[48] = value;
	}
	{
		var value = texter_general_Char._new("1");
		_g.h[49] = value;
	}
	{
		var value = texter_general_Char._new("2");
		_g.h[50] = value;
	}
	{
		var value = texter_general_Char._new("3");
		_g.h[51] = value;
	}
	{
		var value = texter_general_Char._new("4");
		_g.h[52] = value;
	}
	{
		var value = texter_general_Char._new("5");
		_g.h[53] = value;
	}
	{
		var value = texter_general_Char._new("6");
		_g.h[54] = value;
	}
	{
		var value = texter_general_Char._new("7");
		_g.h[55] = value;
	}
	{
		var value = texter_general_Char._new("8");
		_g.h[56] = value;
	}
	{
		var value = texter_general_Char._new("9");
		_g.h[57] = value;
	}
	{
		var value = texter_general_Char._new(":");
		_g.h[58] = value;
	}
	{
		var value = texter_general_Char._new(";");
		_g.h[59] = value;
	}
	{
		var value = texter_general_Char._new("<");
		_g.h[60] = value;
	}
	{
		var value = texter_general_Char._new("=");
		_g.h[61] = value;
	}
	{
		var value = texter_general_Char._new(">");
		_g.h[62] = value;
	}
	{
		var value = texter_general_Char._new("?");
		_g.h[63] = value;
	}
	{
		var value = texter_general_Char._new("@");
		_g.h[64] = value;
	}
	{
		var value = texter_general_Char._new("A");
		_g.h[65] = value;
	}
	{
		var value = texter_general_Char._new("B");
		_g.h[66] = value;
	}
	{
		var value = texter_general_Char._new("C");
		_g.h[67] = value;
	}
	{
		var value = texter_general_Char._new("D");
		_g.h[68] = value;
	}
	{
		var value = texter_general_Char._new("E");
		_g.h[69] = value;
	}
	{
		var value = texter_general_Char._new("F");
		_g.h[70] = value;
	}
	{
		var value = texter_general_Char._new("G");
		_g.h[71] = value;
	}
	{
		var value = texter_general_Char._new("H");
		_g.h[72] = value;
	}
	{
		var value = texter_general_Char._new("I");
		_g.h[73] = value;
	}
	{
		var value = texter_general_Char._new("J");
		_g.h[74] = value;
	}
	{
		var value = texter_general_Char._new("K");
		_g.h[75] = value;
	}
	{
		var value = texter_general_Char._new("L");
		_g.h[76] = value;
	}
	{
		var value = texter_general_Char._new("M");
		_g.h[77] = value;
	}
	{
		var value = texter_general_Char._new("N");
		_g.h[78] = value;
	}
	{
		var value = texter_general_Char._new("O");
		_g.h[79] = value;
	}
	{
		var value = texter_general_Char._new("P");
		_g.h[80] = value;
	}
	{
		var value = texter_general_Char._new("Q");
		_g.h[81] = value;
	}
	{
		var value = texter_general_Char._new("R");
		_g.h[82] = value;
	}
	{
		var value = texter_general_Char._new("S");
		_g.h[83] = value;
	}
	{
		var value = texter_general_Char._new("T");
		_g.h[84] = value;
	}
	{
		var value = texter_general_Char._new("U");
		_g.h[85] = value;
	}
	{
		var value = texter_general_Char._new("V");
		_g.h[86] = value;
	}
	{
		var value = texter_general_Char._new("W");
		_g.h[87] = value;
	}
	{
		var value = texter_general_Char._new("X");
		_g.h[88] = value;
	}
	{
		var value = texter_general_Char._new("Y");
		_g.h[89] = value;
	}
	{
		var value = texter_general_Char._new("Z");
		_g.h[90] = value;
	}
	{
		var value = texter_general_Char._new("[");
		_g.h[91] = value;
	}
	{
		var value = texter_general_Char._new("\\");
		_g.h[92] = value;
	}
	{
		var value = texter_general_Char._new("]");
		_g.h[93] = value;
	}
	{
		var value = texter_general_Char._new("^");
		_g.h[94] = value;
	}
	{
		var value = texter_general_Char._new("_");
		_g.h[95] = value;
	}
	{
		var value = texter_general_Char._new("`");
		_g.h[96] = value;
	}
	{
		var value = texter_general_Char._new("a");
		_g.h[97] = value;
	}
	{
		var value = texter_general_Char._new("b");
		_g.h[98] = value;
	}
	{
		var value = texter_general_Char._new("c");
		_g.h[99] = value;
	}
	{
		var value = texter_general_Char._new("d");
		_g.h[100] = value;
	}
	{
		var value = texter_general_Char._new("e");
		_g.h[101] = value;
	}
	{
		var value = texter_general_Char._new("f");
		_g.h[102] = value;
	}
	{
		var value = texter_general_Char._new("g");
		_g.h[103] = value;
	}
	{
		var value = texter_general_Char._new("h");
		_g.h[104] = value;
	}
	{
		var value = texter_general_Char._new("i");
		_g.h[105] = value;
	}
	{
		var value = texter_general_Char._new("j");
		_g.h[106] = value;
	}
	{
		var value = texter_general_Char._new("k");
		_g.h[107] = value;
	}
	{
		var value = texter_general_Char._new("l");
		_g.h[108] = value;
	}
	{
		var value = texter_general_Char._new("m");
		_g.h[109] = value;
	}
	{
		var value = texter_general_Char._new("n");
		_g.h[110] = value;
	}
	{
		var value = texter_general_Char._new("o");
		_g.h[111] = value;
	}
	{
		var value = texter_general_Char._new("p");
		_g.h[112] = value;
	}
	{
		var value = texter_general_Char._new("q");
		_g.h[113] = value;
	}
	{
		var value = texter_general_Char._new("r");
		_g.h[114] = value;
	}
	{
		var value = texter_general_Char._new("s");
		_g.h[115] = value;
	}
	{
		var value = texter_general_Char._new("t");
		_g.h[116] = value;
	}
	{
		var value = texter_general_Char._new("u");
		_g.h[117] = value;
	}
	{
		var value = texter_general_Char._new("v");
		_g.h[118] = value;
	}
	{
		var value = texter_general_Char._new("w");
		_g.h[119] = value;
	}
	{
		var value = texter_general_Char._new("x");
		_g.h[120] = value;
	}
	{
		var value = texter_general_Char._new("y");
		_g.h[121] = value;
	}
	{
		var value = texter_general_Char._new("z");
		_g.h[122] = value;
	}
	{
		var value = texter_general_Char._new("{");
		_g.h[123] = value;
	}
	{
		var value = texter_general_Char._new("|");
		_g.h[124] = value;
	}
	{
		var value = texter_general_Char._new("}");
		_g.h[125] = value;
	}
	{
		var value = texter_general_Char._new("~");
		_g.h[126] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[127] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[128] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[129] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[130] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[131] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[132] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[133] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[134] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[135] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[136] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[137] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[138] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[139] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[140] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[141] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[142] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[143] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[144] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[145] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[146] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[147] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[148] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[149] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[150] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[151] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[152] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[153] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[154] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[155] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[156] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[157] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[158] = value;
	}
	{
		var value = texter_general_Char._new("");
		_g.h[159] = value;
	}
	{
		var value = texter_general_Char._new(" ");
		_g.h[160] = value;
	}
	{
		var value = texter_general_Char._new("¡");
		_g.h[161] = value;
	}
	{
		var value = texter_general_Char._new("¢");
		_g.h[162] = value;
	}
	{
		var value = texter_general_Char._new("£");
		_g.h[163] = value;
	}
	{
		var value = texter_general_Char._new("¤");
		_g.h[164] = value;
	}
	{
		var value = texter_general_Char._new("¥");
		_g.h[165] = value;
	}
	{
		var value = texter_general_Char._new("¦");
		_g.h[166] = value;
	}
	{
		var value = texter_general_Char._new("§");
		_g.h[167] = value;
	}
	{
		var value = texter_general_Char._new("¨");
		_g.h[168] = value;
	}
	{
		var value = texter_general_Char._new("©");
		_g.h[169] = value;
	}
	{
		var value = texter_general_Char._new("ª");
		_g.h[170] = value;
	}
	{
		var value = texter_general_Char._new("«");
		_g.h[171] = value;
	}
	{
		var value = texter_general_Char._new("¬");
		_g.h[172] = value;
	}
	{
		var value = texter_general_Char._new("­");
		_g.h[173] = value;
	}
	{
		var value = texter_general_Char._new("®");
		_g.h[174] = value;
	}
	{
		var value = texter_general_Char._new("¯");
		_g.h[175] = value;
	}
	{
		var value = texter_general_Char._new("°");
		_g.h[176] = value;
	}
	{
		var value = texter_general_Char._new("±");
		_g.h[177] = value;
	}
	{
		var value = texter_general_Char._new("²");
		_g.h[178] = value;
	}
	{
		var value = texter_general_Char._new("³");
		_g.h[179] = value;
	}
	{
		var value = texter_general_Char._new("´");
		_g.h[180] = value;
	}
	{
		var value = texter_general_Char._new("µ");
		_g.h[181] = value;
	}
	{
		var value = texter_general_Char._new("¶");
		_g.h[182] = value;
	}
	{
		var value = texter_general_Char._new("·");
		_g.h[183] = value;
	}
	{
		var value = texter_general_Char._new("¸");
		_g.h[184] = value;
	}
	{
		var value = texter_general_Char._new("¹");
		_g.h[185] = value;
	}
	{
		var value = texter_general_Char._new("º");
		_g.h[186] = value;
	}
	{
		var value = texter_general_Char._new("»");
		_g.h[187] = value;
	}
	{
		var value = texter_general_Char._new("¼");
		_g.h[188] = value;
	}
	{
		var value = texter_general_Char._new("½");
		_g.h[189] = value;
	}
	{
		var value = texter_general_Char._new("¾");
		_g.h[190] = value;
	}
	{
		var value = texter_general_Char._new("¿");
		_g.h[191] = value;
	}
	{
		var value = texter_general_Char._new("À");
		_g.h[192] = value;
	}
	{
		var value = texter_general_Char._new("Á");
		_g.h[193] = value;
	}
	{
		var value = texter_general_Char._new("Â");
		_g.h[194] = value;
	}
	{
		var value = texter_general_Char._new("Ã");
		_g.h[195] = value;
	}
	{
		var value = texter_general_Char._new("Ä");
		_g.h[196] = value;
	}
	{
		var value = texter_general_Char._new("Å");
		_g.h[197] = value;
	}
	{
		var value = texter_general_Char._new("Æ");
		_g.h[198] = value;
	}
	{
		var value = texter_general_Char._new("Ç");
		_g.h[199] = value;
	}
	{
		var value = texter_general_Char._new("È");
		_g.h[200] = value;
	}
	{
		var value = texter_general_Char._new("É");
		_g.h[201] = value;
	}
	{
		var value = texter_general_Char._new("Ê");
		_g.h[202] = value;
	}
	{
		var value = texter_general_Char._new("Ë");
		_g.h[203] = value;
	}
	{
		var value = texter_general_Char._new("Ì");
		_g.h[204] = value;
	}
	{
		var value = texter_general_Char._new("Í");
		_g.h[205] = value;
	}
	{
		var value = texter_general_Char._new("Î");
		_g.h[206] = value;
	}
	{
		var value = texter_general_Char._new("Ï");
		_g.h[207] = value;
	}
	{
		var value = texter_general_Char._new("Ð");
		_g.h[208] = value;
	}
	{
		var value = texter_general_Char._new("Ñ");
		_g.h[209] = value;
	}
	{
		var value = texter_general_Char._new("Ò");
		_g.h[210] = value;
	}
	{
		var value = texter_general_Char._new("Ó");
		_g.h[211] = value;
	}
	{
		var value = texter_general_Char._new("Ô");
		_g.h[212] = value;
	}
	{
		var value = texter_general_Char._new("Õ");
		_g.h[213] = value;
	}
	{
		var value = texter_general_Char._new("Ö");
		_g.h[214] = value;
	}
	{
		var value = texter_general_Char._new("×");
		_g.h[215] = value;
	}
	{
		var value = texter_general_Char._new("Ø");
		_g.h[216] = value;
	}
	{
		var value = texter_general_Char._new("Ù");
		_g.h[217] = value;
	}
	{
		var value = texter_general_Char._new("Ú");
		_g.h[218] = value;
	}
	{
		var value = texter_general_Char._new("Û");
		_g.h[219] = value;
	}
	{
		var value = texter_general_Char._new("Ü");
		_g.h[220] = value;
	}
	{
		var value = texter_general_Char._new("Ý");
		_g.h[221] = value;
	}
	{
		var value = texter_general_Char._new("Þ");
		_g.h[222] = value;
	}
	{
		var value = texter_general_Char._new("ß");
		_g.h[223] = value;
	}
	{
		var value = texter_general_Char._new("à");
		_g.h[224] = value;
	}
	{
		var value = texter_general_Char._new("á");
		_g.h[225] = value;
	}
	{
		var value = texter_general_Char._new("â");
		_g.h[226] = value;
	}
	{
		var value = texter_general_Char._new("ã");
		_g.h[227] = value;
	}
	{
		var value = texter_general_Char._new("ä");
		_g.h[228] = value;
	}
	{
		var value = texter_general_Char._new("å");
		_g.h[229] = value;
	}
	{
		var value = texter_general_Char._new("æ");
		_g.h[230] = value;
	}
	{
		var value = texter_general_Char._new("ç");
		_g.h[231] = value;
	}
	{
		var value = texter_general_Char._new("è");
		_g.h[232] = value;
	}
	{
		var value = texter_general_Char._new("é");
		_g.h[233] = value;
	}
	{
		var value = texter_general_Char._new("ê");
		_g.h[234] = value;
	}
	{
		var value = texter_general_Char._new("ë");
		_g.h[235] = value;
	}
	{
		var value = texter_general_Char._new("ì");
		_g.h[236] = value;
	}
	{
		var value = texter_general_Char._new("í");
		_g.h[237] = value;
	}
	{
		var value = texter_general_Char._new("î");
		_g.h[238] = value;
	}
	{
		var value = texter_general_Char._new("ï");
		_g.h[239] = value;
	}
	{
		var value = texter_general_Char._new("ð");
		_g.h[240] = value;
	}
	{
		var value = texter_general_Char._new("ñ");
		_g.h[241] = value;
	}
	{
		var value = texter_general_Char._new("ò");
		_g.h[242] = value;
	}
	{
		var value = texter_general_Char._new("ó");
		_g.h[243] = value;
	}
	{
		var value = texter_general_Char._new("ô");
		_g.h[244] = value;
	}
	{
		var value = texter_general_Char._new("õ");
		_g.h[245] = value;
	}
	{
		var value = texter_general_Char._new("ö");
		_g.h[246] = value;
	}
	{
		var value = texter_general_Char._new("÷");
		_g.h[247] = value;
	}
	{
		var value = texter_general_Char._new("ø");
		_g.h[248] = value;
	}
	{
		var value = texter_general_Char._new("ù");
		_g.h[249] = value;
	}
	{
		var value = texter_general_Char._new("ú");
		_g.h[250] = value;
	}
	{
		var value = texter_general_Char._new("û");
		_g.h[251] = value;
	}
	{
		var value = texter_general_Char._new("ü");
		_g.h[252] = value;
	}
	{
		var value = texter_general_Char._new("ý");
		_g.h[253] = value;
	}
	{
		var value = texter_general_Char._new("þ");
		_g.h[254] = value;
	}
	{
		var value = texter_general_Char._new("ÿ");
		_g.h[255] = value;
	}
	{
		var value = texter_general_Char._new("Ā");
		_g.h[256] = value;
	}
	{
		var value = texter_general_Char._new("ā");
		_g.h[257] = value;
	}
	{
		var value = texter_general_Char._new("Ă");
		_g.h[258] = value;
	}
	{
		var value = texter_general_Char._new("ă");
		_g.h[259] = value;
	}
	{
		var value = texter_general_Char._new("Ą");
		_g.h[260] = value;
	}
	{
		var value = texter_general_Char._new("ą");
		_g.h[261] = value;
	}
	{
		var value = texter_general_Char._new("Ć");
		_g.h[262] = value;
	}
	{
		var value = texter_general_Char._new("ć");
		_g.h[263] = value;
	}
	{
		var value = texter_general_Char._new("Ĉ");
		_g.h[264] = value;
	}
	{
		var value = texter_general_Char._new("ĉ");
		_g.h[265] = value;
	}
	{
		var value = texter_general_Char._new("Ċ");
		_g.h[266] = value;
	}
	{
		var value = texter_general_Char._new("ċ");
		_g.h[267] = value;
	}
	{
		var value = texter_general_Char._new("Č");
		_g.h[268] = value;
	}
	{
		var value = texter_general_Char._new("č");
		_g.h[269] = value;
	}
	{
		var value = texter_general_Char._new("Ď");
		_g.h[270] = value;
	}
	{
		var value = texter_general_Char._new("ď");
		_g.h[271] = value;
	}
	{
		var value = texter_general_Char._new("Đ");
		_g.h[272] = value;
	}
	{
		var value = texter_general_Char._new("đ");
		_g.h[273] = value;
	}
	{
		var value = texter_general_Char._new("Ē");
		_g.h[274] = value;
	}
	{
		var value = texter_general_Char._new("ē");
		_g.h[275] = value;
	}
	{
		var value = texter_general_Char._new("Ĕ");
		_g.h[276] = value;
	}
	{
		var value = texter_general_Char._new("ĕ");
		_g.h[277] = value;
	}
	{
		var value = texter_general_Char._new("Ė");
		_g.h[278] = value;
	}
	{
		var value = texter_general_Char._new("ė");
		_g.h[279] = value;
	}
	{
		var value = texter_general_Char._new("Ę");
		_g.h[280] = value;
	}
	{
		var value = texter_general_Char._new("ę");
		_g.h[281] = value;
	}
	{
		var value = texter_general_Char._new("Ě");
		_g.h[282] = value;
	}
	{
		var value = texter_general_Char._new("ě");
		_g.h[283] = value;
	}
	{
		var value = texter_general_Char._new("Ĝ");
		_g.h[284] = value;
	}
	{
		var value = texter_general_Char._new("ĝ");
		_g.h[285] = value;
	}
	{
		var value = texter_general_Char._new("Ğ");
		_g.h[286] = value;
	}
	{
		var value = texter_general_Char._new("ğ");
		_g.h[287] = value;
	}
	{
		var value = texter_general_Char._new("Ġ");
		_g.h[288] = value;
	}
	{
		var value = texter_general_Char._new("ġ");
		_g.h[289] = value;
	}
	{
		var value = texter_general_Char._new("Ģ");
		_g.h[290] = value;
	}
	{
		var value = texter_general_Char._new("ģ");
		_g.h[291] = value;
	}
	{
		var value = texter_general_Char._new("Ĥ");
		_g.h[292] = value;
	}
	{
		var value = texter_general_Char._new("ĥ");
		_g.h[293] = value;
	}
	{
		var value = texter_general_Char._new("Ħ");
		_g.h[294] = value;
	}
	{
		var value = texter_general_Char._new("ħ");
		_g.h[295] = value;
	}
	{
		var value = texter_general_Char._new("Ĩ");
		_g.h[296] = value;
	}
	{
		var value = texter_general_Char._new("ĩ");
		_g.h[297] = value;
	}
	{
		var value = texter_general_Char._new("Ī");
		_g.h[298] = value;
	}
	{
		var value = texter_general_Char._new("ī");
		_g.h[299] = value;
	}
	{
		var value = texter_general_Char._new("Ĭ");
		_g.h[300] = value;
	}
	{
		var value = texter_general_Char._new("ĭ");
		_g.h[301] = value;
	}
	{
		var value = texter_general_Char._new("Į");
		_g.h[302] = value;
	}
	{
		var value = texter_general_Char._new("į");
		_g.h[303] = value;
	}
	{
		var value = texter_general_Char._new("İ");
		_g.h[304] = value;
	}
	{
		var value = texter_general_Char._new("ı");
		_g.h[305] = value;
	}
	{
		var value = texter_general_Char._new("Ĳ");
		_g.h[306] = value;
	}
	{
		var value = texter_general_Char._new("ĳ");
		_g.h[307] = value;
	}
	{
		var value = texter_general_Char._new("Ĵ");
		_g.h[308] = value;
	}
	{
		var value = texter_general_Char._new("ĵ");
		_g.h[309] = value;
	}
	{
		var value = texter_general_Char._new("Ķ");
		_g.h[310] = value;
	}
	{
		var value = texter_general_Char._new("ķ");
		_g.h[311] = value;
	}
	{
		var value = texter_general_Char._new("ĸ");
		_g.h[312] = value;
	}
	{
		var value = texter_general_Char._new("Ĺ");
		_g.h[313] = value;
	}
	{
		var value = texter_general_Char._new("ĺ");
		_g.h[314] = value;
	}
	{
		var value = texter_general_Char._new("Ļ");
		_g.h[315] = value;
	}
	{
		var value = texter_general_Char._new("ļ");
		_g.h[316] = value;
	}
	{
		var value = texter_general_Char._new("Ľ");
		_g.h[317] = value;
	}
	{
		var value = texter_general_Char._new("ľ");
		_g.h[318] = value;
	}
	{
		var value = texter_general_Char._new("Ŀ");
		_g.h[319] = value;
	}
	{
		var value = texter_general_Char._new("ŀ");
		_g.h[320] = value;
	}
	{
		var value = texter_general_Char._new("Ł");
		_g.h[321] = value;
	}
	{
		var value = texter_general_Char._new("ł");
		_g.h[322] = value;
	}
	{
		var value = texter_general_Char._new("Ń");
		_g.h[323] = value;
	}
	{
		var value = texter_general_Char._new("ń");
		_g.h[324] = value;
	}
	{
		var value = texter_general_Char._new("Ņ");
		_g.h[325] = value;
	}
	{
		var value = texter_general_Char._new("ņ");
		_g.h[326] = value;
	}
	{
		var value = texter_general_Char._new("Ň");
		_g.h[327] = value;
	}
	{
		var value = texter_general_Char._new("ň");
		_g.h[328] = value;
	}
	{
		var value = texter_general_Char._new("ŉ");
		_g.h[329] = value;
	}
	{
		var value = texter_general_Char._new("Ŋ");
		_g.h[330] = value;
	}
	{
		var value = texter_general_Char._new("ŋ");
		_g.h[331] = value;
	}
	{
		var value = texter_general_Char._new("Ō");
		_g.h[332] = value;
	}
	{
		var value = texter_general_Char._new("ō");
		_g.h[333] = value;
	}
	{
		var value = texter_general_Char._new("Ŏ");
		_g.h[334] = value;
	}
	{
		var value = texter_general_Char._new("ŏ");
		_g.h[335] = value;
	}
	{
		var value = texter_general_Char._new("Ő");
		_g.h[336] = value;
	}
	{
		var value = texter_general_Char._new("ő");
		_g.h[337] = value;
	}
	{
		var value = texter_general_Char._new("Œ");
		_g.h[338] = value;
	}
	{
		var value = texter_general_Char._new("œ");
		_g.h[339] = value;
	}
	{
		var value = texter_general_Char._new("Ŕ");
		_g.h[340] = value;
	}
	{
		var value = texter_general_Char._new("ŕ");
		_g.h[341] = value;
	}
	{
		var value = texter_general_Char._new("Ŗ");
		_g.h[342] = value;
	}
	{
		var value = texter_general_Char._new("ŗ");
		_g.h[343] = value;
	}
	{
		var value = texter_general_Char._new("Ř");
		_g.h[344] = value;
	}
	{
		var value = texter_general_Char._new("ř");
		_g.h[345] = value;
	}
	{
		var value = texter_general_Char._new("Ś");
		_g.h[346] = value;
	}
	{
		var value = texter_general_Char._new("ś");
		_g.h[347] = value;
	}
	{
		var value = texter_general_Char._new("Ŝ");
		_g.h[348] = value;
	}
	{
		var value = texter_general_Char._new("ŝ");
		_g.h[349] = value;
	}
	{
		var value = texter_general_Char._new("Ş");
		_g.h[350] = value;
	}
	{
		var value = texter_general_Char._new("ş");
		_g.h[351] = value;
	}
	{
		var value = texter_general_Char._new("Š");
		_g.h[352] = value;
	}
	{
		var value = texter_general_Char._new("š");
		_g.h[353] = value;
	}
	{
		var value = texter_general_Char._new("Ţ");
		_g.h[354] = value;
	}
	{
		var value = texter_general_Char._new("ţ");
		_g.h[355] = value;
	}
	{
		var value = texter_general_Char._new("Ť");
		_g.h[356] = value;
	}
	{
		var value = texter_general_Char._new("ť");
		_g.h[357] = value;
	}
	{
		var value = texter_general_Char._new("Ŧ");
		_g.h[358] = value;
	}
	{
		var value = texter_general_Char._new("ŧ");
		_g.h[359] = value;
	}
	{
		var value = texter_general_Char._new("Ũ");
		_g.h[360] = value;
	}
	{
		var value = texter_general_Char._new("ũ");
		_g.h[361] = value;
	}
	{
		var value = texter_general_Char._new("Ū");
		_g.h[362] = value;
	}
	{
		var value = texter_general_Char._new("ū");
		_g.h[363] = value;
	}
	{
		var value = texter_general_Char._new("Ŭ");
		_g.h[364] = value;
	}
	{
		var value = texter_general_Char._new("ŭ");
		_g.h[365] = value;
	}
	{
		var value = texter_general_Char._new("Ů");
		_g.h[366] = value;
	}
	{
		var value = texter_general_Char._new("ů");
		_g.h[367] = value;
	}
	{
		var value = texter_general_Char._new("Ű");
		_g.h[368] = value;
	}
	{
		var value = texter_general_Char._new("ű");
		_g.h[369] = value;
	}
	{
		var value = texter_general_Char._new("Ų");
		_g.h[370] = value;
	}
	{
		var value = texter_general_Char._new("ų");
		_g.h[371] = value;
	}
	{
		var value = texter_general_Char._new("Ŵ");
		_g.h[372] = value;
	}
	{
		var value = texter_general_Char._new("ŵ");
		_g.h[373] = value;
	}
	{
		var value = texter_general_Char._new("Ŷ");
		_g.h[374] = value;
	}
	{
		var value = texter_general_Char._new("ŷ");
		_g.h[375] = value;
	}
	{
		var value = texter_general_Char._new("Ÿ");
		_g.h[376] = value;
	}
	{
		var value = texter_general_Char._new("Ź");
		_g.h[377] = value;
	}
	{
		var value = texter_general_Char._new("ź");
		_g.h[378] = value;
	}
	{
		var value = texter_general_Char._new("Ż");
		_g.h[379] = value;
	}
	{
		var value = texter_general_Char._new("ż");
		_g.h[380] = value;
	}
	{
		var value = texter_general_Char._new("Ž");
		_g.h[381] = value;
	}
	{
		var value = texter_general_Char._new("ž");
		_g.h[382] = value;
	}
	{
		var value = texter_general_Char._new("ſ");
		_g.h[383] = value;
	}
	{
		var value = texter_general_Char._new("ƀ");
		_g.h[384] = value;
	}
	{
		var value = texter_general_Char._new("Ɓ");
		_g.h[385] = value;
	}
	{
		var value = texter_general_Char._new("Ƃ");
		_g.h[386] = value;
	}
	{
		var value = texter_general_Char._new("ƃ");
		_g.h[387] = value;
	}
	{
		var value = texter_general_Char._new("Ƅ");
		_g.h[388] = value;
	}
	{
		var value = texter_general_Char._new("ƅ");
		_g.h[389] = value;
	}
	{
		var value = texter_general_Char._new("Ɔ");
		_g.h[390] = value;
	}
	{
		var value = texter_general_Char._new("Ƈ");
		_g.h[391] = value;
	}
	{
		var value = texter_general_Char._new("ƈ");
		_g.h[392] = value;
	}
	{
		var value = texter_general_Char._new("Ɖ");
		_g.h[393] = value;
	}
	{
		var value = texter_general_Char._new("Ɗ");
		_g.h[394] = value;
	}
	{
		var value = texter_general_Char._new("Ƌ");
		_g.h[395] = value;
	}
	{
		var value = texter_general_Char._new("ƌ");
		_g.h[396] = value;
	}
	{
		var value = texter_general_Char._new("ƍ");
		_g.h[397] = value;
	}
	{
		var value = texter_general_Char._new("Ǝ");
		_g.h[398] = value;
	}
	{
		var value = texter_general_Char._new("Ə");
		_g.h[399] = value;
	}
	{
		var value = texter_general_Char._new("Ɛ");
		_g.h[400] = value;
	}
	{
		var value = texter_general_Char._new("Ƒ");
		_g.h[401] = value;
	}
	{
		var value = texter_general_Char._new("ƒ");
		_g.h[402] = value;
	}
	{
		var value = texter_general_Char._new("Ɠ");
		_g.h[403] = value;
	}
	{
		var value = texter_general_Char._new("Ɣ");
		_g.h[404] = value;
	}
	{
		var value = texter_general_Char._new("ƕ");
		_g.h[405] = value;
	}
	{
		var value = texter_general_Char._new("Ɩ");
		_g.h[406] = value;
	}
	{
		var value = texter_general_Char._new("Ɨ");
		_g.h[407] = value;
	}
	{
		var value = texter_general_Char._new("Ƙ");
		_g.h[408] = value;
	}
	{
		var value = texter_general_Char._new("ƙ");
		_g.h[409] = value;
	}
	{
		var value = texter_general_Char._new("ƚ");
		_g.h[410] = value;
	}
	{
		var value = texter_general_Char._new("ƛ");
		_g.h[411] = value;
	}
	{
		var value = texter_general_Char._new("Ɯ");
		_g.h[412] = value;
	}
	{
		var value = texter_general_Char._new("Ɲ");
		_g.h[413] = value;
	}
	{
		var value = texter_general_Char._new("ƞ");
		_g.h[414] = value;
	}
	{
		var value = texter_general_Char._new("Ɵ");
		_g.h[415] = value;
	}
	{
		var value = texter_general_Char._new("Ơ");
		_g.h[416] = value;
	}
	{
		var value = texter_general_Char._new("ơ");
		_g.h[417] = value;
	}
	{
		var value = texter_general_Char._new("Ƣ");
		_g.h[418] = value;
	}
	{
		var value = texter_general_Char._new("ƣ");
		_g.h[419] = value;
	}
	{
		var value = texter_general_Char._new("Ƥ");
		_g.h[420] = value;
	}
	{
		var value = texter_general_Char._new("ƥ");
		_g.h[421] = value;
	}
	{
		var value = texter_general_Char._new("Ʀ");
		_g.h[422] = value;
	}
	{
		var value = texter_general_Char._new("Ƨ");
		_g.h[423] = value;
	}
	{
		var value = texter_general_Char._new("ƨ");
		_g.h[424] = value;
	}
	{
		var value = texter_general_Char._new("Ʃ");
		_g.h[425] = value;
	}
	{
		var value = texter_general_Char._new("ƪ");
		_g.h[426] = value;
	}
	{
		var value = texter_general_Char._new("ƫ");
		_g.h[427] = value;
	}
	{
		var value = texter_general_Char._new("Ƭ");
		_g.h[428] = value;
	}
	{
		var value = texter_general_Char._new("ƭ");
		_g.h[429] = value;
	}
	{
		var value = texter_general_Char._new("Ʈ");
		_g.h[430] = value;
	}
	{
		var value = texter_general_Char._new("Ư");
		_g.h[431] = value;
	}
	{
		var value = texter_general_Char._new("ư");
		_g.h[432] = value;
	}
	{
		var value = texter_general_Char._new("Ʊ");
		_g.h[433] = value;
	}
	{
		var value = texter_general_Char._new("Ʋ");
		_g.h[434] = value;
	}
	{
		var value = texter_general_Char._new("Ƴ");
		_g.h[435] = value;
	}
	{
		var value = texter_general_Char._new("ƴ");
		_g.h[436] = value;
	}
	{
		var value = texter_general_Char._new("Ƶ");
		_g.h[437] = value;
	}
	{
		var value = texter_general_Char._new("ƶ");
		_g.h[438] = value;
	}
	{
		var value = texter_general_Char._new("Ʒ");
		_g.h[439] = value;
	}
	{
		var value = texter_general_Char._new("Ƹ");
		_g.h[440] = value;
	}
	{
		var value = texter_general_Char._new("ƹ");
		_g.h[441] = value;
	}
	{
		var value = texter_general_Char._new("ƺ");
		_g.h[442] = value;
	}
	{
		var value = texter_general_Char._new("ƻ");
		_g.h[443] = value;
	}
	{
		var value = texter_general_Char._new("Ƽ");
		_g.h[444] = value;
	}
	{
		var value = texter_general_Char._new("ƽ");
		_g.h[445] = value;
	}
	{
		var value = texter_general_Char._new("ƾ");
		_g.h[446] = value;
	}
	{
		var value = texter_general_Char._new("ƿ");
		_g.h[447] = value;
	}
	{
		var value = texter_general_Char._new("ǀ");
		_g.h[448] = value;
	}
	{
		var value = texter_general_Char._new("ǁ");
		_g.h[449] = value;
	}
	{
		var value = texter_general_Char._new("ǂ");
		_g.h[450] = value;
	}
	{
		var value = texter_general_Char._new("ǃ");
		_g.h[451] = value;
	}
	{
		var value = texter_general_Char._new("Ǆ");
		_g.h[452] = value;
	}
	{
		var value = texter_general_Char._new("ǅ");
		_g.h[453] = value;
	}
	{
		var value = texter_general_Char._new("ǆ");
		_g.h[454] = value;
	}
	{
		var value = texter_general_Char._new("Ǉ");
		_g.h[455] = value;
	}
	{
		var value = texter_general_Char._new("ǈ");
		_g.h[456] = value;
	}
	{
		var value = texter_general_Char._new("ǉ");
		_g.h[457] = value;
	}
	{
		var value = texter_general_Char._new("Ǌ");
		_g.h[458] = value;
	}
	{
		var value = texter_general_Char._new("ǋ");
		_g.h[459] = value;
	}
	{
		var value = texter_general_Char._new("ǌ");
		_g.h[460] = value;
	}
	{
		var value = texter_general_Char._new("Ǎ");
		_g.h[461] = value;
	}
	{
		var value = texter_general_Char._new("ǎ");
		_g.h[462] = value;
	}
	{
		var value = texter_general_Char._new("Ǐ");
		_g.h[463] = value;
	}
	{
		var value = texter_general_Char._new("ǐ");
		_g.h[464] = value;
	}
	{
		var value = texter_general_Char._new("Ǒ");
		_g.h[465] = value;
	}
	{
		var value = texter_general_Char._new("ǒ");
		_g.h[466] = value;
	}
	{
		var value = texter_general_Char._new("Ǔ");
		_g.h[467] = value;
	}
	{
		var value = texter_general_Char._new("ǔ");
		_g.h[468] = value;
	}
	{
		var value = texter_general_Char._new("Ǖ");
		_g.h[469] = value;
	}
	{
		var value = texter_general_Char._new("ǖ");
		_g.h[470] = value;
	}
	{
		var value = texter_general_Char._new("Ǘ");
		_g.h[471] = value;
	}
	{
		var value = texter_general_Char._new("ǘ");
		_g.h[472] = value;
	}
	{
		var value = texter_general_Char._new("Ǚ");
		_g.h[473] = value;
	}
	{
		var value = texter_general_Char._new("ǚ");
		_g.h[474] = value;
	}
	{
		var value = texter_general_Char._new("Ǜ");
		_g.h[475] = value;
	}
	{
		var value = texter_general_Char._new("ǜ");
		_g.h[476] = value;
	}
	{
		var value = texter_general_Char._new("ǝ");
		_g.h[477] = value;
	}
	{
		var value = texter_general_Char._new("Ǟ");
		_g.h[478] = value;
	}
	{
		var value = texter_general_Char._new("ǟ");
		_g.h[479] = value;
	}
	{
		var value = texter_general_Char._new("Ǡ");
		_g.h[480] = value;
	}
	{
		var value = texter_general_Char._new("ǡ");
		_g.h[481] = value;
	}
	{
		var value = texter_general_Char._new("Ǣ");
		_g.h[482] = value;
	}
	{
		var value = texter_general_Char._new("ǣ");
		_g.h[483] = value;
	}
	{
		var value = texter_general_Char._new("Ǥ");
		_g.h[484] = value;
	}
	{
		var value = texter_general_Char._new("ǥ");
		_g.h[485] = value;
	}
	{
		var value = texter_general_Char._new("Ǧ");
		_g.h[486] = value;
	}
	{
		var value = texter_general_Char._new("ǧ");
		_g.h[487] = value;
	}
	{
		var value = texter_general_Char._new("Ǩ");
		_g.h[488] = value;
	}
	{
		var value = texter_general_Char._new("ǩ");
		_g.h[489] = value;
	}
	{
		var value = texter_general_Char._new("Ǫ");
		_g.h[490] = value;
	}
	{
		var value = texter_general_Char._new("ǫ");
		_g.h[491] = value;
	}
	{
		var value = texter_general_Char._new("Ǭ");
		_g.h[492] = value;
	}
	{
		var value = texter_general_Char._new("ǭ");
		_g.h[493] = value;
	}
	{
		var value = texter_general_Char._new("Ǯ");
		_g.h[494] = value;
	}
	{
		var value = texter_general_Char._new("ǯ");
		_g.h[495] = value;
	}
	{
		var value = texter_general_Char._new("ǰ");
		_g.h[496] = value;
	}
	{
		var value = texter_general_Char._new("Ǳ");
		_g.h[497] = value;
	}
	{
		var value = texter_general_Char._new("ǲ");
		_g.h[498] = value;
	}
	{
		var value = texter_general_Char._new("ǳ");
		_g.h[499] = value;
	}
	{
		var value = texter_general_Char._new("Ǵ");
		_g.h[500] = value;
	}
	{
		var value = texter_general_Char._new("ǵ");
		_g.h[501] = value;
	}
	{
		var value = texter_general_Char._new("Ƕ");
		_g.h[502] = value;
	}
	{
		var value = texter_general_Char._new("Ƿ");
		_g.h[503] = value;
	}
	{
		var value = texter_general_Char._new("Ǹ");
		_g.h[504] = value;
	}
	{
		var value = texter_general_Char._new("ǹ");
		_g.h[505] = value;
	}
	{
		var value = texter_general_Char._new("Ǻ");
		_g.h[506] = value;
	}
	{
		var value = texter_general_Char._new("ǻ");
		_g.h[507] = value;
	}
	{
		var value = texter_general_Char._new("Ǽ");
		_g.h[508] = value;
	}
	{
		var value = texter_general_Char._new("ǽ");
		_g.h[509] = value;
	}
	{
		var value = texter_general_Char._new("Ǿ");
		_g.h[510] = value;
	}
	{
		var value = texter_general_Char._new("ǿ");
		_g.h[511] = value;
	}
	{
		var value = texter_general_Char._new("Ȁ");
		_g.h[512] = value;
	}
	{
		var value = texter_general_Char._new("ȁ");
		_g.h[513] = value;
	}
	{
		var value = texter_general_Char._new("Ȃ");
		_g.h[514] = value;
	}
	{
		var value = texter_general_Char._new("ȃ");
		_g.h[515] = value;
	}
	{
		var value = texter_general_Char._new("Ȅ");
		_g.h[516] = value;
	}
	{
		var value = texter_general_Char._new("ȅ");
		_g.h[517] = value;
	}
	{
		var value = texter_general_Char._new("Ȇ");
		_g.h[518] = value;
	}
	{
		var value = texter_general_Char._new("ȇ");
		_g.h[519] = value;
	}
	{
		var value = texter_general_Char._new("Ȉ");
		_g.h[520] = value;
	}
	{
		var value = texter_general_Char._new("ȉ");
		_g.h[521] = value;
	}
	{
		var value = texter_general_Char._new("Ȋ");
		_g.h[522] = value;
	}
	{
		var value = texter_general_Char._new("ȋ");
		_g.h[523] = value;
	}
	{
		var value = texter_general_Char._new("Ȍ");
		_g.h[524] = value;
	}
	{
		var value = texter_general_Char._new("ȍ");
		_g.h[525] = value;
	}
	{
		var value = texter_general_Char._new("Ȏ");
		_g.h[526] = value;
	}
	{
		var value = texter_general_Char._new("ȏ");
		_g.h[527] = value;
	}
	{
		var value = texter_general_Char._new("Ȑ");
		_g.h[528] = value;
	}
	{
		var value = texter_general_Char._new("ȑ");
		_g.h[529] = value;
	}
	{
		var value = texter_general_Char._new("Ȓ");
		_g.h[530] = value;
	}
	{
		var value = texter_general_Char._new("ȓ");
		_g.h[531] = value;
	}
	{
		var value = texter_general_Char._new("Ȕ");
		_g.h[532] = value;
	}
	{
		var value = texter_general_Char._new("ȕ");
		_g.h[533] = value;
	}
	{
		var value = texter_general_Char._new("Ȗ");
		_g.h[534] = value;
	}
	{
		var value = texter_general_Char._new("ȗ");
		_g.h[535] = value;
	}
	{
		var value = texter_general_Char._new("Ș");
		_g.h[536] = value;
	}
	{
		var value = texter_general_Char._new("ș");
		_g.h[537] = value;
	}
	{
		var value = texter_general_Char._new("Ț");
		_g.h[538] = value;
	}
	{
		var value = texter_general_Char._new("ț");
		_g.h[539] = value;
	}
	{
		var value = texter_general_Char._new("Ȝ");
		_g.h[540] = value;
	}
	{
		var value = texter_general_Char._new("ȝ");
		_g.h[541] = value;
	}
	{
		var value = texter_general_Char._new("Ȟ");
		_g.h[542] = value;
	}
	{
		var value = texter_general_Char._new("ȟ");
		_g.h[543] = value;
	}
	{
		var value = texter_general_Char._new("Ƞ");
		_g.h[544] = value;
	}
	{
		var value = texter_general_Char._new("ȡ");
		_g.h[545] = value;
	}
	{
		var value = texter_general_Char._new("Ȣ");
		_g.h[546] = value;
	}
	{
		var value = texter_general_Char._new("ȣ");
		_g.h[547] = value;
	}
	{
		var value = texter_general_Char._new("Ȥ");
		_g.h[548] = value;
	}
	{
		var value = texter_general_Char._new("ȥ");
		_g.h[549] = value;
	}
	{
		var value = texter_general_Char._new("Ȧ");
		_g.h[550] = value;
	}
	{
		var value = texter_general_Char._new("ȧ");
		_g.h[551] = value;
	}
	{
		var value = texter_general_Char._new("Ȩ");
		_g.h[552] = value;
	}
	{
		var value = texter_general_Char._new("ȩ");
		_g.h[553] = value;
	}
	{
		var value = texter_general_Char._new("Ȫ");
		_g.h[554] = value;
	}
	{
		var value = texter_general_Char._new("ȫ");
		_g.h[555] = value;
	}
	{
		var value = texter_general_Char._new("Ȭ");
		_g.h[556] = value;
	}
	{
		var value = texter_general_Char._new("ȭ");
		_g.h[557] = value;
	}
	{
		var value = texter_general_Char._new("Ȯ");
		_g.h[558] = value;
	}
	{
		var value = texter_general_Char._new("ȯ");
		_g.h[559] = value;
	}
	{
		var value = texter_general_Char._new("Ȱ");
		_g.h[560] = value;
	}
	{
		var value = texter_general_Char._new("ȱ");
		_g.h[561] = value;
	}
	{
		var value = texter_general_Char._new("Ȳ");
		_g.h[562] = value;
	}
	{
		var value = texter_general_Char._new("ȳ");
		_g.h[563] = value;
	}
	{
		var value = texter_general_Char._new("ȴ");
		_g.h[564] = value;
	}
	{
		var value = texter_general_Char._new("ȵ");
		_g.h[565] = value;
	}
	{
		var value = texter_general_Char._new("ȶ");
		_g.h[566] = value;
	}
	{
		var value = texter_general_Char._new("ȷ");
		_g.h[567] = value;
	}
	{
		var value = texter_general_Char._new("ȸ");
		_g.h[568] = value;
	}
	{
		var value = texter_general_Char._new("ȹ");
		_g.h[569] = value;
	}
	{
		var value = texter_general_Char._new("Ⱥ");
		_g.h[570] = value;
	}
	{
		var value = texter_general_Char._new("Ȼ");
		_g.h[571] = value;
	}
	{
		var value = texter_general_Char._new("ȼ");
		_g.h[572] = value;
	}
	{
		var value = texter_general_Char._new("Ƚ");
		_g.h[573] = value;
	}
	{
		var value = texter_general_Char._new("Ⱦ");
		_g.h[574] = value;
	}
	{
		var value = texter_general_Char._new("ȿ");
		_g.h[575] = value;
	}
	{
		var value = texter_general_Char._new("ɀ");
		_g.h[576] = value;
	}
	{
		var value = texter_general_Char._new("Ɂ");
		_g.h[577] = value;
	}
	{
		var value = texter_general_Char._new("ɂ");
		_g.h[578] = value;
	}
	{
		var value = texter_general_Char._new("Ƀ");
		_g.h[579] = value;
	}
	{
		var value = texter_general_Char._new("Ʉ");
		_g.h[580] = value;
	}
	{
		var value = texter_general_Char._new("Ʌ");
		_g.h[581] = value;
	}
	{
		var value = texter_general_Char._new("Ɇ");
		_g.h[582] = value;
	}
	{
		var value = texter_general_Char._new("ɇ");
		_g.h[583] = value;
	}
	{
		var value = texter_general_Char._new("Ɉ");
		_g.h[584] = value;
	}
	{
		var value = texter_general_Char._new("ɉ");
		_g.h[585] = value;
	}
	{
		var value = texter_general_Char._new("Ɋ");
		_g.h[586] = value;
	}
	{
		var value = texter_general_Char._new("ɋ");
		_g.h[587] = value;
	}
	{
		var value = texter_general_Char._new("Ɍ");
		_g.h[588] = value;
	}
	{
		var value = texter_general_Char._new("ɍ");
		_g.h[589] = value;
	}
	{
		var value = texter_general_Char._new("Ɏ");
		_g.h[590] = value;
	}
	{
		var value = texter_general_Char._new("ɏ");
		_g.h[591] = value;
	}
	{
		var value = texter_general_Char._new("ɐ");
		_g.h[592] = value;
	}
	{
		var value = texter_general_Char._new("ɑ");
		_g.h[593] = value;
	}
	{
		var value = texter_general_Char._new("ɒ");
		_g.h[594] = value;
	}
	{
		var value = texter_general_Char._new("ɓ");
		_g.h[595] = value;
	}
	{
		var value = texter_general_Char._new("ɔ");
		_g.h[596] = value;
	}
	{
		var value = texter_general_Char._new("ɕ");
		_g.h[597] = value;
	}
	{
		var value = texter_general_Char._new("ɖ");
		_g.h[598] = value;
	}
	{
		var value = texter_general_Char._new("ɗ");
		_g.h[599] = value;
	}
	{
		var value = texter_general_Char._new("ɘ");
		_g.h[600] = value;
	}
	{
		var value = texter_general_Char._new("ə");
		_g.h[601] = value;
	}
	{
		var value = texter_general_Char._new("ɚ");
		_g.h[602] = value;
	}
	{
		var value = texter_general_Char._new("ɛ");
		_g.h[603] = value;
	}
	{
		var value = texter_general_Char._new("ɜ");
		_g.h[604] = value;
	}
	{
		var value = texter_general_Char._new("ɝ");
		_g.h[605] = value;
	}
	{
		var value = texter_general_Char._new("ɞ");
		_g.h[606] = value;
	}
	{
		var value = texter_general_Char._new("ɟ");
		_g.h[607] = value;
	}
	{
		var value = texter_general_Char._new("ɠ");
		_g.h[608] = value;
	}
	{
		var value = texter_general_Char._new("ɡ");
		_g.h[609] = value;
	}
	{
		var value = texter_general_Char._new("ɢ");
		_g.h[610] = value;
	}
	{
		var value = texter_general_Char._new("ɣ");
		_g.h[611] = value;
	}
	{
		var value = texter_general_Char._new("ɤ");
		_g.h[612] = value;
	}
	{
		var value = texter_general_Char._new("ɥ");
		_g.h[613] = value;
	}
	{
		var value = texter_general_Char._new("ɦ");
		_g.h[614] = value;
	}
	{
		var value = texter_general_Char._new("ɧ");
		_g.h[615] = value;
	}
	{
		var value = texter_general_Char._new("ɨ");
		_g.h[616] = value;
	}
	{
		var value = texter_general_Char._new("ɩ");
		_g.h[617] = value;
	}
	{
		var value = texter_general_Char._new("ɪ");
		_g.h[618] = value;
	}
	{
		var value = texter_general_Char._new("ɫ");
		_g.h[619] = value;
	}
	{
		var value = texter_general_Char._new("ɬ");
		_g.h[620] = value;
	}
	{
		var value = texter_general_Char._new("ɭ");
		_g.h[621] = value;
	}
	{
		var value = texter_general_Char._new("ɮ");
		_g.h[622] = value;
	}
	{
		var value = texter_general_Char._new("ɯ");
		_g.h[623] = value;
	}
	{
		var value = texter_general_Char._new("ɰ");
		_g.h[624] = value;
	}
	{
		var value = texter_general_Char._new("ɱ");
		_g.h[625] = value;
	}
	{
		var value = texter_general_Char._new("ɲ");
		_g.h[626] = value;
	}
	{
		var value = texter_general_Char._new("ɳ");
		_g.h[627] = value;
	}
	{
		var value = texter_general_Char._new("ɴ");
		_g.h[628] = value;
	}
	{
		var value = texter_general_Char._new("ɵ");
		_g.h[629] = value;
	}
	{
		var value = texter_general_Char._new("ɶ");
		_g.h[630] = value;
	}
	{
		var value = texter_general_Char._new("ɷ");
		_g.h[631] = value;
	}
	{
		var value = texter_general_Char._new("ɸ");
		_g.h[632] = value;
	}
	{
		var value = texter_general_Char._new("ɹ");
		_g.h[633] = value;
	}
	{
		var value = texter_general_Char._new("ɺ");
		_g.h[634] = value;
	}
	{
		var value = texter_general_Char._new("ɻ");
		_g.h[635] = value;
	}
	{
		var value = texter_general_Char._new("ɼ");
		_g.h[636] = value;
	}
	{
		var value = texter_general_Char._new("ɽ");
		_g.h[637] = value;
	}
	{
		var value = texter_general_Char._new("ɾ");
		_g.h[638] = value;
	}
	{
		var value = texter_general_Char._new("ɿ");
		_g.h[639] = value;
	}
	{
		var value = texter_general_Char._new("ʀ");
		_g.h[640] = value;
	}
	{
		var value = texter_general_Char._new("ʁ");
		_g.h[641] = value;
	}
	{
		var value = texter_general_Char._new("ʂ");
		_g.h[642] = value;
	}
	{
		var value = texter_general_Char._new("ʃ");
		_g.h[643] = value;
	}
	{
		var value = texter_general_Char._new("ʄ");
		_g.h[644] = value;
	}
	{
		var value = texter_general_Char._new("ʅ");
		_g.h[645] = value;
	}
	{
		var value = texter_general_Char._new("ʆ");
		_g.h[646] = value;
	}
	{
		var value = texter_general_Char._new("ʇ");
		_g.h[647] = value;
	}
	{
		var value = texter_general_Char._new("ʈ");
		_g.h[648] = value;
	}
	{
		var value = texter_general_Char._new("ʉ");
		_g.h[649] = value;
	}
	{
		var value = texter_general_Char._new("ʊ");
		_g.h[650] = value;
	}
	{
		var value = texter_general_Char._new("ʋ");
		_g.h[651] = value;
	}
	{
		var value = texter_general_Char._new("ʌ");
		_g.h[652] = value;
	}
	{
		var value = texter_general_Char._new("ʍ");
		_g.h[653] = value;
	}
	{
		var value = texter_general_Char._new("ʎ");
		_g.h[654] = value;
	}
	{
		var value = texter_general_Char._new("ʏ");
		_g.h[655] = value;
	}
	{
		var value = texter_general_Char._new("ʐ");
		_g.h[656] = value;
	}
	{
		var value = texter_general_Char._new("ʑ");
		_g.h[657] = value;
	}
	{
		var value = texter_general_Char._new("ʒ");
		_g.h[658] = value;
	}
	{
		var value = texter_general_Char._new("ʓ");
		_g.h[659] = value;
	}
	{
		var value = texter_general_Char._new("ʔ");
		_g.h[660] = value;
	}
	{
		var value = texter_general_Char._new("ʕ");
		_g.h[661] = value;
	}
	{
		var value = texter_general_Char._new("ʖ");
		_g.h[662] = value;
	}
	{
		var value = texter_general_Char._new("ʗ");
		_g.h[663] = value;
	}
	{
		var value = texter_general_Char._new("ʘ");
		_g.h[664] = value;
	}
	{
		var value = texter_general_Char._new("ʙ");
		_g.h[665] = value;
	}
	{
		var value = texter_general_Char._new("ʚ");
		_g.h[666] = value;
	}
	{
		var value = texter_general_Char._new("ʛ");
		_g.h[667] = value;
	}
	{
		var value = texter_general_Char._new("ʜ");
		_g.h[668] = value;
	}
	{
		var value = texter_general_Char._new("ʝ");
		_g.h[669] = value;
	}
	{
		var value = texter_general_Char._new("ʞ");
		_g.h[670] = value;
	}
	{
		var value = texter_general_Char._new("ʟ");
		_g.h[671] = value;
	}
	{
		var value = texter_general_Char._new("ʠ");
		_g.h[672] = value;
	}
	{
		var value = texter_general_Char._new("ʡ");
		_g.h[673] = value;
	}
	{
		var value = texter_general_Char._new("ʢ");
		_g.h[674] = value;
	}
	{
		var value = texter_general_Char._new("ʣ");
		_g.h[675] = value;
	}
	{
		var value = texter_general_Char._new("ʤ");
		_g.h[676] = value;
	}
	{
		var value = texter_general_Char._new("ʥ");
		_g.h[677] = value;
	}
	{
		var value = texter_general_Char._new("ʦ");
		_g.h[678] = value;
	}
	{
		var value = texter_general_Char._new("ʧ");
		_g.h[679] = value;
	}
	{
		var value = texter_general_Char._new("ʨ");
		_g.h[680] = value;
	}
	{
		var value = texter_general_Char._new("ʩ");
		_g.h[681] = value;
	}
	{
		var value = texter_general_Char._new("ʪ");
		_g.h[682] = value;
	}
	{
		var value = texter_general_Char._new("ʫ");
		_g.h[683] = value;
	}
	{
		var value = texter_general_Char._new("ʬ");
		_g.h[684] = value;
	}
	{
		var value = texter_general_Char._new("ʭ");
		_g.h[685] = value;
	}
	{
		var value = texter_general_Char._new("ʮ");
		_g.h[686] = value;
	}
	{
		var value = texter_general_Char._new("ʯ");
		_g.h[687] = value;
	}
	{
		var value = texter_general_Char._new("ʰ");
		_g.h[688] = value;
	}
	{
		var value = texter_general_Char._new("ʱ");
		_g.h[689] = value;
	}
	{
		var value = texter_general_Char._new("ʲ");
		_g.h[690] = value;
	}
	{
		var value = texter_general_Char._new("ʳ");
		_g.h[691] = value;
	}
	{
		var value = texter_general_Char._new("ʴ");
		_g.h[692] = value;
	}
	{
		var value = texter_general_Char._new("ʵ");
		_g.h[693] = value;
	}
	{
		var value = texter_general_Char._new("ʶ");
		_g.h[694] = value;
	}
	{
		var value = texter_general_Char._new("ʷ");
		_g.h[695] = value;
	}
	{
		var value = texter_general_Char._new("ʸ");
		_g.h[696] = value;
	}
	{
		var value = texter_general_Char._new("ʹ");
		_g.h[697] = value;
	}
	{
		var value = texter_general_Char._new("ʺ");
		_g.h[698] = value;
	}
	{
		var value = texter_general_Char._new("ʻ");
		_g.h[699] = value;
	}
	{
		var value = texter_general_Char._new("ʼ");
		_g.h[700] = value;
	}
	{
		var value = texter_general_Char._new("ʽ");
		_g.h[701] = value;
	}
	{
		var value = texter_general_Char._new("ʾ");
		_g.h[702] = value;
	}
	{
		var value = texter_general_Char._new("ʿ");
		_g.h[703] = value;
	}
	{
		var value = texter_general_Char._new("ˀ");
		_g.h[704] = value;
	}
	{
		var value = texter_general_Char._new("ˁ");
		_g.h[705] = value;
	}
	{
		var value = texter_general_Char._new("˂");
		_g.h[706] = value;
	}
	{
		var value = texter_general_Char._new("˃");
		_g.h[707] = value;
	}
	{
		var value = texter_general_Char._new("˄");
		_g.h[708] = value;
	}
	{
		var value = texter_general_Char._new("˅");
		_g.h[709] = value;
	}
	{
		var value = texter_general_Char._new("ˆ");
		_g.h[710] = value;
	}
	{
		var value = texter_general_Char._new("ˇ");
		_g.h[711] = value;
	}
	{
		var value = texter_general_Char._new("ˈ");
		_g.h[712] = value;
	}
	{
		var value = texter_general_Char._new("ˉ");
		_g.h[713] = value;
	}
	{
		var value = texter_general_Char._new("ˊ");
		_g.h[714] = value;
	}
	{
		var value = texter_general_Char._new("ˋ");
		_g.h[715] = value;
	}
	{
		var value = texter_general_Char._new("ˌ");
		_g.h[716] = value;
	}
	{
		var value = texter_general_Char._new("ˍ");
		_g.h[717] = value;
	}
	{
		var value = texter_general_Char._new("ˎ");
		_g.h[718] = value;
	}
	{
		var value = texter_general_Char._new("ˏ");
		_g.h[719] = value;
	}
	{
		var value = texter_general_Char._new("ː");
		_g.h[720] = value;
	}
	{
		var value = texter_general_Char._new("ˑ");
		_g.h[721] = value;
	}
	{
		var value = texter_general_Char._new("˒");
		_g.h[722] = value;
	}
	{
		var value = texter_general_Char._new("˓");
		_g.h[723] = value;
	}
	{
		var value = texter_general_Char._new("˔");
		_g.h[724] = value;
	}
	{
		var value = texter_general_Char._new("˕");
		_g.h[725] = value;
	}
	{
		var value = texter_general_Char._new("˖");
		_g.h[726] = value;
	}
	{
		var value = texter_general_Char._new("˗");
		_g.h[727] = value;
	}
	{
		var value = texter_general_Char._new("˘");
		_g.h[728] = value;
	}
	{
		var value = texter_general_Char._new("˙");
		_g.h[729] = value;
	}
	{
		var value = texter_general_Char._new("˚");
		_g.h[730] = value;
	}
	{
		var value = texter_general_Char._new("˛");
		_g.h[731] = value;
	}
	{
		var value = texter_general_Char._new("˜");
		_g.h[732] = value;
	}
	{
		var value = texter_general_Char._new("˝");
		_g.h[733] = value;
	}
	{
		var value = texter_general_Char._new("˞");
		_g.h[734] = value;
	}
	{
		var value = texter_general_Char._new("˟");
		_g.h[735] = value;
	}
	{
		var value = texter_general_Char._new("ˠ");
		_g.h[736] = value;
	}
	{
		var value = texter_general_Char._new("ˡ");
		_g.h[737] = value;
	}
	{
		var value = texter_general_Char._new("ˢ");
		_g.h[738] = value;
	}
	{
		var value = texter_general_Char._new("ˣ");
		_g.h[739] = value;
	}
	{
		var value = texter_general_Char._new("ˤ");
		_g.h[740] = value;
	}
	{
		var value = texter_general_Char._new("˥");
		_g.h[741] = value;
	}
	{
		var value = texter_general_Char._new("˦");
		_g.h[742] = value;
	}
	{
		var value = texter_general_Char._new("˧");
		_g.h[743] = value;
	}
	{
		var value = texter_general_Char._new("˨");
		_g.h[744] = value;
	}
	{
		var value = texter_general_Char._new("˩");
		_g.h[745] = value;
	}
	{
		var value = texter_general_Char._new("˪");
		_g.h[746] = value;
	}
	{
		var value = texter_general_Char._new("˫");
		_g.h[747] = value;
	}
	{
		var value = texter_general_Char._new("ˬ");
		_g.h[748] = value;
	}
	{
		var value = texter_general_Char._new("˭");
		_g.h[749] = value;
	}
	{
		var value = texter_general_Char._new("ˮ");
		_g.h[750] = value;
	}
	{
		var value = texter_general_Char._new("˯");
		_g.h[751] = value;
	}
	{
		var value = texter_general_Char._new("˰");
		_g.h[752] = value;
	}
	{
		var value = texter_general_Char._new("˱");
		_g.h[753] = value;
	}
	{
		var value = texter_general_Char._new("˲");
		_g.h[754] = value;
	}
	{
		var value = texter_general_Char._new("˳");
		_g.h[755] = value;
	}
	{
		var value = texter_general_Char._new("˴");
		_g.h[756] = value;
	}
	{
		var value = texter_general_Char._new("˵");
		_g.h[757] = value;
	}
	{
		var value = texter_general_Char._new("˶");
		_g.h[758] = value;
	}
	{
		var value = texter_general_Char._new("˷");
		_g.h[759] = value;
	}
	{
		var value = texter_general_Char._new("˸");
		_g.h[760] = value;
	}
	{
		var value = texter_general_Char._new("˹");
		_g.h[761] = value;
	}
	{
		var value = texter_general_Char._new("˺");
		_g.h[762] = value;
	}
	{
		var value = texter_general_Char._new("˻");
		_g.h[763] = value;
	}
	{
		var value = texter_general_Char._new("˼");
		_g.h[764] = value;
	}
	{
		var value = texter_general_Char._new("˽");
		_g.h[765] = value;
	}
	{
		var value = texter_general_Char._new("˾");
		_g.h[766] = value;
	}
	{
		var value = texter_general_Char._new("˿");
		_g.h[767] = value;
	}
	{
		var value = texter_general_Char._new("̀");
		_g.h[768] = value;
	}
	{
		var value = texter_general_Char._new("́");
		_g.h[769] = value;
	}
	{
		var value = texter_general_Char._new("̂");
		_g.h[770] = value;
	}
	{
		var value = texter_general_Char._new("̃");
		_g.h[771] = value;
	}
	{
		var value = texter_general_Char._new("̄");
		_g.h[772] = value;
	}
	{
		var value = texter_general_Char._new("̅");
		_g.h[773] = value;
	}
	{
		var value = texter_general_Char._new("̆");
		_g.h[774] = value;
	}
	{
		var value = texter_general_Char._new("̇");
		_g.h[775] = value;
	}
	{
		var value = texter_general_Char._new("̈");
		_g.h[776] = value;
	}
	{
		var value = texter_general_Char._new("̉");
		_g.h[777] = value;
	}
	{
		var value = texter_general_Char._new("̊");
		_g.h[778] = value;
	}
	{
		var value = texter_general_Char._new("̋");
		_g.h[779] = value;
	}
	{
		var value = texter_general_Char._new("̌");
		_g.h[780] = value;
	}
	{
		var value = texter_general_Char._new("̍");
		_g.h[781] = value;
	}
	{
		var value = texter_general_Char._new("̎");
		_g.h[782] = value;
	}
	{
		var value = texter_general_Char._new("̏");
		_g.h[783] = value;
	}
	{
		var value = texter_general_Char._new("̐");
		_g.h[784] = value;
	}
	{
		var value = texter_general_Char._new("̑");
		_g.h[785] = value;
	}
	{
		var value = texter_general_Char._new("̒");
		_g.h[786] = value;
	}
	{
		var value = texter_general_Char._new("̓");
		_g.h[787] = value;
	}
	{
		var value = texter_general_Char._new("̔");
		_g.h[788] = value;
	}
	{
		var value = texter_general_Char._new("̕");
		_g.h[789] = value;
	}
	{
		var value = texter_general_Char._new("̖");
		_g.h[790] = value;
	}
	{
		var value = texter_general_Char._new("̗");
		_g.h[791] = value;
	}
	{
		var value = texter_general_Char._new("̘");
		_g.h[792] = value;
	}
	{
		var value = texter_general_Char._new("̙");
		_g.h[793] = value;
	}
	{
		var value = texter_general_Char._new("̚");
		_g.h[794] = value;
	}
	{
		var value = texter_general_Char._new("̛");
		_g.h[795] = value;
	}
	{
		var value = texter_general_Char._new("̜");
		_g.h[796] = value;
	}
	{
		var value = texter_general_Char._new("̝");
		_g.h[797] = value;
	}
	{
		var value = texter_general_Char._new("̞");
		_g.h[798] = value;
	}
	{
		var value = texter_general_Char._new("̟");
		_g.h[799] = value;
	}
	{
		var value = texter_general_Char._new("̠");
		_g.h[800] = value;
	}
	{
		var value = texter_general_Char._new("̡");
		_g.h[801] = value;
	}
	{
		var value = texter_general_Char._new("̢");
		_g.h[802] = value;
	}
	{
		var value = texter_general_Char._new("̣");
		_g.h[803] = value;
	}
	{
		var value = texter_general_Char._new("̤");
		_g.h[804] = value;
	}
	{
		var value = texter_general_Char._new("̥");
		_g.h[805] = value;
	}
	{
		var value = texter_general_Char._new("̦");
		_g.h[806] = value;
	}
	{
		var value = texter_general_Char._new("̧");
		_g.h[807] = value;
	}
	{
		var value = texter_general_Char._new("̨");
		_g.h[808] = value;
	}
	{
		var value = texter_general_Char._new("̩");
		_g.h[809] = value;
	}
	{
		var value = texter_general_Char._new("̪");
		_g.h[810] = value;
	}
	{
		var value = texter_general_Char._new("̫");
		_g.h[811] = value;
	}
	{
		var value = texter_general_Char._new("̬");
		_g.h[812] = value;
	}
	{
		var value = texter_general_Char._new("̭");
		_g.h[813] = value;
	}
	{
		var value = texter_general_Char._new("̮");
		_g.h[814] = value;
	}
	{
		var value = texter_general_Char._new("̯");
		_g.h[815] = value;
	}
	{
		var value = texter_general_Char._new("̰");
		_g.h[816] = value;
	}
	{
		var value = texter_general_Char._new("̱");
		_g.h[817] = value;
	}
	{
		var value = texter_general_Char._new("̲");
		_g.h[818] = value;
	}
	{
		var value = texter_general_Char._new("̳");
		_g.h[819] = value;
	}
	{
		var value = texter_general_Char._new("̴");
		_g.h[820] = value;
	}
	{
		var value = texter_general_Char._new("̵");
		_g.h[821] = value;
	}
	{
		var value = texter_general_Char._new("̶");
		_g.h[822] = value;
	}
	{
		var value = texter_general_Char._new("̷");
		_g.h[823] = value;
	}
	{
		var value = texter_general_Char._new("̸");
		_g.h[824] = value;
	}
	{
		var value = texter_general_Char._new("̹");
		_g.h[825] = value;
	}
	{
		var value = texter_general_Char._new("̺");
		_g.h[826] = value;
	}
	{
		var value = texter_general_Char._new("̻");
		_g.h[827] = value;
	}
	{
		var value = texter_general_Char._new("̼");
		_g.h[828] = value;
	}
	{
		var value = texter_general_Char._new("̽");
		_g.h[829] = value;
	}
	{
		var value = texter_general_Char._new("̾");
		_g.h[830] = value;
	}
	{
		var value = texter_general_Char._new("̿");
		_g.h[831] = value;
	}
	{
		var value = texter_general_Char._new("̀");
		_g.h[832] = value;
	}
	{
		var value = texter_general_Char._new("́");
		_g.h[833] = value;
	}
	{
		var value = texter_general_Char._new("͂");
		_g.h[834] = value;
	}
	{
		var value = texter_general_Char._new("̓");
		_g.h[835] = value;
	}
	{
		var value = texter_general_Char._new("̈́");
		_g.h[836] = value;
	}
	{
		var value = texter_general_Char._new("ͅ");
		_g.h[837] = value;
	}
	{
		var value = texter_general_Char._new("͆");
		_g.h[838] = value;
	}
	{
		var value = texter_general_Char._new("͇");
		_g.h[839] = value;
	}
	{
		var value = texter_general_Char._new("͈");
		_g.h[840] = value;
	}
	{
		var value = texter_general_Char._new("͉");
		_g.h[841] = value;
	}
	{
		var value = texter_general_Char._new("͊");
		_g.h[842] = value;
	}
	{
		var value = texter_general_Char._new("͋");
		_g.h[843] = value;
	}
	{
		var value = texter_general_Char._new("͌");
		_g.h[844] = value;
	}
	{
		var value = texter_general_Char._new("͍");
		_g.h[845] = value;
	}
	{
		var value = texter_general_Char._new("͎");
		_g.h[846] = value;
	}
	{
		var value = texter_general_Char._new("͏");
		_g.h[847] = value;
	}
	{
		var value = texter_general_Char._new("͐");
		_g.h[848] = value;
	}
	{
		var value = texter_general_Char._new("͑");
		_g.h[849] = value;
	}
	{
		var value = texter_general_Char._new("͒");
		_g.h[850] = value;
	}
	{
		var value = texter_general_Char._new("͓");
		_g.h[851] = value;
	}
	{
		var value = texter_general_Char._new("͔");
		_g.h[852] = value;
	}
	{
		var value = texter_general_Char._new("͕");
		_g.h[853] = value;
	}
	{
		var value = texter_general_Char._new("͖");
		_g.h[854] = value;
	}
	{
		var value = texter_general_Char._new("͗");
		_g.h[855] = value;
	}
	{
		var value = texter_general_Char._new("͘");
		_g.h[856] = value;
	}
	{
		var value = texter_general_Char._new("͙");
		_g.h[857] = value;
	}
	{
		var value = texter_general_Char._new("͚");
		_g.h[858] = value;
	}
	{
		var value = texter_general_Char._new("͛");
		_g.h[859] = value;
	}
	{
		var value = texter_general_Char._new("͜");
		_g.h[860] = value;
	}
	{
		var value = texter_general_Char._new("͝");
		_g.h[861] = value;
	}
	{
		var value = texter_general_Char._new("͞");
		_g.h[862] = value;
	}
	{
		var value = texter_general_Char._new("͟");
		_g.h[863] = value;
	}
	{
		var value = texter_general_Char._new("͠");
		_g.h[864] = value;
	}
	{
		var value = texter_general_Char._new("͡");
		_g.h[865] = value;
	}
	{
		var value = texter_general_Char._new("͢");
		_g.h[866] = value;
	}
	{
		var value = texter_general_Char._new("ͣ");
		_g.h[867] = value;
	}
	{
		var value = texter_general_Char._new("ͤ");
		_g.h[868] = value;
	}
	{
		var value = texter_general_Char._new("ͥ");
		_g.h[869] = value;
	}
	{
		var value = texter_general_Char._new("ͦ");
		_g.h[870] = value;
	}
	{
		var value = texter_general_Char._new("ͧ");
		_g.h[871] = value;
	}
	{
		var value = texter_general_Char._new("ͨ");
		_g.h[872] = value;
	}
	{
		var value = texter_general_Char._new("ͩ");
		_g.h[873] = value;
	}
	{
		var value = texter_general_Char._new("ͪ");
		_g.h[874] = value;
	}
	{
		var value = texter_general_Char._new("ͫ");
		_g.h[875] = value;
	}
	{
		var value = texter_general_Char._new("ͬ");
		_g.h[876] = value;
	}
	{
		var value = texter_general_Char._new("ͭ");
		_g.h[877] = value;
	}
	{
		var value = texter_general_Char._new("ͮ");
		_g.h[878] = value;
	}
	{
		var value = texter_general_Char._new("ͯ");
		_g.h[879] = value;
	}
	{
		var value = texter_general_Char._new("Ͱ");
		_g.h[880] = value;
	}
	{
		var value = texter_general_Char._new("ͱ");
		_g.h[881] = value;
	}
	{
		var value = texter_general_Char._new("Ͳ");
		_g.h[882] = value;
	}
	{
		var value = texter_general_Char._new("ͳ");
		_g.h[883] = value;
	}
	{
		var value = texter_general_Char._new("ʹ");
		_g.h[884] = value;
	}
	{
		var value = texter_general_Char._new("͵");
		_g.h[885] = value;
	}
	{
		var value = texter_general_Char._new("Ͷ");
		_g.h[886] = value;
	}
	{
		var value = texter_general_Char._new("ͷ");
		_g.h[887] = value;
	}
	{
		var value = texter_general_Char._new("͸");
		_g.h[888] = value;
	}
	{
		var value = texter_general_Char._new("͹");
		_g.h[889] = value;
	}
	{
		var value = texter_general_Char._new("ͺ");
		_g.h[890] = value;
	}
	{
		var value = texter_general_Char._new("ͻ");
		_g.h[891] = value;
	}
	{
		var value = texter_general_Char._new("ͼ");
		_g.h[892] = value;
	}
	{
		var value = texter_general_Char._new("ͽ");
		_g.h[893] = value;
	}
	{
		var value = texter_general_Char._new(";");
		_g.h[894] = value;
	}
	{
		var value = texter_general_Char._new("Ϳ");
		_g.h[895] = value;
	}
	{
		var value = texter_general_Char._new("΀");
		_g.h[896] = value;
	}
	{
		var value = texter_general_Char._new("΁");
		_g.h[897] = value;
	}
	{
		var value = texter_general_Char._new("΂");
		_g.h[898] = value;
	}
	{
		var value = texter_general_Char._new("΃");
		_g.h[899] = value;
	}
	{
		var value = texter_general_Char._new("΄");
		_g.h[900] = value;
	}
	{
		var value = texter_general_Char._new("΅");
		_g.h[901] = value;
	}
	{
		var value = texter_general_Char._new("Ά");
		_g.h[902] = value;
	}
	{
		var value = texter_general_Char._new("·");
		_g.h[903] = value;
	}
	{
		var value = texter_general_Char._new("Έ");
		_g.h[904] = value;
	}
	{
		var value = texter_general_Char._new("Ή");
		_g.h[905] = value;
	}
	{
		var value = texter_general_Char._new("Ί");
		_g.h[906] = value;
	}
	{
		var value = texter_general_Char._new("΋");
		_g.h[907] = value;
	}
	{
		var value = texter_general_Char._new("Ό");
		_g.h[908] = value;
	}
	{
		var value = texter_general_Char._new("΍");
		_g.h[909] = value;
	}
	{
		var value = texter_general_Char._new("Ύ");
		_g.h[910] = value;
	}
	{
		var value = texter_general_Char._new("Ώ");
		_g.h[911] = value;
	}
	{
		var value = texter_general_Char._new("ΐ");
		_g.h[912] = value;
	}
	{
		var value = texter_general_Char._new("Α");
		_g.h[913] = value;
	}
	{
		var value = texter_general_Char._new("Β");
		_g.h[914] = value;
	}
	{
		var value = texter_general_Char._new("Γ");
		_g.h[915] = value;
	}
	{
		var value = texter_general_Char._new("Δ");
		_g.h[916] = value;
	}
	{
		var value = texter_general_Char._new("Ε");
		_g.h[917] = value;
	}
	{
		var value = texter_general_Char._new("Ζ");
		_g.h[918] = value;
	}
	{
		var value = texter_general_Char._new("Η");
		_g.h[919] = value;
	}
	{
		var value = texter_general_Char._new("Θ");
		_g.h[920] = value;
	}
	{
		var value = texter_general_Char._new("Ι");
		_g.h[921] = value;
	}
	{
		var value = texter_general_Char._new("Κ");
		_g.h[922] = value;
	}
	{
		var value = texter_general_Char._new("Λ");
		_g.h[923] = value;
	}
	{
		var value = texter_general_Char._new("Μ");
		_g.h[924] = value;
	}
	{
		var value = texter_general_Char._new("Ν");
		_g.h[925] = value;
	}
	{
		var value = texter_general_Char._new("Ξ");
		_g.h[926] = value;
	}
	{
		var value = texter_general_Char._new("Ο");
		_g.h[927] = value;
	}
	{
		var value = texter_general_Char._new("Π");
		_g.h[928] = value;
	}
	{
		var value = texter_general_Char._new("Ρ");
		_g.h[929] = value;
	}
	{
		var value = texter_general_Char._new("΢");
		_g.h[930] = value;
	}
	{
		var value = texter_general_Char._new("Σ");
		_g.h[931] = value;
	}
	{
		var value = texter_general_Char._new("Τ");
		_g.h[932] = value;
	}
	{
		var value = texter_general_Char._new("Υ");
		_g.h[933] = value;
	}
	{
		var value = texter_general_Char._new("Φ");
		_g.h[934] = value;
	}
	{
		var value = texter_general_Char._new("Χ");
		_g.h[935] = value;
	}
	{
		var value = texter_general_Char._new("Ψ");
		_g.h[936] = value;
	}
	{
		var value = texter_general_Char._new("Ω");
		_g.h[937] = value;
	}
	{
		var value = texter_general_Char._new("Ϊ");
		_g.h[938] = value;
	}
	{
		var value = texter_general_Char._new("Ϋ");
		_g.h[939] = value;
	}
	{
		var value = texter_general_Char._new("ά");
		_g.h[940] = value;
	}
	{
		var value = texter_general_Char._new("έ");
		_g.h[941] = value;
	}
	{
		var value = texter_general_Char._new("ή");
		_g.h[942] = value;
	}
	{
		var value = texter_general_Char._new("ί");
		_g.h[943] = value;
	}
	{
		var value = texter_general_Char._new("ΰ");
		_g.h[944] = value;
	}
	{
		var value = texter_general_Char._new("α");
		_g.h[945] = value;
	}
	{
		var value = texter_general_Char._new("β");
		_g.h[946] = value;
	}
	{
		var value = texter_general_Char._new("γ");
		_g.h[947] = value;
	}
	{
		var value = texter_general_Char._new("δ");
		_g.h[948] = value;
	}
	{
		var value = texter_general_Char._new("ε");
		_g.h[949] = value;
	}
	{
		var value = texter_general_Char._new("ζ");
		_g.h[950] = value;
	}
	{
		var value = texter_general_Char._new("η");
		_g.h[951] = value;
	}
	{
		var value = texter_general_Char._new("θ");
		_g.h[952] = value;
	}
	{
		var value = texter_general_Char._new("ι");
		_g.h[953] = value;
	}
	{
		var value = texter_general_Char._new("κ");
		_g.h[954] = value;
	}
	{
		var value = texter_general_Char._new("λ");
		_g.h[955] = value;
	}
	{
		var value = texter_general_Char._new("μ");
		_g.h[956] = value;
	}
	{
		var value = texter_general_Char._new("ν");
		_g.h[957] = value;
	}
	{
		var value = texter_general_Char._new("ξ");
		_g.h[958] = value;
	}
	{
		var value = texter_general_Char._new("ο");
		_g.h[959] = value;
	}
	{
		var value = texter_general_Char._new("π");
		_g.h[960] = value;
	}
	{
		var value = texter_general_Char._new("ρ");
		_g.h[961] = value;
	}
	{
		var value = texter_general_Char._new("ς");
		_g.h[962] = value;
	}
	{
		var value = texter_general_Char._new("σ");
		_g.h[963] = value;
	}
	{
		var value = texter_general_Char._new("τ");
		_g.h[964] = value;
	}
	{
		var value = texter_general_Char._new("υ");
		_g.h[965] = value;
	}
	{
		var value = texter_general_Char._new("φ");
		_g.h[966] = value;
	}
	{
		var value = texter_general_Char._new("χ");
		_g.h[967] = value;
	}
	{
		var value = texter_general_Char._new("ψ");
		_g.h[968] = value;
	}
	{
		var value = texter_general_Char._new("ω");
		_g.h[969] = value;
	}
	{
		var value = texter_general_Char._new("ϊ");
		_g.h[970] = value;
	}
	{
		var value = texter_general_Char._new("ϋ");
		_g.h[971] = value;
	}
	{
		var value = texter_general_Char._new("ό");
		_g.h[972] = value;
	}
	{
		var value = texter_general_Char._new("ύ");
		_g.h[973] = value;
	}
	{
		var value = texter_general_Char._new("ώ");
		_g.h[974] = value;
	}
	{
		var value = texter_general_Char._new("Ϗ");
		_g.h[975] = value;
	}
	{
		var value = texter_general_Char._new("ϐ");
		_g.h[976] = value;
	}
	{
		var value = texter_general_Char._new("ϑ");
		_g.h[977] = value;
	}
	{
		var value = texter_general_Char._new("ϒ");
		_g.h[978] = value;
	}
	{
		var value = texter_general_Char._new("ϓ");
		_g.h[979] = value;
	}
	{
		var value = texter_general_Char._new("ϔ");
		_g.h[980] = value;
	}
	{
		var value = texter_general_Char._new("ϕ");
		_g.h[981] = value;
	}
	{
		var value = texter_general_Char._new("ϖ");
		_g.h[982] = value;
	}
	{
		var value = texter_general_Char._new("ϗ");
		_g.h[983] = value;
	}
	{
		var value = texter_general_Char._new("Ϙ");
		_g.h[984] = value;
	}
	{
		var value = texter_general_Char._new("ϙ");
		_g.h[985] = value;
	}
	{
		var value = texter_general_Char._new("Ϛ");
		_g.h[986] = value;
	}
	{
		var value = texter_general_Char._new("ϛ");
		_g.h[987] = value;
	}
	{
		var value = texter_general_Char._new("Ϝ");
		_g.h[988] = value;
	}
	{
		var value = texter_general_Char._new("ϝ");
		_g.h[989] = value;
	}
	{
		var value = texter_general_Char._new("Ϟ");
		_g.h[990] = value;
	}
	{
		var value = texter_general_Char._new("ϟ");
		_g.h[991] = value;
	}
	{
		var value = texter_general_Char._new("Ϡ");
		_g.h[992] = value;
	}
	{
		var value = texter_general_Char._new("ϡ");
		_g.h[993] = value;
	}
	{
		var value = texter_general_Char._new("Ϣ");
		_g.h[994] = value;
	}
	{
		var value = texter_general_Char._new("ϣ");
		_g.h[995] = value;
	}
	{
		var value = texter_general_Char._new("Ϥ");
		_g.h[996] = value;
	}
	{
		var value = texter_general_Char._new("ϥ");
		_g.h[997] = value;
	}
	{
		var value = texter_general_Char._new("Ϧ");
		_g.h[998] = value;
	}
	{
		var value = texter_general_Char._new("ϧ");
		_g.h[999] = value;
	}
	{
		var value = texter_general_Char._new("Ϩ");
		_g.h[1000] = value;
	}
	{
		var value = texter_general_Char._new("ϩ");
		_g.h[1001] = value;
	}
	{
		var value = texter_general_Char._new("Ϫ");
		_g.h[1002] = value;
	}
	{
		var value = texter_general_Char._new("ϫ");
		_g.h[1003] = value;
	}
	{
		var value = texter_general_Char._new("Ϭ");
		_g.h[1004] = value;
	}
	{
		var value = texter_general_Char._new("ϭ");
		_g.h[1005] = value;
	}
	{
		var value = texter_general_Char._new("Ϯ");
		_g.h[1006] = value;
	}
	{
		var value = texter_general_Char._new("ϯ");
		_g.h[1007] = value;
	}
	{
		var value = texter_general_Char._new("ϰ");
		_g.h[1008] = value;
	}
	{
		var value = texter_general_Char._new("ϱ");
		_g.h[1009] = value;
	}
	{
		var value = texter_general_Char._new("ϲ");
		_g.h[1010] = value;
	}
	{
		var value = texter_general_Char._new("ϳ");
		_g.h[1011] = value;
	}
	{
		var value = texter_general_Char._new("ϴ");
		_g.h[1012] = value;
	}
	{
		var value = texter_general_Char._new("ϵ");
		_g.h[1013] = value;
	}
	{
		var value = texter_general_Char._new("϶");
		_g.h[1014] = value;
	}
	{
		var value = texter_general_Char._new("Ϸ");
		_g.h[1015] = value;
	}
	{
		var value = texter_general_Char._new("ϸ");
		_g.h[1016] = value;
	}
	{
		var value = texter_general_Char._new("Ϲ");
		_g.h[1017] = value;
	}
	{
		var value = texter_general_Char._new("Ϻ");
		_g.h[1018] = value;
	}
	{
		var value = texter_general_Char._new("ϻ");
		_g.h[1019] = value;
	}
	{
		var value = texter_general_Char._new("ϼ");
		_g.h[1020] = value;
	}
	{
		var value = texter_general_Char._new("Ͻ");
		_g.h[1021] = value;
	}
	{
		var value = texter_general_Char._new("Ͼ");
		_g.h[1022] = value;
	}
	{
		var value = texter_general_Char._new("Ͽ");
		_g.h[1023] = value;
	}
	{
		var value = texter_general_Char._new("Ѐ");
		_g.h[1024] = value;
	}
	{
		var value = texter_general_Char._new("Ё");
		_g.h[1025] = value;
	}
	{
		var value = texter_general_Char._new("Ђ");
		_g.h[1026] = value;
	}
	{
		var value = texter_general_Char._new("Ѓ");
		_g.h[1027] = value;
	}
	{
		var value = texter_general_Char._new("Є");
		_g.h[1028] = value;
	}
	{
		var value = texter_general_Char._new("Ѕ");
		_g.h[1029] = value;
	}
	{
		var value = texter_general_Char._new("І");
		_g.h[1030] = value;
	}
	{
		var value = texter_general_Char._new("Ї");
		_g.h[1031] = value;
	}
	{
		var value = texter_general_Char._new("Ј");
		_g.h[1032] = value;
	}
	{
		var value = texter_general_Char._new("Љ");
		_g.h[1033] = value;
	}
	{
		var value = texter_general_Char._new("Њ");
		_g.h[1034] = value;
	}
	{
		var value = texter_general_Char._new("Ћ");
		_g.h[1035] = value;
	}
	{
		var value = texter_general_Char._new("Ќ");
		_g.h[1036] = value;
	}
	{
		var value = texter_general_Char._new("Ѝ");
		_g.h[1037] = value;
	}
	{
		var value = texter_general_Char._new("Ў");
		_g.h[1038] = value;
	}
	{
		var value = texter_general_Char._new("Џ");
		_g.h[1039] = value;
	}
	{
		var value = texter_general_Char._new("А");
		_g.h[1040] = value;
	}
	{
		var value = texter_general_Char._new("Б");
		_g.h[1041] = value;
	}
	{
		var value = texter_general_Char._new("В");
		_g.h[1042] = value;
	}
	{
		var value = texter_general_Char._new("Г");
		_g.h[1043] = value;
	}
	{
		var value = texter_general_Char._new("Д");
		_g.h[1044] = value;
	}
	{
		var value = texter_general_Char._new("Е");
		_g.h[1045] = value;
	}
	{
		var value = texter_general_Char._new("Ж");
		_g.h[1046] = value;
	}
	{
		var value = texter_general_Char._new("З");
		_g.h[1047] = value;
	}
	{
		var value = texter_general_Char._new("И");
		_g.h[1048] = value;
	}
	{
		var value = texter_general_Char._new("Й");
		_g.h[1049] = value;
	}
	{
		var value = texter_general_Char._new("К");
		_g.h[1050] = value;
	}
	{
		var value = texter_general_Char._new("Л");
		_g.h[1051] = value;
	}
	{
		var value = texter_general_Char._new("М");
		_g.h[1052] = value;
	}
	{
		var value = texter_general_Char._new("Н");
		_g.h[1053] = value;
	}
	{
		var value = texter_general_Char._new("О");
		_g.h[1054] = value;
	}
	{
		var value = texter_general_Char._new("П");
		_g.h[1055] = value;
	}
	{
		var value = texter_general_Char._new("Р");
		_g.h[1056] = value;
	}
	{
		var value = texter_general_Char._new("С");
		_g.h[1057] = value;
	}
	{
		var value = texter_general_Char._new("Т");
		_g.h[1058] = value;
	}
	{
		var value = texter_general_Char._new("У");
		_g.h[1059] = value;
	}
	{
		var value = texter_general_Char._new("Ф");
		_g.h[1060] = value;
	}
	{
		var value = texter_general_Char._new("Х");
		_g.h[1061] = value;
	}
	{
		var value = texter_general_Char._new("Ц");
		_g.h[1062] = value;
	}
	{
		var value = texter_general_Char._new("Ч");
		_g.h[1063] = value;
	}
	{
		var value = texter_general_Char._new("Ш");
		_g.h[1064] = value;
	}
	{
		var value = texter_general_Char._new("Щ");
		_g.h[1065] = value;
	}
	{
		var value = texter_general_Char._new("Ъ");
		_g.h[1066] = value;
	}
	{
		var value = texter_general_Char._new("Ы");
		_g.h[1067] = value;
	}
	{
		var value = texter_general_Char._new("Ь");
		_g.h[1068] = value;
	}
	{
		var value = texter_general_Char._new("Э");
		_g.h[1069] = value;
	}
	{
		var value = texter_general_Char._new("Ю");
		_g.h[1070] = value;
	}
	{
		var value = texter_general_Char._new("Я");
		_g.h[1071] = value;
	}
	{
		var value = texter_general_Char._new("а");
		_g.h[1072] = value;
	}
	{
		var value = texter_general_Char._new("б");
		_g.h[1073] = value;
	}
	{
		var value = texter_general_Char._new("в");
		_g.h[1074] = value;
	}
	{
		var value = texter_general_Char._new("г");
		_g.h[1075] = value;
	}
	{
		var value = texter_general_Char._new("д");
		_g.h[1076] = value;
	}
	{
		var value = texter_general_Char._new("е");
		_g.h[1077] = value;
	}
	{
		var value = texter_general_Char._new("ж");
		_g.h[1078] = value;
	}
	{
		var value = texter_general_Char._new("з");
		_g.h[1079] = value;
	}
	{
		var value = texter_general_Char._new("и");
		_g.h[1080] = value;
	}
	{
		var value = texter_general_Char._new("й");
		_g.h[1081] = value;
	}
	{
		var value = texter_general_Char._new("к");
		_g.h[1082] = value;
	}
	{
		var value = texter_general_Char._new("л");
		_g.h[1083] = value;
	}
	{
		var value = texter_general_Char._new("м");
		_g.h[1084] = value;
	}
	{
		var value = texter_general_Char._new("н");
		_g.h[1085] = value;
	}
	{
		var value = texter_general_Char._new("о");
		_g.h[1086] = value;
	}
	{
		var value = texter_general_Char._new("п");
		_g.h[1087] = value;
	}
	{
		var value = texter_general_Char._new("р");
		_g.h[1088] = value;
	}
	{
		var value = texter_general_Char._new("с");
		_g.h[1089] = value;
	}
	{
		var value = texter_general_Char._new("т");
		_g.h[1090] = value;
	}
	{
		var value = texter_general_Char._new("у");
		_g.h[1091] = value;
	}
	{
		var value = texter_general_Char._new("ф");
		_g.h[1092] = value;
	}
	{
		var value = texter_general_Char._new("х");
		_g.h[1093] = value;
	}
	{
		var value = texter_general_Char._new("ц");
		_g.h[1094] = value;
	}
	{
		var value = texter_general_Char._new("ч");
		_g.h[1095] = value;
	}
	{
		var value = texter_general_Char._new("ш");
		_g.h[1096] = value;
	}
	{
		var value = texter_general_Char._new("щ");
		_g.h[1097] = value;
	}
	{
		var value = texter_general_Char._new("ъ");
		_g.h[1098] = value;
	}
	{
		var value = texter_general_Char._new("ы");
		_g.h[1099] = value;
	}
	{
		var value = texter_general_Char._new("ь");
		_g.h[1100] = value;
	}
	{
		var value = texter_general_Char._new("э");
		_g.h[1101] = value;
	}
	{
		var value = texter_general_Char._new("ю");
		_g.h[1102] = value;
	}
	{
		var value = texter_general_Char._new("я");
		_g.h[1103] = value;
	}
	{
		var value = texter_general_Char._new("ѐ");
		_g.h[1104] = value;
	}
	{
		var value = texter_general_Char._new("ё");
		_g.h[1105] = value;
	}
	{
		var value = texter_general_Char._new("ђ");
		_g.h[1106] = value;
	}
	{
		var value = texter_general_Char._new("ѓ");
		_g.h[1107] = value;
	}
	{
		var value = texter_general_Char._new("є");
		_g.h[1108] = value;
	}
	{
		var value = texter_general_Char._new("ѕ");
		_g.h[1109] = value;
	}
	{
		var value = texter_general_Char._new("і");
		_g.h[1110] = value;
	}
	{
		var value = texter_general_Char._new("ї");
		_g.h[1111] = value;
	}
	{
		var value = texter_general_Char._new("ј");
		_g.h[1112] = value;
	}
	{
		var value = texter_general_Char._new("љ");
		_g.h[1113] = value;
	}
	{
		var value = texter_general_Char._new("њ");
		_g.h[1114] = value;
	}
	{
		var value = texter_general_Char._new("ћ");
		_g.h[1115] = value;
	}
	{
		var value = texter_general_Char._new("ќ");
		_g.h[1116] = value;
	}
	{
		var value = texter_general_Char._new("ѝ");
		_g.h[1117] = value;
	}
	{
		var value = texter_general_Char._new("ў");
		_g.h[1118] = value;
	}
	{
		var value = texter_general_Char._new("џ");
		_g.h[1119] = value;
	}
	{
		var value = texter_general_Char._new("Ѡ");
		_g.h[1120] = value;
	}
	{
		var value = texter_general_Char._new("ѡ");
		_g.h[1121] = value;
	}
	{
		var value = texter_general_Char._new("Ѣ");
		_g.h[1122] = value;
	}
	{
		var value = texter_general_Char._new("ѣ");
		_g.h[1123] = value;
	}
	{
		var value = texter_general_Char._new("Ѥ");
		_g.h[1124] = value;
	}
	{
		var value = texter_general_Char._new("ѥ");
		_g.h[1125] = value;
	}
	{
		var value = texter_general_Char._new("Ѧ");
		_g.h[1126] = value;
	}
	{
		var value = texter_general_Char._new("ѧ");
		_g.h[1127] = value;
	}
	{
		var value = texter_general_Char._new("Ѩ");
		_g.h[1128] = value;
	}
	{
		var value = texter_general_Char._new("ѩ");
		_g.h[1129] = value;
	}
	{
		var value = texter_general_Char._new("Ѫ");
		_g.h[1130] = value;
	}
	{
		var value = texter_general_Char._new("ѫ");
		_g.h[1131] = value;
	}
	{
		var value = texter_general_Char._new("Ѭ");
		_g.h[1132] = value;
	}
	{
		var value = texter_general_Char._new("ѭ");
		_g.h[1133] = value;
	}
	{
		var value = texter_general_Char._new("Ѯ");
		_g.h[1134] = value;
	}
	{
		var value = texter_general_Char._new("ѯ");
		_g.h[1135] = value;
	}
	{
		var value = texter_general_Char._new("Ѱ");
		_g.h[1136] = value;
	}
	{
		var value = texter_general_Char._new("ѱ");
		_g.h[1137] = value;
	}
	{
		var value = texter_general_Char._new("Ѳ");
		_g.h[1138] = value;
	}
	{
		var value = texter_general_Char._new("ѳ");
		_g.h[1139] = value;
	}
	{
		var value = texter_general_Char._new("Ѵ");
		_g.h[1140] = value;
	}
	{
		var value = texter_general_Char._new("ѵ");
		_g.h[1141] = value;
	}
	{
		var value = texter_general_Char._new("Ѷ");
		_g.h[1142] = value;
	}
	{
		var value = texter_general_Char._new("ѷ");
		_g.h[1143] = value;
	}
	{
		var value = texter_general_Char._new("Ѹ");
		_g.h[1144] = value;
	}
	{
		var value = texter_general_Char._new("ѹ");
		_g.h[1145] = value;
	}
	{
		var value = texter_general_Char._new("Ѻ");
		_g.h[1146] = value;
	}
	{
		var value = texter_general_Char._new("ѻ");
		_g.h[1147] = value;
	}
	{
		var value = texter_general_Char._new("Ѽ");
		_g.h[1148] = value;
	}
	{
		var value = texter_general_Char._new("ѽ");
		_g.h[1149] = value;
	}
	{
		var value = texter_general_Char._new("Ѿ");
		_g.h[1150] = value;
	}
	{
		var value = texter_general_Char._new("ѿ");
		_g.h[1151] = value;
	}
	{
		var value = texter_general_Char._new("Ҁ");
		_g.h[1152] = value;
	}
	{
		var value = texter_general_Char._new("ҁ");
		_g.h[1153] = value;
	}
	{
		var value = texter_general_Char._new("҂");
		_g.h[1154] = value;
	}
	{
		var value = texter_general_Char._new("҃");
		_g.h[1155] = value;
	}
	{
		var value = texter_general_Char._new("҄");
		_g.h[1156] = value;
	}
	{
		var value = texter_general_Char._new("҅");
		_g.h[1157] = value;
	}
	{
		var value = texter_general_Char._new("҆");
		_g.h[1158] = value;
	}
	{
		var value = texter_general_Char._new("҇");
		_g.h[1159] = value;
	}
	{
		var value = texter_general_Char._new("҈");
		_g.h[1160] = value;
	}
	{
		var value = texter_general_Char._new("҉");
		_g.h[1161] = value;
	}
	{
		var value = texter_general_Char._new("Ҋ");
		_g.h[1162] = value;
	}
	{
		var value = texter_general_Char._new("ҋ");
		_g.h[1163] = value;
	}
	{
		var value = texter_general_Char._new("Ҍ");
		_g.h[1164] = value;
	}
	{
		var value = texter_general_Char._new("ҍ");
		_g.h[1165] = value;
	}
	{
		var value = texter_general_Char._new("Ҏ");
		_g.h[1166] = value;
	}
	{
		var value = texter_general_Char._new("ҏ");
		_g.h[1167] = value;
	}
	{
		var value = texter_general_Char._new("Ґ");
		_g.h[1168] = value;
	}
	{
		var value = texter_general_Char._new("ґ");
		_g.h[1169] = value;
	}
	{
		var value = texter_general_Char._new("Ғ");
		_g.h[1170] = value;
	}
	{
		var value = texter_general_Char._new("ғ");
		_g.h[1171] = value;
	}
	{
		var value = texter_general_Char._new("Ҕ");
		_g.h[1172] = value;
	}
	{
		var value = texter_general_Char._new("ҕ");
		_g.h[1173] = value;
	}
	{
		var value = texter_general_Char._new("Җ");
		_g.h[1174] = value;
	}
	{
		var value = texter_general_Char._new("җ");
		_g.h[1175] = value;
	}
	{
		var value = texter_general_Char._new("Ҙ");
		_g.h[1176] = value;
	}
	{
		var value = texter_general_Char._new("ҙ");
		_g.h[1177] = value;
	}
	{
		var value = texter_general_Char._new("Қ");
		_g.h[1178] = value;
	}
	{
		var value = texter_general_Char._new("қ");
		_g.h[1179] = value;
	}
	{
		var value = texter_general_Char._new("Ҝ");
		_g.h[1180] = value;
	}
	{
		var value = texter_general_Char._new("ҝ");
		_g.h[1181] = value;
	}
	{
		var value = texter_general_Char._new("Ҟ");
		_g.h[1182] = value;
	}
	{
		var value = texter_general_Char._new("ҟ");
		_g.h[1183] = value;
	}
	{
		var value = texter_general_Char._new("Ҡ");
		_g.h[1184] = value;
	}
	{
		var value = texter_general_Char._new("ҡ");
		_g.h[1185] = value;
	}
	{
		var value = texter_general_Char._new("Ң");
		_g.h[1186] = value;
	}
	{
		var value = texter_general_Char._new("ң");
		_g.h[1187] = value;
	}
	{
		var value = texter_general_Char._new("Ҥ");
		_g.h[1188] = value;
	}
	{
		var value = texter_general_Char._new("ҥ");
		_g.h[1189] = value;
	}
	{
		var value = texter_general_Char._new("Ҧ");
		_g.h[1190] = value;
	}
	{
		var value = texter_general_Char._new("ҧ");
		_g.h[1191] = value;
	}
	{
		var value = texter_general_Char._new("Ҩ");
		_g.h[1192] = value;
	}
	{
		var value = texter_general_Char._new("ҩ");
		_g.h[1193] = value;
	}
	{
		var value = texter_general_Char._new("Ҫ");
		_g.h[1194] = value;
	}
	{
		var value = texter_general_Char._new("ҫ");
		_g.h[1195] = value;
	}
	{
		var value = texter_general_Char._new("Ҭ");
		_g.h[1196] = value;
	}
	{
		var value = texter_general_Char._new("ҭ");
		_g.h[1197] = value;
	}
	{
		var value = texter_general_Char._new("Ү");
		_g.h[1198] = value;
	}
	{
		var value = texter_general_Char._new("ү");
		_g.h[1199] = value;
	}
	{
		var value = texter_general_Char._new("Ұ");
		_g.h[1200] = value;
	}
	{
		var value = texter_general_Char._new("ұ");
		_g.h[1201] = value;
	}
	{
		var value = texter_general_Char._new("Ҳ");
		_g.h[1202] = value;
	}
	{
		var value = texter_general_Char._new("ҳ");
		_g.h[1203] = value;
	}
	{
		var value = texter_general_Char._new("Ҵ");
		_g.h[1204] = value;
	}
	{
		var value = texter_general_Char._new("ҵ");
		_g.h[1205] = value;
	}
	{
		var value = texter_general_Char._new("Ҷ");
		_g.h[1206] = value;
	}
	{
		var value = texter_general_Char._new("ҷ");
		_g.h[1207] = value;
	}
	{
		var value = texter_general_Char._new("Ҹ");
		_g.h[1208] = value;
	}
	{
		var value = texter_general_Char._new("ҹ");
		_g.h[1209] = value;
	}
	{
		var value = texter_general_Char._new("Һ");
		_g.h[1210] = value;
	}
	{
		var value = texter_general_Char._new("һ");
		_g.h[1211] = value;
	}
	{
		var value = texter_general_Char._new("Ҽ");
		_g.h[1212] = value;
	}
	{
		var value = texter_general_Char._new("ҽ");
		_g.h[1213] = value;
	}
	{
		var value = texter_general_Char._new("Ҿ");
		_g.h[1214] = value;
	}
	{
		var value = texter_general_Char._new("ҿ");
		_g.h[1215] = value;
	}
	{
		var value = texter_general_Char._new("Ӏ");
		_g.h[1216] = value;
	}
	{
		var value = texter_general_Char._new("Ӂ");
		_g.h[1217] = value;
	}
	{
		var value = texter_general_Char._new("ӂ");
		_g.h[1218] = value;
	}
	{
		var value = texter_general_Char._new("Ӄ");
		_g.h[1219] = value;
	}
	{
		var value = texter_general_Char._new("ӄ");
		_g.h[1220] = value;
	}
	{
		var value = texter_general_Char._new("Ӆ");
		_g.h[1221] = value;
	}
	{
		var value = texter_general_Char._new("ӆ");
		_g.h[1222] = value;
	}
	{
		var value = texter_general_Char._new("Ӈ");
		_g.h[1223] = value;
	}
	{
		var value = texter_general_Char._new("ӈ");
		_g.h[1224] = value;
	}
	{
		var value = texter_general_Char._new("Ӊ");
		_g.h[1225] = value;
	}
	{
		var value = texter_general_Char._new("ӊ");
		_g.h[1226] = value;
	}
	{
		var value = texter_general_Char._new("Ӌ");
		_g.h[1227] = value;
	}
	{
		var value = texter_general_Char._new("ӌ");
		_g.h[1228] = value;
	}
	{
		var value = texter_general_Char._new("Ӎ");
		_g.h[1229] = value;
	}
	{
		var value = texter_general_Char._new("ӎ");
		_g.h[1230] = value;
	}
	{
		var value = texter_general_Char._new("ӏ");
		_g.h[1231] = value;
	}
	{
		var value = texter_general_Char._new("Ӑ");
		_g.h[1232] = value;
	}
	{
		var value = texter_general_Char._new("ӑ");
		_g.h[1233] = value;
	}
	{
		var value = texter_general_Char._new("Ӓ");
		_g.h[1234] = value;
	}
	{
		var value = texter_general_Char._new("ӓ");
		_g.h[1235] = value;
	}
	{
		var value = texter_general_Char._new("Ӕ");
		_g.h[1236] = value;
	}
	{
		var value = texter_general_Char._new("ӕ");
		_g.h[1237] = value;
	}
	{
		var value = texter_general_Char._new("Ӗ");
		_g.h[1238] = value;
	}
	{
		var value = texter_general_Char._new("ӗ");
		_g.h[1239] = value;
	}
	{
		var value = texter_general_Char._new("Ә");
		_g.h[1240] = value;
	}
	{
		var value = texter_general_Char._new("ә");
		_g.h[1241] = value;
	}
	{
		var value = texter_general_Char._new("Ӛ");
		_g.h[1242] = value;
	}
	{
		var value = texter_general_Char._new("ӛ");
		_g.h[1243] = value;
	}
	{
		var value = texter_general_Char._new("Ӝ");
		_g.h[1244] = value;
	}
	{
		var value = texter_general_Char._new("ӝ");
		_g.h[1245] = value;
	}
	{
		var value = texter_general_Char._new("Ӟ");
		_g.h[1246] = value;
	}
	{
		var value = texter_general_Char._new("ӟ");
		_g.h[1247] = value;
	}
	{
		var value = texter_general_Char._new("Ӡ");
		_g.h[1248] = value;
	}
	{
		var value = texter_general_Char._new("ӡ");
		_g.h[1249] = value;
	}
	{
		var value = texter_general_Char._new("Ӣ");
		_g.h[1250] = value;
	}
	{
		var value = texter_general_Char._new("ӣ");
		_g.h[1251] = value;
	}
	{
		var value = texter_general_Char._new("Ӥ");
		_g.h[1252] = value;
	}
	{
		var value = texter_general_Char._new("ӥ");
		_g.h[1253] = value;
	}
	{
		var value = texter_general_Char._new("Ӧ");
		_g.h[1254] = value;
	}
	{
		var value = texter_general_Char._new("ӧ");
		_g.h[1255] = value;
	}
	{
		var value = texter_general_Char._new("Ө");
		_g.h[1256] = value;
	}
	{
		var value = texter_general_Char._new("ө");
		_g.h[1257] = value;
	}
	{
		var value = texter_general_Char._new("Ӫ");
		_g.h[1258] = value;
	}
	{
		var value = texter_general_Char._new("ӫ");
		_g.h[1259] = value;
	}
	{
		var value = texter_general_Char._new("Ӭ");
		_g.h[1260] = value;
	}
	{
		var value = texter_general_Char._new("ӭ");
		_g.h[1261] = value;
	}
	{
		var value = texter_general_Char._new("Ӯ");
		_g.h[1262] = value;
	}
	{
		var value = texter_general_Char._new("ӯ");
		_g.h[1263] = value;
	}
	{
		var value = texter_general_Char._new("Ӱ");
		_g.h[1264] = value;
	}
	{
		var value = texter_general_Char._new("ӱ");
		_g.h[1265] = value;
	}
	{
		var value = texter_general_Char._new("Ӳ");
		_g.h[1266] = value;
	}
	{
		var value = texter_general_Char._new("ӳ");
		_g.h[1267] = value;
	}
	{
		var value = texter_general_Char._new("Ӵ");
		_g.h[1268] = value;
	}
	{
		var value = texter_general_Char._new("ӵ");
		_g.h[1269] = value;
	}
	{
		var value = texter_general_Char._new("Ӷ");
		_g.h[1270] = value;
	}
	{
		var value = texter_general_Char._new("ӷ");
		_g.h[1271] = value;
	}
	{
		var value = texter_general_Char._new("Ӹ");
		_g.h[1272] = value;
	}
	{
		var value = texter_general_Char._new("ӹ");
		_g.h[1273] = value;
	}
	{
		var value = texter_general_Char._new("Ӻ");
		_g.h[1274] = value;
	}
	{
		var value = texter_general_Char._new("ӻ");
		_g.h[1275] = value;
	}
	{
		var value = texter_general_Char._new("Ӽ");
		_g.h[1276] = value;
	}
	{
		var value = texter_general_Char._new("ӽ");
		_g.h[1277] = value;
	}
	{
		var value = texter_general_Char._new("Ӿ");
		_g.h[1278] = value;
	}
	{
		var value = texter_general_Char._new("ӿ");
		_g.h[1279] = value;
	}
	{
		var value = texter_general_Char._new("Ԁ");
		_g.h[1280] = value;
	}
	{
		var value = texter_general_Char._new("ԁ");
		_g.h[1281] = value;
	}
	{
		var value = texter_general_Char._new("Ԃ");
		_g.h[1282] = value;
	}
	{
		var value = texter_general_Char._new("ԃ");
		_g.h[1283] = value;
	}
	{
		var value = texter_general_Char._new("Ԅ");
		_g.h[1284] = value;
	}
	{
		var value = texter_general_Char._new("ԅ");
		_g.h[1285] = value;
	}
	{
		var value = texter_general_Char._new("Ԇ");
		_g.h[1286] = value;
	}
	{
		var value = texter_general_Char._new("ԇ");
		_g.h[1287] = value;
	}
	{
		var value = texter_general_Char._new("Ԉ");
		_g.h[1288] = value;
	}
	{
		var value = texter_general_Char._new("ԉ");
		_g.h[1289] = value;
	}
	{
		var value = texter_general_Char._new("Ԋ");
		_g.h[1290] = value;
	}
	{
		var value = texter_general_Char._new("ԋ");
		_g.h[1291] = value;
	}
	{
		var value = texter_general_Char._new("Ԍ");
		_g.h[1292] = value;
	}
	{
		var value = texter_general_Char._new("ԍ");
		_g.h[1293] = value;
	}
	{
		var value = texter_general_Char._new("Ԏ");
		_g.h[1294] = value;
	}
	{
		var value = texter_general_Char._new("ԏ");
		_g.h[1295] = value;
	}
	{
		var value = texter_general_Char._new("Ԑ");
		_g.h[1296] = value;
	}
	{
		var value = texter_general_Char._new("ԑ");
		_g.h[1297] = value;
	}
	{
		var value = texter_general_Char._new("Ԓ");
		_g.h[1298] = value;
	}
	{
		var value = texter_general_Char._new("ԓ");
		_g.h[1299] = value;
	}
	{
		var value = texter_general_Char._new("Ԕ");
		_g.h[1300] = value;
	}
	{
		var value = texter_general_Char._new("ԕ");
		_g.h[1301] = value;
	}
	{
		var value = texter_general_Char._new("Ԗ");
		_g.h[1302] = value;
	}
	{
		var value = texter_general_Char._new("ԗ");
		_g.h[1303] = value;
	}
	{
		var value = texter_general_Char._new("Ԙ");
		_g.h[1304] = value;
	}
	{
		var value = texter_general_Char._new("ԙ");
		_g.h[1305] = value;
	}
	{
		var value = texter_general_Char._new("Ԛ");
		_g.h[1306] = value;
	}
	{
		var value = texter_general_Char._new("ԛ");
		_g.h[1307] = value;
	}
	{
		var value = texter_general_Char._new("Ԝ");
		_g.h[1308] = value;
	}
	{
		var value = texter_general_Char._new("ԝ");
		_g.h[1309] = value;
	}
	{
		var value = texter_general_Char._new("Ԟ");
		_g.h[1310] = value;
	}
	{
		var value = texter_general_Char._new("ԟ");
		_g.h[1311] = value;
	}
	{
		var value = texter_general_Char._new("Ԡ");
		_g.h[1312] = value;
	}
	{
		var value = texter_general_Char._new("ԡ");
		_g.h[1313] = value;
	}
	{
		var value = texter_general_Char._new("Ԣ");
		_g.h[1314] = value;
	}
	{
		var value = texter_general_Char._new("ԣ");
		_g.h[1315] = value;
	}
	{
		var value = texter_general_Char._new("Ԥ");
		_g.h[1316] = value;
	}
	{
		var value = texter_general_Char._new("ԥ");
		_g.h[1317] = value;
	}
	{
		var value = texter_general_Char._new("Ԧ");
		_g.h[1318] = value;
	}
	{
		var value = texter_general_Char._new("ԧ");
		_g.h[1319] = value;
	}
	{
		var value = texter_general_Char._new("Ԩ");
		_g.h[1320] = value;
	}
	{
		var value = texter_general_Char._new("ԩ");
		_g.h[1321] = value;
	}
	{
		var value = texter_general_Char._new("Ԫ");
		_g.h[1322] = value;
	}
	{
		var value = texter_general_Char._new("ԫ");
		_g.h[1323] = value;
	}
	{
		var value = texter_general_Char._new("Ԭ");
		_g.h[1324] = value;
	}
	{
		var value = texter_general_Char._new("ԭ");
		_g.h[1325] = value;
	}
	{
		var value = texter_general_Char._new("Ԯ");
		_g.h[1326] = value;
	}
	{
		var value = texter_general_Char._new("ԯ");
		_g.h[1327] = value;
	}
	{
		var value = texter_general_Char._new("԰");
		_g.h[1328] = value;
	}
	{
		var value = texter_general_Char._new("Ա");
		_g.h[1329] = value;
	}
	{
		var value = texter_general_Char._new("Բ");
		_g.h[1330] = value;
	}
	{
		var value = texter_general_Char._new("Գ");
		_g.h[1331] = value;
	}
	{
		var value = texter_general_Char._new("Դ");
		_g.h[1332] = value;
	}
	{
		var value = texter_general_Char._new("Ե");
		_g.h[1333] = value;
	}
	{
		var value = texter_general_Char._new("Զ");
		_g.h[1334] = value;
	}
	{
		var value = texter_general_Char._new("Է");
		_g.h[1335] = value;
	}
	{
		var value = texter_general_Char._new("Ը");
		_g.h[1336] = value;
	}
	{
		var value = texter_general_Char._new("Թ");
		_g.h[1337] = value;
	}
	{
		var value = texter_general_Char._new("Ժ");
		_g.h[1338] = value;
	}
	{
		var value = texter_general_Char._new("Ի");
		_g.h[1339] = value;
	}
	{
		var value = texter_general_Char._new("Լ");
		_g.h[1340] = value;
	}
	{
		var value = texter_general_Char._new("Խ");
		_g.h[1341] = value;
	}
	{
		var value = texter_general_Char._new("Ծ");
		_g.h[1342] = value;
	}
	{
		var value = texter_general_Char._new("Կ");
		_g.h[1343] = value;
	}
	{
		var value = texter_general_Char._new("Հ");
		_g.h[1344] = value;
	}
	{
		var value = texter_general_Char._new("Ձ");
		_g.h[1345] = value;
	}
	{
		var value = texter_general_Char._new("Ղ");
		_g.h[1346] = value;
	}
	{
		var value = texter_general_Char._new("Ճ");
		_g.h[1347] = value;
	}
	{
		var value = texter_general_Char._new("Մ");
		_g.h[1348] = value;
	}
	{
		var value = texter_general_Char._new("Յ");
		_g.h[1349] = value;
	}
	{
		var value = texter_general_Char._new("Ն");
		_g.h[1350] = value;
	}
	{
		var value = texter_general_Char._new("Շ");
		_g.h[1351] = value;
	}
	{
		var value = texter_general_Char._new("Ո");
		_g.h[1352] = value;
	}
	{
		var value = texter_general_Char._new("Չ");
		_g.h[1353] = value;
	}
	{
		var value = texter_general_Char._new("Պ");
		_g.h[1354] = value;
	}
	{
		var value = texter_general_Char._new("Ջ");
		_g.h[1355] = value;
	}
	{
		var value = texter_general_Char._new("Ռ");
		_g.h[1356] = value;
	}
	{
		var value = texter_general_Char._new("Ս");
		_g.h[1357] = value;
	}
	{
		var value = texter_general_Char._new("Վ");
		_g.h[1358] = value;
	}
	{
		var value = texter_general_Char._new("Տ");
		_g.h[1359] = value;
	}
	{
		var value = texter_general_Char._new("Ր");
		_g.h[1360] = value;
	}
	{
		var value = texter_general_Char._new("Ց");
		_g.h[1361] = value;
	}
	{
		var value = texter_general_Char._new("Ւ");
		_g.h[1362] = value;
	}
	{
		var value = texter_general_Char._new("Փ");
		_g.h[1363] = value;
	}
	{
		var value = texter_general_Char._new("Ք");
		_g.h[1364] = value;
	}
	{
		var value = texter_general_Char._new("Օ");
		_g.h[1365] = value;
	}
	{
		var value = texter_general_Char._new("Ֆ");
		_g.h[1366] = value;
	}
	{
		var value = texter_general_Char._new("՗");
		_g.h[1367] = value;
	}
	{
		var value = texter_general_Char._new("՘");
		_g.h[1368] = value;
	}
	{
		var value = texter_general_Char._new("ՙ");
		_g.h[1369] = value;
	}
	{
		var value = texter_general_Char._new("՚");
		_g.h[1370] = value;
	}
	{
		var value = texter_general_Char._new("՛");
		_g.h[1371] = value;
	}
	{
		var value = texter_general_Char._new("՜");
		_g.h[1372] = value;
	}
	{
		var value = texter_general_Char._new("՝");
		_g.h[1373] = value;
	}
	{
		var value = texter_general_Char._new("՞");
		_g.h[1374] = value;
	}
	{
		var value = texter_general_Char._new("՟");
		_g.h[1375] = value;
	}
	{
		var value = texter_general_Char._new("ՠ");
		_g.h[1376] = value;
	}
	{
		var value = texter_general_Char._new("ա");
		_g.h[1377] = value;
	}
	{
		var value = texter_general_Char._new("բ");
		_g.h[1378] = value;
	}
	{
		var value = texter_general_Char._new("գ");
		_g.h[1379] = value;
	}
	{
		var value = texter_general_Char._new("դ");
		_g.h[1380] = value;
	}
	{
		var value = texter_general_Char._new("ե");
		_g.h[1381] = value;
	}
	{
		var value = texter_general_Char._new("զ");
		_g.h[1382] = value;
	}
	{
		var value = texter_general_Char._new("է");
		_g.h[1383] = value;
	}
	{
		var value = texter_general_Char._new("ը");
		_g.h[1384] = value;
	}
	{
		var value = texter_general_Char._new("թ");
		_g.h[1385] = value;
	}
	{
		var value = texter_general_Char._new("ժ");
		_g.h[1386] = value;
	}
	{
		var value = texter_general_Char._new("ի");
		_g.h[1387] = value;
	}
	{
		var value = texter_general_Char._new("լ");
		_g.h[1388] = value;
	}
	{
		var value = texter_general_Char._new("խ");
		_g.h[1389] = value;
	}
	{
		var value = texter_general_Char._new("ծ");
		_g.h[1390] = value;
	}
	{
		var value = texter_general_Char._new("կ");
		_g.h[1391] = value;
	}
	{
		var value = texter_general_Char._new("հ");
		_g.h[1392] = value;
	}
	{
		var value = texter_general_Char._new("ձ");
		_g.h[1393] = value;
	}
	{
		var value = texter_general_Char._new("ղ");
		_g.h[1394] = value;
	}
	{
		var value = texter_general_Char._new("ճ");
		_g.h[1395] = value;
	}
	{
		var value = texter_general_Char._new("մ");
		_g.h[1396] = value;
	}
	{
		var value = texter_general_Char._new("յ");
		_g.h[1397] = value;
	}
	{
		var value = texter_general_Char._new("ն");
		_g.h[1398] = value;
	}
	{
		var value = texter_general_Char._new("շ");
		_g.h[1399] = value;
	}
	{
		var value = texter_general_Char._new("ո");
		_g.h[1400] = value;
	}
	{
		var value = texter_general_Char._new("չ");
		_g.h[1401] = value;
	}
	{
		var value = texter_general_Char._new("պ");
		_g.h[1402] = value;
	}
	{
		var value = texter_general_Char._new("ջ");
		_g.h[1403] = value;
	}
	{
		var value = texter_general_Char._new("ռ");
		_g.h[1404] = value;
	}
	{
		var value = texter_general_Char._new("ս");
		_g.h[1405] = value;
	}
	{
		var value = texter_general_Char._new("վ");
		_g.h[1406] = value;
	}
	{
		var value = texter_general_Char._new("տ");
		_g.h[1407] = value;
	}
	{
		var value = texter_general_Char._new("ր");
		_g.h[1408] = value;
	}
	{
		var value = texter_general_Char._new("ց");
		_g.h[1409] = value;
	}
	{
		var value = texter_general_Char._new("ւ");
		_g.h[1410] = value;
	}
	{
		var value = texter_general_Char._new("փ");
		_g.h[1411] = value;
	}
	{
		var value = texter_general_Char._new("ք");
		_g.h[1412] = value;
	}
	{
		var value = texter_general_Char._new("օ");
		_g.h[1413] = value;
	}
	{
		var value = texter_general_Char._new("ֆ");
		_g.h[1414] = value;
	}
	{
		var value = texter_general_Char._new("և");
		_g.h[1415] = value;
	}
	{
		var value = texter_general_Char._new("ֈ");
		_g.h[1416] = value;
	}
	{
		var value = texter_general_Char._new("։");
		_g.h[1417] = value;
	}
	{
		var value = texter_general_Char._new("֊");
		_g.h[1418] = value;
	}
	{
		var value = texter_general_Char._new("֋");
		_g.h[1419] = value;
	}
	{
		var value = texter_general_Char._new("֌");
		_g.h[1420] = value;
	}
	{
		var value = texter_general_Char._new("֍");
		_g.h[1421] = value;
	}
	{
		var value = texter_general_Char._new("֎");
		_g.h[1422] = value;
	}
	{
		var value = texter_general_Char._new("֏");
		_g.h[1423] = value;
	}
	{
		var value = texter_general_Char._new("֐");
		_g.h[1424] = value;
	}
	{
		var value = texter_general_Char._new("֑");
		_g.h[1425] = value;
	}
	{
		var value = texter_general_Char._new("֒");
		_g.h[1426] = value;
	}
	{
		var value = texter_general_Char._new("֓");
		_g.h[1427] = value;
	}
	{
		var value = texter_general_Char._new("֔");
		_g.h[1428] = value;
	}
	{
		var value = texter_general_Char._new("֕");
		_g.h[1429] = value;
	}
	{
		var value = texter_general_Char._new("֖");
		_g.h[1430] = value;
	}
	{
		var value = texter_general_Char._new("֗");
		_g.h[1431] = value;
	}
	{
		var value = texter_general_Char._new("֘");
		_g.h[1432] = value;
	}
	{
		var value = texter_general_Char._new("֙");
		_g.h[1433] = value;
	}
	{
		var value = texter_general_Char._new("֚");
		_g.h[1434] = value;
	}
	{
		var value = texter_general_Char._new("֛");
		_g.h[1435] = value;
	}
	{
		var value = texter_general_Char._new("֜");
		_g.h[1436] = value;
	}
	{
		var value = texter_general_Char._new("֝");
		_g.h[1437] = value;
	}
	{
		var value = texter_general_Char._new("֞");
		_g.h[1438] = value;
	}
	{
		var value = texter_general_Char._new("֟");
		_g.h[1439] = value;
	}
	{
		var value = texter_general_Char._new("֠");
		_g.h[1440] = value;
	}
	{
		var value = texter_general_Char._new("֡");
		_g.h[1441] = value;
	}
	{
		var value = texter_general_Char._new("֢");
		_g.h[1442] = value;
	}
	{
		var value = texter_general_Char._new("֣");
		_g.h[1443] = value;
	}
	{
		var value = texter_general_Char._new("֤");
		_g.h[1444] = value;
	}
	{
		var value = texter_general_Char._new("֥");
		_g.h[1445] = value;
	}
	{
		var value = texter_general_Char._new("֦");
		_g.h[1446] = value;
	}
	{
		var value = texter_general_Char._new("֧");
		_g.h[1447] = value;
	}
	{
		var value = texter_general_Char._new("֨");
		_g.h[1448] = value;
	}
	{
		var value = texter_general_Char._new("֩");
		_g.h[1449] = value;
	}
	{
		var value = texter_general_Char._new("֪");
		_g.h[1450] = value;
	}
	{
		var value = texter_general_Char._new("֫");
		_g.h[1451] = value;
	}
	{
		var value = texter_general_Char._new("֬");
		_g.h[1452] = value;
	}
	{
		var value = texter_general_Char._new("֭");
		_g.h[1453] = value;
	}
	{
		var value = texter_general_Char._new("֮");
		_g.h[1454] = value;
	}
	{
		var value = texter_general_Char._new("֯");
		_g.h[1455] = value;
	}
	{
		var value = texter_general_Char._new("ְ");
		_g.h[1456] = value;
	}
	{
		var value = texter_general_Char._new("ֱ");
		_g.h[1457] = value;
	}
	{
		var value = texter_general_Char._new("ֲ");
		_g.h[1458] = value;
	}
	{
		var value = texter_general_Char._new("ֳ");
		_g.h[1459] = value;
	}
	{
		var value = texter_general_Char._new("ִ");
		_g.h[1460] = value;
	}
	{
		var value = texter_general_Char._new("ֵ");
		_g.h[1461] = value;
	}
	{
		var value = texter_general_Char._new("ֶ");
		_g.h[1462] = value;
	}
	{
		var value = texter_general_Char._new("ַ");
		_g.h[1463] = value;
	}
	{
		var value = texter_general_Char._new("ָ");
		_g.h[1464] = value;
	}
	{
		var value = texter_general_Char._new("ֹ");
		_g.h[1465] = value;
	}
	{
		var value = texter_general_Char._new("ֺ");
		_g.h[1466] = value;
	}
	{
		var value = texter_general_Char._new("ֻ");
		_g.h[1467] = value;
	}
	{
		var value = texter_general_Char._new("ּ");
		_g.h[1468] = value;
	}
	{
		var value = texter_general_Char._new("ֽ");
		_g.h[1469] = value;
	}
	{
		var value = texter_general_Char._new("־");
		_g.h[1470] = value;
	}
	{
		var value = texter_general_Char._new("ֿ");
		_g.h[1471] = value;
	}
	{
		var value = texter_general_Char._new("׀");
		_g.h[1472] = value;
	}
	{
		var value = texter_general_Char._new("ׁ");
		_g.h[1473] = value;
	}
	{
		var value = texter_general_Char._new("ׂ");
		_g.h[1474] = value;
	}
	{
		var value = texter_general_Char._new("׃");
		_g.h[1475] = value;
	}
	{
		var value = texter_general_Char._new("ׄ");
		_g.h[1476] = value;
	}
	{
		var value = texter_general_Char._new("ׅ");
		_g.h[1477] = value;
	}
	{
		var value = texter_general_Char._new("׆");
		_g.h[1478] = value;
	}
	{
		var value = texter_general_Char._new("ׇ");
		_g.h[1479] = value;
	}
	{
		var value = texter_general_Char._new("׈");
		_g.h[1480] = value;
	}
	{
		var value = texter_general_Char._new("׉");
		_g.h[1481] = value;
	}
	{
		var value = texter_general_Char._new("׊");
		_g.h[1482] = value;
	}
	{
		var value = texter_general_Char._new("׋");
		_g.h[1483] = value;
	}
	{
		var value = texter_general_Char._new("׌");
		_g.h[1484] = value;
	}
	{
		var value = texter_general_Char._new("׍");
		_g.h[1485] = value;
	}
	{
		var value = texter_general_Char._new("׎");
		_g.h[1486] = value;
	}
	{
		var value = texter_general_Char._new("׏");
		_g.h[1487] = value;
	}
	{
		var value = texter_general_Char._new("א");
		_g.h[1488] = value;
	}
	{
		var value = texter_general_Char._new("ב");
		_g.h[1489] = value;
	}
	{
		var value = texter_general_Char._new("ג");
		_g.h[1490] = value;
	}
	{
		var value = texter_general_Char._new("ד");
		_g.h[1491] = value;
	}
	{
		var value = texter_general_Char._new("ה");
		_g.h[1492] = value;
	}
	{
		var value = texter_general_Char._new("ו");
		_g.h[1493] = value;
	}
	{
		var value = texter_general_Char._new("ז");
		_g.h[1494] = value;
	}
	{
		var value = texter_general_Char._new("ח");
		_g.h[1495] = value;
	}
	{
		var value = texter_general_Char._new("ט");
		_g.h[1496] = value;
	}
	{
		var value = texter_general_Char._new("י");
		_g.h[1497] = value;
	}
	{
		var value = texter_general_Char._new("ך");
		_g.h[1498] = value;
	}
	{
		var value = texter_general_Char._new("כ");
		_g.h[1499] = value;
	}
	{
		var value = texter_general_Char._new("ל");
		_g.h[1500] = value;
	}
	{
		var value = texter_general_Char._new("ם");
		_g.h[1501] = value;
	}
	{
		var value = texter_general_Char._new("מ");
		_g.h[1502] = value;
	}
	{
		var value = texter_general_Char._new("ן");
		_g.h[1503] = value;
	}
	{
		var value = texter_general_Char._new("נ");
		_g.h[1504] = value;
	}
	{
		var value = texter_general_Char._new("ס");
		_g.h[1505] = value;
	}
	{
		var value = texter_general_Char._new("ע");
		_g.h[1506] = value;
	}
	{
		var value = texter_general_Char._new("ף");
		_g.h[1507] = value;
	}
	{
		var value = texter_general_Char._new("פ");
		_g.h[1508] = value;
	}
	{
		var value = texter_general_Char._new("ץ");
		_g.h[1509] = value;
	}
	{
		var value = texter_general_Char._new("צ");
		_g.h[1510] = value;
	}
	{
		var value = texter_general_Char._new("ק");
		_g.h[1511] = value;
	}
	{
		var value = texter_general_Char._new("ר");
		_g.h[1512] = value;
	}
	{
		var value = texter_general_Char._new("ש");
		_g.h[1513] = value;
	}
	{
		var value = texter_general_Char._new("ת");
		_g.h[1514] = value;
	}
	{
		var value = texter_general_Char._new("׫");
		_g.h[1515] = value;
	}
	{
		var value = texter_general_Char._new("׬");
		_g.h[1516] = value;
	}
	{
		var value = texter_general_Char._new("׭");
		_g.h[1517] = value;
	}
	{
		var value = texter_general_Char._new("׮");
		_g.h[1518] = value;
	}
	{
		var value = texter_general_Char._new("ׯ");
		_g.h[1519] = value;
	}
	{
		var value = texter_general_Char._new("װ");
		_g.h[1520] = value;
	}
	{
		var value = texter_general_Char._new("ױ");
		_g.h[1521] = value;
	}
	{
		var value = texter_general_Char._new("ײ");
		_g.h[1522] = value;
	}
	{
		var value = texter_general_Char._new("׳");
		_g.h[1523] = value;
	}
	{
		var value = texter_general_Char._new("״");
		_g.h[1524] = value;
	}
	{
		var value = texter_general_Char._new("׵");
		_g.h[1525] = value;
	}
	{
		var value = texter_general_Char._new("׶");
		_g.h[1526] = value;
	}
	{
		var value = texter_general_Char._new("׷");
		_g.h[1527] = value;
	}
	{
		var value = texter_general_Char._new("׸");
		_g.h[1528] = value;
	}
	{
		var value = texter_general_Char._new("׹");
		_g.h[1529] = value;
	}
	{
		var value = texter_general_Char._new("׺");
		_g.h[1530] = value;
	}
	{
		var value = texter_general_Char._new("׻");
		_g.h[1531] = value;
	}
	{
		var value = texter_general_Char._new("׼");
		_g.h[1532] = value;
	}
	{
		var value = texter_general_Char._new("׽");
		_g.h[1533] = value;
	}
	{
		var value = texter_general_Char._new("׾");
		_g.h[1534] = value;
	}
	{
		var value = texter_general_Char._new("׿");
		_g.h[1535] = value;
	}
	{
		var value = texter_general_Char._new("؀");
		_g.h[1536] = value;
	}
	{
		var value = texter_general_Char._new("؁");
		_g.h[1537] = value;
	}
	{
		var value = texter_general_Char._new("؂");
		_g.h[1538] = value;
	}
	{
		var value = texter_general_Char._new("؃");
		_g.h[1539] = value;
	}
	{
		var value = texter_general_Char._new("؄");
		_g.h[1540] = value;
	}
	{
		var value = texter_general_Char._new("؅");
		_g.h[1541] = value;
	}
	{
		var value = texter_general_Char._new("؆");
		_g.h[1542] = value;
	}
	{
		var value = texter_general_Char._new("؇");
		_g.h[1543] = value;
	}
	{
		var value = texter_general_Char._new("؈");
		_g.h[1544] = value;
	}
	{
		var value = texter_general_Char._new("؉");
		_g.h[1545] = value;
	}
	{
		var value = texter_general_Char._new("؊");
		_g.h[1546] = value;
	}
	{
		var value = texter_general_Char._new("؋");
		_g.h[1547] = value;
	}
	{
		var value = texter_general_Char._new("،");
		_g.h[1548] = value;
	}
	{
		var value = texter_general_Char._new("؍");
		_g.h[1549] = value;
	}
	$r = _g;
	return $r;
}(this));
Main.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);

//# sourceMappingURL=interp.js.map