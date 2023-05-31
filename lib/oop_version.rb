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

  def print_board(side, board = @board, rank = 9, i = -1, letters = ('  a'..'  h') )
    (board = board_as_black; rank = 0; i = 1; letters = letters.to_a.reverse) if side == 'black'
    print ' ', *letters, "\n"
    board.each do |row|
      print rank += i, ' '
      row.each { |square| print square }
      print ' ', rank, "\n"
    end
    print ' ', *letters, "\n"
  end

  def full_print_sequence(side)
    init_display
    fill_board
    print_board(side)
  end

end

class Board
  include Display
  attr_reader :pieces, :board, :white_has_castled, :black_has_castled
  attr_accessor :legal_pieces, :state

  def initialize
    @state =  8.times.map { 8.times.map { nil } }
    @pieces = ['Rook', 'Knight', 'Bishop', 'Queen', 'King', 'Bishop', 'Knight', 'Rook']
    @legal_pieces = []
    @white_has_castled = false
    @black_has_castled = false
  end

  def add_piece(piece, y, x)
    @state[y][x] = piece
    @state[y][x].set_origin(@state)
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
    piece.set_origin(@state)
    piece.unmoved = false
    @state.each do |row|
      row.each do |el|
        el.unset_moved if el.instance_of?(Pawn)
      end
    end
  end

  def set_piece_state(piece, dest_y, dest_x)
    piece.set_destination(dest_y, dest_x)
    piece.set_origin(@state)
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
    piece.promote(self) if piece.instance_of?(Pawn)
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
      piece.set_origin(@state)
      piece.set_destination(dest_y, dest_x)
    end
    opponent_pieces.none? { |piece| piece.instance_of?(Pawn) ? piece.square_attackable? : piece.legal_move?(self) }
  end

  def find_king(color)
    @state.each do |row|
      row.each do |piece|
        return piece if !piece.nil? && piece.instance_of?(King) && piece.color == color
      end
    end
  end

  def king_is_safe?(color)
    king = find_king(color)
    dest_y = king.origin[0]
    dest_x = king.origin[1]
    square_safe?(king, dest_y, dest_x)
  end

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
      king.color == 'white' ? @white_has_castled = true : @black_has_castled = true
      king.unmoved, rook.unmoved = false, false
    end
  end

  def find_legal_pieces(turn_color, piece_name, dest_y, dest_x)
    @state.each do |row|
      row.each do |piece|
        if !piece.nil? && piece.color == turn_color && piece.piece_name.downcase == piece_name
          piece.set_destination(dest_y, dest_x)
          @legal_pieces << piece if piece.legal_move?(self)
          piece.destination = []
        end
      end
    end
  end

  def find_pawn_origin(turn_color, dest_y, dest_x)
    @state.each do |row|
      piece = row[dest_x]
      if !piece.nil? && piece.color == turn_color && piece.instance_of?(Pawn)
        piece.set_destination(dest_y, dest_x)
        @legal_pieces << piece if piece.legal_move?(self)
        piece.destination = []
      end
    end
  end

  def check_if_legal(turn_color, origin_y, origin_x, dest_y, dest_x)
    piece = @state[origin_y][origin_x]
    if !piece.nil? && piece.color == turn_color
      piece.set_destination(dest_y, dest_x)
      @legal_pieces << piece if piece.legal_move?(self)
    end
  end

  def print_for_rspec
    @state.each do |row|
      row.each do |piece|
        if piece.nil?
          print '--- '
        else
          print piece.piece_name + ' '
        end
      end
      puts
    end
  end
  
end

class Piece
  attr_reader :origin, :piece_name, :color
  attr_accessor :unmoved, :destination

  def initialize(piece_name, color)
    @piece_name = piece_name
    @color = color
    @destination = []
    @origin = []
    @moved_two = false
    @unmoved = true
  end

  def set_origin(state)
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

  def results_in_king_safety?(board)
    dest_y = @destination[0]
    dest_x = @destination[1]
    check_test_board = Board.new
    check_test_board.state = Marshal.load(Marshal.dump(board.state))
    check_test_board.state[@origin[0]][@origin[1]] = nil
    check_test_board.state[dest_y][dest_x] = self.dup
    check_test_board.king_is_safe?(@color)
  end

end

class Knight < Piece
  def legal_move?(board)
    find_distances
    [@distance_y, @distance_x].sort == [1, 2] && no_friendly_at_dest?(board) && results_in_king_safety?(board)
  end
end

class Bishop < Piece
  def legal_move?(board)
    find_distances
    @distance_y == @distance_x && no_friendly_at_dest?(board) && diagonal_clear?(board) && results_in_king_safety?(board)
  end
end

class Rook < Piece
  def legal_move?(board)
    find_distances
    (@distance_y.zero? || @distance_x.zero?) && no_friendly_at_dest?(board) && horizontal_clear?(board) && results_in_king_safety?(board) 
  end
end

class Queen < Piece
  def queen_path_clear?(board)
    @destination[0] == @origin[0] || @destination[1] == @origin[1] ? horizontal_clear?(board) : diagonal_clear?(board)
  end

  def legal_move?(board)
    find_distances
    no_friendly_at_dest?(board) && queen_path_clear?(board) && (@distance_y == @distance_x || (@distance_y.zero? || @distance_x.zero?)) && results_in_king_safety?(board)
  end
end

class King < Piece
  
  def empty_square_safe?(board)
    board.square_safe?(self, @destination[0], @destination[1])
  end

  def capture_safe?(board, y = @destination[0], x = @destination[1])
    if board.state[y][x] && board.state[y][x].color != self.color
      check_board = Board.new
      check_board.state = Marshal.load(Marshal.dump(board.state))
      check_board.state[y][x] = nil
      empty_square_safe?(check_board)
    else
      true
    end
  end

  def legal_move?(board)
    find_distances
    no_friendly_at_dest?(board) && @distance_y.between?(0, 1) && @distance_x.between?(0, 1) && empty_square_safe?(board) && capture_safe?(board)
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
    (no_opponent_in_front?(board) && no_friendly_at_dest?(board) && one_or_two_steps?(board) && x_in_bounds?(board) || enemy_at_attackable?(board)) && results_in_king_safety?(board)
  end

  def prompt_loop(board, piece_name = nil)
    until board.pieces.reject {|el| el == 'King'}.include?(piece_name) do
      board.full_print_sequence('white')
      puts 'Enter name of new piece for pawn promotion.'
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

module InputHandler
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

  def algebraic?(index_1, index_2)
    @input[index_1].between?('a', 'h') && @input[index_2].between?('1', '8')
  end

  def pawn_push?
    @input.length == 2 && algebraic?(-2, -1)
  end

  def non_pawn?
    @input.length == 3 && @letters.key?(@input[0]) && algebraic?(-2, -1)
  end

  def unambiguous?
    @input.length == 4 && algebraic?(0, 1) && algebraic?(-2, -1)
  end

  def input_valid?
    non_pawn? || pawn_push? || short_c? || long_c? || draw? || resign? || unambiguous?
  end

  def get_input
    @input = gets.chomp.downcase
  end

  def retrieve_dest
    @dest_y = 8 - @input[-1].to_i
    @dest_x = ('a'..'h').to_a.index @input[-2]
  end

  def retrieve_unambiguous_origin
    @origin_y = 8 - @input[1].to_i
    @origin_x = ('a'..'h').to_a.index @input[0]
  end

  def retrieve_origin_from_piece
    @origin_y = @board.legal_pieces[0].origin[0]
    @origin_x = @board.legal_pieces[0].origin[1]
  end

  def lookup_piece
    @letters[@input[0]]
  end
end

class Game
  include InputHandler

  def initialize
    @board = Board.new()
    @turn_color = ['white', 'black']
    @game_status = 'ongoing'
    @input = ''
    @letters = { 'n' => 'kni', 'b' => 'bis', 'r' => 'roo', 'q' => 'que', 'k' => 'kin' }
  end

  def get_input_until_valid
    loop do
      puts "#{@turn_color[0].capitalize}, enter your move."
      get_input
      break if input_valid?
      puts 'Invalid input. Try again.'
    end
  end

  def continue_sequence
    @board.full_print_sequence('white')
    @turn_color.reverse!
    recursive_sequence
  end

  def recursive_sequence
    get_input_until_valid
    retrieve_dest
    branch
    @board.make_move(@origin_y, @origin_x, @dest_y, @dest_x)
    continue_sequence
  end

  def abort
    puts 'Illegal move.'
    recursive_sequence
  end

  def get_origin_from_piece_letter
    @board.find_legal_pieces(@turn_color[0], lookup_piece, @dest_y, @dest_x)
    legal_count = @board.legal_pieces.length
    if legal_count.zero?
      abort
    elsif legal_count > 1
      puts "More than one such piece can move there. State origin square and destination square, e.g. 'a1a4'."
      recursive_sequence
    else
      retrieve_origin_from_piece
      @board.legal_pieces = []
    end
  end

  def get_origin_for_pawn_push
    @board.find_pawn_origin(@turn_color[0], @dest_y, @dest_x)
    legal_count = @board.legal_pieces.length
    if legal_count.zero?
      abort
    else
      retrieve_origin_from_piece
      @board.legal_pieces = []
    end
  end

  def check_legality
    retrieve_unambiguous_origin
    @board.check_if_legal(@turn_color[0], @origin_y, @origin_x, @dest_y, @dest_x)
    legal_count = @board.legal_pieces.length
    if legal_count.zero?
      abort
    else
      @board.legal_pieces = []
    end
  end

  def try_castle(dir)
    king = @turn_color[0] == 'white' ? @board.state[7][4] : @board.state[0][4]
    if dir == 1
      rook = @turn_color[0] == 'white' ? @board.state[7][7] : @board.state[0][7]
    else
      rook = @turn_color[0] == 'white' ? @board.state[7][0] : @board.state[0][0]
    end
    @board.castle(king, rook, dir)
    has_castled = @turn_color[0] == 'white' ? @board.white_has_castled : @board.black_has_castled
    abort unless has_castled
  end

  def branch
    if pawn_push?
      get_origin_for_pawn_push
    elsif unambiguous?
      check_legality
    elsif non_pawn?
      get_origin_from_piece_letter
    elsif short_c?
      try_castle(1)
      continue_sequence
    elsif long_c?
      try_castle(-1)
      continue_sequence
    end
  end

  def play_game
    @board.setup_board
    @board.full_print_sequence(@turn_color[0])
    recursive_sequence
  end

end

game = Game.new
game.play_game