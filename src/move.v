module main

const white_oo_move = Move{Coords{7, 4}, Coords{7, 6}}
const black_oo_move = Move{Coords{0, 4}, Coords{0, 6}}

struct RelativeCoords {
	relative_coords  Coords
	conditions       []fn (GameBoard, Coords, Coords) bool
	break_conditions []fn (GameBoard, Coords, Coords, []Coords) bool
}

struct Attack {
	relative_coords_list []Coords
	shapes []Shape
}

struct Coords { y int x int }

struct Move { origin_coords Coords destination_coords Coords }

fn (table [][]Piece) at (coords Coords) Piece {
	return table[coords.y][coords.x]
}

fn (a Coords) + (b Coords) Coords {
	return Coords {a.y + b.y, a.x + b.x}
}

fn king_not_attacked(game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	move := Move{origin_coords, destination_coords}
	mut game_board_tmp := GameBoard {
		table:       game_board.table.clone()
		to_play:     game_board.to_play
		oo:          game_board.oo.clone()
		ooo:         game_board.ooo.clone()
		en_passant:  game_board.en_passant
		king_coords: game_board.king_coords
	}
	move_piece(mut game_board_tmp, move)
	opposite_player := game_board_tmp.to_play
	current_player := opposite_color(game_board_tmp.to_play)
	for attack in attacks {
		for relative_coords in attack.relative_coords_list {
			mut absolute_coords := game_board_tmp.king_coords[current_player.str()]
			for within_board(absolute_coords) {
				absolute_coords += relative_coords
				if within_board(absolute_coords) && game_board_tmp.table.at(absolute_coords).color == current_player { break }
				if within_board(absolute_coords) && game_board_tmp.table.at(absolute_coords).color == opposite_player && game_board_tmp.table.at(absolute_coords).shape in attack.shapes {
					return false
				}
				if Shape.pawn in attack.shapes || Shape.knight in attack.shapes || Shape.king in attack.shapes { break }
			}
		}
	}
	return true
}

fn square_attacked(game_board GameBoard, )


// fn set_check(mut game_board GameBoard) {
// 	current_player := game_board.to_play // is this player in check?
// 	opposite_player := opposite_color(game_board.to_play)
// 	for attack in attacks {
// 		for relative_coords in attack.relative_coords_list {
// 			mut absolute_coords := game_board.king_coords[current_player]
// 			for within_board(absolute_coords) {
// 				absolute_coords += relative_coords
// 				if within_board(absolute_coords) && game_board_tmp.table.at(absolute_coords).color == current_player { break }
// 				if within_board(absolute_coords) && game_board_tmp.table.at(absolute_coords).color == opposite_player && game_board_tmp.table.at(absolute_coords).shape in attack.shapes {
// 					game_board.is_checked[current_player.color.str()] = true
// 					return
// 				}
// 				if Shape.pawn in attack.shapes || Shape.knight in attack.shapes || Shape.king in attack.shapes { break }
// 			}
// 		}
// 	}
// }


fn get_legal_moves(game_board GameBoard, origin_coords Coords) []Coords {
	origin_piece := game_board.table.at(origin_coords)
	mut legal_moves := []Coords{}
	for relative_coords in move_rules_map[origin_piece.map_key] {
		mut absolute_destination_coords := origin_coords + relative_coords.relative_coords
		for ;
		within_board(absolute_destination_coords)
			&& all_conditions_met(game_board,
								  origin_coords,
								  absolute_destination_coords,
								  relative_coords.conditions)
			&& king_not_attacked(game_board, origin_coords, absolute_destination_coords)
		;
		absolute_destination_coords += relative_coords.relative_coords
		{
			legal_moves << absolute_destination_coords
			if any_condition_met(game_board, origin_coords, absolute_destination_coords, legal_moves, relative_coords.break_conditions)
			{ break }
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

fn move_piece(mut game_board GameBoard, move Move) {
	move_sets(mut game_board, move)
	game_board.table[move.destination_coords.y][move.destination_coords.x] = game_board.table.at(move.origin_coords)
	game_board.table[move.origin_coords.y][move.origin_coords.x] = Piece {  }
	game_board.to_play = opposite_color(game_board.to_play)
}

fn move_piece_no_player_switch(mut game_board GameBoard, move Move) {
	game_board.table[move.destination_coords.y][move.destination_coords.x] = game_board.table.at(move.origin_coords)
	game_board.table[move.origin_coords.y][move.origin_coords.x] = Piece {  }
}

fn handle_origin_coords(mut app App, origin_coords Coords) {
	app.legal_moves = get_legal_moves(app.game_board, origin_coords)
	set_legal_moves_game_board(mut app.legal_moves_game_board, app.legal_moves)
	app.origin_coords = origin_coords
	app.selection_state = .destination_coords
}

fn pawn_moved_two_spaces(game_board [][]Piece, move Move) bool {
	return ((move.origin_coords.y == 6 && move.destination_coords.y == 4) ||
			(move.origin_coords.y == 1 && move.destination_coords.y == 3)) &&
		game_board.at(move.origin_coords).shape == .pawn
}

fn side_piece_is_opposite_color(game_board [][]Piece, move Move, offset int) bool {
	if within_board(Coords{move.destination_coords.y, move.destination_coords.x + offset}) {
		return game_board[move.destination_coords.y][move.destination_coords.x + offset].color == opposite_color(game_board.at(move.origin_coords).color)
	}
	return false
}

fn move_sets(mut game_board GameBoard, move Move) {
	piece := game_board.table.at(move.origin_coords)
	if piece.shape == .king {
		game_board.king_coords[piece.color.str()] = move.destination_coords
		game_board.oo[piece.color.str()] = false
		game_board.ooo[piece.color.str()] = false
	} if piece.shape == .king && piece.color == .black && move == Move{Coords{0, 4}, Coords{0, 6}} { // black king sides castling move
		move_piece_no_player_switch(mut game_board, Move{Coords{0, 7}, Coords{0, 5}})
	} else if piece.shape == .king && piece.color == .white && move == Move{Coords{7, 4}, Coords{7, 6}} { // white king side castling
		move_piece_no_player_switch(mut game_board, Move{Coords{7, 7}, Coords{7, 5}})
	} else if piece.shape == .king && piece.color == .black && move == Move{Coords{0, 4}, Coords{0, 2}} { // black queen side castling move
		move_piece_no_player_switch(mut game_board, Move{Coords{0, 0}, Coords{0, 3}})
	} else if piece.shape == .king && piece.color  == .white && move == Move{Coords{7, 4}, Coords{7, 2}} { // white queen side castling move
		move_piece_no_player_switch(mut game_board, Move{Coords{7, 0}, Coords{7, 3}})
	} else if piece.shape == .rook && (move.origin_coords == Coords{0, 0} || move.origin_coords == Coords{7, 0}) {
		game_board.ooo[piece.color.str()] = false
	} else if piece.shape == .rook && (move.origin_coords == Coords{0, 7} || move.origin_coords == Coords{7, 7}) {
		game_board.oo[piece.color.str()] = false
	} else if pawn_moved_two_spaces(game_board.table, move) && side_piece_is_opposite_color(game_board.table, move, -1) { // set en passant coords for next move
		game_board.en_passant = move.destination_coords
	} else if pawn_moved_two_spaces(game_board.table, move) && side_piece_is_opposite_color(game_board.table, move, 1) { //  set en passant coords for next move
		game_board.en_passant = move.destination_coords
	} else if piece.shape == .pawn && EnPassant(move.destination_coords + if piece.color == .white { Coords{ 1, 0} } else { Coords{ -1, 0} }) == game_board.en_passant { // made the en passant move
		capture_coords := move.destination_coords + if piece.color == .white { Coords{ 1, 0} } else { Coords{ -1, 0} }
		game_board.table[capture_coords.y][capture_coords.x] = Piece { }
	} else if game_board.en_passant != EnPassant(false) {
		game_board.en_passant = EnPassant(false)
	}
}

fn handle_destination_coords(mut app App, move Move) {
	move_piece(mut app.game_board, move)
	app.selection_state = .origin_coords
	// set_check(mut app.game_board)
}

fn handle_coords(mut app App, coords Coords) {
	if app.selection_state == .origin_coords && app.game_board.table.at(coords).color == app.game_board.to_play {
		handle_origin_coords(mut app, coords)
	} else if app.selection_state == .destination_coords && coords in app.legal_moves {
		handle_destination_coords(mut app, Move {app.origin_coords, coords})
		// player selects another one of his pieces:
	} else if app.selection_state == .destination_coords && app.game_board.table.at(coords).color == app.game_board.to_play {
		handle_origin_coords(mut app, coords)
	} else {
		app.selection_state = .origin_coords
	}
}
