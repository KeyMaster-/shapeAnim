package easing;

class Expo {
	public static inline function easeIn ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return ( t == 0 ) ? b : c * Math.pow( 2, 10 * ( t / d - 1 ) ) + b;
	}
	
	public static inline function easeOut ( t : Float, b : Float, c : Float, d : Float ) : Float {
		return ( t == d ) ? b + c : c * ( -Math.pow( 2, -10 * t / d ) + 1 ) + b;
	}
	
	public static inline function easeInOut ( t : Float, b : Float, c : Float, d : Float) : Float {
		if ( t == 0 )
			return b;
		else if ( t == d )
			return b + c;
		else if ( ( t /= d / 2 ) < 1 )
			return c * 0.5 * Math.pow( 2, 10 * ( t - 1 ) ) + b;
		else
			return c * 0.5 * ( -Math.pow( 2, -10 * --t ) + 2 ) + b;
	}
}
