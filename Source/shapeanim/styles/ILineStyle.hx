package shapeanim.styles;
import openfl.display.Graphics;

interface ILineStyle { 
	/**
	 * Apply the style to the graphics object.
	 * @param	graphics	The graphics object to apply the style to
	 */
	public function apply(graphics:Graphics):Void;
	public function toString():String;
}