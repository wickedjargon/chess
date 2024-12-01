module main

const move_rules_map = {
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
        RelativeCoords{
            relative_coords: Coords{
                y: 0
                x: -2
            }
            conditions: [black_ooo]
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
        RelativeCoords{
            relative_coords: Coords{
                y: 0
                x: 2
            }
            conditions: [white_oo]
            break_conditions: [only_one]
        },
        RelativeCoords{
            relative_coords: Coords{
                y: 0
                x: -2
            }
            conditions: [white_ooo]
            break_conditions: [only_one]
        },
    ]
    'black_pawn':   [
        RelativeCoords{
            relative_coords: Coords{
                y: 2
                x: 0
            }
            conditions: [destination_no_same_color, origin_index_1_row, destination_no_capture, black_cant_jump_over]
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
            conditions: [destination_capture]
            break_conditions: [only_one]
        },
        RelativeCoords{
            relative_coords: Coords{
                y: 1
                x: -1
            }
            conditions: [destination_capture]
            break_conditions: [only_one]
        },
        RelativeCoords{
            relative_coords: Coords{
                y: 1
                x: -1
            }
            conditions: [en_passant_black]
            break_conditions: [only_one]
        },
        RelativeCoords{
            relative_coords: Coords{
                y: 1
                x: 1
            }
            conditions: [en_passant_black]
            break_conditions: [only_one]
        },
    ]
    'white_pawn':   [
        RelativeCoords{
            relative_coords: Coords{
                y: -2
                x: 0
            }
            conditions: [destination_no_same_color, origin_index_6_row, destination_no_capture, white_cant_jump_over]
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
            conditions: [destination_capture]
            break_conditions: [only_one]
        },
        RelativeCoords{
            relative_coords: Coords{
                y: -1
                x: 1
            }
            conditions: [destination_capture]
            break_conditions: [only_one]
        },
        RelativeCoords{
            relative_coords: Coords{
                y: -1
                x: -1
            }
            conditions: [en_passant_white] // en passant
            break_conditions: [only_one]
        },
        RelativeCoords{
            relative_coords: Coords{
                y: -1
                x: 1
            }
            conditions: [en_passant_white] // en passant
            break_conditions: [only_one]
        },
    ]
}

const attacks =
      [
          Attack {
              relative_coords_list: [Coords{1, 0}, Coords{-1, 0}, Coords{0, 1}, Coords{0, -1}]
              shapes: [.rook, .queen]
          },
          Attack {
              relative_coords_list: [Coords{1, 1}, Coords{-1, -1}, Coords{1, -1}, Coords{-1, 1}]
              shapes: [.bishop, .queen]
          },
          Attack {
              relative_coords_list: [
                  Coords{1, 0},
                  Coords{-1, 0},
                  Coords{0, 1},
                  Coords{0, -1},
                  Coords{1, 1},
                  Coords{-1, -1},
                  Coords{1, -1},
                  Coords{-1, 1}
              ]
              shapes: [.king]
          },
          Attack {
              relative_coords_list: [Coords{-1, -1}, Coords{-1, 1}]
              shapes: [.pawn]
          },
          Attack {
              relative_coords_list: [Coords{1, -1}, Coords{1, 1}]
              shapes: [.pawn]
          },
          Attack {
              relative_coords_list: [
                  Coords{2, -1},
                  Coords{2, 1},
                  Coords{-2, -1},
                  Coords{-2, 1},
                  Coords{-1, 2},
                  Coords{1, 2},
                  Coords{-1, -2}
                  Coords{1, -2}
              ]
              shapes: [.knight]
          },
      ]
