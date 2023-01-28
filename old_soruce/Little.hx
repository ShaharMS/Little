package little;

@:expose
@:native("Little")
class Little {
    
    public static var interpreter = Interpreter;

    public static var runtime = Runtime;

    public static var transpiler = Transpiler;
}