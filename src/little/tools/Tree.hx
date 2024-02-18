package little.tools;

class Tree<T> {
    public var value:T;
    public var children:Array<Tree<T>> = [];

    public function new(val:T) {
        value = val;
    }
}