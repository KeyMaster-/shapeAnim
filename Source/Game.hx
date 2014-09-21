package;
import ash.core.Engine;
import ash.core.Entity;
import ash.tick.FrameTickProvider;
import ash.tick.ITickProvider;
import components.Aspect;
import components.Position;
import components.ShapeAnim;
import flash.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.geom.Matrix;
import systems.AnimStartSystem;
import systems.InputSystem;
import systems.RenderSystem;
import systems.ShapeAnimSystem;

class Game {
	var container:DisplayObjectContainer;
	var tickProvider:ITickProvider;
	var engine:Engine;
	public function new(container:DisplayObjectContainer) {
		this.container = container;
		setup();
	}
	
	function setup() {
		engine = new Engine();
		engine.addSystem(new InputSystem(container.stage), 0);
		var animStartSys:AnimStartSystem = new AnimStartSystem();
		engine.addSystem(animStartSys, 1);
		engine.addSystem(new ShapeAnimSystem(), 2);
		engine.addSystem(new RenderSystem(container.stage), 3);
		
		EngineSystems.input = engine.getSystem(InputSystem);
		var e:Entity = new Entity();
		var s:Shape = new Shape();
		var sAnim:ShapeAnim;
		
		e.add(new Position(100, 100));
		e.add(new Aspect(s));
		sAnim = new ShapeAnim("assets/animations/hexagonAnim.json", s);
		sAnim.pingpong = true;
		sAnim.curAnimName = "anim1";
		e.add(sAnim);
		engine.addEntity(e);
		
		e = new Entity();
		s = new Shape();
		e.add(new Position(200, 100));
		e.add(new Aspect(s));
		sAnim = new ShapeAnim("assets/animations/boxAnim.json", s);
		sAnim.reversed = true;
		sAnim.loop = true;
		sAnim.curAnimName = "anim1";
		e.add(sAnim);
		engine.addEntity(e);
		
		
		e = new Entity();
		s = new Shape();
		e.add(new Position(300, 100));
		e.add(new Aspect(s));
		sAnim = new ShapeAnim("assets/animations/hexagonRotate.json", s);
		sAnim.loop = true;
		sAnim.curAnimName = "anim1";
		e.add(sAnim);
		engine.addEntity(e);
		
		e = new Entity();
		s = new Shape();
		var asp:Aspect = new Aspect(s);
		
		e.add(new Position(500, 300));
		e.add(asp);
		sAnim = new ShapeAnim("assets/animations/explosion.json", s);
		sAnim.loop = true;
		sAnim.curAnimName = "anim1";
		e.add(sAnim);
		engine.addEntity(e);
		animStartSys.shapeAnim = sAnim;
		e = new Entity();
		s = new Shape();
		
		e.add(new Position(400, 300));
		e.add(new Aspect(s));
		sAnim = new ShapeAnim("assets/animations/faceAnim.json", s);
		sAnim.loop = true;
		sAnim.curAnimName = "anim1";
		e.add(sAnim);
		engine.addEntity(e);
	}
	
	public function start() {
		tickProvider = new FrameTickProvider(container);
		tickProvider.add(engine.update);
		tickProvider.start();
	}
}