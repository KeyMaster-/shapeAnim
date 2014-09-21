package ;
class TwoWayIntIter {
	var start:Int;
	var end:Int;
	var step:Int;
	var pos:Int;
	/**
	 * Iterate from start (inclusive) to end (inclusive)
	 * @param	start	included
	 * @param	end		included
	 */
	public function new(start:Int, end:Int) {
		set(start, end);
	}
	
	/**
	 * Set the iterator to new values (to reuse the iterator) Iterate from start (inclusive) to end (inclusive)
	 * @param	start	included
	 * @param	end		included
	 */
	public function set(start:Int, end:Int) {
		this.start = start;
		this.end = end;
		if (end - start >= 0) {
			step = 1;
		}
		else {
			step = -1;
		}
		
		pos = start;
	}
	
	public function hasNext():Bool {
		return pos != end + step;
	}
	
	public function next():Int {
		pos += step;
		return pos - step;
	}
}