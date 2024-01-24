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

fn set_pieces_new_game(mut game_board [][]Piece) {
	// setup the back-rank pieces
	black_pieces := get_starting_pieces(Color.black)
	mut y_coord := 0
	for x_coord, piece in black_pieces {
		game_board[y_coord][x_coord] = piece
	}
	y_coord = 7
	white_pieces := get_starting_pieces(Color.white)
	for x_coord, piece in white_pieces {
		game_board[y_coord][x_coord] = piece
	}

	// setup the pawn pieces
	y_coord = 1
	black_pawn := Piece{
		shape: .pawn
		color: .black
	}
	for x_coord in 0 .. game_board_dimension {
		game_board[y_coord][x_coord] = black_pawn
	}
	y_coord = 6
	white_pawn := Piece{
		shape: .pawn
		color: .white
	}
	for x_coord in 0 .. game_board_dimension {
		game_board[y_coord][x_coord] = white_pawn
	}
}

fn new_game(mut app App) {
	app.selection_state = .origin_coords
	app.game_board.table = empty_game_board.clone()
	set_pieces_new_game(mut app.game_board.table)
	dump(app.game_board.table)
	app.game_board.current_player = .white
	// set_pieces_new_game(mut app.game_board)
	// set_map_keys(mut app.game_board)
}
