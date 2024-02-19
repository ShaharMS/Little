package js_example;

class JsMacro {
    
    public macro static function getBuildTime(){
		var s = Date.now().toString();
		return macro($v{s} : String);
	}
	
	public macro static function getBuildCount() {
		if (!sys.FileSystem.exists("build-count.txt")) {
			var output = sys.io.File.write("build-count.txt", false);
			output.writeString("0");
			output.close();
		}
		var s = sys.io.File.getContent("build-count.txt");
		return macro($v{s} : String);
	} 
	
	public macro static function increaseBuildCounter() {
		if (!sys.FileSystem.exists("build-count.txt")) {
			var output = sys.io.File.write("build-count.txt", false);
			output.writeString("0");
			output.close();
		}
		var prev = Std.parseInt(sys.io.File.getContent("build-count.txt")) ?? 0;
		var output = sys.io.File.write("build-count.txt", false);
		output.writeString("" + (prev + 1));
		output.close();
		
		return macro null;
	} 
}