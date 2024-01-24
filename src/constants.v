module main

const game_board_dimension = 8
const empty_game_board = [][]Piece{len: game_board_dimension, cap: game_board_dimension, init: []Piece{len: game_board_dimension, cap: game_board_dimension, init: Piece{shape: .empty_square}}}
const empty_legal_moves_game_board = [][]bool{len: game_board_dimension, cap: game_board_dimension, init: []bool{len: game_board_dimension, cap: game_board_dimension, init: false}}
