package {
	import flash.display.*;
	public class Runner extends MovieClip {
		public var mRow: int;
		public var col: int;
		public function Runner(r, c: int) {
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