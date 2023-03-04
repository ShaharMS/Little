package little.expressions;

enum ExpTokens {
	Variable(value:String);
	Value(value:String);
	Characters(value:String);
	Sign(value:String);
	Call(value:String, content:Array<ExpTokens>);
	Closure(content:Array<ExpTokens>);
}