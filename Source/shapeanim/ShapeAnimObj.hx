package shapeanim ;
import flash.display.Graphics;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import openfl.geom.Point;
import shapeanim.styles.StylePack;
class ShapeAnimObj {
	public var animations:StringMap<Animation>;
	public var stylePack:StylePack;
	public function new() {
		animations = new StringMap<Animation>();
	}
	public function toString():String {
		return "Animations: " + animations.toString();
	}
}

class Animation {
	public var frames:Array<Frame>;
	public function new() {
		frames = new Array<Frame>();
	}
	
	public function toString():String {
		return "Frames: [" + frames.toString() + "]";
	}
}

class Frame {
	public var duration:Float = 0;
	public var verts:IntMap<Point>;
	public var faces:IntMap<Face>;
	public var easingCmds:IntMap<EaseFunction>;
	public function new() {
	}
	
	public function toString():String {
		var s:String = "";
		verts != null ? s += "Verts: " + verts.toString() : s += "No verts";
		faces != null ? s += ", Faces: " + faces.toString() : s += "No faces";
		//TODO easing commands string representation
		return s;
	}
}

typedef EaseFunction = Float->Float->Float->Float->Float;

class Face {
	public var indices:Array<Int>;
	public var lineStyleIndex:Int;
	public var fillStyleIndex:Int;
	
	public function new() {
		indices = new Array<Int>();
		lineStyleIndex = 0;
		fillStyleIndex = 0;
	}
	
	public function toString():String {
		var s:String = "Indices: [" + indices.toString() + "]";
		s += ", lineStyleIndex: " + Std.string(lineStyleIndex);
		s += ", fillStyleIndex: " + Std.string(fillStyleIndex);
		return s;
	}
}