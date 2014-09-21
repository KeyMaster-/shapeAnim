package components;
import flash.display.DisplayObject;
import flash.geom.Point;
import flash.geom.Rectangle;

@:allow(systems.RenderSystem)
class Aspect {
	public var displayObject:DisplayObject;
	public var offset:Point;
	public var scale:Point;
	
	public var layer(default, set):Int;
	var oldLayer:Int;
	public function new(displayObject:DisplayObject, layer:Int = 0 ) {
		this.displayObject = displayObject;
		offset = new Point();
		scale = new Point(1,1);
		this.layer = layer;
	}
	
	public function setOffset(x:Float, y:Float) {
		offset.x = x;
		offset.y = y;
	}
	
	public function centerOffset() {
		var rect:Rectangle = displayObject.getRect(displayObject);
		offset.x = -(rect.left + (rect.width / 2));
		offset.y = -(rect.top + (rect.height / 2));
	}
	
	inline function set_layer(value:Int):Int {
		oldLayer = layer;
		layer = value;
		return layer;
	}
}