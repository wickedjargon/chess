module main

import gg
import os
import gx

fn click(x f32, y f32, button gg.MouseButton, mut app App) {
	game_board := app.image_database['game_board_image'] or { panic('click function error') }
	game_board_width := game_board.width
	game_board_height := game_board.height
	// Check if the click is within the chessgame_board bounds
	if x < 0.0 || x > f32(game_board_width) || y < 0.0 || y > f32(game_board_height) {
		return
	}
	// Calculate the square indices based on the clicked coordinates
	square_size_y := f32(game_board_height) / f32(game_board_dimension)
	square_size_x := f32(game_board_width) / f32(game_board_dimension)
	mut y_coord := int(y / square_size_y)
	x_coord := int(x / square_size_x)
	if app.game_board.to_play == .black {
		// Flip the y_coord by subtracting it from the max_y_coord
		max_y_coord := app.game_board.table.len - 1
		y_coord = max_y_coord - y_coord
	}
	if y_coord < 0 || y_coord > 7 || x_coord < 0 || x_coord > 7 {
		return
	}
	handle_coords(mut app, Coords{y_coord, x_coord})
}

fn (mut app App) init_images_pieces(shapes []string, color string) ! {
	for shape in shapes {
		app.image_database['${color}_${shape}'] = app.gg.create_image(os.resource_abs_path('./assets/${color}_${shape}.png'))!
	}
}

fn on_event(e &gg.Event, mut app App) {
	if e.typ == .key_up {
		match e.key_code {
			.r { new_game(mut app) }
			.q { app.gg.quit() }
			else {}
		}
	}
}

fn (mut app App) init_images() ! {
	shapes := ['rook', 'knight', 'bishop', 'queen', 'king', 'pawn']
	app.init_images_pieces(shapes, 'black')!
	app.init_images_pieces(shapes, 'white')!
	app.image_database['game_board_image'] = app.gg.create_image(os.resource_abs_path('./assets/game_board_image.png'))!
	app.image_database['game_board_image_flipped'] = app.gg.create_image(os.resource_abs_path('./assets/game_board_image_flipped.png'))!
	app.image_database['circle'] = app.gg.create_image(os.resource_abs_path('./assets/circle.png'))!
	app.image_database['black_king_red'] = app.gg.create_image(os.resource_abs_path('./assets/black_king_red.png'))!
	app.image_database['white_king_red'] = app.gg.create_image(os.resource_abs_path('./assets/white_king_red.png'))!
}

fn (mut app App) init_images_wrapper() {
	app.init_images() or { panic('init_images_wrapper error') }
}

fn (app App) draw_game_board() {
	game_board_image := app.image_database['game_board_image'] or { panic('draw_game_board error') }
	app.gg.draw_image(0.0, 0.0, f32(game_board_image.width), f32(game_board_image.height),
		game_board_image)
}

fn (app App) draw_game_board_flipped() {
	game_board_image := app.image_database['game_board_image_flipped'] or { panic('draw_game_board_flipped error') }
	app.gg.draw_image(0.0, 0.0, f32(game_board_image.width), f32(game_board_image.height),
		game_board_image)
}

fn (app App) draw_pieces() {
	for y_coord, rows in app.game_board.table {
		for x_coord, piece in rows {
			if piece.shape != .empty_square {
				piece_image := app.image_database[piece.map_key] or { panic('draw_pieces error') }
				app.draw_piece_at_coordinate(piece_image, x_coord, y_coord)
			}
		}
	}
}

fn (app App) draw_pieces_flipped() {
	max_y_coord := app.game_board.table.len - 1
	for y_coord := max_y_coord; y_coord >= 0; y_coord-- {
		for x_coord, piece in app.game_board.table[y_coord] {
			if piece.shape != .empty_square {
				piece_image := app.image_database[piece.map_key] or { panic('draw_pieces_flipped error') }
				// Flip the y_coord by subtracting it from the max_y_coord
				flipped_y_coord := max_y_coord - y_coord
				app.draw_piece_at_coordinate(piece_image, x_coord, flipped_y_coord)
			}
		}
	}
}

fn (app App) draw_piece_at_coordinate(piece gg.Image, x int, y int) {
	game_board_image := app.image_database['game_board_image'] or { panic('draw_piece_at_coordinate error') }
	square_width := f32(game_board_image.width) / f32(game_board_dimension)
	square_height := f32(game_board_image.height) / f32(game_board_dimension)
	x_coord := square_width * f32(x) + (square_width - f32(piece.width)) / 2.0
	y_coord := square_height * f32(y) + (square_height - f32(piece.height)) / 2.0
	app.gg.draw_image(x_coord, y_coord, f32(piece.width), f32(piece.height), piece)
}

// saved-location-2
fn (app App) draw_legal_moves() {
	for y, rows in app.legal_moves_game_board {
		for x, cell in rows {
			if cell == true && app.game_board.table[y][x].shape != .king {
				piece_image := app.image_database['circle'] or { panic('draw_legal_moves error') }
				if app.game_board.to_play == .black {
					max_y_coord := app.legal_moves_game_board.len - 1
					flipped_y_coord := max_y_coord - y
					app.draw_piece_at_coordinate(piece_image, x, flipped_y_coord)
				} else {
					app.draw_piece_at_coordinate(piece_image, x, y)
				}
			}
		}
	}
}

fn frame(app &App) {
	app.gg.begin()
	if app.game_board.to_play == .black {
		app.draw_game_board_flipped()
		app.draw_pieces_flipped()
	} else {
		app.draw_game_board()
		app.draw_pieces()
	}
	if app.selection_state == .destination_coords {
		app.draw_legal_moves()
	}
	to_play := app.game_board.to_play
	if app.game_board.checkmate[to_play.str()] {
		app.gg.draw_text(0, 88*8, "${to_play.str()} is in checkmate", gx.TextCfg{color: gx.white, size: 50})
	} else if app.game_board.check[to_play.str()] {
		app.gg.draw_text(0, 88*8, "${to_play.str()} is in check", gx.TextCfg{color: gx.white, size: 50})
	}
	app.gg.end()
}
