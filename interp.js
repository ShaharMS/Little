(function ($global) { "use strict";
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
	var text = window.document.getElementById("input");
	var output = window.document.getElementById("output");
	haxe_Log.trace(text,{ fileName : "src/Main.hx", lineNumber : 51, className : "Main", methodName : "main", customParams : [output]});
	text.addEventListener("keyup",function(e) {
		try {
			var tmp = little_parser_Parser.typeTokens(little_lexer_Lexer.splitBlocks1(little_lexer_Lexer.lexIntoComplex(text.value)));
			output.innerHTML = little_parser_Parser.prettyPrintAst(tmp,5);
		} catch( _g ) {
		}
	});
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
var TextTools = function() { };
TextTools.__name__ = true;
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
TextTools.multiply = function(string,times) {
	var stringcopy = string;
	if(times <= 0) {
		return "";
	}
	while(--times > 0) string += stringcopy;
	return string;
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
TextTools.replace = function(string,replace,$with) {
	if(replace == null || $with == null) {
		return string;
	}
	return StringTools.replace(string,replace,$with);
};
var Type = function() { };
Type.__name__ = true;
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
});
var haxe_Log = function() { };
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
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
};
haxe_ValueException.__name__ = true;
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
});
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
};
var js_Boot = function() { };
js_Boot.__name__ = true;
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
var little_Keywords = function() { };
little_Keywords.__name__ = true;
var little_expressions_ExpTokens = $hxEnums["little.expressions.ExpTokens"] = { __ename__:true,__constructs__:null
	,Variable: ($_=function(value) { return {_hx_index:0,value:value,__enum__:"little.expressions.ExpTokens",toString:$estr}; },$_._hx_name="Variable",$_.__params__ = ["value"],$_)
	,Value: ($_=function(value) { return {_hx_index:1,value:value,__enum__:"little.expressions.ExpTokens",toString:$estr}; },$_._hx_name="Value",$_.__params__ = ["value"],$_)
	,Characters: ($_=function(value) { return {_hx_index:2,value:value,__enum__:"little.expressions.ExpTokens",toString:$estr}; },$_._hx_name="Characters",$_.__params__ = ["value"],$_)
	,Sign: ($_=function(value) { return {_hx_index:3,value:value,__enum__:"little.expressions.ExpTokens",toString:$estr}; },$_._hx_name="Sign",$_.__params__ = ["value"],$_)
	,Call: ($_=function(value,content) { return {_hx_index:4,value:value,content:content,__enum__:"little.expressions.ExpTokens",toString:$estr}; },$_._hx_name="Call",$_.__params__ = ["value","content"],$_)
	,Closure: ($_=function(content) { return {_hx_index:5,content:content,__enum__:"little.expressions.ExpTokens",toString:$estr}; },$_._hx_name="Closure",$_.__params__ = ["content"],$_)
};
little_expressions_ExpTokens.__constructs__ = [little_expressions_ExpTokens.Variable,little_expressions_ExpTokens.Value,little_expressions_ExpTokens.Characters,little_expressions_ExpTokens.Sign,little_expressions_ExpTokens.Call,little_expressions_ExpTokens.Closure];
var little_expressions_Expressions = function() { };
little_expressions_Expressions.__name__ = true;
little_expressions_Expressions.lex = function(exp) {
	var split = exp.split("");
	var tokens = [];
	var i = 0;
	while(i < split.length) {
		var l = split[i];
		if(texter_general_CharTools.numericChars.match(l)) {
			tokens.push(little_expressions_ExpTokens.Value(l));
		} else if(texter_general_CharTools.softChars.indexOf(l) != -1) {
			tokens.push(little_expressions_ExpTokens.Sign(l));
		} else {
			tokens.push(little_expressions_ExpTokens.Variable(l));
		}
		++i;
	}
	var mergedValues = [];
	i = 0;
	while(i < tokens.length) {
		var token = tokens[i];
		switch(token._hx_index) {
		case 0:
			var value = token.value;
			mergedValues.push(little_expressions_ExpTokens.Variable(value));
			break;
		case 1:
			var v = token.value;
			var val = v;
			_hx_loop3: while(i < tokens.length) {
				if(i + 1 >= tokens.length) {
					break;
				}
				var nextToken = tokens[i + 1];
				switch(nextToken._hx_index) {
				case 1:
					var value1 = nextToken.value;
					val += value1;
					break;
				case 3:
					if(nextToken.value == ".") {
						val += ".";
					} else {
						break _hx_loop3;
					}
					break;
				default:
					break _hx_loop3;
				}
				++i;
			}
			mergedValues.push(little_expressions_ExpTokens.Value(val));
			break;
		case 2:
			var value2 = token.value;
			mergedValues.push(little_expressions_ExpTokens.Characters(value2));
			break;
		case 3:
			var value3 = token.value;
			mergedValues.push(little_expressions_ExpTokens.Sign(value3));
			break;
		case 4:
			var value4 = token.value;
			var content = token.content;
			mergedValues.push(little_expressions_ExpTokens.Call(value4,content));
			break;
		case 5:
			var content1 = token.content;
			mergedValues.push(little_expressions_ExpTokens.Closure(content1));
			break;
		}
		++i;
	}
	var mergedVariables = [];
	i = 0;
	while(i < mergedValues.length) {
		var token = mergedValues[i];
		switch(token._hx_index) {
		case 0:
			var v = token.value;
			var val = v;
			while(i < mergedValues.length) {
				if(i + 1 >= mergedValues.length) {
					break;
				}
				var nextToken = mergedValues[i + 1];
				if(nextToken._hx_index == 0) {
					var value = nextToken.value;
					val += value;
				} else {
					break;
				}
				++i;
			}
			mergedVariables.push(little_expressions_ExpTokens.Variable(val));
			break;
		case 1:
			var value1 = token.value;
			mergedVariables.push(little_expressions_ExpTokens.Value(value1));
			break;
		case 2:
			var value2 = token.value;
			mergedVariables.push(little_expressions_ExpTokens.Characters(value2));
			break;
		case 3:
			var value3 = token.value;
			mergedVariables.push(little_expressions_ExpTokens.Sign(value3));
			break;
		case 4:
			var value4 = token.value;
			var content = token.content;
			mergedVariables.push(little_expressions_ExpTokens.Call(value4,content));
			break;
		case 5:
			var content1 = token.content;
			mergedVariables.push(little_expressions_ExpTokens.Closure(content1));
			break;
		}
		++i;
	}
	var result = new Array(mergedVariables.length);
	var _g = 0;
	var _g1 = mergedVariables.length;
	while(_g < _g1) {
		var i1 = _g++;
		var e = mergedVariables[i1];
		result[i1] = Type.enumEq(e,little_expressions_ExpTokens.Variable(little_Keywords.TRUE_VALUE)) ? little_expressions_ExpTokens.Value(little_Keywords.TRUE_VALUE) : Type.enumEq(e,little_expressions_ExpTokens.Variable(little_Keywords.FALSE_VALUE)) ? little_expressions_ExpTokens.Value(little_Keywords.FALSE_VALUE) : Type.enumEq(e,little_expressions_ExpTokens.Variable(little_Keywords.NULL_VALUE)) ? little_expressions_ExpTokens.Value(little_Keywords.NULL_VALUE) : e;
	}
	mergedVariables = result;
	var mergedChars = [];
	i = 0;
	while(i < mergedVariables.length) {
		var token = mergedVariables[i];
		switch(token._hx_index) {
		case 0:
			var value = token.value;
			mergedChars.push(little_expressions_ExpTokens.Variable(value));
			break;
		case 1:
			var value1 = token.value;
			mergedChars.push(little_expressions_ExpTokens.Value(value1));
			break;
		case 2:
			var value2 = token.value;
			mergedChars.push(little_expressions_ExpTokens.Characters(value2));
			break;
		case 3:
			var _g = token.value;
			if(_g == "\"") {
				var val = "";
				_hx_loop8: while(i < mergedVariables.length) {
					if(i + 1 >= mergedVariables.length) {
						break;
					}
					var nextToken = mergedVariables[i + 1];
					switch(nextToken._hx_index) {
					case 0:
						var value3 = nextToken.value;
						val += value3;
						break;
					case 1:
						var value4 = nextToken.value;
						val += value4;
						break;
					case 3:
						var _g1 = nextToken.value;
						if(_g1 == "\"") {
							++i;
							break _hx_loop8;
						} else {
							var value5 = _g1;
							val += value5;
						}
						break;
					default:
						break _hx_loop8;
					}
					++i;
				}
				mergedChars.push(little_expressions_ExpTokens.Characters(val));
			} else {
				var value6 = _g;
				mergedChars.push(little_expressions_ExpTokens.Sign(value6));
			}
			break;
		case 4:
			var value7 = token.value;
			var content = token.content;
			mergedChars.push(little_expressions_ExpTokens.Call(value7,content));
			break;
		case 5:
			var content1 = token.content;
			mergedChars.push(little_expressions_ExpTokens.Closure(content1));
			break;
		}
		++i;
	}
	var _g = [];
	var _g1 = 0;
	var _g2 = mergedChars;
	while(_g1 < _g2.length) {
		var v = _g2[_g1];
		++_g1;
		if(!Type.enumEq(v,little_expressions_ExpTokens.Sign(" "))) {
			_g.push(v);
		}
	}
	mergedChars = _g;
	var mergedClosures = [];
	i = 0;
	while(i < mergedChars.length) {
		var token = mergedChars[i];
		switch(token._hx_index) {
		case 0:
			var value = token.value;
			mergedClosures.push(little_expressions_ExpTokens.Variable(value));
			break;
		case 1:
			var value1 = token.value;
			mergedClosures.push(little_expressions_ExpTokens.Value(value1));
			break;
		case 2:
			var value2 = token.value;
			mergedClosures.push(little_expressions_ExpTokens.Characters(value2));
			break;
		case 3:
			var _g = token.value;
			if(_g == "(") {
				var val = [];
				_hx_loop11: while(i < mergedChars.length) {
					if(i + 1 >= mergedChars.length) {
						break;
					}
					var nextToken = mergedChars[i + 1];
					switch(nextToken._hx_index) {
					case 0:
						var _g1 = nextToken.value;
						val.push(nextToken);
						break;
					case 1:
						var _g2 = nextToken.value;
						val.push(nextToken);
						break;
					case 2:
						var _g3 = nextToken.value;
						val.push(nextToken);
						break;
					case 3:
						if(nextToken.value == ")") {
							++i;
							break _hx_loop11;
						} else {
							val.push(nextToken);
						}
						break;
					default:
						break _hx_loop11;
					}
					++i;
				}
				mergedClosures.push(little_expressions_ExpTokens.Closure(val));
			} else {
				var value3 = _g;
				mergedClosures.push(little_expressions_ExpTokens.Sign(value3));
			}
			break;
		case 4:
			var value4 = token.value;
			var content = token.content;
			mergedClosures.push(little_expressions_ExpTokens.Call(value4,content));
			break;
		case 5:
			var content1 = token.content;
			mergedClosures.push(little_expressions_ExpTokens.Closure(content1));
			break;
		}
		++i;
	}
	var mergedCalls = [];
	i = 0;
	while(i < mergedClosures.length) {
		var token = mergedClosures[i];
		if(token._hx_index == 0) {
			var value = token.value;
			_hx_loop13: while(i < mergedClosures.length) {
				if(i + 1 >= mergedClosures.length) {
					break;
				}
				var nextToken = mergedClosures[i + 1];
				switch(nextToken._hx_index) {
				case 3:
					if(nextToken.value == " ") {
						++i;
						continue;
					} else {
						break _hx_loop13;
					}
					break;
				case 5:
					var content = nextToken.content;
					mergedCalls.push(little_expressions_ExpTokens.Call(value,content));
					++i;
					break _hx_loop13;
				default:
					break _hx_loop13;
				}
			}
		} else {
			mergedCalls.push(token);
		}
		++i;
	}
	return mergedCalls;
};
var little_lexer_Lexer = function() { };
little_lexer_Lexer.__name__ = true;
little_lexer_Lexer.lexIntoComplex = function(code,disableSkips) {
	if(disableSkips == null) {
		disableSkips = false;
	}
	code = TextTools.replace(code,"==","⩵");
	code = TextTools.replace(code,";","\n");
	var tokens = [];
	var l = 1;
	while(l < code.split("\n").length + 1) {
		var line = code.split("\n")[l - 1];
		if(StringTools.trim(TextTools.replace(line,"\t"," ")) == "") {
			++l;
			continue;
		}
		if(StringTools.startsWith(StringTools.trim(TextTools.replace(line,"\t"," ")),little_Keywords.VARIABLE_DECLARATION)) {
			var _g = [];
			var _g1 = 0;
			var _g2 = line.split(" ");
			while(_g1 < _g2.length) {
				var v = _g2[_g1];
				++_g1;
				if(v != "" && v != "define") {
					_g.push(v);
				}
			}
			var items = _g;
			if(items.length == 0) {
				++l;
			}
			if(items.length == 1) {
				var _this_r = new RegExp("[0-9\\.]","g".split("u").join(""));
				if(items[0].replace(_this_r,"").length == 0) {
					++l;
				} else {
					tokens.push(little_lexer_ComplexToken.DefinitionCreationDetails(l,items[0],little_Keywords.NULL_VALUE,little_Keywords.TYPE_DYNAMIC));
				}
				continue;
			}
			var _defAndVal = line.split("=");
			var _g3 = [];
			var _g4 = 0;
			var _g5 = _defAndVal[0].split(" ");
			while(_g4 < _g5.length) {
				var v1 = _g5[_g4];
				++_g4;
				if(v1 != "" && v1 != little_Keywords.VARIABLE_DECLARATION) {
					_g3.push(v1);
				}
			}
			var defValSplit_0 = _g3;
			var defName = "";
			var val = "";
			var type = null;
			var nameSet = false;
			var typeSet = false;
			var _g6 = 0;
			var _g7 = defValSplit_0.length;
			while(_g6 < _g7) {
				var i = _g6++;
				if(defValSplit_0[i] == little_Keywords.TYPE_CHECK_OR_CAST && defValSplit_0[i + 1] != null && defValSplit_0[i + 1].replace(little_lexer_Lexer.typeDetector.r,"").length == 0) {
					if(!typeSet) {
						type = defValSplit_0[i + 1];
					}
					typeSet = true;
				} else if(defValSplit_0[i].replace(little_lexer_Lexer.nameDetector.r,"").length == 0) {
					if(!nameSet) {
						defName = defValSplit_0[i];
					}
					nameSet = true;
				}
			}
			if(_defAndVal.length == 1) {
				val = little_Keywords.NULL_VALUE;
				tokens.push(little_lexer_ComplexToken.DefinitionCreationDetails(l,defName,val,type));
			} else {
				val = StringTools.trim(_defAndVal[1]);
				tokens.push(little_lexer_ComplexToken.DefinitionCreationDetails(l,defName,val,type));
			}
		} else if(TextTools.replace(StringTools.trim(line),"\t"," ").replace(little_lexer_Lexer.assignmentDetector.r,"").length == 0) {
			var items1 = line.split("=");
			var value = StringTools.trim(items1[items1.length - 1]);
			items1.pop();
			var result = new Array(items1.length);
			var _g8 = 0;
			var _g9 = items1.length;
			while(_g8 < _g9) {
				var i1 = _g8++;
				result[i1] = StringTools.trim(items1[i1]);
			}
			items1 = result;
			var assignees = items1;
			tokens.push(little_lexer_ComplexToken.Assignment(l,value,assignees));
		} else {
			var tmp;
			if(StringTools.trim(TextTools.replace(line,"\t"," ")).replace(little_lexer_Lexer.conditionDetector.r,"").length == 0) {
				var _g10 = [];
				var _g11 = 0;
				var _g12 = little_Keywords.CONDITION_TYPES;
				while(_g11 < _g12.length) {
					var condition = _g12[_g11];
					++_g11;
					_g10.push(StringTools.startsWith(StringTools.trim(TextTools.replace(line,"\t"," ")),condition));
				}
				tmp = _g10.indexOf(true) != -1;
			} else {
				tmp = false;
			}
			if(tmp) {
				little_lexer_Lexer.conditionDetector.match(StringTools.trim(TextTools.replace(line,"\t"," ")));
				var cWord = little_lexer_Lexer.conditionDetector.matched(1);
				var condition1 = little_lexer_Lexer.conditionDetector.matched(2);
				var rawBody = little_lexer_Specifics.extractActionBody(little_lexer_Specifics.cropCode(code,l));
				var body = little_lexer_Lexer.lexIntoComplex(TextTools.multiply("\n",l) + rawBody.body,true);
				tokens.push(little_lexer_ComplexToken.ConditionStatement(l,cWord,condition1,body));
				l += rawBody.lineCount;
			} else if(StringTools.startsWith(StringTools.trim(TextTools.replace(line,"\t"," ")),little_Keywords.FUNCTION_DECLARATION)) {
				var trimmed = StringTools.trim(TextTools.replace(line,"\t"," "));
				var nameExtractor = new EReg(little_Keywords.FUNCTION_DECLARATION + " +(\\w+)","");
				nameExtractor.match(trimmed);
				var name = nameExtractor.matched(1);
				var paramsBody = trimmed.substring(trimmed.indexOf("(") + 1,trimmed.lastIndexOf(")"));
				var containsOptionalType = trimmed.substring(trimmed.lastIndexOf(")") + 1);
				if(TextTools.contains(containsOptionalType,"{")) {
					containsOptionalType = containsOptionalType.substring(0,containsOptionalType.lastIndexOf("{"));
				}
				containsOptionalType = StringTools.trim(containsOptionalType);
				var type1;
				if(TextTools.contains(containsOptionalType,little_Keywords.TYPE_CHECK_OR_CAST)) {
					var typeExtractor = new EReg(little_Keywords.TYPE_CHECK_OR_CAST + " +(\\w+)","");
					typeExtractor.match(containsOptionalType);
					try {
						type1 = typeExtractor.matched(1);
					} catch( _g13 ) {
						type1 = null;
					}
				} else {
					type1 = null;
				}
				var rawBody1 = little_lexer_Specifics.extractActionBody(little_lexer_Specifics.cropCode(code,l - 1));
				var body1 = little_lexer_Lexer.lexIntoComplex(TextTools.multiply("\n",l) + rawBody1.body,true);
				tokens.push(little_lexer_ComplexToken.ActionCreationDetails(l,name,paramsBody,body1,type1));
				l += rawBody1.lineCount;
			} else {
				tokens.push(little_lexer_ComplexToken.GenericExpression(l,StringTools.trim(TextTools.replace(line,"\t"," "))));
			}
		}
		++l;
	}
	return tokens;
};
little_lexer_Lexer.splitBlocks1 = function(complexTokens) {
	var tokens = [];
	var _g = 0;
	while(_g < complexTokens.length) {
		var complex = complexTokens[_g];
		++_g;
		switch(complex._hx_index) {
		case 0:
			var line = complex.line;
			var name = complex.name;
			var complexValue = complex.complexValue;
			var type = complex.type;
			tokens.push(little_lexer_LexerTokens.SetLine(line));
			var defName = name;
			var defType = type;
			var defValue = little_lexer_Specifics.complexValueIntoLexerTokens(complexValue);
			tokens.push(little_lexer_LexerTokens.DefinitionCreation(defName,defValue,defType));
			break;
		case 1:
			var line1 = complex.line;
			var name1 = complex.name;
			var parameterBody = complex.parameters;
			var actionBody = complex.actionBody;
			var type1 = complex.type;
			tokens.push(little_lexer_LexerTokens.SetLine(line1));
			var _g1 = [];
			var _g2 = 0;
			var _g3 = parameterBody.split(",");
			while(_g2 < _g3.length) {
				var p = _g3[_g2];
				++_g2;
				_g1.push(little_lexer_Specifics.extractParamForActionCreation(p));
			}
			var params = _g1;
			var body = little_lexer_Lexer.splitBlocks1(actionBody);
			tokens.push(little_lexer_LexerTokens.ActionCreation(name1,params,body,type1));
			break;
		case 2:
			var line2 = complex.line;
			var value = complex.value;
			var assignees = complex.assignees;
			tokens.push(little_lexer_LexerTokens.SetLine(line2));
			var parsedValue = little_lexer_Specifics.complexValueIntoLexerTokens(value);
			assignees.reverse();
			var _g4 = 0;
			while(_g4 < assignees.length) {
				var assignee = assignees[_g4];
				++_g4;
				tokens.push(little_lexer_LexerTokens.DefinitionWrite(assignee,parsedValue));
			}
			break;
		case 3:
			var line3 = complex.line;
			var type2 = complex.type;
			var conditionExpression = complex.conditionExpression;
			var conditionBody = complex.conditionBody;
			tokens.push(little_lexer_LexerTokens.SetLine(line3));
			var condition = little_lexer_Specifics.complexValueIntoLexerTokens(conditionExpression);
			var body1 = little_lexer_Lexer.splitBlocks1(conditionBody);
			tokens.push(little_lexer_LexerTokens.Condition(type2,condition,body1));
			break;
		case 4:
			var line4 = complex.line;
			var exp = complex.exp;
			tokens.push(little_lexer_LexerTokens.SetLine(line4));
			if(StringTools.startsWith(exp,little_Keywords.FUNCTION_RETURN)) {
				tokens.push(little_lexer_LexerTokens.Return(little_lexer_Specifics.complexValueIntoLexerTokens(StringTools.trim(TextTools.replaceFirst(exp,"return","")))));
			} else {
				tokens.push(little_lexer_Specifics.complexValueIntoLexerTokens(exp));
			}
			break;
		}
	}
	return tokens;
};
var little_lexer_Specifics = function() { };
little_lexer_Specifics.__name__ = true;
little_lexer_Specifics.cropCode = function(code,line) {
	var _g = 0;
	var _g1 = line;
	while(_g < _g1) {
		var _ = _g++;
		code = code.substring(code.indexOf("\n") + 1);
	}
	return code;
};
little_lexer_Specifics.extractParam = function(string) {
	return little_lexer_LexerTokens.ActionCallParameter(little_lexer_Specifics.attributesIntoExpression(little_expressions_Expressions.lex(string)));
};
little_lexer_Specifics.extractParamForActionCreation = function(string) {
	if(TextTools.contains(string,"=")) {
		var __nameValSplit = TextTools.splitOnFirst(string,"=");
		var param = little_lexer_Specifics.extractParamForActionCreation(__nameValSplit[0]);
		var value = little_lexer_Specifics.complexValueIntoLexerTokens(__nameValSplit[1]);
		if(param._hx_index == 8) {
			var _g = param.value;
			var name = param.name;
			var type = param.type;
			return little_lexer_LexerTokens.Parameter(name,type,value);
		} else {
			throw haxe_Exception.thrown("That Shouldn't Happen...");
		}
	} else if(TextTools.contains(string,little_Keywords.TYPE_CHECK_OR_CAST)) {
		var extractor = new EReg("(\\w+) +" + little_Keywords.TYPE_CHECK_OR_CAST + " +(\\w+)","");
		extractor.match(StringTools.trim(TextTools.replace(string,"\t"," ")));
		return little_lexer_LexerTokens.Parameter(extractor.matched(1),extractor.matched(2),little_lexer_LexerTokens.StaticValue(little_Keywords.NULL_VALUE));
	} else {
		return little_lexer_LexerTokens.Parameter(StringTools.trim(TextTools.replace(string,"\t"," ")),null,little_lexer_LexerTokens.StaticValue(little_Keywords.NULL_VALUE));
	}
};
little_lexer_Specifics.extractActionBody = function(code) {
	var lastFunctionLineCount = 0;
	var lines = code.split("\n");
	var stack = [];
	var functionBody = "";
	var inFunction = true;
	var _g = 0;
	while(_g < lines.length) {
		var line = lines[_g];
		++_g;
		var lineTrimmed = StringTools.trim(line);
		if(TextTools.countOccurrencesOf(lineTrimmed,"{") != 0) {
			var _g1 = 0;
			var _g2 = TextTools.countOccurrencesOf(lineTrimmed,"{");
			while(_g1 < _g2) {
				var _ = _g1++;
				stack.push(1);
			}
			if(!inFunction) {
				inFunction = true;
			}
		}
		if(TextTools.countOccurrencesOf(lineTrimmed,"}") != 0) {
			var _g3 = 0;
			var _g4 = TextTools.countOccurrencesOf(lineTrimmed,"}");
			while(_g3 < _g4) {
				var _1 = _g3++;
				if(stack.length > 0) {
					stack.pop();
				}
			}
			if(stack.length == 0 && inFunction) {
				inFunction = false;
				break;
			}
		}
		if(inFunction) {
			functionBody += line + "\n";
		}
		++lastFunctionLineCount;
	}
	++lastFunctionLineCount;
	return { body : functionBody.substring(functionBody.indexOf("{") + 1), lineCount : lastFunctionLineCount};
};
little_lexer_Specifics.complexValueIntoLexerTokens = function(complexValue) {
	complexValue = StringTools.trim(complexValue);
	var defValue = little_lexer_LexerTokens.InvalidSyntax(complexValue);
	if(complexValue.replace(little_lexer_Lexer.staticValueDetector.r,"").length == 0) {
		defValue = little_lexer_LexerTokens.StaticValue(complexValue);
	} else if(complexValue.replace(little_lexer_Lexer.definitionAccessDetector.r,"").length == 0) {
		haxe_Log.trace("\"" + complexValue + "\"",{ fileName : "src/little/lexer/Specifics.hx", lineNumber : 127, className : "little.lexer.Specifics", methodName : "complexValueIntoLexerTokens"});
		defValue = little_lexer_LexerTokens.DefinitionAccess(complexValue);
	} else if(complexValue.replace(little_lexer_Lexer.actionCallDetector.r,"").length == 0) {
		var _actionParamSplit = TextTools.splitOnFirst(complexValue,"(");
		var actionName = _actionParamSplit[0];
		var stringifiedParams = _actionParamSplit[1];
		var tmp = _actionParamSplit[1].lastIndexOf(")");
		var params = stringifiedParams.split(",");
		haxe_Log.trace(params,{ fileName : "src/little/lexer/Specifics.hx", lineNumber : 138, className : "little.lexer.Specifics", methodName : "complexValueIntoLexerTokens"});
		var result = new Array(params.length);
		var _g = 0;
		var _g1 = params.length;
		while(_g < _g1) {
			var i = _g++;
			result[i] = StringTools.trim(params[i]);
		}
		params = result;
		haxe_Log.trace(params,{ fileName : "src/little/lexer/Specifics.hx", lineNumber : 140, className : "little.lexer.Specifics", methodName : "complexValueIntoLexerTokens"});
		var _g = [];
		var _g1 = 0;
		while(_g1 < params.length) {
			var p = params[_g1];
			++_g1;
			_g.push(little_lexer_Specifics.extractParam(p));
		}
		defValue = little_lexer_LexerTokens.ActionCall(actionName,_g);
	} else {
		defValue = little_lexer_Specifics.attributesIntoExpression(little_expressions_Expressions.lex(complexValue));
	}
	return defValue;
};
little_lexer_Specifics.attributesIntoExpression = function(calcTokens) {
	var finalTokens = [];
	var _g = 0;
	while(_g < calcTokens.length) {
		var token = calcTokens[_g];
		++_g;
		switch(token._hx_index) {
		case 0:
			var value = token.value;
			finalTokens.push(little_lexer_LexerTokens.DefinitionAccess(value));
			break;
		case 1:
			var value1 = token.value;
			finalTokens.push(little_lexer_LexerTokens.StaticValue(value1));
			break;
		case 2:
			var value2 = token.value;
			finalTokens.push(little_lexer_LexerTokens.StaticValue("\"" + value2 + "\""));
			break;
		case 3:
			var value3 = token.value;
			finalTokens.push(little_lexer_LexerTokens.Sign(value3));
			break;
		case 4:
			var value4 = token.value;
			var content = token.content;
			finalTokens.push(little_lexer_LexerTokens.ActionCall(value4,[little_lexer_Specifics.attributesIntoExpression(content)]));
			break;
		case 5:
			var content1 = token.content;
			finalTokens.push(little_lexer_Specifics.attributesIntoExpression(content1));
			break;
		}
	}
	return little_lexer_LexerTokens.Expression(finalTokens);
};
var little_lexer_ComplexToken = $hxEnums["little.lexer.ComplexToken"] = { __ename__:true,__constructs__:null
	,DefinitionCreationDetails: ($_=function(line,name,complexValue,type) { return {_hx_index:0,line:line,name:name,complexValue:complexValue,type:type,__enum__:"little.lexer.ComplexToken",toString:$estr}; },$_._hx_name="DefinitionCreationDetails",$_.__params__ = ["line","name","complexValue","type"],$_)
	,ActionCreationDetails: ($_=function(line,name,parameters,actionBody,type) { return {_hx_index:1,line:line,name:name,parameters:parameters,actionBody:actionBody,type:type,__enum__:"little.lexer.ComplexToken",toString:$estr}; },$_._hx_name="ActionCreationDetails",$_.__params__ = ["line","name","parameters","actionBody","type"],$_)
	,Assignment: ($_=function(line,value,assignees) { return {_hx_index:2,line:line,value:value,assignees:assignees,__enum__:"little.lexer.ComplexToken",toString:$estr}; },$_._hx_name="Assignment",$_.__params__ = ["line","value","assignees"],$_)
	,ConditionStatement: ($_=function(line,type,conditionExpression,conditionBody) { return {_hx_index:3,line:line,type:type,conditionExpression:conditionExpression,conditionBody:conditionBody,__enum__:"little.lexer.ComplexToken",toString:$estr}; },$_._hx_name="ConditionStatement",$_.__params__ = ["line","type","conditionExpression","conditionBody"],$_)
	,GenericExpression: ($_=function(line,exp) { return {_hx_index:4,line:line,exp:exp,__enum__:"little.lexer.ComplexToken",toString:$estr}; },$_._hx_name="GenericExpression",$_.__params__ = ["line","exp"],$_)
};
little_lexer_ComplexToken.__constructs__ = [little_lexer_ComplexToken.DefinitionCreationDetails,little_lexer_ComplexToken.ActionCreationDetails,little_lexer_ComplexToken.Assignment,little_lexer_ComplexToken.ConditionStatement,little_lexer_ComplexToken.GenericExpression];
var little_lexer_LexerTokens = $hxEnums["little.lexer.LexerTokens"] = { __ename__:true,__constructs__:null
	,SetLine: ($_=function(line) { return {_hx_index:0,line:line,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="SetLine",$_.__params__ = ["line"],$_)
	,DefinitionCreation: ($_=function(name,value,type) { return {_hx_index:1,name:name,value:value,type:type,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="DefinitionCreation",$_.__params__ = ["name","value","type"],$_)
	,ActionCreation: ($_=function(name,params,body,type) { return {_hx_index:2,name:name,params:params,body:body,type:type,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="ActionCreation",$_.__params__ = ["name","params","body","type"],$_)
	,DefinitionAccess: ($_=function(name) { return {_hx_index:3,name:name,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="DefinitionAccess",$_.__params__ = ["name"],$_)
	,DefinitionWrite: ($_=function(assignee,value) { return {_hx_index:4,assignee:assignee,value:value,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="DefinitionWrite",$_.__params__ = ["assignee","value"],$_)
	,Sign: ($_=function(sign) { return {_hx_index:5,sign:sign,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Sign",$_.__params__ = ["sign"],$_)
	,StaticValue: ($_=function(value) { return {_hx_index:6,value:value,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="StaticValue",$_.__params__ = ["value"],$_)
	,Expression: ($_=function(parts) { return {_hx_index:7,parts:parts,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Expression",$_.__params__ = ["parts"],$_)
	,Parameter: ($_=function(name,type,value) { return {_hx_index:8,name:name,type:type,value:value,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Parameter",$_.__params__ = ["name","type","value"],$_)
	,ActionCallParameter: ($_=function(value) { return {_hx_index:9,value:value,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="ActionCallParameter",$_.__params__ = ["value"],$_)
	,ActionCall: ($_=function(name,params) { return {_hx_index:10,name:name,params:params,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="ActionCall",$_.__params__ = ["name","params"],$_)
	,Return: ($_=function(value) { return {_hx_index:11,value:value,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Return",$_.__params__ = ["value"],$_)
	,InvalidSyntax: ($_=function(string) { return {_hx_index:12,string:string,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="InvalidSyntax",$_.__params__ = ["string"],$_)
	,Condition: ($_=function(type,condition,body) { return {_hx_index:13,type:type,condition:condition,body:body,__enum__:"little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Condition",$_.__params__ = ["type","condition","body"],$_)
};
little_lexer_LexerTokens.__constructs__ = [little_lexer_LexerTokens.SetLine,little_lexer_LexerTokens.DefinitionCreation,little_lexer_LexerTokens.ActionCreation,little_lexer_LexerTokens.DefinitionAccess,little_lexer_LexerTokens.DefinitionWrite,little_lexer_LexerTokens.Sign,little_lexer_LexerTokens.StaticValue,little_lexer_LexerTokens.Expression,little_lexer_LexerTokens.Parameter,little_lexer_LexerTokens.ActionCallParameter,little_lexer_LexerTokens.ActionCall,little_lexer_LexerTokens.Return,little_lexer_LexerTokens.InvalidSyntax,little_lexer_LexerTokens.Condition];
var little_parser_Parser = function() { };
little_parser_Parser.__name__ = true;
little_parser_Parser.typeTokens = function(tokens) {
	var unInfoedParserTokens = [];
	var _g = 0;
	while(_g < tokens.length) {
		var token = tokens[_g];
		++_g;
		var tmp;
		switch(token._hx_index) {
		case 0:
			var line = token.line;
			tmp = little_parser_UnInfoedParserTokens.SetLine(line);
			break;
		case 1:
			var name = token.name;
			var value = token.value;
			var type = token.type;
			tmp = little_parser_UnInfoedParserTokens.DefinitionCreation(name,little_parser_Parser.typeTokens([value])[0],type);
			break;
		case 2:
			var name1 = token.name;
			var params = token.params;
			var body = token.body;
			var type1 = token.type;
			tmp = little_parser_UnInfoedParserTokens.ActionCreation(name1,little_parser_Parser.typeTokens(params),little_parser_Parser.typeTokens(body),type1);
			break;
		case 3:
			var name2 = token.name;
			tmp = little_parser_UnInfoedParserTokens.DefinitionAccess(name2);
			break;
		case 4:
			var assignee = token.assignee;
			var value1 = token.value;
			tmp = little_parser_UnInfoedParserTokens.DefinitionWrite(assignee,little_parser_Parser.typeTokens([value1])[0],little_parser_Specifics.evaluateExpressionType(value1));
			break;
		case 5:
			var sign = token.sign;
			tmp = little_parser_UnInfoedParserTokens.Sign(sign);
			break;
		case 6:
			var value2 = token.value;
			tmp = little_parser_UnInfoedParserTokens.StaticValue(value2,little_parser_Specifics.evaluateExpressionType(little_lexer_LexerTokens.StaticValue(value2)));
			break;
		case 7:
			var parts = token.parts;
			tmp = little_parser_UnInfoedParserTokens.Expression(little_parser_Parser.typeTokens(parts),little_parser_Specifics.evaluateExpressionType(little_lexer_LexerTokens.Expression(parts)));
			break;
		case 8:
			var name3 = token.name;
			var type2 = token.type;
			var value3 = token.value;
			tmp = little_parser_UnInfoedParserTokens.Parameter(name3,type2 == null ? little_parser_Specifics.evaluateExpressionType(value3) : type2,little_parser_Parser.typeTokens([value3])[0]);
			break;
		case 9:
			var value4 = token.value;
			tmp = little_parser_UnInfoedParserTokens.ActionCallParameter(little_parser_Parser.typeTokens([value4])[0],little_parser_Specifics.evaluateExpressionType(value4));
			break;
		case 10:
			var name4 = token.name;
			var params1 = token.params;
			tmp = little_parser_UnInfoedParserTokens.ActionCall(name4,little_parser_Parser.typeTokens(params1),little_parser_Specifics.evaluateExpressionType(params1[params1.length - 1]));
			break;
		case 11:
			var value5 = token.value;
			tmp = little_parser_UnInfoedParserTokens.Return(little_parser_Parser.typeTokens([value5])[0],little_parser_Specifics.evaluateExpressionType(value5));
			break;
		case 12:
			var string = token.string;
			tmp = little_parser_UnInfoedParserTokens.InvalidSyntax(string);
			break;
		case 13:
			var type3 = token.type;
			var c = token.condition;
			var body1 = token.body;
			tmp = little_parser_UnInfoedParserTokens.Condition(type3,little_parser_Parser.typeTokens([c])[0],little_parser_Parser.typeTokens(body1));
			break;
		}
		unInfoedParserTokens.push(tmp);
	}
	return unInfoedParserTokens;
};
little_parser_Parser.prettyPrintAst = function(ast,spacingBetweenNodes) {
	if(spacingBetweenNodes == null) {
		spacingBetweenNodes = 6;
	}
	little_parser_Parser.s = TextTools.multiply(" ",spacingBetweenNodes);
	var unfilteredResult = little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.Expression(ast,""),[],0,true);
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
little_parser_Parser.prefixFA = function(pArray) {
	var prefix = "";
	var _g = 0;
	var _g1 = little_parser_Parser.l;
	while(_g < _g1) {
		var i = _g++;
		if(pArray[i] == 1) {
			prefix += "│" + little_parser_Parser.s.substring(1);
		} else {
			prefix += little_parser_Parser.s;
		}
	}
	return prefix;
};
little_parser_Parser.pushIndex = function(pArray,i) {
	var arr = pArray.slice();
	arr[i + 1] = 1;
	return arr;
};
little_parser_Parser.getTree = function(root,prefix,level,last) {
	little_parser_Parser.l = level;
	var t = last ? "└" : "├";
	var c = "├";
	var d = "───";
	if(root == null) {
		return "";
	}
	switch(root._hx_index) {
	case 0:
		var line = root.line;
		return "" + little_parser_Parser.prefixFA(prefix) + t + d + " SetLine(" + line + ")\n";
	case 1:
		var name = root.name;
		var value = root.value;
		var type = root.type;
		return "" + little_parser_Parser.prefixFA(prefix) + t + d + " Definition Creation\n" + little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.StaticValue(name,""),prefix.slice(),level + 1,false) + little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.StaticValue(type,""),prefix.slice(),level + 1,false) + little_parser_Parser.getTree(value,prefix.slice(),level + 1,true);
	case 2:
		var name = root.name;
		var params = root.params;
		var body = root.body;
		var type = root.type;
		var title = "" + little_parser_Parser.prefixFA(prefix) + t + d + " Action Creation\n";
		title += little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.StaticValue(name,""),prefix.slice(),level + 1,false);
		title += little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.StaticValue(type,""),prefix.slice(),level + 1,false);
		title += little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.Expression(params,""),little_parser_Parser.pushIndex(prefix,level),level + 1,false);
		title += little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.Expression(body,""),prefix.slice(),level + 1,true);
		return title;
	case 3:
		var name = root.name;
		return "" + little_parser_Parser.prefixFA(prefix) + t + d + " " + name + "\n";
	case 4:
		var assignee = root.assignee;
		var value = root.value;
		var type = root.valueType;
		var addon = type != "" ? " (" + type + ")" : "";
		return "" + little_parser_Parser.prefixFA(prefix) + t + d + " Definition Write" + addon + "\n" + little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.StaticValue(assignee,""),prefix.slice(),level + 1,false) + little_parser_Parser.getTree(value,prefix.slice(),level + 1,true);
	case 5:
		var value = root.sign;
		return "" + little_parser_Parser.prefixFA(prefix) + t + d + " " + value + "\n";
	case 6:
		var value = root.value;
		var type = root.type;
		var addon = type != "" ? " (" + type + ")" : "";
		return "" + little_parser_Parser.prefixFA(prefix) + t + d + " " + value + addon + "\n";
	case 7:
		var parts = root.parts;
		var type = root.type;
		if(parts.length == 0) {
			return "" + little_parser_Parser.prefixFA(prefix) + t + d + " <empty expression>\n";
		}
		var addon = type != "" ? " (" + type + ")" : "";
		var strParts = ["" + little_parser_Parser.prefixFA(prefix) + t + d + " Expression" + addon + "\n"];
		var _g = [];
		var _g1 = 0;
		var _g2 = parts.length - 1;
		while(_g1 < _g2) {
			var i = _g1++;
			_g.push(little_parser_Parser.getTree(parts[i],little_parser_Parser.pushIndex(prefix,level),level + 1,false));
		}
		var strParts1 = strParts.concat(_g);
		strParts1.push(little_parser_Parser.getTree(parts[parts.length - 1],prefix.slice(),level + 1,true));
		return strParts1.join("");
	case 8:
		var name = root.name;
		var type = root.type;
		var value = root.value;
		if(name == "") {
			name = "<unnamed>";
		}
		if(type == "") {
			type = "<untyped>";
		}
		var addon = type != "" ? " (" + type + ")" : "";
		return "" + little_parser_Parser.prefixFA(prefix) + t + d + " Parameter" + addon + "\n" + little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.StaticValue(name,""),prefix.slice(),level + 1,false) + little_parser_Parser.getTree(value,prefix.slice(),level + 1,true);
	case 9:
		var value = root.value;
		var type = root.type;
		var addon = type != "" ? " (" + type + ")" : "";
		return "" + little_parser_Parser.prefixFA(prefix) + t + d + " Parameter" + addon + "\n" + little_parser_Parser.getTree(value,prefix.slice(),level + 1,true);
	case 10:
		var name = root.name;
		var params = root.params;
		var type = root.returnType;
		var addon = type != "" ? " (" + type + ")" : "";
		var strParts = ["" + little_parser_Parser.prefixFA(prefix) + t + d + " Action Call" + addon + "\n" + little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.StaticValue(name,""),prefix.slice(),level + 1,false)];
		var _g = [];
		var _g1 = 0;
		var _g2 = params.length - 1;
		while(_g1 < _g2) {
			var i = _g1++;
			_g.push(little_parser_Parser.getTree(params[i],little_parser_Parser.pushIndex(prefix,level),level + 1,false));
		}
		var strParts1 = strParts.concat(_g);
		if(params.length == 0) {
			return strParts1.join("");
		}
		strParts1.push(little_parser_Parser.getTree(params[params.length - 1],prefix.slice(),level + 1,true));
		return strParts1.join("");
	case 11:
		var value = root.value;
		var type = root.type;
		var addon = type != "" ? " (" + type + ")" : "";
		return "" + little_parser_Parser.prefixFA(prefix) + t + d + " Return" + addon + "\n" + little_parser_Parser.getTree(value,prefix.slice(),level + 1,true);
	case 12:
		var title = root.title;
		var reason = root.reason;
		return "" + little_parser_Parser.prefixFA(prefix) + t + d + " Error - " + title + ":\n" + little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.StaticValue(reason,""),prefix.slice(),level + 1,true);
	case 13:
		var s = root.string;
		return "" + little_parser_Parser.prefixFA(prefix) + t + d + " INVALID SYNTAX: " + s + "\n";
	case 14:
		var type = root.type;
		var exp = root.condition;
		var body = root.body;
		var title = "" + little_parser_Parser.prefixFA(prefix) + t + d + " Condition\n";
		title += little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.StaticValue(type,""),prefix.slice(),level + 1,false);
		title += little_parser_Parser.getTree(exp,little_parser_Parser.pushIndex(prefix,level),level + 1,false);
		title += little_parser_Parser.getTree(little_parser_UnInfoedParserTokens.Expression(body,""),prefix.slice(),level + 1,true);
		return title;
	}
};
var little_parser_Specifics = function() { };
little_parser_Specifics.__name__ = true;
little_parser_Specifics.evaluateExpressionType = function(exp) {
	switch(exp._hx_index) {
	case 0:
		var line = exp.line;
		return little_Keywords.TYPE_VOID;
	case 1:
		var name = exp.name;
		var value = exp.value;
		var type = exp.type;
		return little_Keywords.TYPE_VOID;
	case 2:
		var name = exp.name;
		var params = exp.params;
		var body = exp.body;
		var type = exp.type;
		return little_Keywords.TYPE_VOID;
	case 3:
		var name = exp.name;
		return little_Keywords.TYPE_UNKNOWN;
	case 4:
		var assignee = exp.assignee;
		var value = exp.value;
		return little_Keywords.TYPE_UNKNOWN;
	case 5:
		var sign = exp.sign;
		return little_Keywords.TYPE_VOID;
	case 6:
		var value = exp.value;
		if(value.replace(little_parser_Parser.stringDetector.r,"").length == 0) {
			return little_Keywords.TYPE_STRING;
		} else if(value.replace(little_parser_Parser.booleanDetector.r,"").length == 0) {
			return little_Keywords.TYPE_BOOLEAN;
		} else if(value.replace(little_parser_Parser.numberDetector.r,"").length == 0) {
			return little_Keywords.TYPE_INT;
		} else if(value.replace(little_parser_Parser.decimalDetector.r,"").length == 0) {
			return little_Keywords.TYPE_FLOAT;
		}
		return little_Keywords.TYPE_UNKNOWN;
	case 7:
		var parts = exp.parts;
		var resultType = "";
		var currentType = "";
		var hierarchy = [little_Keywords.TYPE_BOOLEAN,little_Keywords.TYPE_INT,little_Keywords.TYPE_FLOAT,little_Keywords.TYPE_STRING,little_Keywords.TYPE_UNKNOWN];
		var promoteOnNextFromInt = false;
		var _g = 0;
		while(_g < parts.length) {
			var part = parts[_g];
			++_g;
			switch(part._hx_index) {
			case 3:
				var name = part.name;
				resultType = little_Keywords.TYPE_UNKNOWN;
				break;
			case 5:
				var sign = part.sign;
				if(!TextTools.contains(".+-*",sign) && currentType == little_Keywords.TYPE_INT) {
					promoteOnNextFromInt = true;
				} else if(!TextTools.contains(".+-*",sign) && currentType == little_Keywords.TYPE_STRING) {
					throw haxe_Exception.thrown("Type Mismatch");
				}
				break;
			case 6:
				var value = part.value;
				var valType = little_parser_Specifics.evaluateExpressionType(little_lexer_LexerTokens.StaticValue(value));
				if(hierarchy.indexOf(valType) > hierarchy.indexOf(currentType)) {
					currentType = valType;
				}
				if(hierarchy.indexOf(valType) > hierarchy.indexOf(resultType)) {
					resultType = valType;
				}
				break;
			case 7:
				var parts1 = part.parts;
				var valType1 = little_parser_Specifics.evaluateExpressionType(little_lexer_LexerTokens.Expression(parts1));
				if(hierarchy.indexOf(valType1) > hierarchy.indexOf(currentType)) {
					currentType = valType1;
				}
				if(hierarchy.indexOf(valType1) > hierarchy.indexOf(resultType)) {
					resultType = valType1;
				}
				break;
			default:
				var a = part;
				throw haxe_Exception.thrown("Type Mismatch" + (", " + Std.string(a)));
			}
		}
		return resultType;
	case 8:
		var name = exp.name;
		var type = exp.type;
		var value = exp.value;
		if(type != null && type != little_parser_Specifics.evaluateExpressionType(value)) {
			throw haxe_Exception.thrown("Type Mismatch");
		}
		if(type != null) {
			return type;
		} else {
			return little_parser_Specifics.evaluateExpressionType(value);
		}
		break;
	case 9:
		var value = exp.value;
		return little_parser_Specifics.evaluateExpressionType(value);
	case 10:
		var name = exp.name;
		var params = exp.params;
		return little_Keywords.TYPE_UNKNOWN;
	case 11:
		var value = exp.value;
		return little_parser_Specifics.evaluateExpressionType(value);
	case 12:
		var string = exp.string;
		return little_Keywords.TYPE_VOID;
	case 13:
		var _g = exp.condition;
		var type = exp.type;
		var body = exp.body;
		return little_parser_Specifics.evaluateExpressionType(body[body.length - 1]);
	}
};
var little_parser_UnInfoedParserTokens = $hxEnums["little.parser.UnInfoedParserTokens"] = { __ename__:true,__constructs__:null
	,SetLine: ($_=function(line) { return {_hx_index:0,line:line,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="SetLine",$_.__params__ = ["line"],$_)
	,DefinitionCreation: ($_=function(name,value,type) { return {_hx_index:1,name:name,value:value,type:type,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="DefinitionCreation",$_.__params__ = ["name","value","type"],$_)
	,ActionCreation: ($_=function(name,params,body,type) { return {_hx_index:2,name:name,params:params,body:body,type:type,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="ActionCreation",$_.__params__ = ["name","params","body","type"],$_)
	,DefinitionAccess: ($_=function(name) { return {_hx_index:3,name:name,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="DefinitionAccess",$_.__params__ = ["name"],$_)
	,DefinitionWrite: ($_=function(assignee,value,valueType) { return {_hx_index:4,assignee:assignee,value:value,valueType:valueType,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="DefinitionWrite",$_.__params__ = ["assignee","value","valueType"],$_)
	,Sign: ($_=function(sign) { return {_hx_index:5,sign:sign,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="Sign",$_.__params__ = ["sign"],$_)
	,StaticValue: ($_=function(value,type) { return {_hx_index:6,value:value,type:type,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="StaticValue",$_.__params__ = ["value","type"],$_)
	,Expression: ($_=function(parts,type) { return {_hx_index:7,parts:parts,type:type,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="Expression",$_.__params__ = ["parts","type"],$_)
	,Parameter: ($_=function(name,type,value) { return {_hx_index:8,name:name,type:type,value:value,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="Parameter",$_.__params__ = ["name","type","value"],$_)
	,ActionCallParameter: ($_=function(value,type) { return {_hx_index:9,value:value,type:type,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="ActionCallParameter",$_.__params__ = ["value","type"],$_)
	,ActionCall: ($_=function(name,params,returnType) { return {_hx_index:10,name:name,params:params,returnType:returnType,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="ActionCall",$_.__params__ = ["name","params","returnType"],$_)
	,Return: ($_=function(value,type) { return {_hx_index:11,value:value,type:type,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="Return",$_.__params__ = ["value","type"],$_)
	,Error: ($_=function(title,reason) { return {_hx_index:12,title:title,reason:reason,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="Error",$_.__params__ = ["title","reason"],$_)
	,InvalidSyntax: ($_=function(string) { return {_hx_index:13,string:string,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="InvalidSyntax",$_.__params__ = ["string"],$_)
	,Condition: ($_=function(type,condition,body) { return {_hx_index:14,type:type,condition:condition,body:body,__enum__:"little.parser.UnInfoedParserTokens",toString:$estr}; },$_._hx_name="Condition",$_.__params__ = ["type","condition","body"],$_)
};
little_parser_UnInfoedParserTokens.__constructs__ = [little_parser_UnInfoedParserTokens.SetLine,little_parser_UnInfoedParserTokens.DefinitionCreation,little_parser_UnInfoedParserTokens.ActionCreation,little_parser_UnInfoedParserTokens.DefinitionAccess,little_parser_UnInfoedParserTokens.DefinitionWrite,little_parser_UnInfoedParserTokens.Sign,little_parser_UnInfoedParserTokens.StaticValue,little_parser_UnInfoedParserTokens.Expression,little_parser_UnInfoedParserTokens.Parameter,little_parser_UnInfoedParserTokens.ActionCallParameter,little_parser_UnInfoedParserTokens.ActionCall,little_parser_UnInfoedParserTokens.Return,little_parser_UnInfoedParserTokens.Error,little_parser_UnInfoedParserTokens.InvalidSyntax,little_parser_UnInfoedParserTokens.Condition];
var texter_general_CharTools = function() { };
texter_general_CharTools.__name__ = true;
if(typeof(performance) != "undefined" ? typeof(performance.now) == "function" : false) {
	HxOverrides.now = performance.now.bind(performance);
}
String.__name__ = true;
Array.__name__ = true;
js_Boot.__toStr = ({ }).toString;
little_Keywords.VARIABLE_DECLARATION = "define";
little_Keywords.FUNCTION_DECLARATION = "action";
little_Keywords.TYPE_CHECK_OR_CAST = "as";
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
little_Keywords.TYPE_UNKNOWN = "Unknown";
little_Keywords.CONDITION_TYPES = ["if","while","whenever","for"];
little_lexer_Lexer.nameDetector = new EReg("(\\w+)","");
little_lexer_Lexer.typeDetector = new EReg("(\\w+)","");
little_lexer_Lexer.assignmentDetector = new EReg("(?:\\w|\\.)+ *(?:=[^=]+)+","");
little_lexer_Lexer.conditionDetector = new EReg("^(\\w+) *\\(([^\n]+)\\) *(?:\\{{0,})","");
little_lexer_Lexer.staticValueString = "[0-9\\.]+|\"[^\"]*\"|" + little_Keywords.TRUE_VALUE + "|" + little_Keywords.FALSE_VALUE + "|" + little_Keywords.NULL_VALUE;
little_lexer_Lexer.staticValueDetector = new EReg(little_lexer_Lexer.staticValueString,"");
little_lexer_Lexer.actionCallDetector = new EReg("\\w+ *\\(.*\\)$","");
little_lexer_Lexer.definitionAccessDetector = new EReg("^[^0-9]\\w*$","");
little_parser_Parser.numberDetector = new EReg("([0-9]+)","");
little_parser_Parser.decimalDetector = new EReg("([0-9\\.]+)","");
little_parser_Parser.booleanDetector = new EReg("true|false","");
little_parser_Parser.stringDetector = new EReg("\"[^\"]*\"","");
little_parser_Parser.s = "";
little_parser_Parser.l = 0;
texter_general_CharTools.numericChars = new EReg("[0-9]","g");
texter_general_CharTools.softChars = ["!","\"","#","$","%","&","'","(",")","*","+",",","-",".","/",":",";","<","=",">","?","@","[","\\","]","^","_","`","{","|","}","~","^"," ","\t"];
Main.main();
})({});

//# sourceMappingURL=interp.js.map