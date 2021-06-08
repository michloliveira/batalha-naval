require "ruby2d"
require_relative "board"
require_relative "grid"

grid = Grid.new
grid.draw_grid

player_1_board = Board.new # tabuleiro do jogador
player_2_board = Board.new # tabuleiro do computador

#fazer controle de jogadas: hum. x comp.
on :mouse_down do |event|
  position = grid.board_position_clicked(event)
  player_1_board.map_click_on_grid_in_board(position[1], position[0])
  player_1_board.print_grid()
  #grid.clicked()
end

grid.show
