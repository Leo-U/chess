# Make Board, but initialize Piece instances in the 2d array.

class Board
  attr_reader :state
  def initialize
    @state =  8.times.map { 8.times.map { nil } }
  end

  def add_piece(piece, y, x)
    @state[x][y] = piece
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
  def initialize(piece_name, color)
    @piece_name = piece_name
    @color = color
  end
end

class Knight
  attr_reader :position, :destination
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

  def legal_move?
    diff1 = (@position[0] - @destination[0]).abs
    diff2 = (@position[1] - @destination[1]).abs
    [diff1, diff2].sort == [1, 2] && destination.none? { |n| n < 0 }
  end

end



board = Board.new
#board.add_first_rank(0, 'black')
board.add_piece(Knight.new('knight', 'black'), 0, 0)
pp board.state
#board.state[0][0].set_position(board.state)
p board.state[0][0].position
board.state[0][0].set_destination(1, 2)
p board.state[0][0].destination
p board.state[0][0].legal_move?