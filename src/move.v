module main

import gg


struct Coords { x int y int }

fn (table [][]Piece) at (coords Coords) Piece {
	return table[coords.y][coords.x]
}

fn (a Coords) + (b Coords) Coords {
	return Coords {a.y + b.y, a.x + b.x}
}

fn handle_coords(mut app App, coords Coords) {
	piece := app.game_board.table.at(coords)
	dump(piece)
}
