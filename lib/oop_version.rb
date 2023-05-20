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

  def friendly_at?(origin_y, origin_x, dest_y, dest_x)
    origin_piece = @state[origin_y][origin_x]
    dest_piece = @state[dest_y][dest_x]
    dest_piece != nil && origin_piece.color == dest_piece.color
  end

  def direction_clear?(origin, destination, y_inc, x_inc)
    path = []
    loop do
      origin[0] += y_inc
      origin[1] += x_inc
      break if origin[0] == destination[0]
      path << @state[origin[0]][origin[1]].nil?
    end
    path.all?
  end

  def diagonal_clear?(origin, destination)
    if destination[0] > origin[0] && destination[1] > origin[1]
      direction_clear?(origin, destination, 1, 1)
    elsif destination[0] > origin[0] && destination[1] < origin[1]
      direction_clear?(origin, destination, 1, -1)
    elsif destination[0] < origin[0] && destination[1] < origin[1]
      direction_clear?(origin, destination, -1, -1)
    elsif destination[0] < origin[0] && destination[1] > origin[1]
      direction_clear?(origin, destination, -1, 1)
    end
  end
end


class Piece
  attr_reader :origin, :destination, :piece_name, :color
  def initialize(piece_name, color)
    @piece_name = piece_name
    @color = color
    @destination = []
    @origin = []
  end

  def set_position(state)
    state.each do |row|
      if row.include? self
        @origin = state.index(row), row.index(self)
      end
    end
  end

  def set_destination(y, x)
    @destination = [y, x]
  end

  def set_diffs
    @diff1 = (@origin[0] - @destination[0]).abs
    @diff2 = (@origin[1] - @destination[1]).abs
  end

  def destination_in_bounds?
    @destination.all? { |n| n.between?(0, 7)}
  end

  def no_friendly_at_dest?(board)
    !board.friendly_at?(@origin[0], @origin[1], @destination[0], @destination[1])
  end

  def diagonal_clear?(board)
    board.diagonal_clear?(@origin, @destination)
  end
end

class Knight < Piece
  def legal_move?(board)
    set_diffs
    [@diff1, @diff2].sort == [1, 2] && destination_in_bounds? && no_friendly_at_dest?(board)
  end
end

class Bishop < Piece
  def legal_move?(board)
    set_diffs
    @diff1 == @diff2 && destination_in_bounds? && no_friendly_at_dest?(board)
  end
end

class Rook < Piece
  def legal_move?(board)
    set_diffs
    (@diff1.zero? || @diff2.zero?) && no_friendly_at_dest?(board) && destination_in_bounds?
  end
end

class Queen < Piece
  def legal_move?(board)
    set_diffs
    (@diff1 == @diff2 && destination_in_bounds? && no_friendly_at_dest?(board)) || (@diff1.zero? || @diff2.zero?) && no_friendly_at_dest?(board) && destination_in_bounds?
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

