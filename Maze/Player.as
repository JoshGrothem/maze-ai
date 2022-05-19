package {
	import flash.display.*;
	public class Player extends MovieClip {
		public var mRow: int;
		public var col: int;
		public function Player(r, c: int) {
			// constructor code
			mRow = r;
			col = c;
			this.x = col * Game.WIDTH + Game.OFFSET;
			this.y = mRow * Game.WIDTH + Game.OFFSET;
		}
	public function reposition() {
			this.x = col * Game.WIDTH + Game.OFFSET;
			this.y = mRow * Game.WIDTH + Game.OFFSET;
		}
	

	}

}