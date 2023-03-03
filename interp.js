(function ($global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); },$hxEnums = $hxEnums || {},$_;
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
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var text = window.document.getElementById("input");
	var output = window.document.getElementById("output");
	haxe_Log.trace(text,{ fileName : "src/Main.hx", lineNumber : 30, className : "Main", methodName : "main", customParams : [output]});
	text.addEventListener("keyup",function(_) {
		try {
			var tmp = refactored_$little_parser_Parser.parse(refactored_$little_lexer_Lexer.lex(text.value));
			output.innerHTML = refactored_$little_tools_PrettyPrinter.printParserAst(tmp);
		} catch( _g ) {
		}
	});
	var tmp = refactored_$little_parser_Parser.parse(refactored_$little_lexer_Lexer.lex(text.value));
	output.innerHTML = refactored_$little_tools_PrettyPrinter.printParserAst(tmp);
	text.innerHTML = Main.code;
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
var TextTools = function() { };
TextTools.__name__ = true;
TextTools.replaceFirst = function(string,replace,by) {
	var place = string.indexOf(replace);
	var result = string.substring(0,place) + by + string.substring(place + replace.length);
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
TextTools.sortByLength = function(array) {
	array.sort(function(a,b) {
		return a.length - b.length;
	});
	return array;
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
var refactored_$little_Keywords = function() { };
refactored_$little_Keywords.__name__ = true;
var refactored_$little_lexer_Lexer = function() { };
refactored_$little_lexer_Lexer.__name__ = true;
refactored_$little_lexer_Lexer.lex = function(code) {
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
			tokens.push(refactored_$little_lexer_LexerTokens.Characters(string));
		} else if(TextTools.contains("1234567890.",char)) {
			var num = char;
			++i;
			while(i < code.length && TextTools.contains("1234567890.",code.charAt(i))) {
				num += code.charAt(i);
				++i;
			}
			--i;
			tokens.push(refactored_$little_lexer_LexerTokens.Number(num));
		} else if(char == "\n") {
			tokens.push(refactored_$little_lexer_LexerTokens.Newline);
		} else if(char == ";") {
			tokens.push(refactored_$little_lexer_LexerTokens.SplitLine);
		} else if(refactored_$little_lexer_Lexer.signs.indexOf(char) != -1) {
			var sign = char;
			++i;
			while(i < code.length && refactored_$little_lexer_Lexer.signs.indexOf(code.charAt(i)) != -1) {
				sign += code.charAt(i);
				++i;
			}
			--i;
			tokens.push(refactored_$little_lexer_LexerTokens.Sign(sign));
		} else if(new EReg("\\w","").match(char)) {
			var name = char;
			++i;
			while(i < code.length && new EReg("\\w","").match(code.charAt(i))) {
				name += code.charAt(i);
				++i;
			}
			--i;
			tokens.push(refactored_$little_lexer_LexerTokens.Identifier(name));
		}
		++i;
	}
	tokens = refactored_$little_lexer_Lexer.separateBooleanIdentifiers(tokens);
	tokens = refactored_$little_lexer_Lexer.mergeOrSplitKnownSigns(tokens);
	return tokens;
};
refactored_$little_lexer_Lexer.separateBooleanIdentifiers = function(tokens) {
	var result = new Array(tokens.length);
	var _g = 0;
	var _g1 = tokens.length;
	while(_g < _g1) {
		var i = _g++;
		var token = tokens[i];
		result[i] = Type.enumEq(token,refactored_$little_lexer_LexerTokens.Identifier(refactored_$little_Keywords.TRUE_VALUE)) || Type.enumEq(token,refactored_$little_lexer_LexerTokens.Identifier(refactored_$little_Keywords.FALSE_VALUE)) ? refactored_$little_lexer_LexerTokens.Boolean(Type.enumParameters(token)[0]) : Type.enumEq(token,refactored_$little_lexer_LexerTokens.Identifier(refactored_$little_Keywords.NULL_VALUE)) ? refactored_$little_lexer_LexerTokens.NullValue : token;
	}
	return result;
};
refactored_$little_lexer_Lexer.mergeOrSplitKnownSigns = function(tokens) {
	var post = [];
	var i = 0;
	while(i < tokens.length) {
		var token = tokens[i];
		if(token._hx_index == 1) {
			var char = token.char;
			refactored_$little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS = TextTools.sortByLength(refactored_$little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS);
			refactored_$little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS.reverse();
			var shouldContinue = false;
			while(char.length > 0) {
				shouldContinue = false;
				var _g = 0;
				var _g1 = refactored_$little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS;
				while(_g < _g1.length) {
					var sign = _g1[_g];
					++_g;
					if(StringTools.startsWith(char,sign)) {
						char = char.substring(sign.length);
						post.push(refactored_$little_lexer_LexerTokens.Sign(sign));
						shouldContinue = true;
						break;
					}
				}
				if(shouldContinue) {
					continue;
				}
				post.push(refactored_$little_lexer_LexerTokens.Sign(char.charAt(0)));
				char = char.substring(1);
			}
		} else {
			post.push(token);
		}
		++i;
	}
	return post;
};
var refactored_$little_lexer_LexerTokens = $hxEnums["refactored_little.lexer.LexerTokens"] = { __ename__:true,__constructs__:null
	,Identifier: ($_=function(name) { return {_hx_index:0,name:name,__enum__:"refactored_little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Identifier",$_.__params__ = ["name"],$_)
	,Sign: ($_=function(char) { return {_hx_index:1,char:char,__enum__:"refactored_little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Sign",$_.__params__ = ["char"],$_)
	,Number: ($_=function(num) { return {_hx_index:2,num:num,__enum__:"refactored_little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Number",$_.__params__ = ["num"],$_)
	,Boolean: ($_=function(value) { return {_hx_index:3,value:value,__enum__:"refactored_little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Boolean",$_.__params__ = ["value"],$_)
	,Characters: ($_=function(string) { return {_hx_index:4,string:string,__enum__:"refactored_little.lexer.LexerTokens",toString:$estr}; },$_._hx_name="Characters",$_.__params__ = ["string"],$_)
	,NullValue: {_hx_name:"NullValue",_hx_index:5,__enum__:"refactored_little.lexer.LexerTokens",toString:$estr}
	,Newline: {_hx_name:"Newline",_hx_index:6,__enum__:"refactored_little.lexer.LexerTokens",toString:$estr}
	,SplitLine: {_hx_name:"SplitLine",_hx_index:7,__enum__:"refactored_little.lexer.LexerTokens",toString:$estr}
};
refactored_$little_lexer_LexerTokens.__constructs__ = [refactored_$little_lexer_LexerTokens.Identifier,refactored_$little_lexer_LexerTokens.Sign,refactored_$little_lexer_LexerTokens.Number,refactored_$little_lexer_LexerTokens.Boolean,refactored_$little_lexer_LexerTokens.Characters,refactored_$little_lexer_LexerTokens.NullValue,refactored_$little_lexer_LexerTokens.Newline,refactored_$little_lexer_LexerTokens.SplitLine];
var refactored_$little_parser_Parser = function() { };
refactored_$little_parser_Parser.__name__ = true;
refactored_$little_parser_Parser.parse = function(lexerTokens) {
	var tokens = [];
	var line = 1;
	var i = 0;
	while(i < lexerTokens.length) {
		var token = lexerTokens[i];
		switch(token._hx_index) {
		case 0:
			var name = token.name;
			tokens.push(refactored_$little_parser_ParserTokens.Identifier(name));
			break;
		case 1:
			var char = token.char;
			tokens.push(refactored_$little_parser_ParserTokens.Sign(char));
			break;
		case 2:
			var num = token.num;
			if(TextTools.countOccurrencesOf(num,".") == 0) {
				tokens.push(refactored_$little_parser_ParserTokens.Number(num));
			} else if(TextTools.countOccurrencesOf(num,".") == 1) {
				tokens.push(refactored_$little_parser_ParserTokens.Decimal(num));
			}
			break;
		case 3:
			var value = token.value;
			if(value == refactored_$little_Keywords.FALSE_VALUE) {
				tokens.push(refactored_$little_parser_ParserTokens.FalseValue);
			} else if(value == refactored_$little_Keywords.TRUE_VALUE) {
				tokens.push(refactored_$little_parser_ParserTokens.TrueValue);
			}
			break;
		case 4:
			var string = token.string;
			tokens.push(refactored_$little_parser_ParserTokens.Characters(string));
			break;
		case 5:
			tokens.push(refactored_$little_parser_ParserTokens.NullValue);
			break;
		case 6:
			tokens.push(refactored_$little_parser_ParserTokens.SetLine(line));
			++line;
			break;
		case 7:
			tokens.push(refactored_$little_parser_ParserTokens.SplitLine);
			break;
		}
		++i;
	}
	tokens = refactored_$little_parser_Parser.mergeBlocks(tokens);
	tokens = refactored_$little_parser_Parser.mergeExpressions(tokens);
	tokens = refactored_$little_parser_Parser.mergeTypeDecls(tokens);
	tokens = refactored_$little_parser_Parser.mergeComplexStructures(tokens);
	tokens = refactored_$little_parser_Parser.mergeCalls(tokens);
	tokens = refactored_$little_parser_Parser.mergeWrites(tokens);
	return tokens;
};
refactored_$little_parser_Parser.mergeTypeDecls = function(pre) {
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
			if(word == refactored_$little_Keywords.TYPE_DECL_OR_CAST && i + 1 < pre.length) {
				var lookahead = pre[i + 1];
				post.push(refactored_$little_parser_ParserTokens.TypeDeclaration(lookahead));
				++i;
			} else {
				post.push(token);
			}
			break;
		case 11:
			var parts = token.parts;
			var type = token.type;
			post.push(refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeTypeDecls(parts),null));
			break;
		case 12:
			var body = token.body;
			var type1 = token.type;
			post.push(refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeTypeDecls(body),null));
			break;
		default:
			post.push(token);
		}
		++i;
	}
	return post;
};
refactored_$little_parser_Parser.mergeBlocks = function(pre) {
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
			post.push(refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeBlocks(parts),null));
			break;
		case 12:
			var body = token.body;
			var type1 = token.type;
			post.push(refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeBlocks(body),null));
			break;
		case 15:
			if(token.sign == "{") {
				var blockBody = [];
				var blockStack = 1;
				while(i + 1 < pre.length) {
					var lookahead = pre[i + 1];
					if(Type.enumEq(lookahead,refactored_$little_parser_ParserTokens.Sign("{"))) {
						++blockStack;
						blockBody.push(lookahead);
					} else if(Type.enumEq(lookahead,refactored_$little_parser_ParserTokens.Sign("}"))) {
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
				post.push(refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeBlocks(blockBody),null));
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
refactored_$little_parser_Parser.mergeExpressions = function(pre) {
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
			post.push(refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeExpressions(parts),null));
			break;
		case 12:
			var body = token.body;
			var type1 = token.type;
			post.push(refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeExpressions(body),null));
			break;
		case 15:
			if(token.sign == "(") {
				var expressionBody = [];
				var expressionStack = 1;
				while(i + 1 < pre.length) {
					var lookahead = pre[i + 1];
					if(Type.enumEq(lookahead,refactored_$little_parser_ParserTokens.Sign("("))) {
						++expressionStack;
						expressionBody.push(lookahead);
					} else if(Type.enumEq(lookahead,refactored_$little_parser_ParserTokens.Sign(")"))) {
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
				post.push(refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeExpressions(expressionBody),null));
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
refactored_$little_parser_Parser.mergeComplexStructures = function(pre) {
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
			if(_g == refactored_$little_Keywords.VARIABLE_DECLARATION == true) {
				++i;
				if(i >= pre.length) {
					return null;
				}
				var name = null;
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
						if(name == null) {
							return null;
						}
						type = typeToken;
						break _hx_loop2;
					case 11:
						var body = lookahead.parts;
						var type1 = lookahead.type;
						if(name == null) {
							name = refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeComplexStructures(body),type1);
						} else if(type1 == null) {
							type1 = refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeComplexStructures(body),type1);
						} else {
							--i;
							break _hx_loop2;
						}
						break;
					case 12:
						var body1 = lookahead.body;
						var type2 = lookahead.type;
						if(name == null) {
							name = refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeComplexStructures(body1),type2);
						} else if(type2 == null) {
							type2 = refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeComplexStructures(body1),type2);
						} else {
							--i;
							break _hx_loop2;
						}
						break;
					case 15:
						if(lookahead.sign == "=") {
							--i;
							break _hx_loop2;
						} else if(name == null) {
							name = lookahead;
						} else if(type == null) {
							type = lookahead;
						} else {
							--i;
							break _hx_loop2;
						}
						break;
					default:
						if(name == null) {
							name = lookahead;
						} else if(type == null) {
							type = lookahead;
						} else {
							--i;
							break _hx_loop2;
						}
					}
					++i;
				}
				post.push(refactored_$little_parser_ParserTokens.Define(name,type));
			} else {
				_hx_tmp2 = _g == refactored_$little_Keywords.FUNCTION_DECLARATION;
				if(_hx_tmp2 == true) {
					++i;
					if(i >= pre.length) {
						return null;
					}
					var name1 = null;
					var params = null;
					var type3 = null;
					_hx_loop3: while(i < pre.length) {
						var lookahead1 = pre[i];
						switch(lookahead1._hx_index) {
						case 0:
							var _g2 = lookahead1.line;
							--i;
							break _hx_loop3;
						case 1:
							--i;
							break _hx_loop3;
						case 8:
							var typeToken1 = lookahead1.type;
							if(name1 == null) {
								return null;
							} else if(type3 == null) {
								return null;
							}
							type3 = typeToken1;
							break _hx_loop3;
						case 11:
							var body2 = lookahead1.parts;
							var type4 = lookahead1.type;
							if(name1 == null) {
								name1 = refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeComplexStructures(body2),type4);
							} else if(params == null) {
								params = refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeComplexStructures(body2),type4);
							} else if(type4 == null) {
								type4 = refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeComplexStructures(body2),type4);
							} else {
								--i;
								break _hx_loop3;
							}
							break;
						case 12:
							var body3 = lookahead1.body;
							var type5 = lookahead1.type;
							if(name1 == null) {
								name1 = refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeComplexStructures(body3),type5);
							} else if(params == null) {
								params = refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeComplexStructures(body3),type5);
							} else if(type5 == null) {
								type5 = refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeComplexStructures(body3),type5);
							} else {
								--i;
								break _hx_loop3;
							}
							break;
						case 15:
							if(lookahead1.sign == "=") {
								--i;
								break _hx_loop3;
							} else if(name1 == null) {
								name1 = lookahead1;
							} else if(params == null) {
								params = lookahead1;
							} else if(type3 == null) {
								type3 = lookahead1;
							} else {
								--i;
								break _hx_loop3;
							}
							break;
						default:
							if(name1 == null) {
								name1 = lookahead1;
							} else if(params == null) {
								params = lookahead1;
							} else if(type3 == null) {
								type3 = lookahead1;
							} else {
								--i;
								break _hx_loop3;
							}
						}
						++i;
					}
					--i;
					post.push(refactored_$little_parser_ParserTokens.Action(name1,params,type3));
				} else {
					_hx_tmp1 = refactored_$little_Keywords.CONDITION_TYPES.indexOf(_g) != -1;
					if(_hx_tmp1 == true) {
						++i;
						if(i >= pre.length) {
							return null;
						}
						var name2 = refactored_$little_parser_ParserTokens.Identifier(Type.enumParameters(token)[0]);
						var exp = null;
						var body4 = null;
						var type6 = null;
						_hx_loop4: while(i < pre.length) {
							var lookahead2 = pre[i];
							switch(lookahead2._hx_index) {
							case 0:
								var _g3 = lookahead2.line;
								break;
							case 1:
								break;
							case 11:
								var parts = lookahead2.parts;
								var type7 = lookahead2.type;
								if(exp == null) {
									exp = refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeComplexStructures(parts),type7);
								} else if(body4 == null) {
									body4 = refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeComplexStructures(parts),type7);
								} else {
									break _hx_loop4;
								}
								break;
							case 12:
								var b = lookahead2.body;
								var type8 = lookahead2.type;
								if(exp == null) {
									exp = refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeComplexStructures(b),type8);
								} else if(body4 == null) {
									body4 = refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeComplexStructures(b),type8);
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
							var _g4 = pre[i + 1];
							switch(_g4._hx_index) {
							case 8:
								var _g5 = _g4.type;
								type6 = pre[i + 1];
								break;
							case 12:
								var _g6 = _g4.body;
								var _g7 = _g4.type;
								type6 = pre[i + 1];
								break;
							default:
							}
						}
						post.push(refactored_$little_parser_ParserTokens.Condition(name2,exp,body4,type6));
					} else {
						_hx_tmp = _g == refactored_$little_Keywords.FUNCTION_RETURN;
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
									var _g8 = lookahead3.line;
									--i;
									break _hx_loop5;
								case 1:
									--i;
									break _hx_loop5;
								case 11:
									var body5 = lookahead3.parts;
									var type9 = lookahead3.type;
									valueToReturn.push(refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeComplexStructures(body5),type9));
									break;
								case 12:
									var body6 = lookahead3.body;
									var type10 = lookahead3.type;
									valueToReturn.push(refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeComplexStructures(body6),type10));
									break;
								default:
									valueToReturn.push(lookahead3);
								}
								++i;
							}
							post.push(refactored_$little_parser_ParserTokens.Return(valueToReturn.length == 1 ? valueToReturn[0] : refactored_$little_parser_ParserTokens.Expression(valueToReturn.slice(),null),null));
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
			post.push(refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeComplexStructures(parts1),null));
			break;
		case 12:
			var body7 = token.body;
			var type12 = token.type;
			post.push(refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeComplexStructures(body7),null));
			break;
		default:
			post.push(token);
		}
		++i;
	}
	return post;
};
refactored_$little_parser_Parser.mergeWrites = function(pre) {
	if(pre == null) {
		return null;
	}
	var post = [];
	var potentialAssignee = refactored_$little_parser_ParserTokens.NullValue;
	var i = 0;
	_hx_loop1: while(i < pre.length) {
		var token = pre[i];
		switch(token._hx_index) {
		case 2:
			var name = token.name;
			var type = token.type;
			post.push(potentialAssignee);
			potentialAssignee = refactored_$little_parser_ParserTokens.Define(refactored_$little_parser_Parser.mergeWrites([name])[0],type);
			break;
		case 3:
			var name1 = token.name;
			var params = token.params;
			var type1 = token.type;
			post.push(potentialAssignee);
			potentialAssignee = refactored_$little_parser_ParserTokens.Action(refactored_$little_parser_Parser.mergeWrites([name1])[0],refactored_$little_parser_Parser.mergeWrites([params])[0],type1);
			break;
		case 4:
			var name2 = token.name;
			var exp = token.exp;
			var body = token.body;
			var type2 = token.type;
			post.push(potentialAssignee);
			potentialAssignee = refactored_$little_parser_ParserTokens.Condition(refactored_$little_parser_Parser.mergeWrites([name2])[0],refactored_$little_parser_Parser.mergeWrites([exp])[0],refactored_$little_parser_Parser.mergeWrites([body])[0],type2);
			break;
		case 9:
			var name3 = token.name;
			var params1 = token.params;
			post.push(potentialAssignee);
			potentialAssignee = refactored_$little_parser_ParserTokens.ActionCall(refactored_$little_parser_Parser.mergeWrites([name3])[0],refactored_$little_parser_Parser.mergeWrites([params1])[0]);
			break;
		case 10:
			var value = token.value;
			var type3 = token.type;
			post.push(potentialAssignee);
			potentialAssignee = refactored_$little_parser_ParserTokens.Return(refactored_$little_parser_Parser.mergeWrites([value])[0],type3);
			break;
		case 11:
			var parts = token.parts;
			var type4 = token.type;
			post.push(potentialAssignee);
			potentialAssignee = refactored_$little_parser_ParserTokens.Expression(refactored_$little_parser_Parser.mergeWrites(parts),type4);
			break;
		case 12:
			var body1 = token.body;
			var type5 = token.type;
			post.push(potentialAssignee);
			potentialAssignee = refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeWrites(body1),type5);
			break;
		case 15:
			if(token.sign == "=") {
				if(i + 1 >= pre.length) {
					break _hx_loop1;
				}
				var currentAssignee = [potentialAssignee];
				if(potentialAssignee._hx_index == 11) {
					var _g = potentialAssignee.parts;
					var _g1 = potentialAssignee.type;
					_hx_loop2: while(true) {
						var _g2 = post[post.length - 1];
						switch(_g2._hx_index) {
						case 0:
							var _g3 = _g2.line;
							break _hx_loop2;
						case 1:
							break _hx_loop2;
						case 11:
							var _g4 = _g2.parts;
							var _g5 = _g2.type;
							currentAssignee.unshift(post.pop());
							break;
						case 15:
							var _g6 = _g2.sign;
							break _hx_loop2;
						default:
							currentAssignee.unshift(post.pop());
							break _hx_loop2;
						}
					}
				}
				var assignees = [currentAssignee.length == 1 ? currentAssignee[0] : refactored_$little_parser_ParserTokens.Expression(currentAssignee.slice(),null)];
				currentAssignee = [];
				_hx_loop3: while(i + 1 < pre.length) {
					var lookahead = pre[i + 1];
					switch(lookahead._hx_index) {
					case 0:
						var _g7 = lookahead.line;
						break _hx_loop3;
					case 1:
						break _hx_loop3;
					case 15:
						if(lookahead.sign == "=") {
							var assignee = currentAssignee.length == 1 ? currentAssignee[0] : refactored_$little_parser_ParserTokens.Expression(currentAssignee.slice(),null);
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
				var value1 = refactored_$little_parser_ParserTokens.Expression(currentAssignee,null);
				post.push(refactored_$little_parser_ParserTokens.Write(assignees,value1,null));
				potentialAssignee = null;
			} else {
				post.push(potentialAssignee);
				potentialAssignee = token;
			}
			break;
		default:
			post.push(potentialAssignee);
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
refactored_$little_parser_Parser.mergeCalls = function(pre) {
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
			post.push(refactored_$little_parser_ParserTokens.Define(refactored_$little_parser_Parser.mergeCalls([name])[0],type));
			break;
		case 3:
			var name1 = token.name;
			var params = token.params;
			var type1 = token.type;
			post.push(refactored_$little_parser_ParserTokens.Action(refactored_$little_parser_Parser.mergeCalls([name1])[0],refactored_$little_parser_Parser.mergeCalls([params])[0],type1));
			break;
		case 4:
			var name2 = token.name;
			var exp = token.exp;
			var body = token.body;
			var type2 = token.type;
			post.push(refactored_$little_parser_ParserTokens.Condition(refactored_$little_parser_Parser.mergeCalls([name2])[0],refactored_$little_parser_Parser.mergeCalls([exp])[0],refactored_$little_parser_Parser.mergeCalls([body])[0],type2));
			break;
		case 10:
			var value = token.value;
			var type3 = token.type;
			post.push(refactored_$little_parser_ParserTokens.Return(refactored_$little_parser_Parser.mergeCalls([value])[0],type3));
			break;
		case 11:
			var parts = token.parts;
			var type4 = token.type;
			parts = refactored_$little_parser_Parser.mergeCalls(parts);
			if(i == 0) {
				post.push(refactored_$little_parser_ParserTokens.Expression(parts,type4));
			} else {
				var lookbehind = pre[i - 1];
				switch(lookbehind._hx_index) {
				case 0:
					var _g = lookbehind.line;
					post.push(refactored_$little_parser_ParserTokens.Expression(parts,type4));
					break;
				case 1:
					post.push(refactored_$little_parser_ParserTokens.Expression(parts,type4));
					break;
				case 15:
					var _g1 = lookbehind.sign;
					post.push(refactored_$little_parser_ParserTokens.Expression(parts,type4));
					break;
				default:
					var previous = post.pop();
					token = refactored_$little_parser_ParserTokens.PartArray(parts);
					post.push(refactored_$little_parser_ParserTokens.ActionCall(previous,token));
				}
			}
			break;
		case 12:
			var body1 = token.body;
			var type5 = token.type;
			post.push(refactored_$little_parser_ParserTokens.Block(refactored_$little_parser_Parser.mergeCalls(body1),type5));
			break;
		case 13:
			var parts1 = token.parts;
			post.push(refactored_$little_parser_ParserTokens.PartArray(refactored_$little_parser_Parser.mergeCalls(parts1)));
			break;
		default:
			post.push(token);
		}
		++i;
	}
	return post;
};
var refactored_$little_parser_ParserTokens = $hxEnums["refactored_little.parser.ParserTokens"] = { __ename__:true,__constructs__:null
	,SetLine: ($_=function(line) { return {_hx_index:0,line:line,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="SetLine",$_.__params__ = ["line"],$_)
	,SplitLine: {_hx_name:"SplitLine",_hx_index:1,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}
	,Define: ($_=function(name,type) { return {_hx_index:2,name:name,type:type,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Define",$_.__params__ = ["name","type"],$_)
	,Action: ($_=function(name,params,type) { return {_hx_index:3,name:name,params:params,type:type,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Action",$_.__params__ = ["name","params","type"],$_)
	,Condition: ($_=function(name,exp,body,type) { return {_hx_index:4,name:name,exp:exp,body:body,type:type,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Condition",$_.__params__ = ["name","exp","body","type"],$_)
	,Read: ($_=function(name) { return {_hx_index:5,name:name,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Read",$_.__params__ = ["name"],$_)
	,Write: ($_=function(assignees,value,type) { return {_hx_index:6,assignees:assignees,value:value,type:type,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Write",$_.__params__ = ["assignees","value","type"],$_)
	,Identifier: ($_=function(word) { return {_hx_index:7,word:word,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Identifier",$_.__params__ = ["word"],$_)
	,TypeDeclaration: ($_=function(type) { return {_hx_index:8,type:type,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="TypeDeclaration",$_.__params__ = ["type"],$_)
	,ActionCall: ($_=function(name,params) { return {_hx_index:9,name:name,params:params,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="ActionCall",$_.__params__ = ["name","params"],$_)
	,Return: ($_=function(value,type) { return {_hx_index:10,value:value,type:type,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Return",$_.__params__ = ["value","type"],$_)
	,Expression: ($_=function(parts,type) { return {_hx_index:11,parts:parts,type:type,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Expression",$_.__params__ = ["parts","type"],$_)
	,Block: ($_=function(body,type) { return {_hx_index:12,body:body,type:type,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Block",$_.__params__ = ["body","type"],$_)
	,PartArray: ($_=function(parts) { return {_hx_index:13,parts:parts,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="PartArray",$_.__params__ = ["parts"],$_)
	,Parameter: ($_=function(name,type) { return {_hx_index:14,name:name,type:type,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Parameter",$_.__params__ = ["name","type"],$_)
	,Sign: ($_=function(sign) { return {_hx_index:15,sign:sign,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Sign",$_.__params__ = ["sign"],$_)
	,Number: ($_=function(num) { return {_hx_index:16,num:num,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Number",$_.__params__ = ["num"],$_)
	,Decimal: ($_=function(num) { return {_hx_index:17,num:num,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Decimal",$_.__params__ = ["num"],$_)
	,Characters: ($_=function(string) { return {_hx_index:18,string:string,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}; },$_._hx_name="Characters",$_.__params__ = ["string"],$_)
	,NullValue: {_hx_name:"NullValue",_hx_index:19,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}
	,TrueValue: {_hx_name:"TrueValue",_hx_index:20,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}
	,FalseValue: {_hx_name:"FalseValue",_hx_index:21,__enum__:"refactored_little.parser.ParserTokens",toString:$estr}
};
refactored_$little_parser_ParserTokens.__constructs__ = [refactored_$little_parser_ParserTokens.SetLine,refactored_$little_parser_ParserTokens.SplitLine,refactored_$little_parser_ParserTokens.Define,refactored_$little_parser_ParserTokens.Action,refactored_$little_parser_ParserTokens.Condition,refactored_$little_parser_ParserTokens.Read,refactored_$little_parser_ParserTokens.Write,refactored_$little_parser_ParserTokens.Identifier,refactored_$little_parser_ParserTokens.TypeDeclaration,refactored_$little_parser_ParserTokens.ActionCall,refactored_$little_parser_ParserTokens.Return,refactored_$little_parser_ParserTokens.Expression,refactored_$little_parser_ParserTokens.Block,refactored_$little_parser_ParserTokens.PartArray,refactored_$little_parser_ParserTokens.Parameter,refactored_$little_parser_ParserTokens.Sign,refactored_$little_parser_ParserTokens.Number,refactored_$little_parser_ParserTokens.Decimal,refactored_$little_parser_ParserTokens.Characters,refactored_$little_parser_ParserTokens.NullValue,refactored_$little_parser_ParserTokens.TrueValue,refactored_$little_parser_ParserTokens.FalseValue];
var refactored_$little_tools_PrettyPrinter = function() { };
refactored_$little_tools_PrettyPrinter.__name__ = true;
refactored_$little_tools_PrettyPrinter.printParserAst = function(ast,spacingBetweenNodes) {
	if(spacingBetweenNodes == null) {
		spacingBetweenNodes = 6;
	}
	if(ast == null) {
		return "null (look for errors in input)";
	}
	refactored_$little_tools_PrettyPrinter.s = TextTools.multiply(" ",spacingBetweenNodes);
	var unfilteredResult = refactored_$little_tools_PrettyPrinter.getTree(refactored_$little_parser_ParserTokens.Expression(ast,null),[],0,true);
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
refactored_$little_tools_PrettyPrinter.prefixFA = function(pArray) {
	var prefix = "";
	var _g = 0;
	var _g1 = refactored_$little_tools_PrettyPrinter.l;
	while(_g < _g1) {
		var i = _g++;
		if(pArray[i] == 1) {
			prefix += "│" + refactored_$little_tools_PrettyPrinter.s.substring(1);
		} else {
			prefix += refactored_$little_tools_PrettyPrinter.s;
		}
	}
	return prefix;
};
refactored_$little_tools_PrettyPrinter.pushIndex = function(pArray,i) {
	var arr = pArray.slice();
	arr[i + 1] = 1;
	return arr;
};
refactored_$little_tools_PrettyPrinter.getTree = function(root,prefix,level,last) {
	refactored_$little_tools_PrettyPrinter.l = level;
	var t = last ? "└" : "├";
	var c = "├";
	var d = "───";
	if(root == null) {
		return "";
	}
	switch(root._hx_index) {
	case 0:
		var line = root.line;
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " SetLine(" + line + ")\n";
	case 1:
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " SplitLine\n";
	case 2:
		var name = root.name;
		var type = root.type;
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Definition Creation\n" + refactored_$little_tools_PrettyPrinter.getTree(name,type == null ? prefix.slice() : refactored_$little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,type == null) + refactored_$little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
	case 3:
		var name = root.name;
		var params = root.params;
		var type = root.type;
		var title = "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Action Creation\n";
		title += refactored_$little_tools_PrettyPrinter.getTree(name,prefix.slice(),level + 1,false);
		title += refactored_$little_tools_PrettyPrinter.getTree(params,prefix.slice(),level + 1,type == null);
		title += refactored_$little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
		return title;
	case 4:
		var name = root.name;
		var exp = root.exp;
		var body = root.body;
		var type = root.type;
		var title = "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Condition\n";
		title += refactored_$little_tools_PrettyPrinter.getTree(name,prefix.slice(),level + 1,false);
		title += refactored_$little_tools_PrettyPrinter.getTree(exp,refactored_$little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false);
		title += refactored_$little_tools_PrettyPrinter.getTree(body,prefix.slice(),level + 1,type == null);
		title += refactored_$little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
		return title;
	case 5:
		var name = root.name;
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + Std.string(name) + "\n";
	case 6:
		var assignees = root.assignees;
		var value = root.value;
		var type = root.type;
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Definition Write\n" + refactored_$little_tools_PrettyPrinter.getTree(refactored_$little_parser_ParserTokens.PartArray(assignees),refactored_$little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false) + refactored_$little_tools_PrettyPrinter.getTree(value,prefix.slice(),level + 1,type == null) + refactored_$little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
	case 7:
		var value = root.word;
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + value + "\n";
	case 8:
		var type = root.type;
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Type Declaration\n" + refactored_$little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
	case 9:
		var name = root.name;
		var params = root.params;
		var title = "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Action Call\n";
		title += refactored_$little_tools_PrettyPrinter.getTree(name,refactored_$little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false);
		title += refactored_$little_tools_PrettyPrinter.getTree(params,prefix.slice(),level + 1,true);
		return title;
	case 10:
		var value = root.value;
		var type = root.type;
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Return\n" + refactored_$little_tools_PrettyPrinter.getTree(value,prefix.slice(),level + 1,type == null) + refactored_$little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
	case 11:
		var parts = root.parts;
		var type = root.type;
		if(parts.length == 0) {
			return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " <empty expression>\n";
		}
		var strParts = ["" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Expression\n" + refactored_$little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,false)];
		var _g = [];
		var _g1 = 0;
		var _g2 = parts.length - 1;
		while(_g1 < _g2) {
			var i = _g1++;
			_g.push(refactored_$little_tools_PrettyPrinter.getTree(parts[i],refactored_$little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false));
		}
		var strParts1 = strParts.concat(_g);
		strParts1.push(refactored_$little_tools_PrettyPrinter.getTree(parts[parts.length - 1],prefix.slice(),level + 1,true));
		return strParts1.join("");
	case 12:
		var body = root.body;
		var type = root.type;
		if(body.length == 0) {
			return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " <empty block>\n";
		}
		var strParts = ["" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Block\n" + refactored_$little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,false)];
		var _g = [];
		var _g1 = 0;
		var _g2 = body.length - 1;
		while(_g1 < _g2) {
			var i = _g1++;
			_g.push(refactored_$little_tools_PrettyPrinter.getTree(body[i],refactored_$little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false));
		}
		var strParts1 = strParts.concat(_g);
		strParts1.push(refactored_$little_tools_PrettyPrinter.getTree(body[body.length - 1],prefix.slice(),level + 1,true));
		return strParts1.join("");
	case 13:
		var body = root.parts;
		if(body.length == 0) {
			return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " <empty array>\n";
		}
		var strParts = ["" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Part Array\n"];
		var _g = [];
		var _g1 = 0;
		var _g2 = body.length - 1;
		while(_g1 < _g2) {
			var i = _g1++;
			_g.push(refactored_$little_tools_PrettyPrinter.getTree(body[i],refactored_$little_tools_PrettyPrinter.pushIndex(prefix,level),level + 1,false));
		}
		var strParts1 = strParts.concat(_g);
		strParts1.push(refactored_$little_tools_PrettyPrinter.getTree(body[body.length - 1],prefix.slice(),level + 1,true));
		return strParts1.join("");
	case 14:
		var name = root.name;
		var type = root.type;
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " Parameter\n" + refactored_$little_tools_PrettyPrinter.getTree(name,prefix.slice(),level + 1,false) + refactored_$little_tools_PrettyPrinter.getTree(type,prefix.slice(),level + 1,true);
	case 15:
		var value = root.sign;
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + value + "\n";
	case 16:
		var num = root.num;
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + num + "\n";
	case 17:
		var num = root.num;
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + num + "\n";
	case 18:
		var string = root.string;
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " \"" + string + "\"\n";
	case 19:
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + refactored_$little_Keywords.NULL_VALUE + "\n";
	case 20:
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + refactored_$little_Keywords.TRUE_VALUE + "\n";
	case 21:
		return "" + refactored_$little_tools_PrettyPrinter.prefixFA(prefix) + t + d + " " + refactored_$little_Keywords.FALSE_VALUE + "\n";
	}
};
String.__name__ = true;
Array.__name__ = true;
js_Boot.__toStr = ({ }).toString;
Main.code = "\r\na() = define {define i = 5; i = i + 1; (\"num\" + i)} = hello() = 6\r\naction a(define h as String = 8; define a = 3; define xe) {\r\n    if (h == a) {\r\n        return a + 1\r\n    }\r\n    nothing; return h + a + xe + {define a = 1; (a + 1)}\r\n}\r\ndefine x as Number = define y as Decimal = 6\r\n    ";
refactored_$little_Keywords.VARIABLE_DECLARATION = "define";
refactored_$little_Keywords.FUNCTION_DECLARATION = "action";
refactored_$little_Keywords.TYPE_DECL_OR_CAST = "as";
refactored_$little_Keywords.FUNCTION_RETURN = "return";
refactored_$little_Keywords.NULL_VALUE = "nothing";
refactored_$little_Keywords.TRUE_VALUE = "true";
refactored_$little_Keywords.FALSE_VALUE = "false";
refactored_$little_Keywords.CONDITION_TYPES = ["if","while","whenever","for"];
refactored_$little_Keywords.SPECIAL_OR_MULTICHAR_SIGNS = ["++","--","**","+=","-=",">=","<=","=="];
refactored_$little_lexer_Lexer.signs = ["!","\"","#","$","%","&","'","(",")","*","+",",","-",".","/",":",";","<","=",">","?","@","[","\\","]","^","_","`","{","|","}","~","^"];
refactored_$little_tools_PrettyPrinter.s = "";
refactored_$little_tools_PrettyPrinter.l = 0;
Main.main();
})({});

//# sourceMappingURL=interp.js.map