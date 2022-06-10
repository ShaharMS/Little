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
HxOverrides.now = function() {
	return Date.now();
};
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	little_interpreter_features_Evaluator.calculateStringAddition("\"hey\" + \"heythere\" + \"hello\"");
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
	,__class__: TermNode
};
var TextTools = function() { };
TextTools.__name__ = true;
TextTools.replaceLast = function(string,replace,by) {
	var place = string.lastIndexOf(replace);
	var result = string.substring(0,place) + by + string.substring(place + replace.length);
	return result;
};
TextTools.replacefirst = function(string,replace,by) {
	var place = string.indexOf(replace);
	var result = string.substring(0,place) + by + string.substring(place + replace.length);
	return result;
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
TextTools.contains = function(string,contains) {
	return string.indexOf(contains) != -1;
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
	v.scope = { scope : little_interpreter_constraints_VariableScope.GLOBAL, info : "Registered externally", initializationLine : 0};
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
		var lv = little_interpreter_Lexer.detectVariables(l);
		if(lv != null) {
			little_interpreter_Memory.safePush(lv);
		}
		little_interpreter_features_Assignment.assign(l);
		little_interpreter_Lexer.detectPrint(l);
		LittleInterpreter.currentLine++;
	}
};
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
var little_interpreter_Lexer = function() { };
little_interpreter_Lexer.__name__ = true;
little_interpreter_Lexer.detectVariables = function(line) {
	var v = new little_interpreter_features_LittleVariable();
	line = " " + StringTools.trim(line);
	if(!TextTools.contains(line," define ")) {
		return null;
	}
	var defParts = line.split(" define ");
	var parts = defParts[1].split("=");
	v.scope.initializationLine = LittleInterpreter.currentLine;
	if(TextTools.contains(parts[0],":")) {
		var type = StringTools.replace(parts[0].split(":")[1]," ","");
		var name = StringTools.replace(parts[0].split(":")[0]," ","");
		if(type == "") {
			little_Runtime.safeThrow(new little_exceptions_MissingTypeDeclaration(name));
			return null;
		}
		v.name = name;
		v.type = type;
	}
	if(!TextTools.contains(parts[0],":")) {
		v.name = StringTools.replace(parts[0]," ","");
		v.type = "Everything";
	}
	return v;
};
little_interpreter_Lexer.detectPrint = function(line) {
	if(!TextTools.contains(line,"print(") && !StringTools.endsWith(line,")")) {
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
	if(little_interpreter_Memory.variableMemory.h[variableName] != null) {
		return little_interpreter_Memory.variableMemory.h[variableName];
	} else {
		return null;
	}
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
var little_interpreter_features_Assignment = function() { };
little_interpreter_features_Assignment.__name__ = true;
little_interpreter_features_Assignment.assign = function(statement) {
	var assignmentSplit = statement.split("=");
	if(assignmentSplit.length == 1) {
		return;
	}
	if(assignmentSplit[2] == "") {
		little_Runtime.safeThrow(new little_exceptions_Typo("When assigning a value to a definition, you need to fill out the value after the = sign."));
		return;
	}
	var variableOperand = assignmentSplit[0];
	var valueOperand = StringTools.trim(assignmentSplit[1]);
	variableOperand = StringTools.replace(variableOperand,"define ","");
	if(variableOperand.indexOf(":") != -1) {
		var _this_r = new RegExp(":[a-zA-Z_]+","".split("u").join(""));
		variableOperand = variableOperand.replace(_this_r,"");
	}
	variableOperand = StringTools.replace(variableOperand," ","");
	valueOperand = little_interpreter_features_Evaluator.getValueOf(valueOperand);
	var variable = little_interpreter_Memory.getLoadedVar(variableOperand);
	if(variable == null) {
		little_Runtime.safeThrow(new little_exceptions_UnknownDefinition(variableOperand));
	}
	if((variable.type == null || variable.type == "Everything") && LittleInterpreter.currentLine == variable.scope.initializationLine) {
		variable.type = little_interpreter_features_Typer.getValueType(valueOperand);
	}
	if(little_interpreter_features_Typer.getValueType(valueOperand) != variable.type) {
		little_Runtime.safeThrow(new little_exceptions_DefinitionTypeMismatch(variableOperand,variable.type,little_interpreter_features_Typer.getValueType(valueOperand)));
	}
	variable.set_basicValue(valueOperand);
};
var little_interpreter_features_Evaluator = function() { };
little_interpreter_features_Evaluator.__name__ = true;
little_interpreter_features_Evaluator.getValueOf = function(value) {
	value = little_interpreter_features_Evaluator.simplifyEquation(value);
	var numberDetector = new EReg("([0-9\\.]+)","");
	var booleanDetector = new EReg("(true|false)","");
	if(numberDetector.match(value)) {
		return numberDetector.matched(1);
	} else if(TextTools.indexesOf(value,"\"").length >= 2) {
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
		return little_interpreter_features_Evaluator.calculateStringMath(expression);
	}
	if(StringTools.trim(expression) == "false" || StringTools.trim(expression) == "true") {
		return StringTools.trim(expression);
	}
	if(little_interpreter_Memory.hasLoadedVar(expression)) {
		return little_interpreter_Memory.getLoadedVar(expression).get_basicValue();
	}
	expression = StringTools.replace(StringTools.replace(StringTools.replace(StringTools.replace(StringTools.replace(StringTools.replace(expression,"+"," + "),"-"," - "),"*"," * "),"/"," / "),"("," ( "),")"," ) ");
	var tempExpression = expression;
	var variableDetector = new EReg("([a-zA-Z_]+)","");
	var f = Formula.fromString(tempExpression);
	while(variableDetector.match(tempExpression)) {
		var variable = variableDetector.matched(1);
		if(little_interpreter_Memory.hasLoadedVar(variable)) {
			var value = little_interpreter_Memory.getLoadedVar(variable).get_basicValue();
			if(new EReg("[^0-9\\.]+","").match(value)) {
				little_Runtime.safeThrow(new little_exceptions_DefinitionTypeMismatch(variable,"Number","e"));
			}
			Formula.bind(f,Formula.fromString(value),variable);
			var pos = variableDetector.matchedPos();
			tempExpression = tempExpression.substring(pos.pos + pos.len);
		} else {
			little_Runtime.safeThrow(new little_exceptions_UnknownDefinition(variable));
			return expression;
		}
	}
	var res = f.operation(f);
	return res + "";
};
little_interpreter_features_Evaluator.calculateStringAddition = function(expression,currentNode) {
	if(currentNode == null) {
		currentNode = { };
	}
	if(expression.indexOf("+") != -1) {
		var additionSplit = expression.split("+");
		var leftString = StringTools.trim(additionSplit[0]);
		currentNode.left = { };
		currentNode.left.value = leftString;
		currentNode.sign = "+";
		additionSplit.shift();
		currentNode.right = { };
		little_interpreter_features_Evaluator.calculateStringAddition(additionSplit.join("+"),currentNode.right);
	} else if(expression.indexOf("\"") != -1) {
		currentNode.left = { };
		currentNode.left.value = expression;
	}
	return currentNode;
};
little_interpreter_features_Evaluator.calculateStringMath = function(expression) {
	var result = "";
	var ast = little_interpreter_features_Evaluator.calculateStringAddition(expression);
	if(ast.right == null) {
		return expression;
	}
	while(ast.left != null) {
		var left = ast.left;
		var right = ast.right;
		if(ast.right == null && ast.sign == null || StringTools.replace(ast.sign," ","") == "+") {
			var addition = TextTools.replaceLast(TextTools.replacefirst(left.value,"\"",""),"\"","");
			if(left.value == addition) {
				try {
					addition = TextTools.replaceLast(TextTools.replacefirst(Std.string(little_interpreter_Memory.getLoadedVar(left.value).get_basicValue()),"\"",""),"\"","");
				} catch( _g ) {
					little_Runtime.safeThrow(new little_exceptions_UnknownDefinition(left.value));
					return result;
				}
			}
			result += addition;
		}
		ast = ast.right;
		if(ast == null) {
			return "\"" + result + "\"";
		}
	}
	return "\"" + result + "\"";
};
var little_interpreter_features_LittleVariable = function() {
	this.scope = { };
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
	var booleanDetector = new EReg("true|false","");
	value = little_interpreter_features_Evaluator.getValueOf(value);
	if(instanceDetector.match(value)) {
		return instanceDetector.matched(1);
	} else if(numberDetector.match(value)) {
		if(value.indexOf(".") != -1) {
			return "Decimal";
		} else {
			return "Number";
		}
	} else if(value.indexOf("\"") != -1) {
		return "Characters";
	} else if(booleanDetector.match(value)) {
		return "Boolean";
	} else if(value.indexOf(".") != -1) {
		var object = value.substring(0,value.indexOf("."));
		value = value.substring(value.indexOf(".") + 1);
		if(value == "") {
			little_Runtime.safeThrow(new little_exceptions_Typo("While trying to access a definition inside " + object + ", you didn't specify a property name (the property name is the part after the dot)."));
		}
	} else {
		return little_interpreter_features_Typer.getValueType(little_interpreter_Memory.getLoadedVar(value).get_basicValue());
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
TermNode.twoParamOpRegFull = new EReg("^(" + TermNode.twoParamOp.join("|") + ")$","i");
TermNode.twoSideOpRegFull = new EReg("^(" + "\\" + TermNode.twoSideOp.join("|\\") + ")$","");
TermNode.nameReg = new EReg("^([a-z]+)(\\s*[:=]\\s*)","i");
TermNode.nameRegFull = new EReg("^([a-z]+)$","i");
TermNode.signReg = new EReg("^([-+\\s]+)","i");
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