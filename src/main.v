module main

import gg
import os

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
	color Color
	shape Shape
}

enum SelectionState {
	origin_coords
	destination_coords
}

struct GameBoard {
	mut:
	table [][]Piece
	current_player Color
	selection_state SelectionState
}

struct App {
	mut:
	gg                     &gg.Context = unsafe { nil }
	image_database         map[string]gg.Image
	game_board             GameBoard
	selection_state        SelectionState
}

fn main() {
	mut app := &App{}
	new_game(mut app)
	app.gg = gg.new_context(
		user_data: app
		window_title: 'Chess'
		// init_fn: app.init_images_wrapper
		// width: 1000
		// height: 1000
		// click_fn: click
		// frame_fn: frame
		// event_fn: on_event
	)
	app.gg.run()
}
