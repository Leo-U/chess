module Display
  def init_escape_sequences
    @dark_bg = "\e[48;5;253m"
    @light_bg = "\e[48;5;231m"
    @black_fg = "\e[30m"
    @red_fg = "\e[31m"
    @reset = "\e[0m"
  end

  def init_pieces
    @blank = '   '
    @red = { kin: '♚', que: '♛', roo: '♜', bis: '♝', kni: '♞', paw: '♟︎' }.transform_values{ |value| @red_fg + value }
    @black = @red.transform_values{ |value| @black_fg + value[5..-1] }
  end
  
  def init_display
    init_escape_sequences
    init_pieces
  end

  def build_empty_board
    @board = Array.new(8) do |row_i|
      Array.new(8) do |el_i|
        (row_i.even? == el_i.even? ? @light_bg : @dark_bg) + @blank + @reset
      end
    end
  end

  def fill_board
    build_empty_board
    @state.each_with_index do |row, y|
      row.each_with_index do |square, x|
        if square
          piece = square.piece_name.downcase.to_sym
          @board[y][x][-6] = square.color == 'white' ? @red[piece] : @black[piece]
        end
      end
    end
  end

  def board_as_black
    @board.reverse.map { |row| row.reverse }
  end

  def print_board(side = 'white', board = @board, rank = 9, i = -1, letters = ('  a'..'  h') )
    (board = board_as_black; rank = 0; i = 1; letters = letters.to_a.reverse) if side == 'black'
    print ' ', *letters, "\n"
    board.each do |row|
      print rank += i, ' '
      row.each { |square| print square }
      print ' ', rank, "\n"
    end
    print ' ', *letters, "\n"
  end

end

class Board
  include Display
  attr_reader :state, :pieces, :board

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
    @state[origin_y][dest_x] = nil if piece.instance_of?(Pawn) && piece.en_passant_possible?(self)
    @state[origin_y][origin_x] = nil
  end

  def move_piece_if_legal(piece, origin_y, origin_x, dest_y, dest_x)
    if piece.legal_move?(self)
      @state[dest_y][dest_x] = piece
      set_nil(piece, origin_y, origin_x, dest_x)
    end
  end
  
  def make_move(origin_y, origin_x, dest_y, dest_x)
    piece = @state[origin_y][origin_x]
    set_piece_state(piece, dest_y, dest_x)
    move_piece_if_legal(piece, origin_y, origin_x, dest_y, dest_x)
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



module InputHandler
  # input will be origin square -- destination square if ambiguous
  # otherwise, it will be piece to dest square

  def draw?
    @input == 'draw'
  end

  def long_c?
    @input == 'o-o-o'
  end

  def short_c?
    @input == 'o-o'
  end

  def resign?
    @input == 'resign'
  end

  def algebraic?
    @input[-2].between?('a', 'h') && @input[-1].between?('1', '8')
  end

  def pawn?
    @input.length == 2 && algebraic?
  end

  def not_pawn?
    @input.length == 3 && @letters.any?(@input[0]) && algebraic?
  end

  def input_valid?
    not_pawn? || pawn? || short_c? || long_c? || draw? || resign?
  end

  def give_input_feedback
    puts input_valid? ? "#{@input} is good" : "#{@input} is not good" 
  end

  def get_input
    @input = gets.chomp.downcase
  end

  # check if any piece 
  def ambiguous?

  end


  












  #if not ambiguous
  # def handle_input(notation, destination)
    
  # end

  # def unambiguous_command(input)

  # end

end

class Game # NOTE: SOMEWHERE I'LL NEED COMMAND FOR MOVE INSTRUCTIONS
  include InputHandler

  def initialize
    @board = Board.new()
    @turn = 'white'
    @game_status = 'ongoing'
    @input = ''
    @letters = ['n', 'b', 'r', 'q', 'k']
  end

  def play_game
    @board.setup_board
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

  def find_distances
    @distance_y = (@origin[0] - @destination[0]).abs
    @distance_x = (@origin[1] - @destination[1]).abs
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
    find_distances
    [@distance_y, @distance_x].sort == [1, 2] && no_friendly_at_dest?(board)
  end
end

class Bishop < Piece
  def legal_move?(board)
    find_distances
    @distance_y == @distance_x && no_friendly_at_dest?(board) && diagonal_clear?(board)
  end
end

class Rook < Piece
  def legal_move?(board)
    find_distances
    (@distance_y.zero? || @distance_x.zero?) && no_friendly_at_dest?(board) && horizontal_clear?(board)
  end
end

class Queen < Piece
  def queen_path_clear?(board)
    @destination[0] == @origin[0] || @destination[1] == @origin[1] ? horizontal_clear?(board) : diagonal_clear?(board)
  end

  def legal_move?(board)
    find_distances
    no_friendly_at_dest?(board) && queen_path_clear?(board) && (@distance_y == @distance_x || (@distance_y.zero? || @distance_x.zero?))
  end
end

class King < Piece
  def dest_safe?(board)
    board.square_safe?(self, @destination[0], @destination[1])
  end

  def legal_move?(board)
    find_distances
    no_friendly_at_dest?(board) && @distance_y.between?(0, 1) && @distance_x.between?(0, 1) && dest_safe?(board)
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
    find_distances
    dir = @color == 'black' ? 1 : -1
    @destination[0] == @origin[0] + dir && @distance_x == 1
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
    no_opponent_in_front?(board) && no_friendly_at_dest?(board) && one_or_two_steps?(board) && x_in_bounds?(board) || enemy_at_attackable?(board)
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
board.init_display
board.setup_board
board.fill_board

board.print_board
board.print_board('black')

game = Game.new
