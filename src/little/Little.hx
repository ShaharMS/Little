package little;

@:expose
@:native("Little")
class Little {
    
    public static var interpreter = Interpreter;

    public static var runtime:Class<Runtime> = Runtime;

    public static var transpiler:Class<Transpiler> = Transpiler;
}