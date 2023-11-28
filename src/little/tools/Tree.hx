package little.tools;

class Tree<T> {
    public var value:T;
    public var children:TreeItem<T> = [];

    public function new(val:T) {
        value = val;
    }
}