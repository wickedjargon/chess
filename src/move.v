module main

import gg

struct RelativeCoords {
	mut:
	relative_coords  Coords
	conditions       []fn (GameBoard, Coords, Coords) bool
	break_conditions []fn (GameBoard, Coords, Coords, []Coords) bool
	modifiers        []string
}


struct Coords { y int x int }

struct Move { origin_coords Coords destination_coords Coords }

fn (table [][]Piece) at (coords Coords) Piece {
	return table[coords.y][coords.x]
}

fn (a Coords) + (b Coords) Coords {
	return Coords {a.y + b.y, a.x + b.x}
}

fn get_legal_moves(game_board GameBoard, origin_coords Coords) []Coords {
	origin_piece := game_board.table.at(origin_coords)
	mut legal_moves := []Coords{}
	for relative_coords in relative_coords_map[origin_piece.map_key] {
		mut absolute_destination_coords := origin_coords + relative_coords.relative_coords
		for ; within_board(absolute_destination_coords) && all_conditions_met(game_board, origin_coords, absolute_destination_coords, relative_coords.conditions);
		absolute_destination_coords += relative_coords.relative_coords {
			legal_moves << absolute_destination_coords
			if any_condition_met(game_board, origin_coords, absolute_destination_coords, legal_moves, relative_coords.break_conditions)
			{
				break
			}
		}
	}
	return legal_moves
}

fn set_legal_moves_game_board(mut legal_moves_game_board [][]bool, legal_moves []Coords) {
	for y, mut row in legal_moves_game_board {
		for x, mut cell in row {
			cell = false
		}
	}
	for legal_move in legal_moves {
		legal_moves_game_board[legal_move.y][legal_move.x] = true
	}
}

fn move_piece(mut game_board_table [][]Piece, move Move) {
	game_board_table[move.destination_coords.y][move.destination_coords.x] = game_board_table.at(move.origin_coords)
	game_board_table[move.origin_coords.y][move.origin_coords.x] = Piece {  }
}

// fn flip_board(mut game_board_table [][]Piece) {
// 	mut empty_game_board_table := [][]Piece{}
// 	for y := game_board_table.len - 1; y >= 0; y-- {
// 		empty_game_board_table << game_board_table[y]
// 	}
// 	game_board_table = empty_game_board_table.clone()
// }

fn handle_origin_coords(mut app App, coords Coords) {
	app.legal_moves = get_legal_moves(app.game_board, coords)
	set_legal_moves_game_board(mut app.legal_moves_game_board, app.legal_moves)
	app.origin_coords = coords
	app.selection_state = .destination_coords
}

fn handle_coords(mut app App, coords Coords) {
	if app.selection_state == .origin_coords && app.game_board.table.at(coords).color == app.game_board.to_play {
		handle_origin_coords(mut app, coords)
	} else if app.selection_state == .destination_coords && coords in app.legal_moves {
		move_piece(mut app.game_board.table, Move {app.origin_coords, coords})
		app.game_board.to_play = opposite_color(app.game_board.to_play)
		app.selection_state = .origin_coords
	} else if app.selection_state == .destination_coords && app.game_board.table.at(coords).color == app.game_board.to_play {
		handle_origin_coords(mut app, coords)
	} else {
		app.selection_state = .origin_coords
	}
}
