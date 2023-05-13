# Make Board, but initialize Piece instances in the 2d array.

class Board
  attr_reader :state
  def initialize
    @state =  8.times.map { 8.times.map { nil } }
  end

  def add_piece(piece, x, y)
    @state[x][y] = piece
  end

  def add_first_rank(rank, color)
    pieces = ['R', 'N', 'B', 'Q', 'K', 'B', 'N', 'R']
    @state[rank].each_index do |i|
      add_piece(Piece.new(pieces[i], 'black'), rank, i)
    end
  end

end


class Piece
  def initialize(piece_name, color)
    @piece_name = piece_name
    @color = color
  end

  def position(state)
    state.each do |row|
      if row.include? self
        return state.index(row), row.index(self)
      end
    end
  end
end

class Knight
  def initialize(piece_name, color)
    @piece_name = piece_name
    @color = color
  end
end



board = Board.new
board.add_first_rank(0, 'black')
pp board.state
p board.state[0][1].return_position(board.state)