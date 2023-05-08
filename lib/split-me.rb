class Board
  attr_accessor :board
  # 2d array with board state
  def initialize
    @dark_bg = "\e[48;5;253m"
    @light_bg = "\e[48;5;231m"
    @black_fg = "\e[30m"
    @red_fg = "\e[31m"
    @reset = "\e[0m"
    @blank = '   '

    @red = {
      K: ' ♚ ',
      Q: ' ♛ ',
      R: ' ♜ ',
      B: ' ♝ ',
      N: ' ♞ ',
      P: ' ♟︎ ',
    }.transform_values{ |value| @red_fg + value + @reset }

    @black = @red.transform_values{ |value| @black_fg + value[5..-1] }

    # @row = array = Array.new(8) { |i| i.even? ? @light_bg + @blank + @reset : @dark_bg + @blank + @reset }
    
    # @board = [@row, @row.reverse] * 4

    @home = [' ♜ ', ' ♞ ', ' ♝ ', ' ♛ ', ' ♚ ', ' ♝ ', ' ♞ ', ' ♜ ']
    @pawns = [' ♟︎ ' * 8]

  end

  def empty_board
    @board = Array.new(8) do |row_i|
      Array.new(8) do |el_i|
        (row_i.even? == el_i.even? ? @light_bg : @dark_bg) + @blank + @reset
      end
    end
  end
  

  def print_board
    @board.each do |row|
      row.each do |entry|
        print entry
      end
      puts ''
    end
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

# dark_bg = "\e[48;5;253m"
# light_bg = "\e[48;5;231m"
# black_fg = "\e[30m"
# red_fg = "\e[31m"


# reset = "\e[0m"



# def print_row(d, l, r, piece)
#   4.times { print l + d + piece + r}
#   print r
#   puts ''
# end

# def print_middle(d, l, r, piece)
#   4.times do
#     print_row(d, l, r, piece)
#     print_row(l, d, r, piece)
#   end
# end

# print_middle(dark_bg, light_bg, reset, pieces[:blank])
# puts 'a b c d e f g h'

board = Board.new
board.empty_board
board.board[0][0][-6] = 'z'
board.print_board
pp board.board[0][0][-6]