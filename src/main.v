module main

import gg

enum Color {
	not_set
	white
	black
}

enum Shape {
	empty_square = -1
	rook
	knight
	bishop
	queen
	king
	pawn
}

struct Piece {
	color Color = .not_set
	shape Shape = .empty_square
	map_key string = 'empty_square'
}

enum SelectionState {
	origin_coords
	destination_coords
}

type EnPassant = Coords | bool

struct GameBoard {
	mut:
	table [][]Piece
	to_play Color
	oo       map[string]bool
	ooo      map[string]bool
	en_passant EnPassant // a pawn's coords that can be captured next turn via en passant rule
	king_coords            map[string]Coords
}

struct App {
	mut:
	gg                     &gg.Context = unsafe { nil }
	image_database         map[string]gg.Image
	game_board             GameBoard
	legal_moves            []Coords
	self_check_game_board  [][]Piece
	legal_moves_game_board [][]bool
	selection_state        SelectionState
	origin_coords          Coords
}

fn main() {
	mut app := &App{}
	new_game(mut app)
	app.gg = gg.new_context(
		user_data: app
		window_title: 'Chess'
		init_fn: app.init_images_wrapper
		click_fn: click
		frame_fn: frame
		event_fn: on_event
	)
	app.gg.run()
}
