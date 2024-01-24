module main

fn get_starting_pieces(color Color) []Piece {
	mut pieces := []Piece{}
	for i in 0 .. 5 {
		pieces << Piece{
			shape: unsafe { Shape(i) }
			color: color
		}
	}
	for i := 2; i >= 0; i-- {
		pieces << Piece{
			shape: unsafe { Shape(i) }
			color: color
		}
	}
	return pieces
}

fn set_pieces_back_rank(mut game_board [][]Piece, pieces []Piece, color Color, y_coord int) {
	for x_coord, piece in pieces {
		game_board[y_coord][x_coord] = piece
	}
}

fn set_pieces_pawns(mut game_board [][]Piece, color Color, y_coord int) {
	pawn := Piece{
		shape: .pawn
		color: color
	}
	for x_coord in 0 .. game_board_dimension {
		game_board[y_coord][x_coord] = pawn
	}
}

fn set_pieces(mut game_board [][]Piece) {
	// setup the back-rank pieces
	black_pieces := get_starting_pieces(Color.black)
	white_pieces := get_starting_pieces(Color.white)
	set_pieces_back_rank(mut game_board, black_pieces, .black, 0)
	set_pieces_back_rank(mut game_board, white_pieces, .black, 7)
	set_pieces_pawns(mut game_board, .black, 1)
	set_pieces_pawns(mut game_board, .white, 6)
}

fn new_game(mut app App) {
	app.selection_state = .origin_coords
	app.game_board.table = empty_game_board.clone()
	set_pieces(mut app.game_board.table)
	dump(app.game_board.table)
	app.game_board.current_player = .white
	// set_pieces_new_game(mut app.game_board)
	// set_map_keys(mut app.game_board)
}
