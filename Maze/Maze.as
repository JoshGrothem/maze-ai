package {
	import flash.display.*;
	import flash.events.*;
	public class Maze extends MovieClip {
		public var mazeCells: Array;
		public var mazeCellsAI: Array;
		public var stack2: Array = new Array();
		public var j: int = 0;
		public var player: Player;
		public var runner: Runner;
		public function Maze() {
			// constructor code
			mazeCells = new Array(Game.COLS * Game.ROWS);
			mazeCellsAI = new Array(Game.COLS * Game.ROWS);
			player = new Player(Game.ROWS - 1, Game.COLS - 1);
			runner = new Runner(Game.ROWS - 1, Game.COLS - 1);
			addChild(player);
			addChild(runner);


			var i: int = 0;
			for (var row: int = 0; row < Game.ROWS; row++) {
				for (var col: int = 0; col < Game.COLS; col++) {
					var cell: Cell = new Cell(row, col);
					mazeCells[i++] = cell;
				}
			}
			backtracker();
			drawMazeCells();
			stage.addEventListener(KeyboardEvent.KEY_UP, playerMoves);
			stage.addEventListener(Event.ENTER_FRAME, runnerPath);


		}

		public function backtracker(): void {
			var stack: Array = new Array();
			var i: int = 0;
			mazeCells[i].visited = true;
			stack.push(i);
			var visitedCells: int = 1;

			while (visitedCells < Game.N_CELLS) {
				var possibleWalls: Array = new Array();
				//NOT A CELL ON THE WESTERN EDGE OF THE MAZE
				if (mazeCells[i].west && i % Game.COLS != 0) {
					if (!mazeCells[i - 1].visited) {
						possibleWalls.push(Game.WEST);
					}
				}
				//NOT A CELL ON THE EASTERN EDGE OF THE MAZE
				if (mazeCells[i].east && i % Game.COLS != Game.COLS - 1) {
					if (!mazeCells[i + 1].visited) {
						possibleWalls.push(Game.EAST);
					}
				}
				//NOT A CELL ON THE SOUTHERN EDGE OF THE MAZE
				if (mazeCells[i].south && i < Game.COLS * Game.ROWS - Game.COLS) {
					if (!mazeCells[i + Game.COLS].visited) {
						possibleWalls.push(Game.SOUTH);
					}
				}
				//NOT A CELL ON THE NORTHERN EDGE OF THE MAZE
				if (mazeCells[i].north && i >= Game.COLS) {
					if (!mazeCells[i - Game.COLS].visited) {
						possibleWalls.push(Game.NORTH);
					}
				}

				if (possibleWalls.length > 0) {
					var randomWall = possibleWalls[Math.floor(Math.random() * possibleWalls.length)];
					//OPEN THE WALL FOR THE CELL AS THE WALL OF THE OTHER CELL
					switch (randomWall) {
						case Game.NORTH:
							//delete lower 2 lines, just move runner
							mazeCells[i].north = false;
							mazeCells[i - Game.COLS].south = false;
							i -= Game.COLS;
							break;
						case Game.SOUTH:
							mazeCells[i].south = false;
							mazeCells[i + Game.COLS].north = false;
							i += Game.COLS;
							break;
						case Game.EAST:
							mazeCells[i].east = false;
							mazeCells[i + 1].west = false;
							i++;
							break;
						case Game.WEST:
							mazeCells[i].west = false;
							mazeCells[i - 1].east = false;
							i--;
							break;
					}
					mazeCells[i].visited = true;
					stack.push(i); //PUSH CELL INTO NEXT STACK
					visitedCells++; //CONT THIS NEXT CELL AFTER VISITING IT
				} else {
					//IF NO WALLS CAN BE REMOVED
					//BEGIN BACKTRACKING; POP THE STACK
					var top: int = stack.pop();
					if (top == i) {
						i = stack.pop(); //POP STACK-REVERSE
						stack.push(i);
					}
				}
			}
		}

		public function runnerPath(event: Event): void {
			var ai: int = ((runner.mRow) * Game.ROWS) + runner.col;
			if (ai == 0) {
				stage.removeEventListener(Event.ENTER_FRAME, runnerPath);
			}
			j = ai;
			mazeCellsAI = mazeCells;
			mazeCellsAI[ai].visited = false;
			stack2.push(j);

			if (mazeCells[j].north != true && mazeCellsAI[j - Game.COLS].visited == true) {
				mazeCellsAI[j].visited = false;
				runner.mRow--;
				runner.reposition();
				stack2.push(j);
			} else if (mazeCells[j].south != true && mazeCellsAI[j + Game.COLS].visited == true) {
				mazeCellsAI[j].visited = false;
				runner.mRow++;
				runner.reposition();
				stack2.push(j);
			} else if (mazeCells[j].east != true && mazeCellsAI[j + 1].visited == true) {
				mazeCellsAI[j].visited = false;
				runner.col++;
				runner.reposition();
				stack2.push(j);
			} else if (mazeCells[j].west != true && mazeCellsAI[j - 1].visited == true) {
				mazeCellsAI[j].visited = false;
				runner.col--;
				runner.reposition();
				stack2.push(j);
			} else {
				j = stack2.pop();
				if (j == ai) {
					j = stack2.pop();
				}

				if (mazeCells[ai].north != true && mazeCellsAI[j].visited == false && j + Game.COLS == ai) {
					runner.mRow--;
					runner.reposition();
				} else if (mazeCells[ai].south != true && mazeCellsAI[j].visited == false && j - Game.COLS == ai) {
					runner.mRow++;
					runner.reposition();
				} else if (mazeCells[ai].east != true && mazeCellsAI[j].visited == false && j - 1 == ai) {
					runner.col++;
					runner.reposition();
				} else if (mazeCells[ai].west != true && mazeCellsAI[j].visited == false && j + 1 == ai) {
					runner.col--;
					runner.reposition();
				}
			}
		}
		public function playerMoves(event: KeyboardEvent) {
			var position: int = ((player.mRow) * Game.ROWS) + player.col;
			switch (event.keyCode) {
				case Game.UPARROW:
					if (mazeCells[position].north == false) {
						player.mRow--;
					}
					break;
				case Game.DOWNARROW:
					if (mazeCells[position].south == false) {
						player.mRow++;
					}
					break;
				case Game.LEFTARROW:
					if (mazeCells[position].west == false) {
						player.col--;
					}
					break;
				case Game.RIGHTARROW:
					if (mazeCells[position].east == false) {
						player.col++;
					}
			}
			player.reposition();
			position = ((player.mRow) * 50) + player.col;
		}

		public function drawMazeCells(): void {

			for (var i: int = 0; i < Game.N_CELLS; i++) {
				var shape: Shape = new Shape();
				shape.graphics.lineStyle(2, 0x0000FF);
				shape.graphics.moveTo(mazeCells[i].xPos, mazeCells[i].yPos);

				if (mazeCells[i].north) {
					shape.graphics.lineTo(mazeCells[i].xPos + Game.SIZE, mazeCells[i].yPos);
				} else {
					shape.graphics.moveTo(mazeCells[i].xPos + Game.SIZE, mazeCells[i].yPos);
				}

				if (mazeCells[i].east) {
					shape.graphics.lineTo(mazeCells[i].xPos + Game.SIZE, mazeCells[i].yPos + Game.SIZE);
				} else {
					shape.graphics.moveTo(mazeCells[i].xPos + Game.SIZE, mazeCells[i].yPos + Game.SIZE);
				}

				if (mazeCells[i].south) {
					shape.graphics.lineTo(mazeCells[i].xPos, mazeCells[i].yPos + Game.SIZE);
				} else {
					shape.graphics.moveTo(mazeCells[i].xPos, mazeCells[i].yPos + Game.SIZE);
				}

				if (mazeCells[i].west) {
					shape.graphics.lineTo(mazeCells[i].xPos, mazeCells[i].yPos);
				} else {
					shape.graphics.moveTo(mazeCells[i].xPos, mazeCells[i].yPos);
				}
				addChild(shape);
			}
		}
	}
}