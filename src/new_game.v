module main

const game_board_dimension = 8
const empty_game_board = [][]Piece{len: game_board_dimension, cap: game_board_dimension, init: []Piece{len: game_board_dimension, cap: game_board_dimension, init: Piece{shape: .empty_square map_key: 'empty_square'}}}
const empty_legal_moves_game_board = [][]bool{len: game_board_dimension, cap: game_board_dimension, init: []bool{len: game_board_dimension, cap: game_board_dimension, init: false}}

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

fn set_game_board(mut game_board GameBoard) {
	game_board.to_play = .white
	game_board.table = empty_game_board.clone()
	game_board.oo['white'] = true
	game_board.oo['black'] = true
	game_board.ooo['white'] = true
	game_board.ooo['black'] = true
	game_board.en_passant = EnPassant(false)
	game_board.king_coords['black'] = Coords{0, 4}
	game_board.king_coords['white'] = Coords{7, 4}
	game_board.check['white'] = false
	game_board.check['black'] = false
	game_board.checkmate['white'] = false
	game_board.checkmate['black'] = false
}

fn new_game(mut app App) {
	app.selection_state = .origin_coords
	app.legal_moves_game_board = empty_legal_moves_game_board.clone()
	set_game_board(mut app.game_board)
	set_pieces(mut app.game_board.table)
}
