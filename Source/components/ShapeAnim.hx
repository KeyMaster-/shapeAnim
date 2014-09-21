package components;
import flash.display.Graphics;
import flash.display.Shape;
import haxe.ds.IntMap;
import openfl.geom.Point;
import shapeanim.ShapeAnimObj;

class ShapeAnim {
	public var path:String;
	//TODO remove public later
	var shapeAnimObj:ShapeAnimObj;
	public var shape:Shape;
	public var curAnimName:String = "";
	public var curAnim:Animation = null;
	public var curFrameNum:Int = -1;
	public var curFrame:Frame = null;
	public var nextFrame:Int = -1;
	public var curVerts:IntMap<Point>;
	public var curFaces:IntMap<Face>;
	public var frameTimeElapsed:Float = 0;
	public var reversed:Bool = false;
	public var playing:Bool = true;
	public var loop:Bool = false;
	public var pingpong:Bool = false;//Unify these bools into one "mode"
	var animUpdated:Bool = false;
	public function new(filePath:String, shape:Shape) {
		path = filePath;
		this.shape = shape;
		curVerts = new IntMap<Point>();
		curFaces = new IntMap<Face>();
	}
	
	public function playAnimation(animName:String) {
		curAnimName = animName;
		curFrameNum = 0;
		animUpdated = true;
	}
}