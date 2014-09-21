package easing;

class Linear {
	public static inline function easeNone ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * t / d + b;
	}
	
	public static inline function easeIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * t / d + b;
	}
	
	public static inline function easeOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * t / d + b;
	}
	
	public static inline function easeInOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * t / d + b;
	}
}
