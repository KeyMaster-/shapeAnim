package components;
class KeyControls {
	public var left:Int;
	public var right:Int;
	public var up:Int;
	public var down:Int;
	public var shoot:Int;
	public function new(left:Int, right:Int, up:Int, down:Int, shoot:Int) {
		this.left = left;
		this.right = right;
		this.up = up;
		this.down = down;
		this.shoot = shoot;
	}
}