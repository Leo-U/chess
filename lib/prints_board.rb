class Board
  attr_reader :board, :red, :black
  
  def initialize
    @dark_bg = "\e[48;5;253m"
    @light_bg = "\e[48;5;231m"
    @black_fg = "\e[30m"
    @red_fg = "\e[31m"
    @reset = "\e[0m"
    @blank = '   '

    @red = {
      K: '♚',
      Q: '♛',
      R: '♜',
      B: '♝',
      N: '♞',
      P: '♟︎',
    }.transform_values{ |value| @red_fg + value }

    @black = @red.transform_values{ |value| @black_fg + value[5..-1] }

    @pawns = [' ♟︎ ' * 8]

  end

  def build_empty_board
    @board = Array.new(8) do |row_i|
      Array.new(8) do |el_i|
        (row_i.even? == el_i.even? ? @light_bg : @dark_bg) + @blank + @reset
      end
    end
  end
  
  def build_back_rank(color, rank)
    [:R, :N, :B, :Q, :K, :B, :N, :R].each do |symbol|
      @board[rank].each do |square|
        square[-6] = color[symbol]
      end
    end
  end

  def build_second_rank(color, rank)
    @board[rank].each do |square|
      square[-6] = color[:P]
    end
  end

  def print_board(rank = 9, letters = ('  a'..'  h'))
    print ' ', *letters, "\n"
    @board.each do |row|
      print rank -= 1, ' ' 
      row.each do |entry|
        print entry
      end
      print ' ', rank, "\n"
    end
    print ' ', *letters, "\n"
  end

  def build_starting_position
    build_empty_board
    build_back_rank(@black, 0)
    build_back_rank(@red, 7)
    build_second_rank(black, 1)
    build_second_rank(red, 6)
  end

end

class Piece
  # contains legal move logic -- an is_legal? method -- takes coord arg & returns true or false
  # has color attribute
  # instantiates anywhere on the board.
end

class Game
  # contains looping script to play game
end


# print_middle(dark_bg, light_bg, reset, pieces[:blank])
# puts 'a b c d e f g h'

board = Board.new
board.build_starting_position
board.print_board
