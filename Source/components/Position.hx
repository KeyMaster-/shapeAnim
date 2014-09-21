package components;
import flash.geom.Point;

class Position {
	public var position:Point;
	public var rotation:Float;
	public function new(x:Float = 0, y:Float = 0, rotation:Float = 0) {
		this.position = new Point(x, y);
		this.rotation = rotation;
	}
}