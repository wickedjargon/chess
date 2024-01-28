module main

fn opposite_color(color Color) Color {
	if color == .black {
		return Color.white
	} else if color == .white {
		return Color.black
	}
	return Color.not_set
}

fn within_board(absolute_destination_coords Coords) bool {
	return absolute_destination_coords.x >= 0
		&& absolute_destination_coords.x < game_board_dimension
		&& absolute_destination_coords.y >= 0
		&& absolute_destination_coords.y < game_board_dimension
}

fn all_conditions_met(game_board GameBoard, origin_coords Coords, destination_coords Coords, conditions []fn (GameBoard, Coords, Coords) bool ) bool {
	for condition in conditions {
		if condition(game_board, origin_coords, destination_coords) == false {
			return false
		}
	}
	return true
}

fn any_condition_met(game_board GameBoard, origin_coords Coords, destination_coords Coords, legal_moves []Coords, break_conditions []fn (GameBoard, Coords, Coords, []Coords) bool ) bool {
	for condition in break_conditions {
		if condition(game_board, origin_coords, destination_coords, legal_moves) == true {
			return true
		}
	}
	return false
}

// pre loop condition:


fn en_passant_white(game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	return EnPassant(destination_coords + Coords{1, 0}) == game_board.en_passant
}

fn en_passant_black(game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	return EnPassant(destination_coords + Coords{-1, 0}) == game_board.en_passant
}

fn origin_index_6_row(game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	return origin_coords.y == 6
}

fn origin_index_1_row(game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	return origin_coords.y == 1
}

fn destination_no_capture(game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	return game_board.table.at(destination_coords).color != opposite_color(game_board.table.at(origin_coords).color)
}


fn destination_capture(game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	return game_board.table.at(destination_coords).color == opposite_color(game_board.table.at(origin_coords).color)
}

fn destination_no_same_color(game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	return game_board.table.at(destination_coords).color != game_board.table.at(origin_coords).color
}

// casting: // update to account for king and rook attacks

fn black_oo (game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	return game_board.oo['black'] == true &&
		game_board.table.at(Coords{0, 5}).shape == .empty_square &&
		game_board.table.at(Coords{0, 6}).shape == .empty_square
}

fn white_oo (game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	return game_board.oo['white'] == true &&
		game_board.table.at(Coords{7, 5}).shape == .empty_square &&
		game_board.table.at(Coords{7, 6}).shape == .empty_square
}

fn black_ooo (game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	return game_board.ooo['black'] == true &&
		game_board.table.at(Coords{0, 1}).shape == .empty_square &&
		game_board.table.at(Coords{0, 2}).shape == .empty_square &&
		game_board.table.at(Coords{0, 3}).shape == .empty_square
}

fn white_ooo (game_board GameBoard, origin_coords Coords, destination_coords Coords) bool {
	return game_board.ooo['white'] == true &&
		game_board.table.at(Coords{7, 1}).shape == .empty_square &&
		game_board.table.at(Coords{7, 2}).shape == .empty_square &&
		game_board.table.at(Coords{7, 3}).shape == .empty_square
}

// post loop conditions:

fn only_one(game_board GameBoard, origin_coords Coords, destination_coords Coords, legal_moves []Coords) bool {
	return true
}


fn last_legal_was_capture(game_board GameBoard, origin_coords Coords, destination_coords Coords, legal_moves []Coords) bool {
	if legal_moves.len == 0 {
		return false
	}
	last_legal_coords := legal_moves[legal_moves.len - 1]
	if game_board.table.at(last_legal_coords).color in [Color.white, Color.black] {
		return true
	}
	return false
}

// self check:
