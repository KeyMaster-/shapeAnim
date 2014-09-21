package easing;
import haxe.ds.StringMap;
import shapeanim.ShapeAnimObj.EaseFunction;

class EasingLookup {
	public static var funcMap:StringMap<EaseFunction> = 
	[
		"Back.easeIn" => Back.easeIn,
		"Back.easeOut" => Back.easeOut,
		"Back.easeInOut" => Back.easeInOut,
		
		"Bounce.easeIn" => Bounce.easeIn,
		"Bounce.easeOut" => Bounce.easeOut,
		"Bounce.easeInOut" => Bounce.easeInOut,
		
		"Circ.easeIn" => Circ.easeIn,
		"Circ.easeOut" => Circ.easeOut,
		"Circ.easeInOut" => Circ.easeInOut,
		
		"Cubic.easeIn" => Cubic.easeIn,
		"Cubic.easeOut" => Cubic.easeOut,
		"Cubic.easeInOut" => Cubic.easeInOut,
		
		"Elastic.easeIn" => Elastic.easeIn,
		"Elastic.easeOut" => Elastic.easeOut,
		"Elastic.easeInOut" => Elastic.easeInOut,
		
		"Expo.easeIn" => Expo.easeIn,
		"Expo.easeOut" => Expo.easeOut,
		"Expo.easeInOut" => Expo.easeInOut,
		
		"Linear.easeIn" => Linear.easeIn,
		"Linear.easeOut" => Linear.easeOut,
		"Linear.easeInOut" => Linear.easeInOut,
		
		"Quad.easeIn" => Quad.easeIn,
		"Quad.easeOut" => Quad.easeOut,
		"Quad.easeInOut" => Quad.easeInOut,
		
		"Quart.easeIn" => Quart.easeIn,
		"Quart.easeOut" => Quart.easeOut,
		"Quart.easeInOut" => Quart.easeInOut,
		
		"Quint.easeIn" => Quint.easeIn,
		"Quint.easeOut" => Quint.easeOut,
		"Quint.easeInOut" => Quint.easeInOut,
		
		"Sine.easeIn" => Sine.easeIn,
		"Sine.easeOut" => Sine.easeOut,
		"Sine.easeInOut" => Sine.easeInOut,
	];
}