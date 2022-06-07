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
	,matchedRight: function() {
		if(this.r.m == null) {
			throw haxe_Exception.thrown("No string matched");
		}
		var sz = this.r.m.index + this.r.m[0].length;
		return HxOverrides.substr(this.r.s,sz,this.r.s.length - sz);
	}
	,matchedPos: function() {
		if(this.r.m == null) {
			throw haxe_Exception.thrown("No string matched");
		}
		return { pos : this.r.m.index, len : this.r.m[0].length};
	}
	,__class__: EReg
};
var Formula = {};
Formula.bind = function(this1,formula,paramName) {
	if(paramName != null) {
		if(!TermNode.nameRegFull.match(paramName)) {
			throw haxe_Exception.thrown("Not allowed characters for name " + paramName + "\".");
		}
		var _g = new haxe_ds_StringMap();
		_g.h[paramName] = formula;
		var params = _g;
		if(Reflect.compareMethods(this1.operation,TermNode.opParam)) {
			if(Object.prototype.hasOwnProperty.call(params.h,this1.symbol)) {
				this1.left = params.h[this1.symbol];
			}
		} else {
			if(this1.left != null) {
				var _this = this1.left;
				if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
					if(Object.prototype.hasOwnProperty.call(params.h,_this.symbol)) {
						_this.left = params.h[_this.symbol];
					}
				} else {
					if(_this.left != null) {
						_this.left.bind(params);
					}
					if(_this.right != null) {
						_this.right.bind(params);
					}
				}
			}
			if(this1.right != null) {
				var _this = this1.right;
				if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
					if(Object.prototype.hasOwnProperty.call(params.h,_this.symbol)) {
						_this.left = params.h[_this.symbol];
					}
				} else {
					if(_this.left != null) {
						_this.left.bind(params);
					}
					if(_this.right != null) {
						_this.right.bind(params);
					}
				}
			}
		}
		return this1;
	} else {
		if((Reflect.compareMethods(formula.operation,TermNode.opName) ? formula.symbol : null) == null) {
			throw haxe_Exception.thrown("Can't bind unnamed formula:\"" + formula.toString(null,null) + "\" as parameter.");
		}
		var _g = new haxe_ds_StringMap();
		var key = Reflect.compareMethods(formula.operation,TermNode.opName) ? formula.symbol : null;
		_g.h[key] = formula;
		var params = _g;
		if(Reflect.compareMethods(this1.operation,TermNode.opParam)) {
			if(Object.prototype.hasOwnProperty.call(params.h,this1.symbol)) {
				this1.left = params.h[this1.symbol];
			}
		} else {
			if(this1.left != null) {
				var _this = this1.left;
				if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
					if(Object.prototype.hasOwnProperty.call(params.h,_this.symbol)) {
						_this.left = params.h[_this.symbol];
					}
				} else {
					if(_this.left != null) {
						_this.left.bind(params);
					}
					if(_this.right != null) {
						_this.right.bind(params);
					}
				}
			}
			if(this1.right != null) {
				var _this = this1.right;
				if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
					if(Object.prototype.hasOwnProperty.call(params.h,_this.symbol)) {
						_this.left = params.h[_this.symbol];
					}
				} else {
					if(_this.left != null) {
						_this.left.bind(params);
					}
					if(_this.right != null) {
						_this.right.bind(params);
					}
				}
			}
		}
		return this1;
	}
};
Formula.fromString = function(a) {
	var s = a;
	var bindings = null;
	var errPos = 0;
	errPos = TermNode.trailingSpacesReg.match(s) ? TermNode.trailingSpacesReg.matched(1).length : 0;
	s = HxOverrides.substr(s,errPos,null);
	if(TermNode.nameReg.match(s)) {
		var name = TermNode.nameReg.matched(1);
		s = HxOverrides.substr(s,name.length + TermNode.nameReg.matched(2).length,null);
		errPos += name.length + TermNode.nameReg.matched(2).length;
		if(new EReg("^\\s*$","").match(s)) {
			throw haxe_Exception.thrown({ "msg" : "Can't parse Term from empty string.", "pos" : errPos});
		}
		var term = TermNode.parseString(s,errPos,bindings);
		var t = new TermNode();
		t.operation = TermNode.opName;
		t.symbol = name;
		t.left = term;
		t.right = null;
		return t;
	} else {
		if(new EReg("^\\s*$","").match(s)) {
			throw haxe_Exception.thrown({ "msg" : "Can't parse Term from empty string.", "pos" : errPos});
		}
		return TermNode.parseString(s,errPos,bindings);
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
Main.__name__ = true;
Main.main = function() {
};
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.isFunction = function(f) {
	if(typeof(f) == "function") {
		return !(f.__name__ || f.__ename__);
	} else {
		return false;
	}
};
Reflect.compareMethods = function(f1,f2) {
	if(f1 == f2) {
		return true;
	}
	if(!Reflect.isFunction(f1) || !Reflect.isFunction(f2)) {
		return false;
	}
	if(f1.scope == f2.scope && f1.method == f2.method) {
		return f1.method != null;
	} else {
		return false;
	}
};
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
var TermNode = function() {
};
TermNode.__name__ = true;
TermNode.newValue = function(f) {
	var t = new TermNode();
	t.operation = TermNode.opValue;
	t.symbol = null;
	t.value = f;
	t.left = null;
	t.right = null;
	return t;
};
TermNode.newOperation = function(s,left,right) {
	var t = new TermNode();
	t.operation = TermNode.MathOp.h[s];
	if(t.operation != null) {
		t.symbol = s;
		t.left = left;
		t.right = right;
	} else {
		throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
	}
	return t;
};
TermNode.opName = function(t) {
	if(t.left != null) {
		var _this = t.left;
		return _this.operation(_this);
	} else {
		throw haxe_Exception.thrown("Empty function \"" + t.symbol + "\".");
	}
};
TermNode.opParam = function(t) {
	if(t.left != null) {
		var _this = t.left;
		return _this.operation(_this);
	} else {
		throw haxe_Exception.thrown("Missing parameter \"" + t.symbol + "\".");
	}
};
TermNode.opValue = function(t) {
	return t.value;
};
TermNode.parseString = function(s,errPos,params) {
	var t = null;
	var operations = [];
	var e;
	var f;
	var negate;
	var spaces = 0;
	while(s.length != 0) {
		negate = false;
		spaces = TermNode.trailingSpacesReg.match(s) ? TermNode.trailingSpacesReg.matched(1).length : 0;
		s = HxOverrides.substr(s,spaces,null);
		errPos += spaces;
		if(TermNode.numberReg.match(s)) {
			e = TermNode.numberReg.matched(1);
			var f1 = parseFloat(e);
			var t1 = new TermNode();
			t1.operation = TermNode.opValue;
			t1.symbol = null;
			t1.value = f1;
			t1.left = null;
			t1.right = null;
			t = t1;
		} else if(TermNode.constantOpReg.match(s)) {
			e = TermNode.constantOpReg.matched(1);
			var t2 = new TermNode();
			t2.operation = TermNode.MathOp.h[e];
			if(t2.operation != null) {
				t2.symbol = e;
				t2.left = null;
				t2.right = null;
			} else {
				throw haxe_Exception.thrown("\"" + e + "\" is no valid operation.");
			}
			t = t2;
			e += "()";
		} else if(TermNode.oneParamOpReg.match(s)) {
			f = TermNode.oneParamOpReg.matched(1);
			errPos += f.length;
			s = "(" + TermNode.oneParamOpReg.matchedRight();
			e = TermNode.getBrackets(s,errPos);
			var left = TermNode.parseString(e.substring(1,e.length - 1),errPos + 1,params);
			var t3 = new TermNode();
			t3.operation = TermNode.MathOp.h[f];
			if(t3.operation != null) {
				t3.symbol = f;
				t3.left = left;
				t3.right = null;
			} else {
				throw haxe_Exception.thrown("\"" + f + "\" is no valid operation.");
			}
			t = t3;
		} else if(TermNode.twoParamOpReg.match(s)) {
			f = TermNode.twoParamOpReg.matched(1);
			errPos += f.length;
			s = "(" + TermNode.twoParamOpReg.matchedRight();
			e = TermNode.getBrackets(s,errPos);
			var p1 = e.substring(1,TermNode.comataPos);
			var p2 = e.substring(TermNode.comataPos + 1,e.length - 1);
			if(TermNode.comataPos == -1) {
				throw haxe_Exception.thrown({ "msg" : f + "() needs two parameter separated by comma.", "pos" : errPos});
			}
			var left1 = TermNode.parseString(p1,errPos + 1,params);
			var right = TermNode.parseString(p2,errPos + 1 + TermNode.comataPos,params);
			var t4 = new TermNode();
			t4.operation = TermNode.MathOp.h[f];
			if(t4.operation != null) {
				t4.symbol = f;
				t4.left = left1;
				t4.right = right;
			} else {
				throw haxe_Exception.thrown("\"" + f + "\" is no valid operation.");
			}
			t = t4;
		} else if(TermNode.paramReg.match(s)) {
			e = TermNode.paramReg.matched(1);
			var term = params == null ? null : params.h[e];
			var t5 = new TermNode();
			t5.operation = TermNode.opParam;
			t5.symbol = e;
			t5.left = term;
			t5.right = null;
			t = t5;
		} else if(TermNode.signReg.match(s)) {
			e = TermNode.signReg.matched(1);
			s = HxOverrides.substr(s,e.length,null);
			errPos += e.length;
			var _this_r = new RegExp("[\\s+]","g".split("u").join(""));
			e = e.replace(_this_r,"");
			if(e.length % 2 > 0) {
				if(TermNode.numberReg.match(s)) {
					e = TermNode.numberReg.matched(1);
					var f2 = -parseFloat(e);
					var t6 = new TermNode();
					t6.operation = TermNode.opValue;
					t6.symbol = null;
					t6.value = f2;
					t6.left = null;
					t6.right = null;
					t = t6;
				} else {
					var t7 = new TermNode();
					t7.operation = TermNode.opValue;
					t7.symbol = null;
					t7.value = 0;
					t7.left = null;
					t7.right = null;
					t = t7;
					s = "-" + s;
					e = "";
					negate = true;
				}
			} else {
				continue;
			}
		} else if(TermNode.twoSideOpReg.match(s)) {
			throw haxe_Exception.thrown({ "msg" : "Missing left operand.", "pos" : errPos});
		} else {
			e = TermNode.getBrackets(s,errPos);
			t = TermNode.parseString(e.substring(1,e.length - 1),errPos + 1,params);
		}
		s = HxOverrides.substr(s,e.length,null);
		errPos += e.length;
		if(operations.length > 0) {
			operations[operations.length - 1].right = t;
		}
		spaces = TermNode.trailingSpacesReg.match(s) ? TermNode.trailingSpacesReg.matched(1).length : 0;
		s = HxOverrides.substr(s,spaces,null);
		errPos += spaces;
		if(TermNode.twoSideOpReg.match(s)) {
			e = TermNode.twoSideOpReg.matched(1);
			errPos += e.length;
			s = TermNode.twoSideOpReg.matchedRight();
			spaces = TermNode.trailingSpacesReg.match(s) ? TermNode.trailingSpacesReg.matched(1).length : 0;
			s = HxOverrides.substr(s,spaces,null);
			errPos += spaces;
			operations.push({ symbol : e, left : t, right : null, leftOperation : null, rightOperation : null, precedence : negate ? -1 : TermNode.precedence.h[e]});
			if(operations.length > 1) {
				operations[operations.length - 2].rightOperation = operations[operations.length - 1];
				operations[operations.length - 1].leftOperation = operations[operations.length - 2];
			}
		} else if(s.length > 0) {
			if(s.indexOf(")") == 0) {
				throw haxe_Exception.thrown({ "msg" : "No opening bracket.", "pos" : errPos});
			}
			if(!(s.indexOf("(") == 0 || TermNode.numberReg.match(s) || TermNode.paramReg.match(s) || TermNode.constantOpReg.match(s) || TermNode.oneParamOpReg.match(s) || TermNode.twoParamOpReg.match(s))) {
				throw haxe_Exception.thrown({ "msg" : "Wrong char.", "pos" : errPos});
			} else {
				throw haxe_Exception.thrown({ "msg" : "Missing operation.", "pos" : errPos});
			}
		}
	}
	if(operations.length > 0) {
		if(operations[operations.length - 1].right == null) {
			throw haxe_Exception.thrown({ "msg" : "Missing right operand.", "pos" : errPos - spaces});
		} else {
			operations.sort(function(a,b) {
				if(a.precedence < b.precedence) {
					return -1;
				}
				if(a.precedence > b.precedence) {
					return 1;
				}
				return 0;
			});
			var _g = 0;
			while(_g < operations.length) {
				var op = operations[_g];
				++_g;
				var s = op.symbol;
				var left = op.left;
				var right = op.right;
				var t1 = new TermNode();
				t1.operation = TermNode.MathOp.h[s];
				if(t1.operation != null) {
					t1.symbol = s;
					t1.left = left;
					t1.right = right;
				} else {
					throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
				}
				t = t1;
				if(op.leftOperation != null && op.rightOperation != null) {
					op.rightOperation.leftOperation = op.leftOperation;
					op.leftOperation.rightOperation = op.rightOperation;
				}
				if(op.leftOperation != null) {
					op.leftOperation.right = t;
				}
				if(op.rightOperation != null) {
					op.rightOperation.left = t;
				}
			}
			return t;
		}
	} else {
		return t;
	}
};
TermNode.getBrackets = function(s,errPos) {
	var pos = 1;
	if(s.indexOf("(") == 0) {
		if(new EReg("^\\(\\s*\\)","").match(s)) {
			throw haxe_Exception.thrown({ "msg" : "Empty brackets.", "pos" : errPos});
		}
		var i;
		var j;
		var k;
		var openBrackets = 1;
		TermNode.comataPos = -1;
		while(openBrackets > 0) {
			i = s.indexOf("(",pos);
			j = s.indexOf(")",pos);
			if(openBrackets == 1 && TermNode.comataPos == -1) {
				k = s.indexOf(",",pos);
				if(k < j && j > 0) {
					TermNode.comataPos = k;
				}
			}
			if(i > 0 && j > 0 && i < j || i > 0 && j < 0) {
				++openBrackets;
				pos = i + 1;
			} else if(j > 0 && i > 0 && j < i || j > 0 && i < 0) {
				--openBrackets;
				pos = j + 1;
			} else {
				throw haxe_Exception.thrown({ "msg" : "Wrong bracket nesting.", "pos" : errPos});
			}
		}
		return s.substring(0,pos);
	}
	if(s.indexOf(")") == 0) {
		throw haxe_Exception.thrown({ "msg" : "No opening bracket.", "pos" : errPos});
	} else {
		throw haxe_Exception.thrown({ "msg" : "Wrong char.", "pos" : errPos});
	}
};
TermNode.prototype = {
	bind: function(params) {
		if(Reflect.compareMethods(this.operation,TermNode.opParam)) {
			if(Object.prototype.hasOwnProperty.call(params.h,this.symbol)) {
				this.left = params.h[this.symbol];
			}
		} else {
			if(this.left != null) {
				this.left.bind(params);
			}
			if(this.right != null) {
				this.right.bind(params);
			}
		}
		return this;
	}
	,copy: function(depth) {
		if(depth == null) {
			depth = -1;
		}
		if(Reflect.compareMethods(this.operation,TermNode.opValue)) {
			var f = this.value;
			var t = new TermNode();
			t.operation = TermNode.opValue;
			t.symbol = null;
			t.value = f;
			t.left = null;
			t.right = null;
			return t;
		} else if(Reflect.compareMethods(this.operation,TermNode.opName)) {
			var name = this.symbol;
			var term = this.left != null ? this.left.copy(depth) : null;
			var t = new TermNode();
			t.operation = TermNode.opName;
			t.symbol = name;
			t.left = term;
			t.right = null;
			return t;
		} else if(Reflect.compareMethods(this.operation,TermNode.opParam)) {
			var name = this.symbol;
			var term = this.left != null ? depth == 0 ? this.left : this.left.copy(depth - 1) : null;
			var t = new TermNode();
			t.operation = TermNode.opParam;
			t.symbol = name;
			t.left = term;
			t.right = null;
			return t;
		} else {
			var s = this.symbol;
			var left = this.left != null ? this.left.copy(depth) : null;
			var right = this.right != null ? this.right.copy(depth) : null;
			var t = new TermNode();
			t.operation = TermNode.MathOp.h[s];
			if(t.operation != null) {
				t.symbol = s;
				t.left = left;
				t.right = right;
			} else {
				throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
			}
			return t;
		}
	}
	,length: function(depth) {
		if(depth == null) {
			depth = -1;
		}
		var _g = this.symbol;
		var s = _g;
		if(Reflect.compareMethods(this.operation,TermNode.opValue)) {
			return 1;
		} else {
			var s = _g;
			if(Reflect.compareMethods(this.operation,TermNode.opName)) {
				if(this.left == null) {
					return 0;
				} else {
					return this.left.length(depth);
				}
			} else {
				var s = _g;
				if(Reflect.compareMethods(this.operation,TermNode.opParam)) {
					if(depth == 0 || this.left == null) {
						return 1;
					} else {
						return this.left.length(depth - 1);
					}
				} else {
					var s = _g;
					if(TermNode.constantOpRegFull.match(s)) {
						return 1;
					} else {
						var s = _g;
						if(TermNode.oneParamOpRegFull.match(s)) {
							return 1 + this.left.length(depth);
						} else {
							return 1 + this.left.length(depth) + this.right.length(depth);
						}
					}
				}
			}
		}
	}
	,isEqual: function(t,compareNames,compareParams) {
		if(compareParams == null) {
			compareParams = false;
		}
		if(compareNames == null) {
			compareNames = false;
		}
		if(!compareNames && (Reflect.compareMethods(this.operation,TermNode.opName) || Reflect.compareMethods(t.operation,TermNode.opName))) {
			if(Reflect.compareMethods(this.operation,TermNode.opName) && this.left != null) {
				return this.left.isEqual(t,compareNames,compareParams);
			}
			if(Reflect.compareMethods(t.operation,TermNode.opName) && t.left != null) {
				return this.isEqual(t.left,compareNames,compareParams);
			}
			if(Reflect.compareMethods(this.operation,TermNode.opName)) {
				return Reflect.compareMethods(t.operation,TermNode.opName);
			} else {
				return false;
			}
		}
		if(!compareParams && (Reflect.compareMethods(this.operation,TermNode.opParam) || Reflect.compareMethods(t.operation,TermNode.opParam))) {
			if(Reflect.compareMethods(this.operation,TermNode.opParam) && this.left != null) {
				return this.left.isEqual(t,compareNames,compareParams);
			}
			if(Reflect.compareMethods(t.operation,TermNode.opParam) && t.left != null) {
				return this.isEqual(t.left,compareNames,compareParams);
			}
			if(Reflect.compareMethods(this.operation,TermNode.opParam)) {
				return Reflect.compareMethods(t.operation,TermNode.opParam);
			} else {
				return false;
			}
		}
		var is_equal = false;
		if(Reflect.compareMethods(this.operation,TermNode.opValue) && Reflect.compareMethods(t.operation,TermNode.opValue)) {
			is_equal = this.value == t.value;
		} else if(Reflect.compareMethods(this.operation,TermNode.opName) && Reflect.compareMethods(t.operation,TermNode.opName) || Reflect.compareMethods(this.operation,TermNode.opParam) && Reflect.compareMethods(t.operation,TermNode.opParam) || !(Reflect.compareMethods(this.operation,TermNode.opName) || Reflect.compareMethods(this.operation,TermNode.opParam) || Reflect.compareMethods(this.operation,TermNode.opValue)) && !(Reflect.compareMethods(t.operation,TermNode.opName) || Reflect.compareMethods(t.operation,TermNode.opParam) || Reflect.compareMethods(t.operation,TermNode.opValue))) {
			is_equal = this.symbol == t.symbol;
		}
		if(this.left != null) {
			if(t.left != null) {
				is_equal = is_equal && this.left.isEqual(t.left,compareNames,compareParams);
			} else {
				is_equal = false;
			}
		}
		if(this.right != null) {
			if(t.right != null) {
				is_equal = is_equal && this.right.isEqual(t.right,compareNames,compareParams);
			} else {
				is_equal = false;
			}
		}
		return is_equal;
	}
	,toString: function(depth,plOut) {
		var t = this;
		if(Reflect.compareMethods(this.operation,TermNode.opName)) {
			t = this.left;
		}
		var options;
		if(plOut == null) {
			options = 0;
		} else if(plOut == "glsl") {
			options = 127;
		} else {
			options = 0;
		}
		if(this.left != null || !Reflect.compareMethods(this.operation,TermNode.opName)) {
			var depth1 = depth;
			if(depth1 == null) {
				depth1 = -1;
			}
			var _g = t.symbol;
			var s = _g;
			if(Reflect.compareMethods(t.operation,TermNode.opValue)) {
				var options1 = options;
				if(options1 == null) {
					options1 = 0;
				}
				var s = Std.string(t.value);
				if((options1 & 2) > 0 && s.indexOf(".") == -1) {
					s += ".0";
				}
				return s;
			} else {
				var s = _g;
				if(Reflect.compareMethods(t.operation,TermNode.opName)) {
					if(depth1 == 0 || t.left == null) {
						return t.symbol;
					} else {
						var _this = t.left;
						var depth = depth1 - 1;
						var isFirst = false;
						if(isFirst == null) {
							isFirst = true;
						}
						if(depth == null) {
							depth = -1;
						}
						var _g1 = _this.symbol;
						var s = _g1;
						if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
							var options1 = options;
							if(options1 == null) {
								options1 = 0;
							}
							var s = Std.string(_this.value);
							if((options1 & 2) > 0 && s.indexOf(".") == -1) {
								s += ".0";
							}
							return s;
						} else {
							var s = _g1;
							if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
								if(depth == 0 || _this.left == null) {
									return _this.symbol;
								} else {
									return _this.left._toString(depth - 1,options,false);
								}
							} else {
								var s = _g1;
								if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
									if(depth == 0 || _this.left == null) {
										return _this.symbol;
									} else {
										return _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
									}
								} else {
									var s = _g1;
									if(TermNode.twoSideOpRegFull.match(s)) {
										if(_this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0) {
											return _this.symbol + _this.right._toString(depth,options,false);
										} else if(_this.symbol == "^" && (options & 4) > 0) {
											return "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
										} else if(_this.symbol == "%" && (options & 8) > 0) {
											return "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
										} else {
											return (isFirst ? "" : "(") + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + (isFirst ? "" : ")");
										}
									} else {
										var s = _g1;
										if(TermNode.twoParamOpRegFull.match(s)) {
											if(_this.symbol == "log" && (options & 16) > 0) {
												return "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))";
											} else if(_this.symbol == "atan2" && (options & 32) > 0) {
												return "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
											} else {
												return _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
											}
										} else {
											var s = _g1;
											if(TermNode.constantOpRegFull.match(s)) {
												if(_this.symbol == "pi" && (options & 64) > 0) {
													return Std.string(Math.PI);
												} else if(_this.symbol == "e" && (options & 64) > 0) {
													return Std.string(Math.exp(1));
												} else {
													return _this.symbol + "()";
												}
											} else if(_this.symbol == "ln" && (options & 16) > 0) {
												return "log" + "(" + _this.left._toString(depth,options,null) + ")";
											} else {
												return _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
											}
										}
									}
								}
							}
						}
					}
				} else {
					var s = _g;
					if(Reflect.compareMethods(t.operation,TermNode.opParam)) {
						if(depth1 == 0 || t.left == null) {
							return t.symbol;
						} else {
							var _this = t.left;
							var depth = depth1 - (Reflect.compareMethods(t.left.operation,TermNode.opName) ? 0 : 1);
							var isFirst = false;
							if(isFirst == null) {
								isFirst = true;
							}
							if(depth == null) {
								depth = -1;
							}
							var _g1 = _this.symbol;
							var s = _g1;
							if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
								var options1 = options;
								if(options1 == null) {
									options1 = 0;
								}
								var s = Std.string(_this.value);
								if((options1 & 2) > 0 && s.indexOf(".") == -1) {
									s += ".0";
								}
								return s;
							} else {
								var s = _g1;
								if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
									if(depth == 0 || _this.left == null) {
										return _this.symbol;
									} else {
										return _this.left._toString(depth - 1,options,false);
									}
								} else {
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
										if(depth == 0 || _this.left == null) {
											return _this.symbol;
										} else {
											return _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
										}
									} else {
										var s = _g1;
										if(TermNode.twoSideOpRegFull.match(s)) {
											if(_this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0) {
												return _this.symbol + _this.right._toString(depth,options,false);
											} else if(_this.symbol == "^" && (options & 4) > 0) {
												return "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
											} else if(_this.symbol == "%" && (options & 8) > 0) {
												return "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
											} else {
												return (isFirst ? "" : "(") + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + (isFirst ? "" : ")");
											}
										} else {
											var s = _g1;
											if(TermNode.twoParamOpRegFull.match(s)) {
												if(_this.symbol == "log" && (options & 16) > 0) {
													return "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))";
												} else if(_this.symbol == "atan2" && (options & 32) > 0) {
													return "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
												} else {
													return _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
												}
											} else {
												var s = _g1;
												if(TermNode.constantOpRegFull.match(s)) {
													if(_this.symbol == "pi" && (options & 64) > 0) {
														return Std.string(Math.PI);
													} else if(_this.symbol == "e" && (options & 64) > 0) {
														return Std.string(Math.exp(1));
													} else {
														return _this.symbol + "()";
													}
												} else if(_this.symbol == "ln" && (options & 16) > 0) {
													return "log" + "(" + _this.left._toString(depth,options,null) + ")";
												} else {
													return _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
												}
											}
										}
									}
								}
							}
						}
					} else {
						var s = _g;
						if(TermNode.twoSideOpRegFull.match(s)) {
							if(t.symbol == "-" && Reflect.compareMethods(t.left.operation,TermNode.opValue) && t.left.value == 0 && (options & 1) == 0) {
								var t1 = t.symbol;
								var _this = t.right;
								var depth = depth1;
								var isFirst = false;
								if(isFirst == null) {
									isFirst = true;
								}
								if(depth == null) {
									depth = -1;
								}
								var tmp;
								var _g1 = _this.symbol;
								var s = _g1;
								if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
									var options1 = options;
									if(options1 == null) {
										options1 = 0;
									}
									var s = Std.string(_this.value);
									if((options1 & 2) > 0 && s.indexOf(".") == -1) {
										s += ".0";
									}
									tmp = s;
								} else {
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
										tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
											tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
										} else {
											var s = _g1;
											if(TermNode.twoSideOpRegFull.match(s)) {
												tmp = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : (isFirst ? "" : "(") + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + (isFirst ? "" : ")");
											} else {
												var s = _g1;
												if(TermNode.twoParamOpRegFull.match(s)) {
													tmp = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
												} else {
													var s = _g1;
													tmp = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
												}
											}
										}
									}
								}
								return t1 + tmp;
							} else if(t.symbol == "^" && (options & 4) > 0) {
								var _this = t.left;
								var depth = depth1;
								if(depth == null) {
									depth = -1;
								}
								var tmp;
								var _g1 = _this.symbol;
								var s = _g1;
								if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
									var options1 = options;
									if(options1 == null) {
										options1 = 0;
									}
									var s = Std.string(_this.value);
									if((options1 & 2) > 0 && s.indexOf(".") == -1) {
										s += ".0";
									}
									tmp = s;
								} else {
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
										tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
											tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
										} else {
											var s = _g1;
											if(TermNode.twoSideOpRegFull.match(s)) {
												tmp = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : "" + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + "";
											} else {
												var s = _g1;
												if(TermNode.twoParamOpRegFull.match(s)) {
													tmp = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
												} else {
													var s = _g1;
													tmp = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
												}
											}
										}
									}
								}
								var _this = t.right;
								var depth = depth1;
								if(depth == null) {
									depth = -1;
								}
								var tmp1;
								var _g1 = _this.symbol;
								var s = _g1;
								if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
									var options1 = options;
									if(options1 == null) {
										options1 = 0;
									}
									var s = Std.string(_this.value);
									if((options1 & 2) > 0 && s.indexOf(".") == -1) {
										s += ".0";
									}
									tmp1 = s;
								} else {
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
										tmp1 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
											tmp1 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
										} else {
											var s = _g1;
											if(TermNode.twoSideOpRegFull.match(s)) {
												tmp1 = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : "" + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + "";
											} else {
												var s = _g1;
												if(TermNode.twoParamOpRegFull.match(s)) {
													tmp1 = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
												} else {
													var s = _g1;
													tmp1 = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
												}
											}
										}
									}
								}
								return "pow" + "(" + tmp + "," + tmp1 + ")";
							} else if(t.symbol == "%" && (options & 8) > 0) {
								var _this = t.left;
								var depth = depth1;
								if(depth == null) {
									depth = -1;
								}
								var tmp;
								var _g1 = _this.symbol;
								var s = _g1;
								if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
									var options1 = options;
									if(options1 == null) {
										options1 = 0;
									}
									var s = Std.string(_this.value);
									if((options1 & 2) > 0 && s.indexOf(".") == -1) {
										s += ".0";
									}
									tmp = s;
								} else {
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
										tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
											tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
										} else {
											var s = _g1;
											if(TermNode.twoSideOpRegFull.match(s)) {
												tmp = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : "" + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + "";
											} else {
												var s = _g1;
												if(TermNode.twoParamOpRegFull.match(s)) {
													tmp = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
												} else {
													var s = _g1;
													tmp = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
												}
											}
										}
									}
								}
								var _this = t.right;
								var depth = depth1;
								if(depth == null) {
									depth = -1;
								}
								var tmp1;
								var _g1 = _this.symbol;
								var s = _g1;
								if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
									var options1 = options;
									if(options1 == null) {
										options1 = 0;
									}
									var s = Std.string(_this.value);
									if((options1 & 2) > 0 && s.indexOf(".") == -1) {
										s += ".0";
									}
									tmp1 = s;
								} else {
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
										tmp1 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
											tmp1 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
										} else {
											var s = _g1;
											if(TermNode.twoSideOpRegFull.match(s)) {
												tmp1 = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : "" + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + "";
											} else {
												var s = _g1;
												if(TermNode.twoParamOpRegFull.match(s)) {
													tmp1 = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
												} else {
													var s = _g1;
													tmp1 = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
												}
											}
										}
									}
								}
								return "mod" + "(" + tmp + "," + tmp1 + ")";
							} else {
								var _this = t.left;
								var depth = depth1;
								var isFirst = false;
								if(isFirst == null) {
									isFirst = true;
								}
								if(depth == null) {
									depth = -1;
								}
								var tmp;
								var _g1 = _this.symbol;
								var s = _g1;
								if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
									var options1 = options;
									if(options1 == null) {
										options1 = 0;
									}
									var s = Std.string(_this.value);
									if((options1 & 2) > 0 && s.indexOf(".") == -1) {
										s += ".0";
									}
									tmp = s;
								} else {
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
										tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
											tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
										} else {
											var s = _g1;
											if(TermNode.twoSideOpRegFull.match(s)) {
												tmp = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : (isFirst ? "" : "(") + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + (isFirst ? "" : ")");
											} else {
												var s = _g1;
												if(TermNode.twoParamOpRegFull.match(s)) {
													tmp = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
												} else {
													var s = _g1;
													tmp = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
												}
											}
										}
									}
								}
								var tmp1 = "" + tmp + t.symbol;
								var _this = t.right;
								var depth = depth1;
								var isFirst = false;
								if(isFirst == null) {
									isFirst = true;
								}
								if(depth == null) {
									depth = -1;
								}
								var tmp;
								var _g1 = _this.symbol;
								var s = _g1;
								if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
									var options1 = options;
									if(options1 == null) {
										options1 = 0;
									}
									var s = Std.string(_this.value);
									if((options1 & 2) > 0 && s.indexOf(".") == -1) {
										s += ".0";
									}
									tmp = s;
								} else {
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
										tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
											tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
										} else {
											var s = _g1;
											if(TermNode.twoSideOpRegFull.match(s)) {
												tmp = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : (isFirst ? "" : "(") + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + (isFirst ? "" : ")");
											} else {
												var s = _g1;
												if(TermNode.twoParamOpRegFull.match(s)) {
													tmp = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
												} else {
													var s = _g1;
													tmp = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
												}
											}
										}
									}
								}
								return tmp1 + tmp + "";
							}
						} else {
							var s = _g;
							if(TermNode.twoParamOpRegFull.match(s)) {
								if(t.symbol == "log" && (options & 16) > 0) {
									var _this = t.right;
									var depth = depth1;
									if(depth == null) {
										depth = -1;
									}
									var tmp;
									var _g1 = _this.symbol;
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
										var options1 = options;
										if(options1 == null) {
											options1 = 0;
										}
										var s = Std.string(_this.value);
										if((options1 & 2) > 0 && s.indexOf(".") == -1) {
											s += ".0";
										}
										tmp = s;
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
											tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
										} else {
											var s = _g1;
											if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
												tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
											} else {
												var s = _g1;
												if(TermNode.twoSideOpRegFull.match(s)) {
													tmp = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : "" + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + "";
												} else {
													var s = _g1;
													if(TermNode.twoParamOpRegFull.match(s)) {
														tmp = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
													} else {
														var s = _g1;
														tmp = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
													}
												}
											}
										}
									}
									var _this = t.left;
									var depth = depth1;
									if(depth == null) {
										depth = -1;
									}
									var tmp1;
									var _g1 = _this.symbol;
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
										var options1 = options;
										if(options1 == null) {
											options1 = 0;
										}
										var s = Std.string(_this.value);
										if((options1 & 2) > 0 && s.indexOf(".") == -1) {
											s += ".0";
										}
										tmp1 = s;
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
											tmp1 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
										} else {
											var s = _g1;
											if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
												tmp1 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
											} else {
												var s = _g1;
												if(TermNode.twoSideOpRegFull.match(s)) {
													tmp1 = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : "" + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + "";
												} else {
													var s = _g1;
													if(TermNode.twoParamOpRegFull.match(s)) {
														tmp1 = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
													} else {
														var s = _g1;
														tmp1 = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
													}
												}
											}
										}
									}
									return "(log(" + tmp + ")/log(" + tmp1 + "))";
								} else if(t.symbol == "atan2" && (options & 32) > 0) {
									var _this = t.left;
									var depth = depth1;
									if(depth == null) {
										depth = -1;
									}
									var tmp;
									var _g1 = _this.symbol;
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
										var options1 = options;
										if(options1 == null) {
											options1 = 0;
										}
										var s = Std.string(_this.value);
										if((options1 & 2) > 0 && s.indexOf(".") == -1) {
											s += ".0";
										}
										tmp = s;
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
											tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
										} else {
											var s = _g1;
											if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
												tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
											} else {
												var s = _g1;
												if(TermNode.twoSideOpRegFull.match(s)) {
													tmp = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : "" + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + "";
												} else {
													var s = _g1;
													if(TermNode.twoParamOpRegFull.match(s)) {
														tmp = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
													} else {
														var s = _g1;
														tmp = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
													}
												}
											}
										}
									}
									var _this = t.right;
									var depth = depth1;
									if(depth == null) {
										depth = -1;
									}
									var tmp1;
									var _g1 = _this.symbol;
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
										var options1 = options;
										if(options1 == null) {
											options1 = 0;
										}
										var s = Std.string(_this.value);
										if((options1 & 2) > 0 && s.indexOf(".") == -1) {
											s += ".0";
										}
										tmp1 = s;
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
											tmp1 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
										} else {
											var s = _g1;
											if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
												tmp1 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
											} else {
												var s = _g1;
												if(TermNode.twoSideOpRegFull.match(s)) {
													tmp1 = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : "" + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + "";
												} else {
													var s = _g1;
													if(TermNode.twoParamOpRegFull.match(s)) {
														tmp1 = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
													} else {
														var s = _g1;
														tmp1 = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
													}
												}
											}
										}
									}
									return "atan(" + tmp + "," + tmp1 + ")";
								} else {
									var tmp = t.symbol + "(";
									var _this = t.left;
									var depth = depth1;
									if(depth == null) {
										depth = -1;
									}
									var tmp1;
									var _g1 = _this.symbol;
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
										var options1 = options;
										if(options1 == null) {
											options1 = 0;
										}
										var s = Std.string(_this.value);
										if((options1 & 2) > 0 && s.indexOf(".") == -1) {
											s += ".0";
										}
										tmp1 = s;
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
											tmp1 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
										} else {
											var s = _g1;
											if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
												tmp1 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
											} else {
												var s = _g1;
												if(TermNode.twoSideOpRegFull.match(s)) {
													tmp1 = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : "" + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + "";
												} else {
													var s = _g1;
													if(TermNode.twoParamOpRegFull.match(s)) {
														tmp1 = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
													} else {
														var s = _g1;
														tmp1 = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
													}
												}
											}
										}
									}
									var _this = t.right;
									var depth = depth1;
									if(depth == null) {
										depth = -1;
									}
									var tmp2;
									var _g1 = _this.symbol;
									var s = _g1;
									if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
										var options1 = options;
										if(options1 == null) {
											options1 = 0;
										}
										var s = Std.string(_this.value);
										if((options1 & 2) > 0 && s.indexOf(".") == -1) {
											s += ".0";
										}
										tmp2 = s;
									} else {
										var s = _g1;
										if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
											tmp2 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
										} else {
											var s = _g1;
											if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
												tmp2 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
											} else {
												var s = _g1;
												if(TermNode.twoSideOpRegFull.match(s)) {
													tmp2 = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : "" + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + "";
												} else {
													var s = _g1;
													if(TermNode.twoParamOpRegFull.match(s)) {
														tmp2 = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
													} else {
														var s = _g1;
														tmp2 = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
													}
												}
											}
										}
									}
									return tmp + tmp1 + "," + tmp2 + ")";
								}
							} else {
								var s = _g;
								if(TermNode.constantOpRegFull.match(s)) {
									if(t.symbol == "pi" && (options & 64) > 0) {
										return Std.string(Math.PI);
									} else if(t.symbol == "e" && (options & 64) > 0) {
										return Std.string(Math.exp(1));
									} else {
										return t.symbol + "()";
									}
								} else if(t.symbol == "ln" && (options & 16) > 0) {
									var _this = t.left;
									var depth = depth1;
									if(depth == null) {
										depth = -1;
									}
									var tmp;
									var _g = _this.symbol;
									var s = _g;
									if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
										var options1 = options;
										if(options1 == null) {
											options1 = 0;
										}
										var s = Std.string(_this.value);
										if((options1 & 2) > 0 && s.indexOf(".") == -1) {
											s += ".0";
										}
										tmp = s;
									} else {
										var s = _g;
										if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
											tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
										} else {
											var s = _g;
											if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
												tmp = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
											} else {
												var s = _g;
												if(TermNode.twoSideOpRegFull.match(s)) {
													tmp = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : "" + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + "";
												} else {
													var s = _g;
													if(TermNode.twoParamOpRegFull.match(s)) {
														tmp = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
													} else {
														var s = _g;
														tmp = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
													}
												}
											}
										}
									}
									return "log" + "(" + tmp + ")";
								} else {
									var tmp = t.symbol + "(";
									var _this = t.left;
									var depth = depth1;
									if(depth == null) {
										depth = -1;
									}
									var tmp1;
									var _g = _this.symbol;
									var s = _g;
									if(Reflect.compareMethods(_this.operation,TermNode.opValue)) {
										var options1 = options;
										if(options1 == null) {
											options1 = 0;
										}
										var s = Std.string(_this.value);
										if((options1 & 2) > 0 && s.indexOf(".") == -1) {
											s += ".0";
										}
										tmp1 = s;
									} else {
										var s = _g;
										if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
											tmp1 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - 1,options,false);
										} else {
											var s = _g;
											if(Reflect.compareMethods(_this.operation,TermNode.opParam)) {
												tmp1 = depth == 0 || _this.left == null ? _this.symbol : _this.left._toString(depth - (Reflect.compareMethods(_this.left.operation,TermNode.opName) ? 0 : 1),options,false);
											} else {
												var s = _g;
												if(TermNode.twoSideOpRegFull.match(s)) {
													tmp1 = _this.symbol == "-" && Reflect.compareMethods(_this.left.operation,TermNode.opValue) && _this.left.value == 0 && (options & 1) == 0 ? _this.symbol + _this.right._toString(depth,options,false) : _this.symbol == "^" && (options & 4) > 0 ? "pow" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol == "%" && (options & 8) > 0 ? "mod" + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : "" + _this.left._toString(depth,options,false) + _this.symbol + _this.right._toString(depth,options,false) + "";
												} else {
													var s = _g;
													if(TermNode.twoParamOpRegFull.match(s)) {
														tmp1 = _this.symbol == "log" && (options & 16) > 0 ? "(log(" + _this.right._toString(depth,options,null) + ")/log(" + _this.left._toString(depth,options,null) + "))" : _this.symbol == "atan2" && (options & 32) > 0 ? "atan(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + "," + _this.right._toString(depth,options,null) + ")";
													} else {
														var s = _g;
														tmp1 = TermNode.constantOpRegFull.match(s) ? _this.symbol == "pi" && (options & 64) > 0 ? Std.string(Math.PI) : _this.symbol == "e" && (options & 64) > 0 ? Std.string(Math.exp(1)) : _this.symbol + "()" : _this.symbol == "ln" && (options & 16) > 0 ? "log" + "(" + _this.left._toString(depth,options,null) + ")" : _this.symbol + "(" + _this.left._toString(depth,options,null) + ")";
													}
												}
											}
										}
									}
									return tmp + tmp1 + ")";
								}
							}
						}
					}
				}
			}
		} else {
			return "";
		}
	}
	,_toString: function(depth,options,isFirst) {
		if(isFirst == null) {
			isFirst = true;
		}
		if(depth == null) {
			depth = -1;
		}
		var _g = this.symbol;
		var s = _g;
		if(Reflect.compareMethods(this.operation,TermNode.opValue)) {
			var options1 = options;
			if(options1 == null) {
				options1 = 0;
			}
			var s = Std.string(this.value);
			if((options1 & 2) > 0 && s.indexOf(".") == -1) {
				s += ".0";
			}
			return s;
		} else {
			var s = _g;
			if(Reflect.compareMethods(this.operation,TermNode.opName)) {
				if(depth == 0 || this.left == null) {
					return this.symbol;
				} else {
					return this.left._toString(depth - 1,options,false);
				}
			} else {
				var s = _g;
				if(Reflect.compareMethods(this.operation,TermNode.opParam)) {
					if(depth == 0 || this.left == null) {
						return this.symbol;
					} else {
						return this.left._toString(depth - (Reflect.compareMethods(this.left.operation,TermNode.opName) ? 0 : 1),options,false);
					}
				} else {
					var s = _g;
					if(TermNode.twoSideOpRegFull.match(s)) {
						if(this.symbol == "-" && Reflect.compareMethods(this.left.operation,TermNode.opValue) && this.left.value == 0 && (options & 1) == 0) {
							return this.symbol + this.right._toString(depth,options,false);
						} else if(this.symbol == "^" && (options & 4) > 0) {
							return "pow" + "(" + this.left._toString(depth,options,null) + "," + this.right._toString(depth,options,null) + ")";
						} else if(this.symbol == "%" && (options & 8) > 0) {
							return "mod" + "(" + this.left._toString(depth,options,null) + "," + this.right._toString(depth,options,null) + ")";
						} else {
							return (isFirst ? "" : "(") + this.left._toString(depth,options,false) + this.symbol + this.right._toString(depth,options,false) + (isFirst ? "" : ")");
						}
					} else {
						var s = _g;
						if(TermNode.twoParamOpRegFull.match(s)) {
							if(this.symbol == "log" && (options & 16) > 0) {
								return "(log(" + this.right._toString(depth,options,null) + ")/log(" + this.left._toString(depth,options,null) + "))";
							} else if(this.symbol == "atan2" && (options & 32) > 0) {
								return "atan(" + this.left._toString(depth,options,null) + "," + this.right._toString(depth,options,null) + ")";
							} else {
								return this.symbol + "(" + this.left._toString(depth,options,null) + "," + this.right._toString(depth,options,null) + ")";
							}
						} else {
							var s = _g;
							if(TermNode.constantOpRegFull.match(s)) {
								if(this.symbol == "pi" && (options & 64) > 0) {
									return Std.string(Math.PI);
								} else if(this.symbol == "e" && (options & 64) > 0) {
									return Std.string(Math.exp(1));
								} else {
									return this.symbol + "()";
								}
							} else if(this.symbol == "ln" && (options & 16) > 0) {
								return "log" + "(" + this.left._toString(depth,options,null) + ")";
							} else {
								return this.symbol + "(" + this.left._toString(depth,options,null) + ")";
							}
						}
					}
				}
			}
		}
	}
	,simplify: function() {
		var tnew = this.copy();
		TermTransform._expand(tnew);
		var len = -1;
		var len_old = 0;
		while(len != len_old) {
			if(Reflect.compareMethods(tnew.operation,TermNode.opName) && tnew.left != null) {
				TermTransform.simplifyStep(tnew.left);
			} else {
				TermTransform.simplifyStep(tnew);
			}
			len_old = len;
			len = tnew.length();
		}
		return tnew;
	}
	,__class__: TermNode
};
var TermTransform = function() { };
TermTransform.__name__ = true;
TermTransform.isEqualAfterSimplify = function(t1,t2) {
	TermTransform._expand(t1);
	var len = -1;
	var len_old = 0;
	while(len != len_old) {
		if(Reflect.compareMethods(t1.operation,TermNode.opName) && t1.left != null) {
			TermTransform.simplifyStep(t1.left);
		} else {
			TermTransform.simplifyStep(t1);
		}
		len_old = len;
		len = t1.length();
	}
	TermTransform._expand(t2);
	var len = -1;
	var len_old = 0;
	while(len != len_old) {
		if(Reflect.compareMethods(t2.operation,TermNode.opName) && t2.left != null) {
			TermTransform.simplifyStep(t2.left);
		} else {
			TermTransform.simplifyStep(t2);
		}
		len_old = len;
		len = t2.length();
	}
	return t1.isEqual(t2,false,true);
};
TermTransform.simplifyStep = function(t) {
	if(Reflect.compareMethods(t.operation,TermNode.opName) || Reflect.compareMethods(t.operation,TermNode.opParam) || Reflect.compareMethods(t.operation,TermNode.opValue)) {
		return;
	}
	if(t.left != null) {
		if(Reflect.compareMethods(t.left.operation,TermNode.opValue)) {
			if(t.right == null) {
				return;
			} else if(Reflect.compareMethods(t.right.operation,TermNode.opValue)) {
				var f = t.operation(t);
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = f;
				t.left = null;
				t.right = null;
				return;
			}
		}
	}
	switch(t.symbol) {
	case "*":
		if(Reflect.compareMethods(t.left.operation,TermNode.opValue)) {
			if(t.left.value == 1) {
				var t1 = t.right;
				if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
					t.operation = TermNode.opValue;
					t.symbol = null;
					t.value = t1.value;
					t.left = null;
					t.right = null;
				} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
					t.operation = TermNode.opName;
					t.symbol = t1.symbol;
					t.left = t1.left;
					t.right = null;
				} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
					t.operation = TermNode.opParam;
					t.symbol = t1.symbol;
					t.left = t1.left;
					t.right = null;
				} else {
					var s = t1.symbol;
					t.operation = TermNode.MathOp.h[s];
					if(t.operation != null) {
						t.symbol = s;
						t.left = t1.left;
						t.right = t1.right;
					} else {
						throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
					}
				}
			} else if(t.left.value == 0) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = 0;
				t.left = null;
				t.right = null;
			}
		} else if(Reflect.compareMethods(t.right.operation,TermNode.opValue)) {
			if(t.right.value == 1) {
				var t1 = t.left;
				if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
					t.operation = TermNode.opValue;
					t.symbol = null;
					t.value = t1.value;
					t.left = null;
					t.right = null;
				} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
					t.operation = TermNode.opName;
					t.symbol = t1.symbol;
					t.left = t1.left;
					t.right = null;
				} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
					t.operation = TermNode.opParam;
					t.symbol = t1.symbol;
					t.left = t1.left;
					t.right = null;
				} else {
					var s = t1.symbol;
					t.operation = TermNode.MathOp.h[s];
					if(t.operation != null) {
						t.symbol = s;
						t.left = t1.left;
						t.right = t1.right;
					} else {
						throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
					}
				}
			} else if(t.right.value == 0) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = 0;
				t.left = null;
				t.right = null;
			}
		} else if(t.left.symbol == "/") {
			var left = t.right.copy();
			var left1 = t.left.left.copy();
			var left2 = TermTransform.newOperation("*",left,left1);
			var right = t.left.right.copy();
			t.operation = TermNode.MathOp.h["/"];
			if(t.operation != null) {
				t.symbol = "/";
				t.left = left2;
				t.right = right;
			} else {
				throw haxe_Exception.thrown("\"" + "/" + "\" is no valid operation.");
			}
		} else if(t.right.symbol == "/") {
			var left = t.left.copy();
			var left1 = t.right.left.copy();
			var left2 = TermTransform.newOperation("*",left,left1);
			var right = t.right.right.copy();
			t.operation = TermNode.MathOp.h["/"];
			if(t.operation != null) {
				t.symbol = "/";
				t.left = left2;
				t.right = right;
			} else {
				throw haxe_Exception.thrown("\"" + "/" + "\" is no valid operation.");
			}
		} else {
			TermTransform.arrangeMultiplication(t);
		}
		break;
	case "+":
		if(Reflect.compareMethods(t.left.operation,TermNode.opValue) && t.left.value == 0) {
			var t1 = t.right;
			if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = t1.value;
				t.left = null;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
				t.operation = TermNode.opName;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
				t.operation = TermNode.opParam;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else {
				var s = t1.symbol;
				t.operation = TermNode.MathOp.h[s];
				if(t.operation != null) {
					t.symbol = s;
					t.left = t1.left;
					t.right = t1.right;
				} else {
					throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
				}
			}
		} else if(Reflect.compareMethods(t.right.operation,TermNode.opValue) && t.right.value == 0) {
			var t1 = t.left;
			if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = t1.value;
				t.left = null;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
				t.operation = TermNode.opName;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
				t.operation = TermNode.opParam;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else {
				var s = t1.symbol;
				t.operation = TermNode.MathOp.h[s];
				if(t.operation != null) {
					t.symbol = s;
					t.left = t1.left;
					t.right = t1.right;
				} else {
					throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
				}
			}
		} else if(t.left.symbol == "ln" && t.right.symbol == "ln") {
			var left = t.left.left.copy();
			var left1 = t.right.left.copy();
			var left2 = TermTransform.newOperation("*",left,left1);
			t.operation = TermNode.MathOp.h["ln"];
			if(t.operation != null) {
				t.symbol = "ln";
				t.left = left2;
				t.right = null;
			} else {
				throw haxe_Exception.thrown("\"" + "ln" + "\" is no valid operation.");
			}
		} else if(t.left.symbol == "/" && t.right.symbol == "/" && TermTransform.isEqualAfterSimplify(t.left.right,t.right.right)) {
			var left = t.left.left.copy();
			var left1 = t.right.left.copy();
			var left2 = TermTransform.newOperation("+",left,left1);
			var right = t.left.right.copy();
			t.operation = TermNode.MathOp.h["/"];
			if(t.operation != null) {
				t.symbol = "/";
				t.left = left2;
				t.right = right;
			} else {
				throw haxe_Exception.thrown("\"" + "/" + "\" is no valid operation.");
			}
		} else if(t.left.symbol == "/" && t.right.symbol == "/") {
			var left = t.left.left.copy();
			var left1 = t.right.right.copy();
			var left2 = TermTransform.newOperation("*",left,left1);
			var left = t.right.left.copy();
			var left1 = t.left.right.copy();
			var left3 = TermTransform.newOperation("*",left,left1);
			var left = TermTransform.newOperation("+",left2,left3);
			var right = t.left.right.copy();
			var right1 = t.right.right.copy();
			var right2 = TermTransform.newOperation("*",right,right1);
			t.operation = TermNode.MathOp.h["/"];
			if(t.operation != null) {
				t.symbol = "/";
				t.left = left;
				t.right = right2;
			} else {
				throw haxe_Exception.thrown("\"" + "/" + "\" is no valid operation.");
			}
		}
		TermTransform.arrangeAddition(t);
		if(t.symbol == "+") {
			TermTransform._factorize(t);
		}
		break;
	case "-":
		if(Reflect.compareMethods(t.right.operation,TermNode.opValue) && t.right.value == 0) {
			var t1 = t.left;
			if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = t1.value;
				t.left = null;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
				t.operation = TermNode.opName;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
				t.operation = TermNode.opParam;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else {
				var s = t1.symbol;
				t.operation = TermNode.MathOp.h[s];
				if(t.operation != null) {
					t.symbol = s;
					t.left = t1.left;
					t.right = t1.right;
				} else {
					throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
				}
			}
		} else if(t.left.symbol == "ln" && t.right.symbol == "ln") {
			var left = t.left.left.copy();
			var left1 = t.right.left.copy();
			var left2 = TermTransform.newOperation("/",left,left1);
			t.operation = TermNode.MathOp.h["ln"];
			if(t.operation != null) {
				t.symbol = "ln";
				t.left = left2;
				t.right = null;
			} else {
				throw haxe_Exception.thrown("\"" + "ln" + "\" is no valid operation.");
			}
		} else if(t.left.symbol == "/" && t.right.symbol == "/" && TermTransform.isEqualAfterSimplify(t.left.right,t.right.right)) {
			var left = t.left.left.copy();
			var left1 = t.right.left.copy();
			var left2 = TermTransform.newOperation("-",left,left1);
			var right = t.left.right.copy();
			t.operation = TermNode.MathOp.h["/"];
			if(t.operation != null) {
				t.symbol = "/";
				t.left = left2;
				t.right = right;
			} else {
				throw haxe_Exception.thrown("\"" + "/" + "\" is no valid operation.");
			}
		} else if(t.left.symbol == "/" && t.right.symbol == "/") {
			var left = t.left.left.copy();
			var left1 = t.right.right.copy();
			var left2 = TermTransform.newOperation("*",left,left1);
			var left = t.right.left.copy();
			var left1 = t.left.right.copy();
			var left3 = TermTransform.newOperation("*",left,left1);
			var left = TermTransform.newOperation("-",left2,left3);
			var right = t.left.right.copy();
			var right1 = t.right.right.copy();
			var right2 = TermTransform.newOperation("*",right,right1);
			t.operation = TermNode.MathOp.h["/"];
			if(t.operation != null) {
				t.symbol = "/";
				t.left = left;
				t.right = right2;
			} else {
				throw haxe_Exception.thrown("\"" + "/" + "\" is no valid operation.");
			}
		}
		TermTransform.arrangeAddition(t);
		if(t.symbol == "-") {
			TermTransform._factorize(t);
		}
		break;
	case "/":
		if(TermTransform.isEqualAfterSimplify(t.left,t.right)) {
			t.operation = TermNode.opValue;
			t.symbol = null;
			t.value = 1;
			t.left = null;
			t.right = null;
		} else if(Reflect.compareMethods(t.left.operation,TermNode.opValue) && t.left.value == 0) {
			t.operation = TermNode.opValue;
			t.symbol = null;
			t.value = 0;
			t.left = null;
			t.right = null;
		} else if(t.right.symbol == "/") {
			var left = t.right.right.copy();
			var left1 = t.left.copy();
			var left2 = TermTransform.newOperation("*",left,left1);
			var right = t.right.left.copy();
			t.operation = TermNode.MathOp.h["/"];
			if(t.operation != null) {
				t.symbol = "/";
				t.left = left2;
				t.right = right;
			} else {
				throw haxe_Exception.thrown("\"" + "/" + "\" is no valid operation.");
			}
		} else if(Reflect.compareMethods(t.right.operation,TermNode.opValue) && t.right.value == 1) {
			var t1 = t.left;
			if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = t1.value;
				t.left = null;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
				t.operation = TermNode.opName;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
				t.operation = TermNode.opParam;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else {
				var s = t1.symbol;
				t.operation = TermNode.MathOp.h[s];
				if(t.operation != null) {
					t.symbol = s;
					t.left = t1.left;
					t.right = t1.right;
				} else {
					throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
				}
			}
		} else if(t.left.symbol == "/") {
			var left = t.left.left.copy();
			var right = t.left.right.copy();
			var right1 = t.right.copy();
			var right2 = TermTransform.newOperation("*",right,right1);
			t.operation = TermNode.MathOp.h["/"];
			if(t.operation != null) {
				t.symbol = "/";
				t.left = left;
				t.right = right2;
			} else {
				throw haxe_Exception.thrown("\"" + "/" + "\" is no valid operation.");
			}
		} else if(t.right.symbol == "/") {
			var left = t.right.right.copy();
			var left1 = t.left.copy();
			var left2 = TermTransform.newOperation("*",left,left1);
			var right = t.right.left.copy();
			t.operation = TermNode.MathOp.h["/"];
			if(t.operation != null) {
				t.symbol = "/";
				t.left = left2;
				t.right = right;
			} else {
				throw haxe_Exception.thrown("\"" + "/" + "\" is no valid operation.");
			}
		} else if(t.left.symbol == "-" && Reflect.compareMethods(t.left.left.operation,TermNode.opValue) && t.left.left.value == 0) {
			var left = TermTransform.newValue(0);
			var right = t.left.right.copy();
			var right1 = t.right.copy();
			var right2 = TermTransform.newOperation("/",right,right1);
			t.operation = TermNode.MathOp.h["-"];
			if(t.operation != null) {
				t.symbol = "-";
				t.left = left;
				t.right = right2;
			} else {
				throw haxe_Exception.thrown("\"" + "-" + "\" is no valid operation.");
			}
		} else {
			TermTransform.simplifyfraction(t);
		}
		break;
	case "^":
		if(Reflect.compareMethods(t.left.operation,TermNode.opValue)) {
			if(t.left.value == 1) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = 1;
				t.left = null;
				t.right = null;
			} else if(t.left.value == 0) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = 0;
				t.left = null;
				t.right = null;
			}
		} else if(Reflect.compareMethods(t.right.operation,TermNode.opValue)) {
			if(t.right.value == 1) {
				var t1 = t.left;
				if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
					t.operation = TermNode.opValue;
					t.symbol = null;
					t.value = t1.value;
					t.left = null;
					t.right = null;
				} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
					t.operation = TermNode.opName;
					t.symbol = t1.symbol;
					t.left = t1.left;
					t.right = null;
				} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
					t.operation = TermNode.opParam;
					t.symbol = t1.symbol;
					t.left = t1.left;
					t.right = null;
				} else {
					var s = t1.symbol;
					t.operation = TermNode.MathOp.h[s];
					if(t.operation != null) {
						t.symbol = s;
						t.left = t1.left;
						t.right = t1.right;
					} else {
						throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
					}
				}
			} else if(t.right.value == 0) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = 1;
				t.left = null;
				t.right = null;
			}
		} else if(t.left.symbol == "^") {
			var left = t.left.left.copy();
			var right = t.left.right.copy();
			var right1 = t.right.copy();
			var right2 = TermTransform.newOperation("*",right,right1);
			t.operation = TermNode.MathOp.h["^"];
			if(t.operation != null) {
				t.symbol = "^";
				t.left = left;
				t.right = right2;
			} else {
				throw haxe_Exception.thrown("\"" + "^" + "\" is no valid operation.");
			}
		}
		break;
	case "ln":
		if(t.left.symbol == "e") {
			t.operation = TermNode.opValue;
			t.symbol = null;
			t.value = 1;
			t.left = null;
			t.right = null;
		}
		break;
	case "log":
		if(TermTransform.isEqualAfterSimplify(t.left,t.right)) {
			t.operation = TermNode.opValue;
			t.symbol = null;
			t.value = 1;
			t.left = null;
			t.right = null;
		} else {
			var left = t.right.copy();
			var left1 = TermTransform.newOperation("ln",left);
			var right = t.left.copy();
			var right1 = TermTransform.newOperation("ln",right);
			t.operation = TermNode.MathOp.h["/"];
			if(t.operation != null) {
				t.symbol = "/";
				t.left = left1;
				t.right = right1;
			} else {
				throw haxe_Exception.thrown("\"" + "/" + "\" is no valid operation.");
			}
		}
		break;
	}
	if(t.left != null) {
		TermTransform.simplifyStep(t.left);
	}
	if(t.right != null) {
		TermTransform.simplifyStep(t.right);
	}
};
TermTransform.traverseMultiplication = function(t,p) {
	if(t.symbol != "*") {
		p.push(t);
	} else {
		TermTransform.traverseMultiplication(t.left,p);
		TermTransform.traverseMultiplication(t.right,p);
	}
};
TermTransform.traverseMultiplicationBack = function(t,p) {
	if(p.length > 2) {
		var left = TermTransform.newValue(1);
		var right = p.pop();
		t.operation = TermNode.MathOp.h["*"];
		if(t.operation != null) {
			t.symbol = "*";
			t.left = left;
			t.right = right;
		} else {
			throw haxe_Exception.thrown("\"" + "*" + "\" is no valid operation.");
		}
		TermTransform.traverseMultiplicationBack(t.left,p);
	} else if(p.length == 2) {
		var left = p[0].copy();
		var right = p[1].copy();
		t.operation = TermNode.MathOp.h["*"];
		if(t.operation != null) {
			t.symbol = "*";
			t.left = left;
			t.right = right;
		} else {
			throw haxe_Exception.thrown("\"" + "*" + "\" is no valid operation.");
		}
		p.pop();
		p.pop();
	} else {
		var term = p.pop();
		if(Reflect.compareMethods(t.operation,TermNode.opName)) {
			if(!Reflect.compareMethods(term.operation,TermNode.opName)) {
				t.left = term.copy();
			} else if(term.left != null) {
				t.left = term.left.copy();
			} else {
				t.left = null;
			}
		} else if(!Reflect.compareMethods(term.operation,TermNode.opName)) {
			var t1 = term.copy();
			if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = t1.value;
				t.left = null;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
				t.operation = TermNode.opName;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
				t.operation = TermNode.opParam;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else {
				var s = t1.symbol;
				t.operation = TermNode.MathOp.h[s];
				if(t.operation != null) {
					t.symbol = s;
					t.left = t1.left;
					t.right = t1.right;
				} else {
					throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
				}
			}
		} else if(term.left != null) {
			var t1 = term.left.copy();
			if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = t1.value;
				t.left = null;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
				t.operation = TermNode.opName;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
				t.operation = TermNode.opParam;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else {
				var s = t1.symbol;
				t.operation = TermNode.MathOp.h[s];
				if(t.operation != null) {
					t.symbol = s;
					t.left = t1.left;
					t.right = t1.right;
				} else {
					throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
				}
			}
		}
	}
};
TermTransform.traverseAddition = function(t,p,negative) {
	if(negative == null) {
		negative = false;
	}
	if(t.symbol == "+" && negative == false) {
		TermTransform.traverseAddition(t.left,p);
		TermTransform.traverseAddition(t.right,p);
	} else if(t.symbol == "-" && negative == false) {
		TermTransform.traverseAddition(t.left,p);
		TermTransform.traverseAddition(t.right,p,true);
	} else if(t.symbol == "+" && negative == true) {
		TermTransform.traverseAddition(t.left,p,true);
		TermTransform.traverseAddition(t.right,p,true);
	} else if(t.symbol == "-" && negative == true) {
		TermTransform.traverseAddition(t.left,p,true);
		TermTransform.traverseAddition(t.right,p);
	} else if(negative == true && !Reflect.compareMethods(t.operation,TermNode.opValue) || negative == true && Reflect.compareMethods(t.operation,TermNode.opValue) && t.value != 0) {
		var tmp = TermTransform.newValue(0);
		p.push(TermTransform.newOperation("-",tmp,t));
	} else if(!Reflect.compareMethods(t.operation,TermNode.opValue) || Reflect.compareMethods(t.operation,TermNode.opValue) && t.value != 0) {
		p.push(t);
	}
	return p;
};
TermTransform.traverseAdditionBack = function(t,p) {
	if(p.length > 1) {
		if(p[p.length - 1].symbol == "-") {
			var term = p.pop();
			if(Reflect.compareMethods(t.operation,TermNode.opName)) {
				if(!Reflect.compareMethods(term.operation,TermNode.opName)) {
					t.left = term.copy();
				} else if(term.left != null) {
					t.left = term.left.copy();
				} else {
					t.left = null;
				}
			} else if(!Reflect.compareMethods(term.operation,TermNode.opName)) {
				var t1 = term.copy();
				if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
					t.operation = TermNode.opValue;
					t.symbol = null;
					t.value = t1.value;
					t.left = null;
					t.right = null;
				} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
					t.operation = TermNode.opName;
					t.symbol = t1.symbol;
					t.left = t1.left;
					t.right = null;
				} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
					t.operation = TermNode.opParam;
					t.symbol = t1.symbol;
					t.left = t1.left;
					t.right = null;
				} else {
					var s = t1.symbol;
					t.operation = TermNode.MathOp.h[s];
					if(t.operation != null) {
						t.symbol = s;
						t.left = t1.left;
						t.right = t1.right;
					} else {
						throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
					}
				}
			} else if(term.left != null) {
				var t1 = term.left.copy();
				if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
					t.operation = TermNode.opValue;
					t.symbol = null;
					t.value = t1.value;
					t.left = null;
					t.right = null;
				} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
					t.operation = TermNode.opName;
					t.symbol = t1.symbol;
					t.left = t1.left;
					t.right = null;
				} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
					t.operation = TermNode.opParam;
					t.symbol = t1.symbol;
					t.left = t1.left;
					t.right = null;
				} else {
					var s = t1.symbol;
					t.operation = TermNode.MathOp.h[s];
					if(t.operation != null) {
						t.symbol = s;
						t.left = t1.left;
						t.right = t1.right;
					} else {
						throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
					}
				}
			}
		} else {
			var left = TermTransform.newValue(0);
			var right = p.pop();
			t.operation = TermNode.MathOp.h["+"];
			if(t.operation != null) {
				t.symbol = "+";
				t.left = left;
				t.right = right;
			} else {
				throw haxe_Exception.thrown("\"" + "+" + "\" is no valid operation.");
			}
		}
		TermTransform.traverseAdditionBack(t.left,p);
	} else if(p.length == 1) {
		var term = p.pop();
		if(Reflect.compareMethods(t.operation,TermNode.opName)) {
			if(!Reflect.compareMethods(term.operation,TermNode.opName)) {
				t.left = term.copy();
			} else if(term.left != null) {
				t.left = term.left.copy();
			} else {
				t.left = null;
			}
		} else if(!Reflect.compareMethods(term.operation,TermNode.opName)) {
			var t1 = term.copy();
			if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = t1.value;
				t.left = null;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
				t.operation = TermNode.opName;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
				t.operation = TermNode.opParam;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else {
				var s = t1.symbol;
				t.operation = TermNode.MathOp.h[s];
				if(t.operation != null) {
					t.symbol = s;
					t.left = t1.left;
					t.right = t1.right;
				} else {
					throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
				}
			}
		} else if(term.left != null) {
			var t1 = term.left.copy();
			if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
				t.operation = TermNode.opValue;
				t.symbol = null;
				t.value = t1.value;
				t.left = null;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
				t.operation = TermNode.opName;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
				t.operation = TermNode.opParam;
				t.symbol = t1.symbol;
				t.left = t1.left;
				t.right = null;
			} else {
				var s = t1.symbol;
				t.operation = TermNode.MathOp.h[s];
				if(t.operation != null) {
					t.symbol = s;
					t.left = t1.left;
					t.right = t1.right;
				} else {
					throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
				}
			}
		}
	}
};
TermTransform.simplifyfraction = function(t) {
	var numerator = [];
	TermTransform.traverseMultiplication(t.left,numerator);
	var denominator = [];
	TermTransform.traverseMultiplication(t.right,denominator);
	var _g = 0;
	while(_g < numerator.length) {
		var n = numerator[_g];
		++_g;
		var _g1 = 0;
		while(_g1 < denominator.length) {
			var d = denominator[_g1];
			++_g1;
			if(TermTransform.isEqualAfterSimplify(n,d)) {
				HxOverrides.remove(numerator,n);
				HxOverrides.remove(denominator,d);
			}
		}
	}
	if(numerator.length > 1) {
		TermTransform.traverseMultiplicationBack(t.left,numerator);
	} else if(numerator.length == 1) {
		var left = numerator.pop();
		var right = TermTransform.newValue(1);
		t.operation = TermNode.MathOp.h["/"];
		if(t.operation != null) {
			t.symbol = "/";
			t.left = left;
			t.right = right;
		} else {
			throw haxe_Exception.thrown("\"" + "/" + "\" is no valid operation.");
		}
	} else if(numerator.length == 0) {
		var _this = t.left;
		_this.operation = TermNode.opValue;
		_this.symbol = null;
		_this.value = 1;
		_this.left = null;
		_this.right = null;
	}
	if(denominator.length > 1) {
		TermTransform.traverseMultiplicationBack(t.right,denominator);
	} else if(denominator.length == 1) {
		var left = t.left.copy();
		var right = denominator.pop();
		t.operation = TermNode.MathOp.h["/"];
		if(t.operation != null) {
			t.symbol = "/";
			t.left = left;
			t.right = right;
		} else {
			throw haxe_Exception.thrown("\"" + "/" + "\" is no valid operation.");
		}
	} else if(denominator.length == 0) {
		var _this = t.right;
		_this.operation = TermNode.opValue;
		_this.symbol = null;
		_this.value = 1;
		_this.left = null;
		_this.right = null;
	}
};
TermTransform._expand = function(t) {
	var len = -1;
	var len_old = 0;
	while(len != len_old) {
		if(t.symbol == "*") {
			TermTransform.expandStep(t);
		} else {
			if(t.left != null) {
				TermTransform._expand(t.left);
			}
			if(t.right != null) {
				TermTransform._expand(t.right);
			}
		}
		len_old = len;
		len = t.length();
	}
};
TermTransform.expandStep = function(t) {
	var left = t.left;
	var right = t.right;
	if(left.symbol == "+" || left.symbol == "-") {
		if(right.symbol == "+" || right.symbol == "-") {
			if(left.symbol == "+" && right.symbol == "+") {
				var left1 = left.left.copy();
				var left2 = right.left.copy();
				var left3 = TermTransform.newOperation("*",left1,left2);
				var left1 = left.left.copy();
				var left2 = right.right.copy();
				var left4 = TermTransform.newOperation("*",left1,left2);
				var left1 = TermTransform.newOperation("+",left3,left4);
				var right1 = left.right.copy();
				var right2 = right.left.copy();
				var right3 = TermTransform.newOperation("*",right1,right2);
				var right1 = left.right.copy();
				var right2 = right.right.copy();
				var right4 = TermTransform.newOperation("*",right1,right2);
				var right1 = TermTransform.newOperation("+",right3,right4);
				t.operation = TermNode.MathOp.h["+"];
				if(t.operation != null) {
					t.symbol = "+";
					t.left = left1;
					t.right = right1;
				} else {
					throw haxe_Exception.thrown("\"" + "+" + "\" is no valid operation.");
				}
			} else if(left.symbol == "+" && right.symbol == "-") {
				var left1 = left.left.copy();
				var left2 = right.left.copy();
				var left3 = TermTransform.newOperation("*",left1,left2);
				var left1 = left.left.copy();
				var left2 = right.right.copy();
				var left4 = TermTransform.newOperation("*",left1,left2);
				var left1 = TermTransform.newOperation("-",left3,left4);
				var right1 = left.right.copy();
				var right2 = right.left.copy();
				var right3 = TermTransform.newOperation("*",right1,right2);
				var right1 = left.right.copy();
				var right2 = right.right.copy();
				var right4 = TermTransform.newOperation("*",right1,right2);
				var right1 = TermTransform.newOperation("-",right3,right4);
				t.operation = TermNode.MathOp.h["+"];
				if(t.operation != null) {
					t.symbol = "+";
					t.left = left1;
					t.right = right1;
				} else {
					throw haxe_Exception.thrown("\"" + "+" + "\" is no valid operation.");
				}
			} else if(left.symbol == "-" && right.symbol == "+") {
				var left1 = left.left.copy();
				var left2 = right.left.copy();
				var left3 = TermTransform.newOperation("*",left1,left2);
				var left1 = left.left.copy();
				var left2 = right.right.copy();
				var left4 = TermTransform.newOperation("*",left1,left2);
				var left1 = TermTransform.newOperation("+",left3,left4);
				var right1 = left.right.copy();
				var right2 = right.left.copy();
				var right3 = TermTransform.newOperation("*",right1,right2);
				var right1 = left.right.copy();
				var right2 = right.right.copy();
				var right4 = TermTransform.newOperation("*",right1,right2);
				var right1 = TermTransform.newOperation("+",right3,right4);
				t.operation = TermNode.MathOp.h["-"];
				if(t.operation != null) {
					t.symbol = "-";
					t.left = left1;
					t.right = right1;
				} else {
					throw haxe_Exception.thrown("\"" + "-" + "\" is no valid operation.");
				}
			} else if(left.symbol == "-" && right.symbol == "-") {
				var left1 = left.left.copy();
				var left2 = right.left.copy();
				var left3 = TermTransform.newOperation("*",left1,left2);
				var left1 = left.left.copy();
				var left2 = right.right.copy();
				var left4 = TermTransform.newOperation("*",left1,left2);
				var left1 = TermTransform.newOperation("-",left3,left4);
				var right1 = left.right.copy();
				var right2 = right.left.copy();
				var right3 = TermTransform.newOperation("*",right1,right2);
				var right1 = left.right.copy();
				var right2 = right.right.copy();
				var right4 = TermTransform.newOperation("*",right1,right2);
				var right1 = TermTransform.newOperation("-",right3,right4);
				t.operation = TermNode.MathOp.h["-"];
				if(t.operation != null) {
					t.symbol = "-";
					t.left = left1;
					t.right = right1;
				} else {
					throw haxe_Exception.thrown("\"" + "-" + "\" is no valid operation.");
				}
			}
		} else if(left.symbol == "+") {
			var left1 = left.left.copy();
			var left2 = right.copy();
			var left3 = TermTransform.newOperation("*",left1,left2);
			var right1 = left.right.copy();
			var right2 = right.copy();
			var right3 = TermTransform.newOperation("*",right1,right2);
			t.operation = TermNode.MathOp.h["+"];
			if(t.operation != null) {
				t.symbol = "+";
				t.left = left3;
				t.right = right3;
			} else {
				throw haxe_Exception.thrown("\"" + "+" + "\" is no valid operation.");
			}
		} else if(left.symbol == "-") {
			var left1 = left.left.copy();
			var left2 = right.copy();
			var left3 = TermTransform.newOperation("*",left1,left2);
			var right1 = left.right.copy();
			var right2 = right.copy();
			var right3 = TermTransform.newOperation("*",right1,right2);
			t.operation = TermNode.MathOp.h["-"];
			if(t.operation != null) {
				t.symbol = "-";
				t.left = left3;
				t.right = right3;
			} else {
				throw haxe_Exception.thrown("\"" + "-" + "\" is no valid operation.");
			}
		}
	} else if(right.symbol == "+" || right.symbol == "-") {
		if(right.symbol == "+") {
			var left1 = left.copy();
			var left2 = right.left.copy();
			var left3 = TermTransform.newOperation("*",left1,left2);
			var right1 = left.copy();
			var right2 = right.right.copy();
			var right3 = TermTransform.newOperation("*",right1,right2);
			t.operation = TermNode.MathOp.h["+"];
			if(t.operation != null) {
				t.symbol = "+";
				t.left = left3;
				t.right = right3;
			} else {
				throw haxe_Exception.thrown("\"" + "+" + "\" is no valid operation.");
			}
		} else if(right.symbol == "-") {
			var left1 = left.copy();
			var left2 = right.left.copy();
			var left3 = TermTransform.newOperation("*",left1,left2);
			var right1 = left.copy();
			var right2 = right.right.copy();
			var right = TermTransform.newOperation("*",right1,right2);
			t.operation = TermNode.MathOp.h["-"];
			if(t.operation != null) {
				t.symbol = "-";
				t.left = left3;
				t.right = right;
			} else {
				throw haxe_Exception.thrown("\"" + "-" + "\" is no valid operation.");
			}
		}
	}
};
TermTransform._factorize = function(t) {
	var mult_matrix = [];
	var add = [];
	TermTransform.traverseAddition(t,add);
	var add_length_old = 0;
	var _g = 0;
	while(_g < add.length) {
		var i = add[_g];
		++_g;
		if(i.symbol == "-") {
			mult_matrix.push([]);
			TermTransform.traverseMultiplication(add[mult_matrix.length - 1].right,mult_matrix[mult_matrix.length - 1]);
		} else {
			mult_matrix.push([]);
			TermTransform.traverseMultiplication(add[mult_matrix.length - 1],mult_matrix[mult_matrix.length - 1]);
		}
	}
	var part_of_all = [];
	TermTransform.factorize_extract_common(mult_matrix,part_of_all);
	if(part_of_all.length != 0) {
		var new_add = [];
		var helper = new TermNode();
		var _g = 0;
		while(_g < mult_matrix.length) {
			var i = mult_matrix[_g];
			++_g;
			TermTransform.traverseMultiplicationBack(helper,i);
			var v = new TermNode();
			if(Reflect.compareMethods(v.operation,TermNode.opName)) {
				if(!Reflect.compareMethods(helper.operation,TermNode.opName)) {
					v.left = helper.copy();
				} else if(helper.left != null) {
					v.left = helper.left.copy();
				} else {
					v.left = null;
				}
			} else if(!Reflect.compareMethods(helper.operation,TermNode.opName)) {
				var t1 = helper.copy();
				if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
					v.operation = TermNode.opValue;
					v.symbol = null;
					v.value = t1.value;
					v.left = null;
					v.right = null;
				} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
					v.operation = TermNode.opName;
					v.symbol = t1.symbol;
					v.left = t1.left;
					v.right = null;
				} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
					v.operation = TermNode.opParam;
					v.symbol = t1.symbol;
					v.left = t1.left;
					v.right = null;
				} else {
					var s = t1.symbol;
					v.operation = TermNode.MathOp.h[s];
					if(v.operation != null) {
						v.symbol = s;
						v.left = t1.left;
						v.right = t1.right;
					} else {
						throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
					}
				}
			} else if(helper.left != null) {
				var t2 = helper.left.copy();
				if(Reflect.compareMethods(t2.operation,TermNode.opValue)) {
					v.operation = TermNode.opValue;
					v.symbol = null;
					v.value = t2.value;
					v.left = null;
					v.right = null;
				} else if(Reflect.compareMethods(t2.operation,TermNode.opName)) {
					v.operation = TermNode.opName;
					v.symbol = t2.symbol;
					v.left = t2.left;
					v.right = null;
				} else if(Reflect.compareMethods(t2.operation,TermNode.opParam)) {
					v.operation = TermNode.opParam;
					v.symbol = t2.symbol;
					v.left = t2.left;
					v.right = null;
				} else {
					var s1 = t2.symbol;
					v.operation = TermNode.MathOp.h[s1];
					if(v.operation != null) {
						v.symbol = s1;
						v.left = t2.left;
						v.right = t2.right;
					} else {
						throw haxe_Exception.thrown("\"" + s1 + "\" is no valid operation.");
					}
				}
			}
			new_add.push(v);
		}
		var _g = 0;
		var _g1 = add.length;
		while(_g < _g1) {
			var i = _g++;
			if(add[i].symbol == "-" && add[i].left.value == 0) {
				var _this = new_add[i];
				var left = TermTransform.newValue(0);
				var right = new_add[i].copy();
				_this.operation = TermNode.MathOp.h["-"];
				if(_this.operation != null) {
					_this.symbol = "-";
					_this.left = left;
					_this.right = right;
				} else {
					throw haxe_Exception.thrown("\"" + "-" + "\" is no valid operation.");
				}
			}
		}
		var left = new TermNode();
		var right = new TermNode();
		t.operation = TermNode.MathOp.h["*"];
		if(t.operation != null) {
			t.symbol = "*";
			t.left = left;
			t.right = right;
		} else {
			throw haxe_Exception.thrown("\"" + "*" + "\" is no valid operation.");
		}
		TermTransform.traverseMultiplicationBack(t.left,part_of_all);
		TermTransform.traverseAdditionBack(t.right,new_add);
	}
};
TermTransform.factorize_extract_common = function(mult_matrix,part_of_all) {
	var bool = false;
	var matrix_length_old = -1;
	var i = new TermNode();
	var exponentiation_counter = 0;
	while(matrix_length_old != mult_matrix[0].length) {
		matrix_length_old = mult_matrix[0].length;
		var _g = 0;
		var _g1 = mult_matrix[0];
		while(_g < _g1.length) {
			var p = _g1[_g];
			++_g;
			if(p.symbol == "^") {
				var term = p.left;
				if(Reflect.compareMethods(i.operation,TermNode.opName)) {
					if(!Reflect.compareMethods(term.operation,TermNode.opName)) {
						i.left = term.copy();
					} else if(term.left != null) {
						i.left = term.left.copy();
					} else {
						i.left = null;
					}
				} else if(!Reflect.compareMethods(term.operation,TermNode.opName)) {
					var t = term.copy();
					if(Reflect.compareMethods(t.operation,TermNode.opValue)) {
						i.operation = TermNode.opValue;
						i.symbol = null;
						i.value = t.value;
						i.left = null;
						i.right = null;
					} else if(Reflect.compareMethods(t.operation,TermNode.opName)) {
						i.operation = TermNode.opName;
						i.symbol = t.symbol;
						i.left = t.left;
						i.right = null;
					} else if(Reflect.compareMethods(t.operation,TermNode.opParam)) {
						i.operation = TermNode.opParam;
						i.symbol = t.symbol;
						i.left = t.left;
						i.right = null;
					} else {
						var s = t.symbol;
						i.operation = TermNode.MathOp.h[s];
						if(i.operation != null) {
							i.symbol = s;
							i.left = t.left;
							i.right = t.right;
						} else {
							throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
						}
					}
				} else if(term.left != null) {
					var t1 = term.left.copy();
					if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
						i.operation = TermNode.opValue;
						i.symbol = null;
						i.value = t1.value;
						i.left = null;
						i.right = null;
					} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
						i.operation = TermNode.opName;
						i.symbol = t1.symbol;
						i.left = t1.left;
						i.right = null;
					} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
						i.operation = TermNode.opParam;
						i.symbol = t1.symbol;
						i.left = t1.left;
						i.right = null;
					} else {
						var s1 = t1.symbol;
						i.operation = TermNode.MathOp.h[s1];
						if(i.operation != null) {
							i.symbol = s1;
							i.left = t1.left;
							i.right = t1.right;
						} else {
							throw haxe_Exception.thrown("\"" + s1 + "\" is no valid operation.");
						}
					}
				}
				++exponentiation_counter;
			} else if(p.symbol == "-" && Reflect.compareMethods(p.left.operation,TermNode.opValue) && p.left.value == 0) {
				var term1 = p.right;
				if(Reflect.compareMethods(i.operation,TermNode.opName)) {
					if(!Reflect.compareMethods(term1.operation,TermNode.opName)) {
						i.left = term1.copy();
					} else if(term1.left != null) {
						i.left = term1.left.copy();
					} else {
						i.left = null;
					}
				} else if(!Reflect.compareMethods(term1.operation,TermNode.opName)) {
					var t2 = term1.copy();
					if(Reflect.compareMethods(t2.operation,TermNode.opValue)) {
						i.operation = TermNode.opValue;
						i.symbol = null;
						i.value = t2.value;
						i.left = null;
						i.right = null;
					} else if(Reflect.compareMethods(t2.operation,TermNode.opName)) {
						i.operation = TermNode.opName;
						i.symbol = t2.symbol;
						i.left = t2.left;
						i.right = null;
					} else if(Reflect.compareMethods(t2.operation,TermNode.opParam)) {
						i.operation = TermNode.opParam;
						i.symbol = t2.symbol;
						i.left = t2.left;
						i.right = null;
					} else {
						var s2 = t2.symbol;
						i.operation = TermNode.MathOp.h[s2];
						if(i.operation != null) {
							i.symbol = s2;
							i.left = t2.left;
							i.right = t2.right;
						} else {
							throw haxe_Exception.thrown("\"" + s2 + "\" is no valid operation.");
						}
					}
				} else if(term1.left != null) {
					var t3 = term1.left.copy();
					if(Reflect.compareMethods(t3.operation,TermNode.opValue)) {
						i.operation = TermNode.opValue;
						i.symbol = null;
						i.value = t3.value;
						i.left = null;
						i.right = null;
					} else if(Reflect.compareMethods(t3.operation,TermNode.opName)) {
						i.operation = TermNode.opName;
						i.symbol = t3.symbol;
						i.left = t3.left;
						i.right = null;
					} else if(Reflect.compareMethods(t3.operation,TermNode.opParam)) {
						i.operation = TermNode.opParam;
						i.symbol = t3.symbol;
						i.left = t3.left;
						i.right = null;
					} else {
						var s3 = t3.symbol;
						i.operation = TermNode.MathOp.h[s3];
						if(i.operation != null) {
							i.symbol = s3;
							i.left = t3.left;
							i.right = t3.right;
						} else {
							throw haxe_Exception.thrown("\"" + s3 + "\" is no valid operation.");
						}
					}
				}
			} else if(Reflect.compareMethods(i.operation,TermNode.opName)) {
				if(!Reflect.compareMethods(p.operation,TermNode.opName)) {
					i.left = p.copy();
				} else if(p.left != null) {
					i.left = p.left.copy();
				} else {
					i.left = null;
				}
			} else if(!Reflect.compareMethods(p.operation,TermNode.opName)) {
				var t4 = p.copy();
				if(Reflect.compareMethods(t4.operation,TermNode.opValue)) {
					i.operation = TermNode.opValue;
					i.symbol = null;
					i.value = t4.value;
					i.left = null;
					i.right = null;
				} else if(Reflect.compareMethods(t4.operation,TermNode.opName)) {
					i.operation = TermNode.opName;
					i.symbol = t4.symbol;
					i.left = t4.left;
					i.right = null;
				} else if(Reflect.compareMethods(t4.operation,TermNode.opParam)) {
					i.operation = TermNode.opParam;
					i.symbol = t4.symbol;
					i.left = t4.left;
					i.right = null;
				} else {
					var s4 = t4.symbol;
					i.operation = TermNode.MathOp.h[s4];
					if(i.operation != null) {
						i.symbol = s4;
						i.left = t4.left;
						i.right = t4.right;
					} else {
						throw haxe_Exception.thrown("\"" + s4 + "\" is no valid operation.");
					}
				}
			} else if(p.left != null) {
				var t5 = p.left.copy();
				if(Reflect.compareMethods(t5.operation,TermNode.opValue)) {
					i.operation = TermNode.opValue;
					i.symbol = null;
					i.value = t5.value;
					i.left = null;
					i.right = null;
				} else if(Reflect.compareMethods(t5.operation,TermNode.opName)) {
					i.operation = TermNode.opName;
					i.symbol = t5.symbol;
					i.left = t5.left;
					i.right = null;
				} else if(Reflect.compareMethods(t5.operation,TermNode.opParam)) {
					i.operation = TermNode.opParam;
					i.symbol = t5.symbol;
					i.left = t5.left;
					i.right = null;
				} else {
					var s5 = t5.symbol;
					i.operation = TermNode.MathOp.h[s5];
					if(i.operation != null) {
						i.symbol = s5;
						i.left = t5.left;
						i.right = t5.right;
					} else {
						throw haxe_Exception.thrown("\"" + s5 + "\" is no valid operation.");
					}
				}
			}
			var _g2 = 1;
			var _g3 = mult_matrix.length;
			while(_g2 < _g3) {
				var j = _g2++;
				bool = false;
				var _g4 = 0;
				var _g5 = mult_matrix[j];
				while(_g4 < _g5.length) {
					var h = _g5[_g4];
					++_g4;
					if(TermTransform.isEqualAfterSimplify(h,i)) {
						bool = true;
						break;
					} else if(h.symbol == "^" && TermTransform.isEqualAfterSimplify(h.left,i)) {
						bool = true;
						++exponentiation_counter;
						break;
					} else if(h.symbol == "-" && Reflect.compareMethods(h.left.operation,TermNode.opValue) && h.left.value == 0 && TermTransform.isEqualAfterSimplify(h.right,i)) {
						bool = true;
						break;
					}
				}
				if(bool == false) {
					break;
				}
			}
			if(bool == true && exponentiation_counter < mult_matrix.length) {
				part_of_all.push(new TermNode());
				var _this = part_of_all[part_of_all.length - 1];
				if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
					if(!Reflect.compareMethods(i.operation,TermNode.opName)) {
						_this.left = i.copy();
					} else if(i.left != null) {
						_this.left = i.left.copy();
					} else {
						_this.left = null;
					}
				} else if(!Reflect.compareMethods(i.operation,TermNode.opName)) {
					var t6 = i.copy();
					if(Reflect.compareMethods(t6.operation,TermNode.opValue)) {
						_this.operation = TermNode.opValue;
						_this.symbol = null;
						_this.value = t6.value;
						_this.left = null;
						_this.right = null;
					} else if(Reflect.compareMethods(t6.operation,TermNode.opName)) {
						_this.operation = TermNode.opName;
						_this.symbol = t6.symbol;
						_this.left = t6.left;
						_this.right = null;
					} else if(Reflect.compareMethods(t6.operation,TermNode.opParam)) {
						_this.operation = TermNode.opParam;
						_this.symbol = t6.symbol;
						_this.left = t6.left;
						_this.right = null;
					} else {
						var s6 = t6.symbol;
						_this.operation = TermNode.MathOp.h[s6];
						if(_this.operation != null) {
							_this.symbol = s6;
							_this.left = t6.left;
							_this.right = t6.right;
						} else {
							throw haxe_Exception.thrown("\"" + s6 + "\" is no valid operation.");
						}
					}
				} else if(i.left != null) {
					var t7 = i.left.copy();
					if(Reflect.compareMethods(t7.operation,TermNode.opValue)) {
						_this.operation = TermNode.opValue;
						_this.symbol = null;
						_this.value = t7.value;
						_this.left = null;
						_this.right = null;
					} else if(Reflect.compareMethods(t7.operation,TermNode.opName)) {
						_this.operation = TermNode.opName;
						_this.symbol = t7.symbol;
						_this.left = t7.left;
						_this.right = null;
					} else if(Reflect.compareMethods(t7.operation,TermNode.opParam)) {
						_this.operation = TermNode.opParam;
						_this.symbol = t7.symbol;
						_this.left = t7.left;
						_this.right = null;
					} else {
						var s7 = t7.symbol;
						_this.operation = TermNode.MathOp.h[s7];
						if(_this.operation != null) {
							_this.symbol = s7;
							_this.left = t7.left;
							_this.right = t7.right;
						} else {
							throw haxe_Exception.thrown("\"" + s7 + "\" is no valid operation.");
						}
					}
				}
				var helper = new TermNode();
				if(Reflect.compareMethods(helper.operation,TermNode.opName)) {
					if(!Reflect.compareMethods(i.operation,TermNode.opName)) {
						helper.left = i.copy();
					} else if(i.left != null) {
						helper.left = i.left.copy();
					} else {
						helper.left = null;
					}
				} else if(!Reflect.compareMethods(i.operation,TermNode.opName)) {
					var t8 = i.copy();
					if(Reflect.compareMethods(t8.operation,TermNode.opValue)) {
						helper.operation = TermNode.opValue;
						helper.symbol = null;
						helper.value = t8.value;
						helper.left = null;
						helper.right = null;
					} else if(Reflect.compareMethods(t8.operation,TermNode.opName)) {
						helper.operation = TermNode.opName;
						helper.symbol = t8.symbol;
						helper.left = t8.left;
						helper.right = null;
					} else if(Reflect.compareMethods(t8.operation,TermNode.opParam)) {
						helper.operation = TermNode.opParam;
						helper.symbol = t8.symbol;
						helper.left = t8.left;
						helper.right = null;
					} else {
						var s8 = t8.symbol;
						helper.operation = TermNode.MathOp.h[s8];
						if(helper.operation != null) {
							helper.symbol = s8;
							helper.left = t8.left;
							helper.right = t8.right;
						} else {
							throw haxe_Exception.thrown("\"" + s8 + "\" is no valid operation.");
						}
					}
				} else if(i.left != null) {
					var t9 = i.left.copy();
					if(Reflect.compareMethods(t9.operation,TermNode.opValue)) {
						helper.operation = TermNode.opValue;
						helper.symbol = null;
						helper.value = t9.value;
						helper.left = null;
						helper.right = null;
					} else if(Reflect.compareMethods(t9.operation,TermNode.opName)) {
						helper.operation = TermNode.opName;
						helper.symbol = t9.symbol;
						helper.left = t9.left;
						helper.right = null;
					} else if(Reflect.compareMethods(t9.operation,TermNode.opParam)) {
						helper.operation = TermNode.opParam;
						helper.symbol = t9.symbol;
						helper.left = t9.left;
						helper.right = null;
					} else {
						var s9 = t9.symbol;
						helper.operation = TermNode.MathOp.h[s9];
						if(helper.operation != null) {
							helper.symbol = s9;
							helper.left = t9.left;
							helper.right = t9.right;
						} else {
							throw haxe_Exception.thrown("\"" + s9 + "\" is no valid operation.");
						}
					}
				}
				TermTransform.delete_last_from_matrix(mult_matrix,helper);
				break;
			}
		}
	}
};
TermTransform.delete_last_from_matrix = function(mult_matrix,d) {
	var _g = 0;
	while(_g < mult_matrix.length) {
		var i = mult_matrix[_g];
		++_g;
		if(i.length > 1) {
			var _g1 = 1;
			var _g2 = i.length + 1;
			while(_g1 < _g2) {
				var j = _g1++;
				if(TermTransform.isEqualAfterSimplify(i[i.length - j],d)) {
					var _g3 = 0;
					var _g4 = j - 1;
					while(_g3 < _g4) {
						var h = _g3++;
						var _this = i[i.length - j + h];
						var term = i[i.length - j + h + 1];
						if(Reflect.compareMethods(_this.operation,TermNode.opName)) {
							if(!Reflect.compareMethods(term.operation,TermNode.opName)) {
								_this.left = term.copy();
							} else if(term.left != null) {
								_this.left = term.left.copy();
							} else {
								_this.left = null;
							}
						} else if(!Reflect.compareMethods(term.operation,TermNode.opName)) {
							var t = term.copy();
							if(Reflect.compareMethods(t.operation,TermNode.opValue)) {
								_this.operation = TermNode.opValue;
								_this.symbol = null;
								_this.value = t.value;
								_this.left = null;
								_this.right = null;
							} else if(Reflect.compareMethods(t.operation,TermNode.opName)) {
								_this.operation = TermNode.opName;
								_this.symbol = t.symbol;
								_this.left = t.left;
								_this.right = null;
							} else if(Reflect.compareMethods(t.operation,TermNode.opParam)) {
								_this.operation = TermNode.opParam;
								_this.symbol = t.symbol;
								_this.left = t.left;
								_this.right = null;
							} else {
								var s = t.symbol;
								_this.operation = TermNode.MathOp.h[s];
								if(_this.operation != null) {
									_this.symbol = s;
									_this.left = t.left;
									_this.right = t.right;
								} else {
									throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
								}
							}
						} else if(term.left != null) {
							var t1 = term.left.copy();
							if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
								_this.operation = TermNode.opValue;
								_this.symbol = null;
								_this.value = t1.value;
								_this.left = null;
								_this.right = null;
							} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
								_this.operation = TermNode.opName;
								_this.symbol = t1.symbol;
								_this.left = t1.left;
								_this.right = null;
							} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
								_this.operation = TermNode.opParam;
								_this.symbol = t1.symbol;
								_this.left = t1.left;
								_this.right = null;
							} else {
								var s1 = t1.symbol;
								_this.operation = TermNode.MathOp.h[s1];
								if(_this.operation != null) {
									_this.symbol = s1;
									_this.left = t1.left;
									_this.right = t1.right;
								} else {
									throw haxe_Exception.thrown("\"" + s1 + "\" is no valid operation.");
								}
							}
						}
					}
					i.pop();
					break;
				} else if(i[i.length - j].symbol == "^" && TermTransform.isEqualAfterSimplify(i[i.length - j].left,d)) {
					var _this1 = i[i.length - j].right;
					var term1 = i[i.length - j].right.copy();
					var term2 = TermTransform.newValue(1);
					var term3 = TermTransform.newOperation("-",term1,term2);
					if(Reflect.compareMethods(_this1.operation,TermNode.opName)) {
						if(!Reflect.compareMethods(term3.operation,TermNode.opName)) {
							_this1.left = term3.copy();
						} else if(term3.left != null) {
							_this1.left = term3.left.copy();
						} else {
							_this1.left = null;
						}
					} else if(!Reflect.compareMethods(term3.operation,TermNode.opName)) {
						var t2 = term3.copy();
						if(Reflect.compareMethods(t2.operation,TermNode.opValue)) {
							_this1.operation = TermNode.opValue;
							_this1.symbol = null;
							_this1.value = t2.value;
							_this1.left = null;
							_this1.right = null;
						} else if(Reflect.compareMethods(t2.operation,TermNode.opName)) {
							_this1.operation = TermNode.opName;
							_this1.symbol = t2.symbol;
							_this1.left = t2.left;
							_this1.right = null;
						} else if(Reflect.compareMethods(t2.operation,TermNode.opParam)) {
							_this1.operation = TermNode.opParam;
							_this1.symbol = t2.symbol;
							_this1.left = t2.left;
							_this1.right = null;
						} else {
							var s2 = t2.symbol;
							_this1.operation = TermNode.MathOp.h[s2];
							if(_this1.operation != null) {
								_this1.symbol = s2;
								_this1.left = t2.left;
								_this1.right = t2.right;
							} else {
								throw haxe_Exception.thrown("\"" + s2 + "\" is no valid operation.");
							}
						}
					} else if(term3.left != null) {
						var t3 = term3.left.copy();
						if(Reflect.compareMethods(t3.operation,TermNode.opValue)) {
							_this1.operation = TermNode.opValue;
							_this1.symbol = null;
							_this1.value = t3.value;
							_this1.left = null;
							_this1.right = null;
						} else if(Reflect.compareMethods(t3.operation,TermNode.opName)) {
							_this1.operation = TermNode.opName;
							_this1.symbol = t3.symbol;
							_this1.left = t3.left;
							_this1.right = null;
						} else if(Reflect.compareMethods(t3.operation,TermNode.opParam)) {
							_this1.operation = TermNode.opParam;
							_this1.symbol = t3.symbol;
							_this1.left = t3.left;
							_this1.right = null;
						} else {
							var s3 = t3.symbol;
							_this1.operation = TermNode.MathOp.h[s3];
							if(_this1.operation != null) {
								_this1.symbol = s3;
								_this1.left = t3.left;
								_this1.right = t3.right;
							} else {
								throw haxe_Exception.thrown("\"" + s3 + "\" is no valid operation.");
							}
						}
					}
					break;
				} else if(i[i.length - j].symbol == "-" && Reflect.compareMethods(i[i.length - j].left.operation,TermNode.opValue) && i[i.length - j].left.value == 0 && TermTransform.isEqualAfterSimplify(i[i.length - j].right,d)) {
					var _this2 = i[i.length - j].right;
					var term4 = TermTransform.newValue(1);
					if(Reflect.compareMethods(_this2.operation,TermNode.opName)) {
						if(!Reflect.compareMethods(term4.operation,TermNode.opName)) {
							_this2.left = term4.copy();
						} else if(term4.left != null) {
							_this2.left = term4.left.copy();
						} else {
							_this2.left = null;
						}
					} else if(!Reflect.compareMethods(term4.operation,TermNode.opName)) {
						var t4 = term4.copy();
						if(Reflect.compareMethods(t4.operation,TermNode.opValue)) {
							_this2.operation = TermNode.opValue;
							_this2.symbol = null;
							_this2.value = t4.value;
							_this2.left = null;
							_this2.right = null;
						} else if(Reflect.compareMethods(t4.operation,TermNode.opName)) {
							_this2.operation = TermNode.opName;
							_this2.symbol = t4.symbol;
							_this2.left = t4.left;
							_this2.right = null;
						} else if(Reflect.compareMethods(t4.operation,TermNode.opParam)) {
							_this2.operation = TermNode.opParam;
							_this2.symbol = t4.symbol;
							_this2.left = t4.left;
							_this2.right = null;
						} else {
							var s4 = t4.symbol;
							_this2.operation = TermNode.MathOp.h[s4];
							if(_this2.operation != null) {
								_this2.symbol = s4;
								_this2.left = t4.left;
								_this2.right = t4.right;
							} else {
								throw haxe_Exception.thrown("\"" + s4 + "\" is no valid operation.");
							}
						}
					} else if(term4.left != null) {
						var t5 = term4.left.copy();
						if(Reflect.compareMethods(t5.operation,TermNode.opValue)) {
							_this2.operation = TermNode.opValue;
							_this2.symbol = null;
							_this2.value = t5.value;
							_this2.left = null;
							_this2.right = null;
						} else if(Reflect.compareMethods(t5.operation,TermNode.opName)) {
							_this2.operation = TermNode.opName;
							_this2.symbol = t5.symbol;
							_this2.left = t5.left;
							_this2.right = null;
						} else if(Reflect.compareMethods(t5.operation,TermNode.opParam)) {
							_this2.operation = TermNode.opParam;
							_this2.symbol = t5.symbol;
							_this2.left = t5.left;
							_this2.right = null;
						} else {
							var s5 = t5.symbol;
							_this2.operation = TermNode.MathOp.h[s5];
							if(_this2.operation != null) {
								_this2.symbol = s5;
								_this2.left = t5.left;
								_this2.right = t5.right;
							} else {
								throw haxe_Exception.thrown("\"" + s5 + "\" is no valid operation.");
							}
						}
					}
					break;
				}
			}
		} else if(i[0].symbol == "^" && TermTransform.isEqualAfterSimplify(i[0].left,d)) {
			var _this3 = i[0].right;
			var term5 = i[0].right.copy();
			var term6 = TermTransform.newValue(1);
			var term7 = TermTransform.newOperation("-",term5,term6);
			if(Reflect.compareMethods(_this3.operation,TermNode.opName)) {
				if(!Reflect.compareMethods(term7.operation,TermNode.opName)) {
					_this3.left = term7.copy();
				} else if(term7.left != null) {
					_this3.left = term7.left.copy();
				} else {
					_this3.left = null;
				}
			} else if(!Reflect.compareMethods(term7.operation,TermNode.opName)) {
				var t6 = term7.copy();
				if(Reflect.compareMethods(t6.operation,TermNode.opValue)) {
					_this3.operation = TermNode.opValue;
					_this3.symbol = null;
					_this3.value = t6.value;
					_this3.left = null;
					_this3.right = null;
				} else if(Reflect.compareMethods(t6.operation,TermNode.opName)) {
					_this3.operation = TermNode.opName;
					_this3.symbol = t6.symbol;
					_this3.left = t6.left;
					_this3.right = null;
				} else if(Reflect.compareMethods(t6.operation,TermNode.opParam)) {
					_this3.operation = TermNode.opParam;
					_this3.symbol = t6.symbol;
					_this3.left = t6.left;
					_this3.right = null;
				} else {
					var s6 = t6.symbol;
					_this3.operation = TermNode.MathOp.h[s6];
					if(_this3.operation != null) {
						_this3.symbol = s6;
						_this3.left = t6.left;
						_this3.right = t6.right;
					} else {
						throw haxe_Exception.thrown("\"" + s6 + "\" is no valid operation.");
					}
				}
			} else if(term7.left != null) {
				var t7 = term7.left.copy();
				if(Reflect.compareMethods(t7.operation,TermNode.opValue)) {
					_this3.operation = TermNode.opValue;
					_this3.symbol = null;
					_this3.value = t7.value;
					_this3.left = null;
					_this3.right = null;
				} else if(Reflect.compareMethods(t7.operation,TermNode.opName)) {
					_this3.operation = TermNode.opName;
					_this3.symbol = t7.symbol;
					_this3.left = t7.left;
					_this3.right = null;
				} else if(Reflect.compareMethods(t7.operation,TermNode.opParam)) {
					_this3.operation = TermNode.opParam;
					_this3.symbol = t7.symbol;
					_this3.left = t7.left;
					_this3.right = null;
				} else {
					var s7 = t7.symbol;
					_this3.operation = TermNode.MathOp.h[s7];
					if(_this3.operation != null) {
						_this3.symbol = s7;
						_this3.left = t7.left;
						_this3.right = t7.right;
					} else {
						throw haxe_Exception.thrown("\"" + s7 + "\" is no valid operation.");
					}
				}
			}
		} else {
			var _this4 = i[0];
			var term8 = TermTransform.newValue(1);
			if(Reflect.compareMethods(_this4.operation,TermNode.opName)) {
				if(!Reflect.compareMethods(term8.operation,TermNode.opName)) {
					_this4.left = term8.copy();
				} else if(term8.left != null) {
					_this4.left = term8.left.copy();
				} else {
					_this4.left = null;
				}
			} else if(!Reflect.compareMethods(term8.operation,TermNode.opName)) {
				var t8 = term8.copy();
				if(Reflect.compareMethods(t8.operation,TermNode.opValue)) {
					_this4.operation = TermNode.opValue;
					_this4.symbol = null;
					_this4.value = t8.value;
					_this4.left = null;
					_this4.right = null;
				} else if(Reflect.compareMethods(t8.operation,TermNode.opName)) {
					_this4.operation = TermNode.opName;
					_this4.symbol = t8.symbol;
					_this4.left = t8.left;
					_this4.right = null;
				} else if(Reflect.compareMethods(t8.operation,TermNode.opParam)) {
					_this4.operation = TermNode.opParam;
					_this4.symbol = t8.symbol;
					_this4.left = t8.left;
					_this4.right = null;
				} else {
					var s8 = t8.symbol;
					_this4.operation = TermNode.MathOp.h[s8];
					if(_this4.operation != null) {
						_this4.symbol = s8;
						_this4.left = t8.left;
						_this4.right = t8.right;
					} else {
						throw haxe_Exception.thrown("\"" + s8 + "\" is no valid operation.");
					}
				}
			} else if(term8.left != null) {
				var t9 = term8.left.copy();
				if(Reflect.compareMethods(t9.operation,TermNode.opValue)) {
					_this4.operation = TermNode.opValue;
					_this4.symbol = null;
					_this4.value = t9.value;
					_this4.left = null;
					_this4.right = null;
				} else if(Reflect.compareMethods(t9.operation,TermNode.opName)) {
					_this4.operation = TermNode.opName;
					_this4.symbol = t9.symbol;
					_this4.left = t9.left;
					_this4.right = null;
				} else if(Reflect.compareMethods(t9.operation,TermNode.opParam)) {
					_this4.operation = TermNode.opParam;
					_this4.symbol = t9.symbol;
					_this4.left = t9.left;
					_this4.right = null;
				} else {
					var s9 = t9.symbol;
					_this4.operation = TermNode.MathOp.h[s9];
					if(_this4.operation != null) {
						_this4.symbol = s9;
						_this4.left = t9.left;
						_this4.right = t9.right;
					} else {
						throw haxe_Exception.thrown("\"" + s9 + "\" is no valid operation.");
					}
				}
			}
		}
	}
};
TermTransform.formsort_compare = function(t1,t2) {
	if(TermTransform.formsort_priority(t1) > TermTransform.formsort_priority(t2)) {
		return -1;
	} else if(TermTransform.formsort_priority(t1) < TermTransform.formsort_priority(t2)) {
		return 1;
	} else if(Reflect.compareMethods(t1.operation,TermNode.opValue) && Reflect.compareMethods(t2.operation,TermNode.opValue)) {
		if(t1.value >= t2.value) {
			return -1;
		} else {
			return 1;
		}
	} else if(!(Reflect.compareMethods(t1.operation,TermNode.opName) || Reflect.compareMethods(t1.operation,TermNode.opParam) || Reflect.compareMethods(t1.operation,TermNode.opValue)) && !(Reflect.compareMethods(t2.operation,TermNode.opName) || Reflect.compareMethods(t2.operation,TermNode.opParam) || Reflect.compareMethods(t2.operation,TermNode.opValue))) {
		if(t1.right != null && t2.right != null) {
			return TermTransform.formsort_compare(t1.right,t2.right);
		} else {
			return TermTransform.formsort_compare(t1.left,t2.left);
		}
	} else {
		return 0;
	}
};
TermTransform.formsort_priority = function(t) {
	var _g = t.symbol;
	var s = _g;
	if(Reflect.compareMethods(t.operation,TermNode.opParam)) {
		return HxOverrides.cca(t.symbol,0);
	} else {
		var s = _g;
		if(Reflect.compareMethods(t.operation,TermNode.opName)) {
			return HxOverrides.cca(t.symbol,0);
		} else {
			var s = _g;
			if(Reflect.compareMethods(t.operation,TermNode.opValue)) {
				return 1 + 0.00001 * t.value;
			} else {
				var s = _g;
				if(TermNode.twoSideOpRegFull.match(s)) {
					if(t.symbol == "-" && t.left.value == 0) {
						return TermTransform.formsort_priority(t.right);
					} else {
						return TermTransform.formsort_priority(t.left) + TermTransform.formsort_priority(t.right) * 0.001;
					}
				} else {
					var s = _g;
					if(TermNode.oneParamOpRegFull.match(s)) {
						return -5 - TermNode.oneParamOp.indexOf(s);
					} else {
						var s = _g;
						if(TermNode.twoParamOpRegFull.match(s)) {
							return -5 - TermNode.oneParamOp.length - TermNode.twoParamOp.indexOf(s);
						} else {
							var s = _g;
							if(TermNode.constantOpRegFull.match(s)) {
								return -5 - TermNode.oneParamOp.length - TermNode.twoParamOp.length - TermNode.constantOp.indexOf(s);
							} else {
								return -5 - TermNode.oneParamOp.length - TermNode.twoParamOp.length - TermNode.constantOp.length;
							}
						}
					}
				}
			}
		}
	}
};
TermTransform.arrangeMultiplication = function(t) {
	var mult = [];
	TermTransform.traverseMultiplication(t,mult);
	mult.sort(TermTransform.formsort_compare);
	TermTransform.traverseMultiplicationBack(t,mult);
};
TermTransform.arrangeAddition = function(t) {
	var addlength_old = -1;
	var add = [];
	TermTransform.traverseAddition(t,add);
	add.sort(TermTransform.formsort_compare);
	while(add.length != addlength_old) {
		addlength_old = add.length;
		var _g = 0;
		var _g1 = add.length - 1;
		while(_g < _g1) {
			var i = _g++;
			if(TermTransform.isEqualAfterSimplify(add[i],add[i + 1])) {
				var _this = add[i];
				var left = add[i].copy();
				var right = TermTransform.newValue(2);
				_this.operation = TermNode.MathOp.h["*"];
				if(_this.operation != null) {
					_this.symbol = "*";
					_this.left = left;
					_this.right = right;
				} else {
					throw haxe_Exception.thrown("\"" + "*" + "\" is no valid operation.");
				}
				var _g2 = 1;
				var _g3 = add.length - i - 1;
				while(_g2 < _g3) {
					var j = _g2++;
					add[i + j] = add[i + j + 1];
				}
				add.pop();
				break;
			}
			if(add[i].symbol == "*" && add[i + 1].symbol == "*" && Reflect.compareMethods(add[i].right.operation,TermNode.opValue) && Reflect.compareMethods(add[i + 1].right.operation,TermNode.opValue) && TermTransform.isEqualAfterSimplify(add[i].left,add[i + 1].left)) {
				var _this1 = add[i].right;
				var f = add[i].right.value + add[i + 1].right.value;
				_this1.operation = TermNode.opValue;
				_this1.symbol = null;
				_this1.value = f;
				_this1.left = null;
				_this1.right = null;
				var _g4 = 1;
				var _g5 = add.length - i - 1;
				while(_g4 < _g5) {
					var j1 = _g4++;
					add[i + j1] = add[i + j1 + 1];
				}
				add.pop();
				break;
			}
			if(Reflect.compareMethods(add[i].operation,TermNode.opValue) && Reflect.compareMethods(add[i + 1].operation,TermNode.opValue)) {
				var _this2 = add[i];
				var f1 = add[i].value + add[i + 1].value;
				_this2.operation = TermNode.opValue;
				_this2.symbol = null;
				_this2.value = f1;
				_this2.left = null;
				_this2.right = null;
				var _g6 = 1;
				var _g7 = add.length - i - 1;
				while(_g6 < _g7) {
					var j2 = _g6++;
					add[i + j2] = add[i + j2 + 1];
				}
				add.pop();
				break;
			}
			if(add[i].symbol == "-" && Reflect.compareMethods(add[i].left.operation,TermNode.opValue) && add[i].left.value == 0 && TermTransform.isEqualAfterSimplify(add[i].right,add[i + 1]) || add[i + 1].symbol == "-" && Reflect.compareMethods(add[i + 1].left.operation,TermNode.opValue) && add[i + 1].left.value == 0 && TermTransform.isEqualAfterSimplify(add[i + 1].right,add[i])) {
				var _g8 = 0;
				var _g9 = add.length - i - 2;
				while(_g8 < _g9) {
					var j3 = _g8++;
					add[i + j3] = add[i + j3 + 2];
				}
				add.pop();
				add.pop();
				if(add.length == 0) {
					add.push(TermTransform.newValue(0));
				}
				break;
			}
		}
		if(add[0].symbol == "-" && add[0].left.value == 0) {
			var _g10 = 0;
			while(_g10 < add.length) {
				var i1 = add[_g10];
				++_g10;
				if(i1.symbol == "-" && i1.left.value == 0) {
					var term = i1.right;
					if(Reflect.compareMethods(i1.operation,TermNode.opName)) {
						if(!Reflect.compareMethods(term.operation,TermNode.opName)) {
							i1.left = term.copy();
						} else if(term.left != null) {
							i1.left = term.left.copy();
						} else {
							i1.left = null;
						}
					} else if(!Reflect.compareMethods(term.operation,TermNode.opName)) {
						var t1 = term.copy();
						if(Reflect.compareMethods(t1.operation,TermNode.opValue)) {
							i1.operation = TermNode.opValue;
							i1.symbol = null;
							i1.value = t1.value;
							i1.left = null;
							i1.right = null;
						} else if(Reflect.compareMethods(t1.operation,TermNode.opName)) {
							i1.operation = TermNode.opName;
							i1.symbol = t1.symbol;
							i1.left = t1.left;
							i1.right = null;
						} else if(Reflect.compareMethods(t1.operation,TermNode.opParam)) {
							i1.operation = TermNode.opParam;
							i1.symbol = t1.symbol;
							i1.left = t1.left;
							i1.right = null;
						} else {
							var s = t1.symbol;
							i1.operation = TermNode.MathOp.h[s];
							if(i1.operation != null) {
								i1.symbol = s;
								i1.left = t1.left;
								i1.right = t1.right;
							} else {
								throw haxe_Exception.thrown("\"" + s + "\" is no valid operation.");
							}
						}
					} else if(term.left != null) {
						var t2 = term.left.copy();
						if(Reflect.compareMethods(t2.operation,TermNode.opValue)) {
							i1.operation = TermNode.opValue;
							i1.symbol = null;
							i1.value = t2.value;
							i1.left = null;
							i1.right = null;
						} else if(Reflect.compareMethods(t2.operation,TermNode.opName)) {
							i1.operation = TermNode.opName;
							i1.symbol = t2.symbol;
							i1.left = t2.left;
							i1.right = null;
						} else if(Reflect.compareMethods(t2.operation,TermNode.opParam)) {
							i1.operation = TermNode.opParam;
							i1.symbol = t2.symbol;
							i1.left = t2.left;
							i1.right = null;
						} else {
							var s1 = t2.symbol;
							i1.operation = TermNode.MathOp.h[s1];
							if(i1.operation != null) {
								i1.symbol = s1;
								i1.left = t2.left;
								i1.right = t2.right;
							} else {
								throw haxe_Exception.thrown("\"" + s1 + "\" is no valid operation.");
							}
						}
					}
				} else {
					var left1 = TermTransform.newValue(0);
					var right1 = i1.copy();
					i1.operation = TermNode.MathOp.h["-"];
					if(i1.operation != null) {
						i1.symbol = "-";
						i1.left = left1;
						i1.right = right1;
					} else {
						throw haxe_Exception.thrown("\"" + "-" + "\" is no valid operation.");
					}
				}
			}
			var left2 = TermTransform.newValue(0);
			var right2 = new TermNode();
			t.operation = TermNode.MathOp.h["-"];
			if(t.operation != null) {
				t.symbol = "-";
				t.left = left2;
				t.right = right2;
			} else {
				throw haxe_Exception.thrown("\"" + "-" + "\" is no valid operation.");
			}
			TermTransform.traverseAdditionBack(t.right,add);
			return;
		}
	}
	TermTransform.traverseAdditionBack(t,add);
};
var TextTools = function() { };
TextTools.__name__ = true;
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
	__class__: haxe_ValueException
});
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
haxe_ds_StringMap.__name__ = true;
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
	case "Any":case "Dynamic":
		tmp = "Everything";
		break;
	case "Float":
		tmp = "Decimal";
		break;
	case "Int":
		tmp = "Number";
		break;
	case "String":
		tmp = "Characters";
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
little_Runtime.safeThrow = function(exception) {
	little_Runtime.exceptionStack.push(exception);
	little_Runtime.print("Error! (from line " + little_Runtime.get_currentLine() + "):\n\t---\n\t" + exception.get_content() + "\n\t---");
};
little_Runtime.print = function(expression) {
	haxe_Log.trace("Line " + little_Runtime.get_currentLine() + ": " + expression,null);
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
var little_exceptions_UnknownDefinition = function(name) {
	this.type = "Unknown Definition";
	this.details = "There isn't any known definition for\n\t\t" + name + "\n\tDid you forget to declare it?";
};
little_exceptions_UnknownDefinition.__name__ = true;
little_exceptions_UnknownDefinition.prototype = {
	get_content: function() {
		return "" + this.type + ": " + this.details;
	}
	,__class__: little_exceptions_UnknownDefinition
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
	value = little_interpreter_features_Evaluator.simplifyEquation(value);
	var numberDetector = new EReg("([0-9\\.]+)","");
	var booleanDetector = new EReg("(true|false)","");
	if(numberDetector.match(value)) {
		return numberDetector.matched(1);
	} else if(TextTools.indexesOf(value,"\"").length == 2) {
		return value;
	} else if(booleanDetector.match(value)) {
		return booleanDetector.matched(1);
	} else if(little_interpreter_Memory.hasLoadedVar(value)) {
		return little_interpreter_Memory.getLoadedVar(value).toString();
	}
	return "Nothing";
};
little_interpreter_features_Evaluator.simplifyEquation = function(expression) {
	if(expression.indexOf("\"") != -1) {
		return expression;
	} else if(little_interpreter_Memory.hasLoadedVar(expression)) {
		return little_interpreter_Memory.getLoadedVar(expression).get_basicValue();
	}
	expression = StringTools.replace(StringTools.replace(StringTools.replace(StringTools.replace(StringTools.replace(StringTools.replace(expression,"+"," + "),"-"," - "),"*"," * "),"/"," / "),"("," ( "),")"," ) ");
	var tempExpression = expression;
	var variableDetector = new EReg("([a-zA-Z_]+)","");
	var f = Formula.fromString(tempExpression);
	while(variableDetector.match(tempExpression)) {
		var variable = variableDetector.matched(1);
		if(little_interpreter_Memory.hasLoadedVar(variable)) {
			Formula.bind(f,Formula.fromString(little_interpreter_Memory.getLoadedVar(variable).get_basicValue()),variable);
			var pos = variableDetector.matchedPos();
			tempExpression = tempExpression.substring(pos.pos + pos.len);
		} else {
			little_Runtime.safeThrow(new little_exceptions_UnknownDefinition(variable));
			return expression;
		}
	}
	var _this = f.simplify();
	var res = _this.operation(_this);
	return res + "";
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
		return "Characters";
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
TermNode.MathOp = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	_g.h["+"] = function(t) {
		var _this = t.left;
		var tmp = _this.operation(_this);
		var _this = t.right;
		return tmp + _this.operation(_this);
	};
	_g.h["-"] = function(t) {
		var _this = t.left;
		var tmp = _this.operation(_this);
		var _this = t.right;
		return tmp - _this.operation(_this);
	};
	_g.h["*"] = function(t) {
		var _this = t.left;
		var tmp = _this.operation(_this);
		var _this = t.right;
		return tmp * _this.operation(_this);
	};
	_g.h["/"] = function(t) {
		var _this = t.left;
		var tmp = _this.operation(_this);
		var _this = t.right;
		return tmp / _this.operation(_this);
	};
	_g.h["^"] = function(t) {
		var _this = t.left;
		var tmp = _this.operation(_this);
		var _this = t.right;
		return Math.pow(tmp,_this.operation(_this));
	};
	_g.h["%"] = function(t) {
		var _this = t.left;
		var tmp = _this.operation(_this);
		var _this = t.right;
		return tmp % _this.operation(_this);
	};
	_g.h["e"] = function(t) {
		return Math.exp(1);
	};
	_g.h["pi"] = function(t) {
		return Math.PI;
	};
	_g.h["abs"] = function(t) {
		var _this = t.left;
		return Math.abs(_this.operation(_this));
	};
	_g.h["ln"] = function(t) {
		var _this = t.left;
		return Math.log(_this.operation(_this));
	};
	_g.h["sin"] = function(t) {
		var _this = t.left;
		return Math.sin(_this.operation(_this));
	};
	_g.h["cos"] = function(t) {
		var _this = t.left;
		return Math.cos(_this.operation(_this));
	};
	_g.h["tan"] = function(t) {
		var _this = t.left;
		return Math.tan(_this.operation(_this));
	};
	_g.h["cot"] = function(t) {
		var _this = t.left;
		return 1 / Math.tan(_this.operation(_this));
	};
	_g.h["asin"] = function(t) {
		var _this = t.left;
		return Math.asin(_this.operation(_this));
	};
	_g.h["acos"] = function(t) {
		var _this = t.left;
		return Math.acos(_this.operation(_this));
	};
	_g.h["atan"] = function(t) {
		var _this = t.left;
		return Math.atan(_this.operation(_this));
	};
	_g.h["atan2"] = function(t) {
		var _this = t.left;
		var tmp = _this.operation(_this);
		var _this = t.right;
		return Math.atan2(tmp,_this.operation(_this));
	};
	_g.h["log"] = function(t) {
		var _this = t.right;
		var tmp = Math.log(_this.operation(_this));
		var _this = t.left;
		return tmp / Math.log(_this.operation(_this));
	};
	_g.h["max"] = function(t) {
		var _this = t.left;
		var tmp = _this.operation(_this);
		var _this = t.right;
		return Math.max(tmp,_this.operation(_this));
	};
	_g.h["min"] = function(t) {
		var _this = t.left;
		var tmp = _this.operation(_this);
		var _this = t.right;
		return Math.min(tmp,_this.operation(_this));
	};
	$r = _g;
	return $r;
}(this));
TermNode.twoSideOp_ = "^,/,*,-,+,%";
TermNode.constantOp_ = "e,pi";
TermNode.oneParamOp_ = "abs,ln,sin,cos,tan,cot,asin,acos,atan";
TermNode.twoParamOp_ = "atan2,log,max,min";
TermNode.twoSideOp = TermNode.twoSideOp_.split(",");
TermNode.constantOp = TermNode.constantOp_.split(",");
TermNode.oneParamOp = TermNode.oneParamOp_.split(",");
TermNode.twoParamOp = TermNode.twoParamOp_.split(",");
TermNode.precedence = (function($this) {
	var $r;
	var _g = new haxe_ds_StringMap();
	{
		var _g1 = 0;
		var _g2 = TermNode.twoSideOp.length;
		while(_g1 < _g2) {
			var i = _g1++;
			_g.h[TermNode.twoSideOp[i]] = i;
		}
	}
	$r = _g;
	return $r;
}(this));
TermNode.trailingSpacesReg = new EReg("^(\\s+)","");
TermNode.numberReg = new EReg("^([-+]?\\d+\\.?\\d*)","");
TermNode.paramReg = new EReg("^([a-z]+)","i");
TermNode.constantOpReg = new EReg("^(" + TermNode.constantOp.join("|") + ")\\(\\)","i");
TermNode.oneParamOpReg = new EReg("^(" + TermNode.oneParamOp.join("|") + ")\\(","i");
TermNode.twoParamOpReg = new EReg("^(" + TermNode.twoParamOp.join("|") + ")\\(","i");
TermNode.twoSideOpReg = new EReg("^(" + "\\" + TermNode.twoSideOp.join("|\\") + ")","");
TermNode.constantOpRegFull = new EReg("^(" + TermNode.constantOp.join("|") + ")$","i");
TermNode.oneParamOpRegFull = new EReg("^(" + TermNode.oneParamOp.join("|") + ")$","i");
TermNode.twoParamOpRegFull = new EReg("^(" + TermNode.twoParamOp.join("|") + ")$","i");
TermNode.twoSideOpRegFull = new EReg("^(" + "\\" + TermNode.twoSideOp.join("|\\") + ")$","");
TermNode.nameReg = new EReg("^([a-z]+)(\\s*[:=]\\s*)","i");
TermNode.nameRegFull = new EReg("^([a-z]+)$","i");
TermNode.signReg = new EReg("^([-+\\s]+)","i");
TermTransform.newOperation = TermNode.newOperation;
TermTransform.newValue = TermNode.newValue;
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