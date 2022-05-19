package  {
	import flash.events.*;
	import flash.display.*;
	public class Cell extends MovieClip{
		public var xPos:int;
		public var yPos:int;
		public var visited:Boolean;
		public var north:Boolean;
		public var south:Boolean;
		public var east:Boolean;
		public var west:Boolean;
		public function Cell(row, col:int) {
			// constructor code
			xPos = col * Game.SIZE + Game.OFFSET;
			yPos = row * Game.SIZE + Game.OFFSET;
			
			visited = false;
			north = true;
			south = true;
			east = true;
			west = true;
		}

	}
	
}
