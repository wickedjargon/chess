module main

fn new_game(mut app App) {
	app.selection_state = .origin_coords
	app.game_board.table = empty_game_board.clone()
	app.game_board.current_player = .white
	// set_pieces_new_game(mut app.game_board)
	// set_map_keys(mut app.game_board)
}
