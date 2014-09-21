package shapeanim.styles;
import flash.display.Graphics;
interface IFillStyle { 
	/**
	 * Apply the style to the graphics object.
	 * @param	graphics	The graphics object to apply the style to
	 */
	public function apply(graphics:Graphics):Void;
	public function toString():String;
}