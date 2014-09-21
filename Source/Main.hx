package;


import flash.events.Event;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.Lib;


class Main extends Sprite {
	
	var game:Game;
	public function new () {
		
		super ();
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
		//#if debug
		var fps:FPS = new FPS();
		this.addChild(fps);
		//#end
		
	}
	
	function onEnterFrame(event:Event):Void {
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		game = new Game(this);
		game.start();
	}
}