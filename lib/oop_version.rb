class Board
  attr_reader :state, :pieces
  def initialize
    @state =  8.times.map { 8.times.map { nil } }
    @pieces = ['Rook', 'Knight', 'Bishop', 'Queen', 'King', 'Bishop', 'Knight', 'Rook']
  end

  def add_piece(piece, y, x)
    @state[y][x] = piece
    @state[y][x].set_position(@state)
  end

  def create_piece(name, color)
    label = color == 'black' ? name.downcase : name
    Object.const_get(name).new(label.slice(0, 3), color)
  end

  def add_home_rank(rank, color)
    @state[rank].each_index do |i|
      add_piece(create_piece(@pieces[i], color), rank, i)
    end
  end

  def add_pawn_rank(rank, color)
    @state[rank].each_index do |i|
      add_piece(create_piece('Pawn', color), rank, i)
    end
  end

  def setup_board
    add_home_rank(0, 'black')
    add_pawn_rank(1, 'black')
    add_pawn_rank(6, 'white')
    add_home_rank(7, 'white')
  end

  def reset_piece_state(piece)
    piece.set_position(@state)
    piece.unmoved = false
    @state.each do |row|
      row.each do |el|
        el.unset_moved if el.instance_of?(Pawn)
      end
    end
  end

  def set_piece_state(piece, dest_y, dest_x)
    piece.set_destination(dest_y, dest_x)
    piece.set_position(@state)
  end

  def set_nil(piece, origin_y, origin_x, dest_x)
    @state[origin_y][dest_x] = nil if piece.instance_of?(Pawn) && @state[origin_y][dest_x].instance_of?(Pawn) && @state[origin_y][dest_x].moved_two
    @state[origin_y][origin_x] = nil
  end

  def make_move(origin_y, origin_x, dest_y, dest_x)
    piece = @state[origin_y][origin_x]
    set_piece_state(piece, dest_y, dest_x)
    if piece.legal_move?(self)
      @state[dest_y][dest_x] = piece
      set_nil(piece, origin_y, origin_x, dest_x)
    end
    reset_piece_state(piece)
    piece.set_moved_two if piece.instance_of?(Pawn) && (origin_y - dest_y).abs == 2
  end

  def piece_at?(color, dest_y, dest_x, side)
    dest_piece = @state[dest_y][dest_x]
    dest_piece != nil && (side == 'friendly' ? color == dest_piece.color : color != dest_piece.color)
  end

  def direction_clear?(origin, destination, y_inc, x_inc, y = origin[0], x = origin[1])
    path = []
    loop do
      y += y_inc
      x += x_inc
      break if [y, x] == destination || !y.between?(0, 7) || !x.between?(0, 7)
      path << @state[y][x].nil?
    end
    path.all?
  end

  def diagonal_clear?(origin, destination)
    destination[0] > origin[0] ? inc_y = 1 : inc_y = -1
    destination[1] > origin[1] ? inc_x = 1 : inc_x = -1
    direction_clear?(origin, destination, inc_y, inc_x)
  end

  def horizontal_clear?(origin, destination)
    if destination[0] != origin[0]
      inc_x = 0
      inc_y = destination[0] > origin[0] ? 1 : -1
    else
      inc_y = 0
      inc_x = destination[1] > origin[1] ? 1 : -1
    end
    direction_clear?(origin, destination, inc_y, inc_x)
  end

  def square_safe?(king, dest_y, dest_x)
    opponent_pieces = @state.flatten.select { |el| el.is_a?(Piece) && el.color != king.color }
    opponent_pieces.each do |piece|
      piece.set_position(@state)
      piece.set_destination(dest_y, dest_x)
    end
    opponent_pieces.none? { |piece| piece.instance_of?(Pawn) ? piece.square_attackable? : piece.legal_move?(self) }
  end

  # requires position to be set:
  def each_square_safe?(king, dir, y = king.origin[0], x = king.origin[1])
    coords = [[y, x], [y, x + dir], [y, x + dir * 2]]
    booleans = []
    coords.each do |sub_arr|
      booleans << square_safe?(king, sub_arr[0], sub_arr[1])
    end
    booleans.all?
  end

  def castle(king, rook, dir, y = king.origin[0], king_x = king.origin[1], rook_x = rook.origin[1])
    king_dest_x = king_x + dir * 2
    rook_dest_x = king_x + dir
    if horizontal_clear?([y, king_x], [y, rook_x]) && each_square_safe?(king, dir) && king.unmoved && rook.unmoved
      add_piece(king, y, king_dest_x)
      add_piece(rook, y, rook_dest_x)
      @state[y][king_x], @state[y][rook_x] = nil, nil
    end
    king.unmoved, rook.unmoved = false, false
  end

end

class Piece
  attr_reader :origin, :destination, :piece_name, :color
  attr_accessor :unmoved

  def initialize(piece_name, color)
    @piece_name = piece_name
    @color = color
    @destination = []
    @origin = []
    @moved_two = false
    @unmoved = true
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

  def in_bounds?
    @destination.all? { |n| n.between?(0, 7) }
  end

  def no_friendly_at_dest?(board)
    !board.piece_at?(@color, @destination[0], @destination[1], 'friendly')
  end

  def diagonal_clear?(board)
    board.diagonal_clear?(@origin, @destination)
  end

  def horizontal_clear?(board)
    board.horizontal_clear?(@origin, @destination)
  end

end

class Knight < Piece
  def legal_move?(board)
    set_diffs
    [@diff1, @diff2].sort == [1, 2] && in_bounds? && no_friendly_at_dest?(board)
  end
end

class Bishop < Piece
  def legal_move?(board)
    set_diffs
    @diff1 == @diff2 && in_bounds? && no_friendly_at_dest?(board) && diagonal_clear?(board)
  end
end

class Rook < Piece
  def legal_move?(board)
    set_diffs
    (@diff1.zero? || @diff2.zero?) && no_friendly_at_dest?(board) && in_bounds? && horizontal_clear?(board)
  end
end

class Queen < Piece
  def queen_path_clear?(board)
    @destination[0] == @origin[0] || @destination[1] == @origin[1] ? horizontal_clear?(board) : diagonal_clear?(board)
  end

  def legal_move?(board)
    set_diffs
    no_friendly_at_dest?(board) && in_bounds? && queen_path_clear?(board) && (@diff1 == @diff2 || (@diff1.zero? || @diff2.zero?))
  end
end

class King < Piece
  def dest_safe?(board)
    board.square_safe?(self, @destination[0], @destination[1])
  end

  def legal_move?(board)
    set_diffs
    no_friendly_at_dest?(board) && in_bounds? && @diff1.between?(0, 1) && @diff2.between?(0, 1) && dest_safe?(board)
  end
end

class Pawn < Piece
  attr_reader :moved_two
  def at_starting_square?
    @color == 'white' ? @origin[0] == 6 : @origin[0] == 1
  end

  def set_direction(c = @color == 'white')
    @one_step = c ? -1 : 1
    @two_step = c ? -2 : 2
  end

  def set_moved_two
    @moved_two = true
  end

  def unset_moved
    @moved_two = false
  end

  def square_attackable?
    set_diffs
    dir = @color == 'black' ? 1 : -1
    @destination[0] == @origin[0] + dir && @diff2 == 1
  end

  def en_passant_possible?(board)
    board.piece_at?(@color, @origin[0], @destination[1], 'opponent') && board.state[@origin[0]][@destination[1]].moved_two
  end

  def enemy_at_attackable?(board)
    square_attackable? && (board.piece_at?(@color, @destination[0], @destination[1], 'opponent') || en_passant_possible?(board))
  end

  def x_in_bounds?(board)
    @destination[1] == @origin[1]
  end

  def one_or_two_steps?(board)
    @destination[0] == @origin[0] + @one_step || (at_starting_square? && @destination[0] == @origin[0] + @two_step && horizontal_clear?(board))
  end

  def no_opponent_in_front?(board)
    !board.piece_at?(@color, @destination[0], @destination[1], 'opponent')
  end

  def legal_move?(board)
    set_direction
    in_bounds? && no_opponent_in_front?(board) && no_friendly_at_dest?(board) && one_or_two_steps?(board) && x_in_bounds?(board) || enemy_at_attackable?(board)
  end

  def prompt_loop(board, piece_name = nil)
    until board.pieces.include?(piece_name) do
      puts 'Enter piece name'
      piece_name = gets.chomp.downcase.capitalize
    end
    piece_name
  end

  def promote(board)
    if @origin[0] == 0 || @origin[0] == 7
      color = @origin[0] == 0 ? 'white' : 'black'
      piece_name = prompt_loop(board)
      new_piece = board.create_piece(piece_name, color)
      board.add_piece(new_piece, @origin[0], @origin[1])
    end
  end
end

def basic_print(board)
  board.state.each do |row|
    row.each do |entry|
      print entry.nil? ? "nil, " : "#{entry.piece_name}, "
    end
    puts "\n"
  end
  puts ''
end



board = Board.new
board.setup_board
basic_print board

board.make_move(6, 4, 4, 4)
basic_print board

board.make_move(1, 4, 3, 4)
basic_print board

board.make_move(7, 6, 5, 5)
basic_print board

board.make_move(1, 7, 2, 7)
basic_print board

board.make_move(5, 5, 3, 4)
basic_print board

board.make_move(0, 6, 2, 5)
basic_print board

board.make_move(3, 4, 5, 5)
basic_print board

board.make_move(1, 6, 2, 6)
basic_print board

board.make_move(7, 1, 5, 2)
basic_print board

board.make_move(0, 5, 1, 6)
basic_print board

board.make_move(4, 4, 3, 4)
basic_print board

board.castle(board.state[0][4], board.state[0][7], 1)
basic_print board

board.make_move(3, 4, 2, 4)
basic_print board

board.make_move(2, 7, 3, 7)
basic_print board

board.make_move(2, 4, 1, 4)
basic_print board

board.make_move(3, 7, 4, 7)
basic_print board

board.make_move(1, 4, 0, 4)
basic_print board
board.state[0][4].promote(board)
basic_print board
