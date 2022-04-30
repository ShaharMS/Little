# Little

### What is it?

Little is a simple programming language that can be used to teach children how to program.

Because of the minimal and simple nature of this language, you don't have to write it's source code specifically in English, and it can also be used in games that need a coding interface with fast execution

The language itself is cross-platform, as it can compile to haxe. it also bundles its own interpreter.

## Syntax

The language is very minimal by design, and only has a couple of reserved words:

 - **`define`** - used for defining variables.
 - **`action`** - used for defining functions.
 - **`new`** - used for instances.
 - **`return`** used for returning action values.
 - **`nothing`** - the language is always type safe by default, but this can be used to explicitly make a definition throw an error when accessed.
 - **`hide`** - disables access from outside that instance file
 - **`className: `** - specifically with a `:\s` at the end (a definition named `className` is valid), used to declare a class in a file. a file can contain several classes, seperated by declaring a new class

The resereved word's translation might change a bit between different languages to make programming more intuitive. for example, new (חדש) will be changed to create (צור) in hebrew to keep the same structure of: `(instantiator word) (classname)`

Examples:

```
define x = 5
define z:Number = 10
define y = new ImprovedNumber(5)
y.increment(4)
print(y)

//also supports classes:

className: ImprovedNumber

    define baseNumber:Number

    action new(number:Number) = {
        baseNumber = number
    }

    //write comments with a double /!
    // + types for actions are automatically inferred
    action increment(x:Number) = {
        return baseNumber += x
    }
    hide action dispose() = {
        //nothing
    }

className: AnotherClass
```

(When transpiled to Haxe)

```haxe
var x:Int = 5;
var z:Int = 10;
var y:ImprovedNumber = new ImprovedNumber(5);

public static function main()
{
    y.increment(4);
    trace(y);
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
```