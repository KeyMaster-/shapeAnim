package systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import flash.display.Stage;
import flash.geom.Point;
import haxe.ds.IntMap;
import nodes.RenderNode;

class RenderSystem extends System {
	var stage:Stage;
	var nodes:NodeList<RenderNode>;
	var layerObjCount:IntMap<Int>;
	public function new(stage:Stage) {
		super();
		this.stage = stage;
		layerObjCount = new IntMap<Int>();
	}
	
	override public function addToEngine(engine:Engine):Void 
	{
		super.addToEngine(engine);
		nodes = engine.getNodeList(RenderNode);
		
		var node:RenderNode = nodes.head;
		while (node != null) {
			node.aspect.displayObject.x = node.position.position.x;
			node.aspect.displayObject.y = node.position.position.y;
			node.aspect.displayObject.rotation = node.position.rotation;
			node = node.next;
		}
		nodes.nodeAdded.add(addToDisplay);
		nodes.nodeRemoved.add(removeFromDisplay);
	}
	
	private function addToDisplay(node:RenderNode) {
		var index:Int = 0;
		//TODO remove this layering logic and make it based on layer holding sprites
		//-1 => always on top layer
		if (node.aspect.layer == -1) {
			//Add object at the end of the list, now it will always be pushed down and stay on top if others are added
			stage.addChild(node.aspect.displayObject);
			return;
		}
		if (!layerObjCount.exists(node.aspect.layer)) {
			layerObjCount.set(node.aspect.layer, 0);
		}
		stage.addChildAt(node.aspect.displayObject, countObjectsToLayer(node.aspect.layer));
		
		layerObjCount.set(node.aspect.layer, layerObjCount.get(node.aspect.layer) + 1);
	}
	
	/**
	 * Counts the objects in the display list up to and including the layer given
	 * @param	layer	Count objects up to this layer, including this one
	 * @return			The number of objects up to and including this layer
	 */
	inline function countObjectsToLayer(layer:Int):Int {
		var count:Int = 0;
		var curLayer:Int = 0;
		while (curLayer <= layer) {
			if (layerObjCount.exists(curLayer)) {
				count += layerObjCount.get(curLayer);
			}
			curLayer += 1;
		}
		return count;
	}
	
	private function removeFromDisplay(node:RenderNode) {
		stage.removeChild(node.aspect.displayObject);
		if (node.aspect.layer == -1) {
			return;
		}
		layerObjCount.set(node.aspect.layer, layerObjCount.get(node.aspect.layer) - 1);
	}
	
	private function removeNode(node:RenderNode) {
		stage.removeChild(node.aspect.displayObject);
	}
	
	override public function update(time:Float):Void 
	{
		var node:RenderNode = nodes.head;
		var actualOffset:Point = new Point();
		while (node != null) {
			actualOffset.x = node.aspect.offset.x * Math.cos(node.position.rotation * 0.01745329) - node.aspect.offset.y * Math.sin(node.position.rotation * 0.01745329);
			actualOffset.y = node.aspect.offset.x * Math.sin(node.position.rotation * 0.01745329) + node.aspect.offset.y * Math.cos(node.position.rotation * 0.01745329);
			node.aspect.displayObject.x = node.position.position.x + actualOffset.x;
			node.aspect.displayObject.y = node.position.position.y + actualOffset.y;
			node.aspect.displayObject.rotation = node.position.rotation;
			
			node.aspect.displayObject.scaleX = node.aspect.scale.x;
			node.aspect.displayObject.scaleY = node.aspect.scale.y;
			if (node.aspect.oldLayer != node.aspect.layer) {
				//Swap the layers
				node.aspect.layer = node.aspect.oldLayer;
				removeFromDisplay(node);
				//Swap back
				node.aspect.layer = node.aspect.oldLayer;
				addToDisplay(node);
				node.aspect.oldLayer = node.aspect.layer;
			}
			node = node.next;
		}
		super.update(time);
	}
	
	override public function removeFromEngine(engine:Engine):Void 
	{
		nodes = null;
		super.removeFromEngine(engine);
	}
}