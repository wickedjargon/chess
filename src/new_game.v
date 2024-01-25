module main

fn get_starting_pieces(color Color) []Piece {
	mut pieces := []Piece{}
	for i in 0 .. 5 {
		shape := unsafe { Shape(i) }
		pieces << Piece{
			shape: shape
			color: color
			map_key: '${color.str()}_${shape.str()}'
		}
	}
	for i := 2; i >= 0; i-- {
		shape := unsafe { Shape(i) }
		pieces << Piece{
			shape: shape
			color: color
			map_key: '${color.str()}_${shape.str()}'
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
		map_key: '${color}_pawn'
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
	app.legal_moves_game_board = empty_legal_moves_game_board.clone()
	app.game_board.to_play = .white
	app.game_board.oo['white'] = true
	app.game_board.oo['black'] = true
	app.game_board.ooo['white'] = true
	app.game_board.ooo['black'] = true
	app.game_board.en_passant = EnPassant(false)

	set_pieces(mut app.game_board.table)
}
