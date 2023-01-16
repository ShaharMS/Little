# Little

### What is it?

**Little** is a simple programming language that can be used to teach children how to program.

Because of the minimal and simple nature of this language, you don't have to write it's source code specifically in English.

The language itself is cross-platform, as it can compile to haxe. it also bundles its own interpreter.

### Why does that exist?

Other than teaching, the language has a lot of benefits, some I already mentioned before:

 - cross platform
 - small bundle size
 - fast interpreter
 - Multilingual coding
 - interfaces with external H⁹axe code (Haxe transpiler only)
 - makes it easy to implement code interfacing in games
 - Understandable errors that actually explain what went wrong and where
 - easy and accurate access to runtime details & definition values

## Syntax

The language is very minimal by design, and only has a couple of reserved words:

 - **`define`** - used for defining Definitions.
 - **`action`** - used for defining functions.
 - **`new`** - used for instances.
 - **`return`** used for returning action values.
 - **`nothing`** - the language is always type safe by default, but this can be used to explicitly make a definition throw an error when accessed.
 - **`hide`** - disables access from outside that instance file
 - **`className: `** - specifically with a `:\s` at the end (a definition named `className` is valid), used to declare a class in a file. a file can contain several classes, seperated by declaring a new class
 - **`external: `** - specifically with a `:\s` at the end (a definition named `external` is valid), used for defining external classes, actions or definitions that do not exist in the language, but do exist in haxe code.

The resereved word's translation might change a bit between different languages to make programming more intuitive. for example, new (חדש) will be changed to create (צור) in hebrew to keep the same structure of: `(instantiator word) (classname)`

Examples:

```
define x = 5
define z of type Number = 10
define y = new ImprovedNumber(5)
y.increment(4)
print(y)
define fileWriter = File.write("idk.txt")
fileWriter.writeString("Yay Haxe")
fileWriter.close();

for name from 0 to 9 every 2 {
    print(i)
}
```

(When transpiled to Haxe)

```haxe
public static function main()
{
    var x:Int = 5;
    var z:Int = 10;
    var y:ImprovedNumber = new ImprovedNumber(5);
    y.increment(4);
    trace(y);
    var fileWriter = File.write("idk.txt")
    fileWriter.writeString("Yay Haxe")
    fileWriter.close();

    var name:Int = 0;
    while (name < 9) {
        trace(name);
        name += 2;
    }
}

class ImprovedNumber
{
    public var baseNumber:Int = 0;

    public function new(nmber:Int) 
    {
        baseNumber = number;
    }

    public function increment(x:Int) 
    {
        return baseNumber += x;
    }

    function dispose() {}
}

class AnotherClass {}
```
