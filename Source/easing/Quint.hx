package easing;

class Quint {
	public static inline function easeIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * ( t /= d ) * t * t * t * t + b;
	}
	
	public static inline function easeOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * ( ( t = t / d - 1 ) * t * t * t * t + 1 ) + b;
	}
	
	public static inline function easeInOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		if ( ( t /= d * 0.5 ) < 1 )
			return c * 0.5 * t * t * t * t * t + b;
		else
			return c * 0.5 * ( ( t -= 2 ) * t * t * t * t + 2 ) + b;
	}
}
