```
define x = 15
define xe:Number = 0
define xer = new ChildInstance()

action getSomething() = {
    return
}
action getSomething(a:Number) = {
    return 8
}
action getSomething(b:SomeType) = {
    return
}
```
/////
```haxe

public var x:Int = 15;
public var xe:Int = 0;
public var xer:ChildInstance = new ChildInstance();

public function getSomething()
{
    return;
}
public function getSomething(a:Number)
{
    return 8;
}
public function getSomething(b:SomeType)
{
    return;
}
```