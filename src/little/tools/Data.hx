package little.tools;

import haxe.macro.Type.TypedExprDef;
import haxe.Json;
import haxe.macro.Context;
import haxe.macro.ExprTools;
import haxe.macro.Expr;

class Data {

    public static macro function inspectFunction(expr:Expr) {
		switch (expr.expr) {
			case EFunction(kind, f):
				{
					return macro {
						returnType: $v{Std.string(f.ret)},
						parameters: $a{
							f.args.map(param -> macro {
								name: $v{param.name},
								type: $v{Std.string(param.type)},
								optional: $v{param.opt}
							})
						},
						typeParams: $a{
							f.params.map(param -> macro {name: $v{param.name}})
						}
					}
				}
			case _:
		}

		return macro null;
	}

	public static macro function getClassInfo(e) {
		var stats:Array<haxe.macro.Expr> = [];

		function getTypeString(t:haxe.macro.Type):String {
			return switch t {
				case TMono(t): getTypeString(t.get());
				case TEnum(t, params): t.get().name + '${if (params.length != 0) "<" else ""}' + params.map(a -> getTypeString(a)).join(",") + '${if (params.length != 0) ">" else ""}';
				case TInst(t, params): t.get().name + '${if (params.length != 0) "<" else ""}' + params.map(a -> getTypeString(a)).join(",") + '${if (params.length != 0) ">" else ""}';
				case TType(t, params): t.get().name + '${if (params.length != 0) "<" else ""}' + params.map(a -> getTypeString(a)).join(",") + '${if (params.length != 0) ">" else ""}';
				case TFun(args, ret): args.map(a -> getTypeString(a.t)).join("->") + "->" + getTypeString(ret);
				case TAnonymous(a): Json.stringify(a);
				case TDynamic(t): "Dynamic";
				case TLazy(f): getTypeString(f());
				case TAbstract(t, params): t.get().name + '${if (params.length != 0) "<" else ""}' + params.map(a -> getTypeString(a)).join(",") + '${if (params.length != 0) ">" else ""}';
				case _: "Dynamic";
			}
		}

		function getWriteAccess(k:haxe.macro.Type.FieldKind) {
			return switch k {
				case FVar(read, write): {
					switch write {
						case AccNormal: true;
						case AccNo: false;
						case AccNever: false;
						case AccResolve: false;
						case AccCall: true;
						case AccInline: true;
						case AccRequire(r, msg): false;
						case AccCtor: false;
					}
				}
				case FMethod(k): {
					false;
				}
			}
		}

		switch e.expr {
			case EConst(CString(path)):
				var t:haxe.macro.Type;
				try {
					t = haxe.macro.Context.getType(path);
				} catch (_) {
					haxe.macro.Context.error(path + ' Is not a class. Did you misspell the type/package?', e.pos);
				}
				switch t {
					case TInst(inst, _): {
						var statics = inst.get().statics.get();
						for (field in statics) {
							var type = field.type;
							switch type {
								case TFun(args, ret): {
									stats.push(macro {
										className: $v{path},
										name: $v{field.name},
										parameters: $a{
											args.map(param -> macro {
												name: $v{param.name},
												type: $v{getTypeString(param.t)},
												optional: $v{param.opt}
											})
										},
										returnType: $v{getTypeString(ret)},
										fieldType: "function",
										allowWrite: $v{getWriteAccess(field.kind)}
									});
								}
								case _: {
									stats.push(macro {
										className: $v{path},
										name: $v{field.name},
										fieldType: "var",
										parameters: [],
										returnType: $v{getTypeString(field.type)},
										allowWrite: $v{getWriteAccess(field.kind)}
									});
								}
							}
						}
						return macro ($a{stats} : Array<{className:String, name:String, parameters:Array<{name:String, type:String, optional:Bool}>, returnType:String, fieldType:String, allowWrite:Bool}>);
					}
						// var statics = inst.get().statics.get();
						// return macro $v{statics.map(s -> s.name)};
					case _: haxe.macro.Context.error(e + 'Is not a class. Did you misspell the type/package?', e.pos);
				}
			case _:
				haxe.macro.Context.error('Expected string constant, found ${e.expr} instead', e.pos);
		}
		return macro null;
	}
}