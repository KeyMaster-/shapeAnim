package systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import components.ShapeAnim;
import easing.EasingLookup;
import haxe.ds.IntMap;
import haxe.ds.StringMap;
import haxe.Json;
import nodes.ShapeAnimNode;
import openfl.Assets;
import openfl.geom.Point;
import shapeanim.ShapeAnimObj;
import shapeanim.styles.IFillStyle;
import shapeanim.styles.ILineStyle;
import shapeanim.styles.SolidFillStyle;
import shapeanim.styles.SolidLineStyle;
import shapeanim.styles.StylePack;
@:access(components.ShapeAnim)
@:access(components.ShapeAnim.dirty)
class ShapeAnimSystem extends System {
	var nodes:NodeList<ShapeAnimNode>;
	public var stylePacks:StringMap<StylePack>;
	public function new() {
		super();
		stylePacks = new StringMap<StylePack>();
	}
	override public function addToEngine(engine:Engine):Void 
	{
		nodes = engine.getNodeList(ShapeAnimNode);
		nodes.nodeAdded.add(nodeAdded);
	}
	
	override public function removeFromEngine(engine:Engine):Void 
	{
		engine.releaseNodeList(ShapeAnimNode);
		nodes = null;
	}
	
	function nodeAdded(node:ShapeAnimNode) {
		var jsonString:String = Assets.getText(node.shapeAnim.path);
		if (jsonString == null) {
			throw "file " + node.shapeAnim.path + " does not exist";
		}
		var json = Json.parse(jsonString);
		node.shapeAnim.shapeAnimObj = new ShapeAnimObj();
		var anim:Animation;
		var frame:Frame;
		var face:Face;
		var vertex:Point;
		var jsonAnims:Array<Dynamic> = json.animations;
		var jsonFrames:Array<Dynamic>;
		var jsonVerts:Array<Dynamic>;
		var jsonFaces:Array<Dynamic>;
		var jsonEasing:Array<Dynamic>;
		for (jsonAnim in jsonAnims) {
			anim = new Animation();
			jsonFrames = jsonAnim.frames;
			for (jsonFrame in jsonFrames) {
				frame = new Frame();
				frame.duration = jsonFrame.duration;
				
				if (jsonFrame.verts != null) {
					jsonVerts = jsonFrame.verts;
					frame.verts = new IntMap<Point>();
					for (jsonVert in jsonVerts) {
						frame.verts.set(Std.int(jsonVert.n), new Point(jsonVert.x, jsonVert.y));
					}
				}
				
				if (jsonFrame.faces != null) {
					jsonFaces = jsonFrame.faces;
					frame.faces = new IntMap<Face>();
					for (jsonFace in jsonFaces) {
						face = new Face();
						face.indices = jsonFace.indices;
						face.lineStyleIndex = Std.int(jsonFace.line);
						face.fillStyleIndex = Std.int(jsonFace.fill);
						frame.faces.set(Std.int(jsonFace.n), face);
					}
				}
				var jsonIndices:String;
				var start:Int;
				var end:Int;
				var indexStrings:Array<String>;
				var intIterator:TwoWayIntIter = new TwoWayIntIter(0, 0);
				if (jsonFrame.easing != null) {
					jsonEasing = jsonFrame.easing;
					frame.easingCmds = new IntMap<EaseFunction>();
					for (jsonEasingCmd in jsonEasing) {
						if (EasingLookup.funcMap.get(jsonEasingCmd.ease) != null) {
							jsonIndices = Std.string(jsonEasingCmd.n);
							indexStrings = jsonIndices.split("-");
							if (indexStrings[0] == null || indexStrings[0] == "") {
								break;
							}
							start = Std.parseInt(indexStrings[0]);
							if (indexStrings[1] == null || indexStrings[1] == "") {
								end = start;
							}
							else {
								end = Std.parseInt(indexStrings[1]);
							}
							
							intIterator.set(start, end);
							for (i in intIterator) {
								frame.easingCmds.set(i, EasingLookup.funcMap.get(jsonEasingCmd.ease));
							}
						}
					}
				}
				anim.frames.push(frame);
			}
			node.shapeAnim.shapeAnimObj.animations.set(jsonAnim.name, anim);
		}
		loadStylePack(json.stylePack);
		node.shapeAnim.shapeAnimObj.stylePack = stylePacks.get(json.stylePack);
		if (node.shapeAnim.curAnimName != "") {
			if (node.shapeAnim.reversed) {
				setFrame(node.shapeAnim, node.shapeAnim.curAnimName, 0);//TODO not clean, should really set all frames from start to end once and then let it run backwards
				setFrame(node.shapeAnim, node.shapeAnim.curAnimName, node.shapeAnim.shapeAnimObj.animations.get(node.shapeAnim.curAnimName).frames.length - 1);
				node.shapeAnim.nextFrame = node.shapeAnim.curFrameNum - 1;
			}
			else {
				setFrame(node.shapeAnim, node.shapeAnim.curAnimName, 0);
				node.shapeAnim.nextFrame = 1;
			}
			drawCurrent(node);
		}
	}
	
	function loadStylePack(packName:String):Void {
		if (stylePacks.exists(packName)) return;
		var jsonText:String = Assets.getText("assets/animations/stylePacks/" + packName + ".json");
		
		if (jsonText == null) {
			throw "The style pack " + packName + " does not exist";
		}
		var json = Json.parse(jsonText);
		
		var stylePack:StylePack = new StylePack();
		var jsonStyles:Array<Dynamic>;
		
		var fillStyle:IFillStyle = null;
		
		jsonStyles = json.fill;
		for (jsonFillStyle in jsonStyles) {
			var type:String = Std.string(jsonFillStyle.type);
			switch (type) {
				case "solid":
					fillStyle = new SolidFillStyle(Std.parseInt(jsonFillStyle.color), jsonFillStyle.alpha);
			}
			stylePack.fillStyles.set(Std.int(jsonFillStyle.n), fillStyle);
		}
		
		var lineStyle:ILineStyle = null;
		jsonStyles = json.line;
		for (jsonLineSyle in jsonStyles) {
			var type:String = jsonLineSyle.type;
			switch(type) {
				case "none":
					lineStyle = new SolidLineStyle();
				case "solid":
					lineStyle = new SolidLineStyle(Std.int(jsonLineSyle.thickness), Std.parseInt(jsonLineSyle.color), jsonLineSyle.alpha); 
			}
			stylePack.lineStyles.set(Std.int(jsonLineSyle.n), lineStyle);
		}
		
		stylePacks.set(packName, stylePack);
	}
	function setFrame(comp:ShapeAnim, animName:String, frameNum:Int):Void {
		if (!comp.shapeAnimObj.animations.exists(animName)) 					 throw "Animation: \"" + animName + "\" doesn't exist!";
		if (comp.shapeAnimObj.animations.get(animName).frames[frameNum] == null) throw "Frame number " + Std.string(frameNum) + " in animation \"" + animName + "\" does not exist";
		
		comp.curAnimName = animName;
		comp.curAnim = comp.shapeAnimObj.animations.get(animName);
		comp.curFrameNum = frameNum;
		comp.curFrame = comp.shapeAnimObj.animations.get(animName).frames[frameNum];
		
		comp.frameTimeElapsed = 0;
		
		var vertex:Point;
		
		//Copy over any changed faces
		if (comp.curFrame.faces != null) {
			for (faceIndex in comp.curFrame.faces.keys()) {
				comp.curFaces.set(faceIndex, comp.curFrame.faces.get(faceIndex));
			}
		}
		
		if (comp.curFrame.verts != null) {
			for (vertIndex in comp.curFrame.verts.keys()) {
				comp.curVerts.set(vertIndex, comp.curFrame.verts.get(vertIndex));
			}
		}
		
	}
	
	function drawCurrent(node:ShapeAnimNode):Void {
		node.shapeAnim.shape.graphics.clear();
		var nextFrame:Frame = null;
		if (node.shapeAnim.curAnim.frames.length != 1) {
			nextFrame = node.shapeAnim.curAnim.frames[node.shapeAnim.nextFrame];
		}
		var vertex:Point = new Point();
		var easeFunc:EaseFunction;
		var index:Int;
		for (face in node.shapeAnim.curFaces) {
			node.shapeAnim.shapeAnimObj.stylePack.fillStyles.get(face.fillStyleIndex).apply(node.shapeAnim.shape.graphics);
			node.shapeAnim.shapeAnimObj.stylePack.lineStyles.get(face.lineStyleIndex).apply(node.shapeAnim.shape.graphics);
			var i = 0;
			while (i < face.indices.length) {
				index = face.indices[i];
				vertex.x = node.shapeAnim.curVerts.get(index).x;
				vertex.y = node.shapeAnim.curVerts.get(index).y;
				if (nextFrame != null && nextFrame.verts != null && node.shapeAnim.curFrame.easingCmds != null && node.shapeAnim.curFrame.easingCmds.get(index) != null && node.shapeAnim.curFrame.easingCmds.exists(index)) {
					easeFunc = node.shapeAnim.curFrame.easingCmds.get(index);
					vertex.x = easeFunc(node.shapeAnim.frameTimeElapsed, vertex.x, nextFrame.verts.get(index).x - vertex.x, node.shapeAnim.curFrame.duration);
					vertex.y = easeFunc(node.shapeAnim.frameTimeElapsed, vertex.y, nextFrame.verts.get(index).y - vertex.y, node.shapeAnim.curFrame.duration);
				}
				
				if (i == 0) {
					node.shapeAnim.shape.graphics.moveTo(vertex.x, vertex.y);
					i++;
					continue;
				}
				node.shapeAnim.shape.graphics.lineTo(vertex.x, vertex.y);
				i++;
			}
		}
		node.shapeAnim.shape.graphics.endFill();
		node.shapeAnim.shape.graphics.lineStyle();
	}
	
	override public function update(time:Float):Void 
	{
		var node:ShapeAnimNode = nodes.head;
		var nextFrame:Int = 0;
		while (node != null) {
			if (node.shapeAnim.animUpdated) {
				setFrame(node.shapeAnim, node.shapeAnim.curAnimName, node.shapeAnim.curFrameNum);
				node.shapeAnim.frameTimeElapsed = 0;
				node.shapeAnim.animUpdated = false;
				node.shapeAnim.playing = true;
				node.shapeAnim.nextFrame = 1;
			}
			node.shapeAnim.frameTimeElapsed += time;
			
			if (node.shapeAnim.playing) {
				//Ensure to stop playing when it should be turned off because the animation has ended
				
				if (!node.shapeAnim.pingpong && !node.shapeAnim.loop) {
					if (node.shapeAnim.reversed) {
						if (node.shapeAnim.curFrameNum == 0) {
							node.shapeAnim.playing = false;
							node = node.next;
							continue;
						}
					}
					else {
						if (node.shapeAnim.curFrameNum == node.shapeAnim.shapeAnimObj.animations.get(node.shapeAnim.curAnimName).frames.length - 1) {
							node.shapeAnim.playing = false;
							node = node.next;
							continue;
						}
					}
				}
				//If the current frame has ended
				if (node.shapeAnim.frameTimeElapsed >= node.shapeAnim.curFrame.duration) {
					//Advance to next frame
					node.shapeAnim.curFrameNum = node.shapeAnim.nextFrame;
					//set next frame either has the next or previous frame
					if (node.shapeAnim.reversed) {
						node.shapeAnim.nextFrame = node.shapeAnim.curFrameNum - 1;
					}
					else {
						node.shapeAnim.nextFrame = node.shapeAnim.curFrameNum + 1;
						
					}
					
					if (node.shapeAnim.reversed) {
						if (node.shapeAnim.nextFrame < 0) {
							if (node.shapeAnim.pingpong) {
								node.shapeAnim.nextFrame = 1;
								node.shapeAnim.reversed = false;
							}
							else if (node.shapeAnim.loop) {
								node.shapeAnim.nextFrame = node.shapeAnim.curAnim.frames.length - 1;
							}
							else {
								node.shapeAnim.playing = false;
							}
						}
					}
					else {
						if (node.shapeAnim.nextFrame == node.shapeAnim.curAnim.frames.length) {
							if (node.shapeAnim.pingpong) {
								node.shapeAnim.nextFrame = node.shapeAnim.curAnim.frames.length - 2;
								node.shapeAnim.reversed = true;
							}
							else if (node.shapeAnim.loop) {
								node.shapeAnim.nextFrame = 0;
							}
							else {
								trace("playing false");
								node.shapeAnim.playing = false;
							}
						}
					}
					setFrame(node.shapeAnim, node.shapeAnim.curAnimName, node.shapeAnim.curFrameNum);
				}
				drawCurrent(node);
			}
			node = node.next;
		}
	}
}
