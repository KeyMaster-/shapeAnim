package systems;

import ash.core.Engine;
import ash.core.NodeList;
import ash.core.System;
import components.ShapeAnim;
import openfl.ui.Keyboard;
class AnimStartSystem extends System {
	public var shapeAnim:ShapeAnim;
	override public function update(time:Float):Void 
	{
		if (EngineSystems.input.getKeyDown(Keyboard.P)) {
			shapeAnim.playAnimation("anim1");
		}
	}
}