package shapeanim.styles;
import flash.display.Graphics;

class SolidFillStyle implements IFillStyle{
	public var color:Int;
	public var alpha:Float;
	
	/**
	 * Creates a new SolidFillStyle specification
	 * @param	color		The solid color of the fill, in hex 0xRRGGBB
	 * @param	alpha		The alpha of the fill, from 0 to 1
	 */
	public function new(color:Int = 0x000000, alpha:Float = 1) {
		this.color = color;
		this.alpha = alpha;
	}
	
	public function apply(graphics:Graphics):Void 
	{
		graphics.beginFill(color, alpha);
	}
	
	public function toString():String {
		return "Color: 0x" + StringTools.hex(color, 6) + ", Alpha: " + Std.string(alpha);
	}
}