package easing;

class Quad {
	public static inline function easeIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c * ( t /= d ) * t + b;
	}
	
	public static inline function easeOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return -c * ( t /= d ) * ( t - 2 ) + b;
	}
	
	public static inline function easeInOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		if ( ( t /= d * 0.5 ) < 1 )
			return c * 0.5 * t * t + b;
		else
			return -c * 0.5 * ( ( --t ) * ( t - 2 ) - 1 ) + b;
	}
}
