require "ruby2d"

# classe para representar um tabuleiro
class Board < Square
  attr_accessor :board

  def initialize
    @board = [[], [], [], [], [], [], [], [], [], []]

    for i in 0..9
      for j in 0..9
        @board[i][j] = 0
      end
    end
  end

  def map_click_on_grid_in_board(x, y)
    @board[x][y] = 1
  end

  # for tests only
  def print_grid
    for i in 0..9
      for j in 0..9
        print @board[i][j].to_s + " "
      end
      puts
    end
    puts
  end
end
