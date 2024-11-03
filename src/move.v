module main

const white_oo_move = Move{Coords{7, 4}, Coords{7, 6}}
const black_oo_move = Move{Coords{0, 4}, Coords{0, 6}}

struct RelativeCoords {
	relative_coords	 Coords
	conditions		 []fn (GameBoard, Coords, Coords) bool
	break_conditions []fn (GameBoard, Coords, Coords, []Coords) bool
}

struct Attack {
	relative_coords_list []Coords
	shapes []Shape
}

struct Coords { y int x int }

fn (a Coords) + (b Coords) Coords {
	return Coords {a.y + b.y, a.x + b.x}
}

fn (a Coords) - (b Coords) Coords {
	return Coords {a.y - b.y, a.x - b.x}
}

struct Move { origin_coords Coords destination_coords Coords }

fn coords_attacked(game_board [][]Piece, attacking_color Color, coords Coords) bool {
	attacked_color := opposite_color(attacking_color)

	for attack in attacks {
		for relative_coords in attack.relative_coords_list {
			mut absolute_coords := coords
			for within_board(absolute_coords) {
				// Create new Coords to move to the next cell
				next_coords := Coords{
					x: absolute_coords.x + relative_coords.x
					y: absolute_coords.y + relative_coords.y
				}

				// Update absolute_coords to next_coords
				absolute_coords = next_coords

				// Check if we're  gone out of bounds
				if !within_board(absolute_coords) {
					break
				}

				piece := game_board[absolute_coords.y][absolute_coords.x] // Access piece at the new location

				// If we hit an opponent's piece, stop looking further in this direction
				if piece.color == attacked_color {
					break
				}

				// If we hit the attacking color's piece and it can attack in this direction
				if piece.color == attacking_color && piece.shape in attack.shapes {
					return true
				}

				// Break after checking one square for short-range attackers
				if Shape.pawn in attack.shapes || Shape.knight in attack.shapes || Shape.king in attack.shapes {
					break
				}

				// If any piece is blocking further movement, we should break
				if piece.color != .not_set {
					break
				}
			}
		}
	}
	return false
}

fn get_legal_moves(game_board GameBoard, origin_coords Coords) []Coords {
	origin_piece := game_board.table.at(origin_coords)
	mut legal_moves := []Coords{}
	for relative_coords in move_rules_map[origin_piece.map_key] {
		for absolute_destination_coords := origin_coords + relative_coords.relative_coords ;
		within_board(absolute_destination_coords)
			&& all_conditions_met(game_board,
								  origin_coords,
								  absolute_destination_coords,
								  relative_coords.conditions) ;
		absolute_destination_coords += relative_coords.relative_coords
		{
			if !king_attacked(game_board, origin_coords, absolute_destination_coords) { // prevents player from checking himself
				legal_moves << absolute_destination_coords
			}
			if any_condition_met(game_board, origin_coords, absolute_destination_coords, legal_moves, relative_coords.break_conditions)
			{ break }
		}
	}
	return legal_moves
}


fn set_legal_moves_game_board(mut legal_moves_game_board [][]bool, legal_moves []Coords) {
	for _, mut row in legal_moves_game_board {
		for _, mut cell in row {
			cell = false
		}
	}
	for legal_move in legal_moves {
		legal_moves_game_board[legal_move.y][legal_move.x] = true
	}
}

fn move_piece(mut game_board GameBoard, move Move) {
	game_board.table[move.destination_coords.y][move.destination_coords.x] = game_board.table.at(move.origin_coords)
	game_board.table[move.origin_coords.y][move.origin_coords.x] = Piece {	}
	move_sets(mut game_board, move)
	game_board.to_play = opposite_color(game_board.to_play)
}

fn move_piece_no_sets(mut game_board GameBoard, move Move) {
	game_board.table[move.destination_coords.y][move.destination_coords.x] = game_board.table.at(move.origin_coords)
	game_board.table[move.origin_coords.y][move.origin_coords.x] = Piece {	}
}

fn handle_origin_coords(mut app App, origin_coords Coords) {
	app.legal_moves = get_legal_moves(app.game_board, origin_coords)
	set_legal_moves_game_board(mut app.legal_moves_game_board, app.legal_moves)
	app.origin_coords = origin_coords
	app.selection_state = .destination_coords
}

fn king_attacked(game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	move := Move{origin_coords, destination_coords}
	mut game_board_tmp := GameBoard {
		table:		 game_board.table.clone()
		to_play:	 game_board.to_play
		oo:			 game_board.oo.clone()
		ooo:		 game_board.ooo.clone()
		en_passant:	 game_board.en_passant
		king_coords: game_board.king_coords.clone()
	}
	move_piece(mut game_board_tmp, move)
	coords := game_board_tmp.king_coords[opposite_color(game_board_tmp.to_play).str()]
	attacking_color := game_board_tmp.to_play
	return coords_attacked(game_board_tmp.table, attacking_color, coords)
}

fn handle_destination_coords(mut app App, move Move) {
	move_piece(mut app.game_board, move)
	set_check(mut app.game_board)
	if is_stalemate(app.game_board, app.game_board.to_play) {
		app.game_board.stalemate[app.game_board.to_play.str()] = true
	} else {
		app.game_board.stalemate[app.game_board.to_play.str()] = true
	}
	app.selection_state = .origin_coords
}

fn set_check(mut game_board GameBoard) {
	if coords_attacked(game_board.table, opposite_color(game_board.to_play), game_board.king_coords[game_board.to_play.str()]) {
		game_board.check[game_board.to_play.str()] = true
		if is_checkmate(game_board, game_board.to_play) {
			game_board.checkmate[game_board.to_play.str()] = true
		} else {
			game_board.checkmate[game_board.to_play.str()] = false
		}
	} else {
		game_board.check[game_board.to_play.str()] = false
		game_board.checkmate[game_board.to_play.str()] = false
	}
}

fn is_checkmate(game_board GameBoard, color Color) bool {
	king_coords := game_board.king_coords[color.str()]
	if !coords_attacked(game_board.table, opposite_color(color), king_coords) {
		return false
	}
	if get_legal_moves(game_board, king_coords).len == 0 {
		return true
	}
	return false
}

fn is_stalemate(game_board GameBoard, color Color) bool {
	for y, row in game_board.table {
		for x, piece in row {
			if piece.color == color {
				origin_coords := Coords{y, x}
				legal_moves := get_legal_moves(game_board, origin_coords)
				if legal_moves.len > 0 {
					return false
				}
			}
		}
	}
	return true
}

fn pawn_moved_two_spaces(game_board [][]Piece, move Move) bool {
	return ((move.origin_coords.y == 6 && move.destination_coords.y == 4) ||
			(move.origin_coords.y == 1 && move.destination_coords.y == 3)) &&
		game_board.at(move.destination_coords).shape == .pawn
}

fn side_piece_is_opposite_color(game_board [][]Piece, move Move, offset int) bool {
	if within_board(Coords{move.destination_coords.y, move.destination_coords.x + offset}) {
		return game_board[move.destination_coords.y][move.destination_coords.x + offset].color == opposite_color(game_board.at(move.origin_coords).color)
	}
	return false
}

fn move_sets(mut game_board GameBoard, move Move) {
	piece := game_board.table.at(move.destination_coords)
	if piece.shape == .king {
		game_board.king_coords[piece.color.str()] = move.destination_coords
		game_board.oo[piece.color.str()] = false
		game_board.ooo[piece.color.str()] = false
	} if piece.shape == .king && piece.color == .black && move == Move{Coords{0, 4}, Coords{0, 6}} { // black king sides castling move
		move_piece_no_sets(mut game_board, Move{Coords{0, 7}, Coords{0, 5}})
	} else if piece.shape == .king && piece.color == .white && move == Move{Coords{7, 4}, Coords{7, 6}} { // white king side castling
		move_piece_no_sets(mut game_board, Move{Coords{7, 7}, Coords{7, 5}})
	} else if piece.shape == .king && piece.color == .black && move == Move{Coords{0, 4}, Coords{0, 2}} { // black queen side castling move
		move_piece_no_sets(mut game_board, Move{Coords{0, 0}, Coords{0, 3}})
	} else if piece.shape == .king && piece.color  == .white && move == Move{Coords{7, 4}, Coords{7, 2}} { // white queen side castling move
		move_piece_no_sets(mut game_board, Move{Coords{7, 0}, Coords{7, 3}})
	} else if piece.shape == .rook && (move.origin_coords == Coords{0, 0} || move.origin_coords == Coords{7, 0}) { // rook move sets oo/ooo (castling) to false
		game_board.ooo[piece.color.str()] = false
	} else if piece.shape == .rook && (move.origin_coords == Coords{0, 7} || move.origin_coords == Coords{7, 7}) { // rook move sets oo/ooo (castling) to false
		game_board.oo[piece.color.str()] = false
	} else if ((piece.shape == .pawn) && (move.destination_coords.y == 7)) || ((piece.shape == .pawn) && (move.destination_coords.y == 0)) {
		//
		game_board.table[move.destination_coords.y][move.destination_coords.x] = Piece { shape: .queen, color: piece.color, map_key: "${piece.color}_queen" } // pawn auto queen
	}
	if pawn_moved_two_spaces(game_board.table, move) && side_piece_is_opposite_color(game_board.table, move, -1) { // set en passant coords for next move
		game_board.en_passant = move.destination_coords
	} else if pawn_moved_two_spaces(game_board.table, move) && side_piece_is_opposite_color(game_board.table, move, 1) { //	 set en passant coords for next move
		game_board.en_passant = move.destination_coords
	} else if piece.shape == .pawn && EnPassant(move.destination_coords + if piece.color == .white { Coords{ 1, 0} } else { Coords{ -1, 0} }) == game_board.en_passant { // made the en passant move
		capture_coords := move.destination_coords + if piece.color == .white { Coords{ 1, 0} } else { Coords{ -1, 0} }
		game_board.table[capture_coords.y][capture_coords.x] = Piece { }
	} else if game_board.en_passant != EnPassant(false) {
		game_board.en_passant = EnPassant(false)
	}
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
