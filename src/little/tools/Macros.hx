package little.tools;

import haxe.macro.Context;
import haxe.macro.ExprTools;
import haxe.macro.Expr;

class Macros {

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
}