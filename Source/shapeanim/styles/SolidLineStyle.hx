package shapeanim.styles;
import flash.display.Graphics;
class SolidLineStyle implements ILineStyle {
	public var thickness:Int;
	public var color:Int;
	public var alpha:Float;
	
	/**
	 * Creates a new LineStyle specification
	 * @param	thickness	Thickness of the line, from 0 to 255. -1 means no line
	 * @param	color		Color of the line, in hex 0xRRGGBB
	 * @param	alpha		Alpha of the line, from 0 to 1
	 */
	public function new(thickness:Int = -1, color:Int = 0x000000, alpha:Float = 1) {
		this.thickness = thickness;
		this.color = color;
		this.alpha = alpha;
	}
	
	public function apply(graphics:Graphics):Void 
	{
		if (thickness < 0) {
			graphics.lineStyle();
		}
		else {
			graphics.lineStyle(thickness, color, alpha);
		}
	}
	
	public function toString():String {
		return "Thickness: " + Std.string(thickness) + ", Color: 0x" + StringTools.hex(color, 6) + ", Alpha: " + Std.string(alpha);
	}
}