module main

const game_board_dimension = 8
const empty_game_board = [][]Piece{len: game_board_dimension, cap: game_board_dimension, init: []Piece{len: game_board_dimension, cap: game_board_dimension, init: Piece{shape: .empty_square map_key: 'empty_square'}}}
const empty_legal_moves_game_board = [][]bool{len: game_board_dimension, cap: game_board_dimension, init: []bool{len: game_board_dimension, cap: game_board_dimension, init: false}}
const white_oo_move = Move{Coords{7, 4}, Coords{7, 6}}
const black_oo_move = Move{Coords{0, 4}, Coords{0, 6}}


const relative_coords_map := {
	'black_rook':   [
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 0
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 0
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
	]
	'white_rook':   [
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 0
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 0
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
	]
	'black_knight': [
		RelativeCoords{
			relative_coords: Coords{
				y: 2
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 2
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -2
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -2
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 2
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 2
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: -2
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: -2
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
	]
	'white_knight': [
		RelativeCoords{
			relative_coords: Coords{
				y: 2
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 2
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -2
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -2
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 2
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 2
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: -2
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: -2
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
	]
	'black_bishop': [
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
	]
	'white_bishop': [
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
	]
	'black_queen':  [
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 0
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 0
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
	]
	'white_queen':  [
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 0
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 0
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [last_legal_was_capture]
		},
	]
	'black_king':   [
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 0
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 0
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: 2
			}
			conditions: [black_oo]
			break_conditions: [only_one]
		},
	]
	'white_king':   [
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 0
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 0
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: 1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 0
				x: -1
			}
			conditions: [destination_no_same_color]
			break_conditions: [only_one]
		},
	]
	'black_pawn':   [
		RelativeCoords{
			relative_coords: Coords{
				y: 2
				x: 0
			}
			conditions: [destination_no_same_color, origin_index_1_row,
				destination_no_capture]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 0
			}
			conditions: [destination_no_same_color, destination_no_capture]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: 1
			}
			conditions: [destination_no_same_color, destination_capture]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: 1
				x: -1
			}
			conditions: [destination_no_same_color, destination_capture]
			break_conditions: [only_one]
		},
	]
	'white_pawn':   [
		RelativeCoords{
			relative_coords: Coords{
				y: -2
				x: 0
			}
			conditions: [destination_no_same_color, origin_index_6_row,
				destination_no_capture]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 0
			}
			conditions: [destination_no_same_color, destination_no_capture]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: -1
			}
			conditions: [destination_no_same_color, destination_capture]
			break_conditions: [only_one]
		},
		RelativeCoords{
			relative_coords: Coords{
				y: -1
				x: 1
			}
			conditions: [destination_no_same_color, destination_capture]
			break_conditions: [only_one]
		},
	]
}
