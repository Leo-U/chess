# Make Board, but initialize Piece instances in the 2d array.

class Board
  attr_reader :state
  def initialize
    @state =  8.times.map { 8.times.map { nil } }
  end

  def add_piece(piece, y, x)
    @state[y][x] = piece
    @state[y][x].set_position(@state)
  end

  # delete or refactor
  def add_first_rank(rank, color)
    pieces = ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R']
    @state[rank].each_index do |i|
      add_piece(Piece.new(pieces[i], 'black'), rank, i)
    end
  end

  def make_move(origin_y, origin_x, dest_y, dest_x)
    piece = @state[origin_y][origin_x]
    piece.set_destination(dest_y, dest_x)
    if piece.legal_move?
      @state[dest_y][dest_x] = piece
      @state[origin_y][origin_x] = nil
    end
  end

end


class Piece
  attr_reader :position, :destination, :piece_name
  def initialize(piece_name, color)
    @piece_name = piece_name
    @color = color
    @destination = []
    @position = []
  end

  def set_position(state)
    state.each do |row|
      if row.include? self
        @position = state.index(row), row.index(self)
      end
    end
  end

  def set_destination(y, x)
    @destination = [y, x]
  end

  def set_diffs
    @diff1 = (@position[0] - @destination[0]).abs
    @diff2 = (@position[1] - @destination[1]).abs
  end

  def in_bounds?
    @destination.all? { |n| n.between?(0, 7)}
  end
end

class Knight < Piece
  def legal_move?
    set_diffs
    [@diff1, @diff2].sort == [1, 2] && in_bounds?
  end
end

class Bishop < Piece
  def legal_move?
    set_diffs
    @diff1 == @diff2 && in_bounds?
  end
end

def shitty_print_board(board)
  board.state.each do |row|
    row.each do |entry|
      print entry.nil? ? "nil, " : "#{entry.piece_name}, "
    end
    puts "\n"
  end
end



board = Board.new

board.add_piece(Bishop.new('Bsh', 'black'), 0, 7)
puts 'before move:'
shitty_print_board(board)
board.make_move(0, 7, 2, 5)
puts 'after move:'
shitty_print_board(board)




