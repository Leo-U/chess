require_relative '../lib/oop_version.rb'

describe Knight do
  describe '#legal_move?' do
    subject(:legal_knight) { described_class.new('kn1', 'black') }
    let(:king) { King.new('kng', 'black') }
    let(:board) { Board.new }

    context 'when knight is at top left corner' do
      before do
        board.state[0][0] = legal_knight
        legal_knight.set_origin(board.state)
        board.state[0][4] = king
        king.set_origin(board.state)
      end

      context 'when  destination is 2 right and 1 down' do
        it 'returns true' do
          legal_knight.set_destination(1, 2)
          expect(legal_knight.legal_move?(board)).to be true
        end
      end

      context 'when destination is 1 right and 2 down' do
        it 'returns true' do
          legal_knight.set_destination(2, 1)
          expect(legal_knight.legal_move?(board)).to be true
        end
      end
    end

    context 'when knight is at 4, 2' do
      before do
        board.state[4][2] = legal_knight
        legal_knight.set_origin(board.state)
        board.state[0][4] = king
        king.set_origin(board.state)
      end

      context 'when destination is 1 left and 2 down' do
        it 'returns true' do
          legal_knight.set_destination(6, 1)
          expect(legal_knight.legal_move?(board)).to be true
        end
      end

      context 'when destination is 1 left and 2 up' do
        it 'returns true' do
          legal_knight.set_destination(2, 1)
          expect(legal_knight.legal_move?(board)).to be true
        end
      end

      context 'when destination is same as origin' do
        it 'returns false' do
          legal_knight.set_destination(4, 2)
          expect(legal_knight.legal_move?(board)).to be false
        end
      end

      context 'when destination is occupied by friendly piece' do
        it 'returns false' do
          board.state[6][1] = described_class.new('kn2', 'black')
          legal_knight.set_destination(6, 1)
          expect(legal_knight.legal_move?(board)).to be false
        end
      end

      context 'when destination is occupied by opponent piece' do
        it 'returns true' do
          board.state[6][1] = described_class.new('kn2', 'white')
          legal_knight.set_destination(6, 1)
          expect(legal_knight.legal_move?(board)).to be true
        end
      end
    end
  end
end

describe Bishop do
  describe '#legal_move?' do
    subject(:legal_bishop) { described_class.new('bp1', 'black') }
    let(:board) { Board.new }
    let(:black_king) { King.new('kng', 'black') }
    #let(:white_king) { King.new('Kng', 'white') }

    context 'when bishop is at 0, 0' do
      before do
        board.state[0][0] = legal_bishop
        board.state[7][7] = black_king
        #board.state[3][7] = white_king
        black_king.set_origin(board.state)
        legal_bishop.set_origin(board.state)
      end

      context 'when destination is at 1, 1' do
        it 'returns true' do
          legal_bishop.set_destination(1, 1)
          expect(legal_bishop.legal_move?(board)).to be true
        end
      end

      context 'when destination is at 1, 2' do
        it 'returns false' do
          legal_bishop.set_destination(1, 2)
          expect(legal_bishop.legal_move?(board)).to be false
        end
      end
    end

    context 'when bishop is at 0, 7' do
      before do
        board.state[0][7] = legal_bishop
        board.state[7][7] = black_king
        legal_bishop.set_origin(board.state)
        black_king.set_origin(board.state)
      end

      context 'when destination is at 7, 0' do
        it 'returns true' do
          legal_bishop.set_destination(7, 0)
          expect(legal_bishop.legal_move?(board)).to be true
        end
      end
    end

    context 'when bishop is at 7, 3' do
      before do
        board.state[7][7] = black_king
        board.state[7][3] = legal_bishop
        black_king.set_origin(board.state)
        legal_bishop.set_origin(board.state)
      end

      context 'when destination is 5, 1' do
        context 'when way is clear' do
          it 'returns true' do
            legal_bishop.set_destination(5, 1)
            expect(legal_bishop.legal_move?(board)).to be true
          end          
        end

        context 'when way is blocked' do
          it 'returns false' do
            board.state[6][2] = described_class.new('bsp2', 'white')
            legal_bishop.set_destination(5, 1)
            expect(legal_bishop.legal_move?(board)).to be false
          end
        end
      end
    end

    context 'when bishop is at 3, 3' do
      before do
        board.state[3][3] = legal_bishop
        board.state[7][7] = black_king
        black_king.set_origin(board.state)
        legal_bishop.set_origin(board.state)
      end

      context 'when destination is 2, 4' do
        it 'returns true' do
          legal_bishop.set_destination(2, 4)
          expect(legal_bishop.legal_move?(board)).to be true
        end
      end

      context 'when destination is same as origin' do
        it 'returns false' do
          legal_bishop.set_destination(3, 3)
          expect(legal_bishop.legal_move?(board)).to be false
        end
      end

      context 'when destination is occupied by friendly piece' do
        it 'returns true' do
          board.state[2][4] = described_class.new('bp2', 'black')
          legal_bishop.set_destination(2, 4)
          expect(legal_bishop.legal_move?(board)).to be false
        end
      end

      context 'when destination is occupied by opponent piece' do
        it 'returns true' do
          board.state[2][4] = described_class.new('bp2', 'white')
          legal_bishop.set_destination(2, 4)
          expect(legal_bishop.legal_move?(board)).to be true
        end
      end
    end
  end

  describe '#diagonal_clear?' do
    subject(:between_bishop) { Bishop.new('bp1', 'black') }
    let(:board) { Board.new }
  
    context 'when bishop is at 3, 3' do
      before do
        board.state[3][3] = between_bishop
        between_bishop.set_origin(board.state)
      end
  
      context 'when destination y/x are both > origin y/x' do
        before { between_bishop.set_destination(6, 6) }
        
        context 'when a piece is blocking' do
          it 'returns false' do
            board.state[4][4] = Bishop.new('bp2', 'black')
            expect(between_bishop.diagonal_clear?(board)).to be false
          end
        end

        context 'when the way is clear' do
          it 'returns true' do
            expect(between_bishop.diagonal_clear?(board)).to be true
          end
        end
      end

      context 'when dest y > origin y & dest x < origin x' do
        before { between_bishop.set_destination(6, 0) }

        context 'when a piece is blocking' do
          it 'returns false' do
            board.state[4][2] = Bishop.new('bp2', 'black')
            expect(between_bishop.diagonal_clear?(board)).to be false
          end
        end

        context 'when the way is clear' do
          it 'returns true' do
            expect(between_bishop.diagonal_clear?(board)).to be true
          end
        end
      end

      context 'when dest y/x are both < origin y/x' do
        before { between_bishop.set_destination(0, 0) }

        context 'when a piece is blocking' do
          it 'returns false' do
            board.state[1][1] = Bishop.new('bp2', 'black')
            expect(between_bishop.diagonal_clear?(board)).to be false
          end
        end

        context 'when the way is clear' do
          it 'returns true' do
            expect(between_bishop.diagonal_clear?(board)).to be true
          end
        end
      end

      context 'when dest y < origin y & dest x > origin x' do
        before { between_bishop.set_destination(0, 6) }

        context 'when a piece is blocking' do
          it 'returns false' do
            board.state[2][4] = Bishop.new('bp2', 'black')
            expect(between_bishop.diagonal_clear?(board)).to be false
          end
        end

        context 'when the way is clear' do
          it 'returns true' do
            expect(between_bishop.diagonal_clear?(board)).to be true
          end
        end
      end
    end
  end
end

describe Rook do
  describe '#legal_move' do
    subject(:legal_rook) { described_class.new('rk1', 'black') }
    let(:black_king) { King.new('kin', 'black') }
    let(:board) { Board.new }

    context 'when rook is at 0, 0' do
      before do
        board.state[0][0] = legal_rook
        board.state[7][7] = black_king
        black_king.set_origin(board.state)
        legal_rook.set_origin(board.state)
      end

      context 'when destination is 2, 0' do
        it 'returns true' do
          legal_rook.set_destination(2, 0)
          expect(legal_rook.legal_move?(board)).to be true
        end
      end

      context 'when destination 2, 1' do
        it 'returns false' do
          legal_rook.set_destination(2, 1)
          expect(legal_rook.legal_move?(board)).to be false
        end
      end

      context 'when destination is 0, 7' do
        it 'returns true' do
          legal_rook.set_destination(0, 7)
          expect(legal_rook.legal_move?(board)).to be true
        end
      end

      context 'when destination is 7, 0' do
        before { legal_rook.set_destination(7, 0) }

        context 'when path is clear' do
          it 'returns true' do
            expect(legal_rook.legal_move?(board)).to be true
          end          
        end

        context 'when path is blocked' do
          it 'returns false' do
            board.state[3][0] = described_class.new('rk2', 'black')
            expect(legal_rook.legal_move?(board)).to be false
          end
        end
      end

      context 'when destination is occupied by friendly piece' do
        it 'returns false' do
          board.state[2][1] = described_class.new('rk2', 'black')
          legal_rook.set_destination(2, 1)
          expect(legal_rook.legal_move?(board)).to be false
        end
      end

      context 'when destination is occupied by opponent piece' do
        it 'returns true' do
          board.state[2][0] = described_class.new('rk2', 'white')
          legal_rook.set_destination(2, 0)
          expect(legal_rook.legal_move?(board)).to be true
        end
      end
    end
  end

  describe 'horizontal_clear?' do
    subject(:between_rook) { Rook.new('rk1', 'black') }
    let(:board) { Board.new }
  
    context 'when rook is at 3, 3' do
      before do
        board.state[3][3] = between_rook
        between_rook.set_origin(board.state)
      end

      context 'when destination is 7, 3' do
        before { between_rook.set_destination(7, 3) }

        context 'when way is clear' do
          it 'returns true' do
            expect(between_rook.horizontal_clear?(board)).to be true
          end
        end

        context 'when way is blocked' do
          it 'returns false' do
            board.state[6][3] = described_class.new('rk2', 'white')
            expect(between_rook.horizontal_clear?(board)).to be false
          end
        end
      end

      context 'when destination is 0, 3' do
        before { between_rook.set_destination(0, 3) }

        context 'when way is clear' do
          it 'returns true' do
            expect(between_rook.horizontal_clear?(board)).to be true
          end
        end

        context 'when way is blocked' do
          it 'returns false' do
            board.state[1][3] = described_class.new('rk2', 'white')
            expect(between_rook.horizontal_clear?(board)).to be false
          end
        end
      end

      context 'when destination is 3, 7' do
        before { between_rook.set_destination(3, 7) }

        context 'when way is clear' do
          it 'returns true' do
            expect(between_rook.horizontal_clear?(board)).to be true
          end
        end

        context 'when way is blocked' do
          it 'returns false' do
            board.state[3][5] = described_class.new('rk2', 'black')
            expect(between_rook.horizontal_clear?(board)).to be false
          end
        end
      end

      context 'when destination is 3, 1' do
        before { between_rook.set_destination(3, 1) }

        context 'when way is clear' do
          it 'returns true' do
            expect(between_rook.horizontal_clear?(board)).to be true
          end
        end

        context 'when way is blocked' do
          it 'returns false' do
            board.state[3][2] = described_class.new('rk2', 'black')
            expect(between_rook.horizontal_clear?(board)).to be false
          end
        end
      end
    end
  end

  describe '#unmoved?' do
    subject(:unmoved_rook) { described_class.new('rk1', 'black') }
    let(:game) { Game.new }
    let(:board) { game.board }

    before do
      board.setup_board
    end

    context 'when rook is unmoved' do
      it 'returns true' do
        expect(board.state[7][0].unmoved).to be true
      end
    end

    context 'when rook has moved' do
      it 'returns false' do
        board.make_move(6, 0, 4, 0)
        board.make_move(1, 0, 2, 0)
        board.make_move(7, 0, 5, 0)
        expect(board.state[5][0].unmoved).to be false
      end
    end
  end
end

describe Queen do
  subject(:legal_queen) { described_class.new('qn1', 'black') }
  let(:black_king) { King.new('kin', 'black') }
  let(:board) { Board.new }

  describe '#legal_move?' do
    context 'when queen is at 3, 3' do
      before do
        board.state[3][3] = legal_queen
        board.state[0][0] = black_king
        black_king.set_origin(board.state)
        legal_queen.set_origin(board.state)
      end

      context 'when destination is at 1, 1' do
        before { legal_queen.set_destination(1, 1) }

        context 'when path is clear' do
          it 'returns true' do
            expect(legal_queen.legal_move?(board)).to be true
          end          
        end

        context 'when path is blocked' do
          it 'returns false' do
            board.state[2][2] = Rook.new('rk1', 'white')
            expect(legal_queen.legal_move?(board)).to be false
          end
        end

        context 'when destination is occupied by friendly piece' do
          it 'returns false' do
            board.state[1][1] = Rook.new('rk1', 'black')
            expect(legal_queen.legal_move?(board)).to be false
          end
        end
      end

      context 'when destination is 6, 0' do
        before { legal_queen.set_destination(6, 0) }

        context 'when path is clear' do
          it 'returns true' do
            expect(legal_queen.legal_move?(board)).to be true
          end
        end

        context 'when path is blocked' do
          it 'returns false' do
            board.state[5][1] = Knight.new('knt', 'black')
            expect(legal_queen.legal_move?(board)).to be false
          end
        end

        context 'when destination is occupied by friendly piece' do
          it 'returns false' do
            board.state[6][0] = Bishop.new('bp1', 'black')
            expect(legal_queen.legal_move?(board)).to be false
          end
        end
      end

      context 'when destination is 7, 7' do
        before { legal_queen.set_destination(7, 7) }

        context 'when path is clear' do
          it 'returns true' do
            expect(legal_queen.legal_move?(board)).to be true
          end
        end

        context 'when path is blocked' do
          it 'returns false' do
            board.state[5][5] = described_class.new('qn2', 'white')
            expect(legal_queen.legal_move?(board)).to be false
          end
        end
      end

      context 'when destination is 0, 6' do
        before { legal_queen.set_destination(0, 6) }

        context 'when path is clear' do
          it 'returns true' do
            expect(legal_queen.legal_move?(board)).to be true
          end
        end

        context 'when path is blocked' do
          it 'returns false' do
            board.state[2][4] = Knight.new('nt1', 'white')
            expect(legal_queen.legal_move?(board)).to be false
          end
        end

        context 'when destination is occupied by friendly piece' do
          it 'returns false' do
            board.state[0][6] = Knight.new('nt1', 'black')
            expect(legal_queen.legal_move?(board)).to be false
          end
        end

        context 'when destination is occupied by opponent piece' do
          it 'returns true' do
            board.state[0][6] = Knight.new('nt1', 'white')
            expect(legal_queen.legal_move?(board)).to be true
          end
        end
      end

      context 'when destination is 6, 3' do
        before { legal_queen.set_destination(6, 3) }

        context 'when path is clear' do
          it 'returns true' do
            expect(legal_queen.legal_move?(board)).to be true
          end
        end

        context 'when path is blocked' do
          it 'returns false' do
            board.state[5][3] = Rook.new('rk1', 'black')
            expect(legal_queen.legal_move?(board)).to be false
          end
        end
      end
    end
  end
end

describe King do
  subject(:legal_king) { described_class.new('kng', 'black') }
  let(:board) { Board.new }
  let(:white_king) { King.new('kng', 'white') }

  describe '#legal_move?' do
    context 'when king is at 3, 3' do
      before do
        board.state[3][3] = legal_king
        legal_king.set_origin(board.state)
      end

      context 'when destination is 4, 4' do
        before { legal_king.set_destination(4, 4) }

        context 'when destination square is empty' do
          it 'returns true' do
            expect(legal_king.legal_move?(board)).to be true
          end
        end

        context 'when destination square is occupied by friendly piece' do
          it 'returns false' do
            board.state[4][4] = Knight.new('ngt', 'black')
            expect(legal_king.legal_move?(board)).to be false
          end
        end
      end

      context 'when destination is 7, 4' do
        it 'returns false' do
          legal_king.set_destination(7, 4)
          expect(legal_king.legal_move?(board)).to be false
        end
      end
      
      context 'when destination is origin' do
        it 'returns false' do
          legal_king.set_destination(3, 3)
          expect(legal_king.legal_move?(board)).to be false
        end
      end
      
      context 'when destination is 3, 4' do
        before do
          legal_king.set_destination(3, 4)
          board.state[7][0] = white_king
        end

        context 'when unobstructed' do
          it 'returns true' do
            expect(legal_king.legal_move?(board)).to be true
          end
        end

        context 'when destination threatened by bishop' do
          it 'returns false' do
            board.state[0][0] = white_king
            board.state[0][7] = Bishop.new('bsp', 'white')
            expect(legal_king.legal_move?(board)).to be false
          end
        end

        context 'when destination threatened by knight' do
          it 'returns false' do
            board.state[1][5] = Knight.new('knt', 'white')
            board.state[0][0] = white_king
            expect(legal_king.legal_move?(board)).to be false
          end
        end

        context 'when destination threatened by rook' do
          it 'returns false' do
            board.state[0][4] = Rook.new('Rk1', 'white')
            expect(legal_king.legal_move?(board)).to be false
          end
        end

        context 'when destination horizontally threatened by queen' do
          it 'returns false' do
            board.state[7][4] = Queen.new('qn1', 'white')
            expect(legal_king.legal_move?(board)).to be false
          end
        end

        context 'when destination is not threatened by queen' do
          it 'returns false' do
            board.state[7][7] = Queen.new('qn1', 'white')
            expect(legal_king.legal_move?(board)).to be true
          end
        end

        context 'when destination diagonally threatened by queen' do
          it 'returns false' do
            board.state[6][7] = Queen.new('qn1', 'white')
            expect(legal_king.legal_move?(board)).to be false
          end
        end

        context 'when destination threatened by pawn at 4, 5' do
          it 'returns false' do
            board.state[4][5] = Pawn.new('pn1', 'white')
            expect(legal_king.legal_move?(board)).to be false
          end
        end

        context 'when destination threatened by pawn at 4, 3' do
          it 'returns false' do
            board.state[4][3] = Pawn.new('pn1', 'white')
            expect(legal_king.legal_move?(board)).to be false
          end
        end
      end
    end
  end
end

describe Pawn do
  let(:game) { Game.new }
  let(:board) { game.board }
  let(:black_king) { King.new('kin', 'black') }
  let(:white_king) { King.new('Kin', 'white') }

  describe '#legal_move' do
    context 'when black pawn is at 1, 4' do
      subject(:legal_pawn_black) { described_class.new('pwn', 'black') }

      before do
        board.state[1][4] = legal_pawn_black
        board.state[0][0] = black_king
        black_king.set_origin(board.state)
        legal_pawn_black.set_origin(board.state)
      end

      context 'when destination is 2, 4' do
        before { legal_pawn_black.set_destination(2, 4) }

        context 'when square is empty' do
          it 'returns true' do
            expect(legal_pawn_black.legal_move?(board)).to be true
          end
        end

        context 'when square is occupied by friendly' do
          it 'returns false' do
            board.state[2][4] = Knight.new('kn1', 'black')
            expect(legal_pawn_black.legal_move?(board)).to be false
          end
        end

        context 'when square is occupied by opponent' do
          it 'returns false' do
            board.state[2][4] = Bishop.new('bp1', 'white')
            expect(legal_pawn_black.legal_move?(board)).to be false
          end
        end
      end

      context 'when destination is 3, 4 (two steps foward)' do
        before { legal_pawn_black.set_destination(3, 4) }

        context 'when path is clear' do
          it 'returns true' do
            expect(legal_pawn_black.legal_move?(board)).to be true
          end        
        end

        context 'when path is blocked' do
          it 'returns false' do
            board.state[2][4] = described_class.new('pn2', 'black')
            expect(legal_pawn_black.legal_move?(board)).to be false
          end
        end
      end

      context 'when destination is 0, 4 (backwards)' do
        it 'returns false' do
          legal_pawn_black.set_destination(0, 4)
          expect(legal_pawn_black.legal_move?(board)).to be false
        end
      end

      context 'when destination is 2, 5' do
        before { legal_pawn_black.set_destination(2, 5) }

        context 'when NO enemy piece at 2, 5' do
          it 'returns false' do
            expect(legal_pawn_black.legal_move?(board)).to be false
          end
        end

        context 'when enemy piece IS at 2, 5' do
          it 'returns true' do
            board.state[2][5] = Queen.new('Qn1', 'white')
            expect(legal_pawn_black.legal_move?(board)).to be true
          end
        end

        context 'when friendly piece is at 2, 5' do
          it 'returns false' do
            board.state[2][5] = Queen.new('Rk1', 'black')
            expect(legal_pawn_black.legal_move?(board)).to be false
          end
        end
      end

      context 'when it moves 2 forward next to white pawn' do
        it 'returns true' do
          white_pawn = described_class.new('Pwn', 'white')
          board.state[3][5] = white_pawn
          board.state[7][7] = white_king
          white_king.set_origin(board.state)
          white_pawn.set_origin(board.state)
          board.make_move(1, 4, 3, 4)
          white_pawn.set_destination(2, 4)
          expect(white_pawn.legal_move?(board)).to be true
        end
      end
    end

    context 'when white pawn is at 6, 3' do
      subject(:legal_pawn_white) { described_class.new('Pwn', 'white') }

      before do
        board.state[6][3] = legal_pawn_white
        board.state[0][0] = white_king
        white_king.set_origin(board.state)
        legal_pawn_white.set_origin(board.state)
      end

      context 'when destination is 5, 3' do
        it 'returns true' do
          legal_pawn_white.set_destination(5, 3)
          expect(legal_pawn_white.legal_move?(board)).to be true
        end
      end

      context 'when destination is 4, 3 (two steps foward)' do
        it 'returns true' do
          legal_pawn_white.set_destination(4, 3)
          expect(legal_pawn_white.legal_move?(board)).to be true
        end
      end

      context 'when destination is 7, 3 (backwards)' do
        it 'returns false' do
          legal_pawn_white.set_destination(7, 3)
          expect(legal_pawn_white.legal_move?(board)).to be false
        end
      end
    end
  end

  describe '#promote' do
    subject(:white_pawn) { described_class.new('Paw', 'white') }
    subject(:black_pawn) { described_class.new('paw', 'black') }

    context 'when white pawn arrives at rank 0' do
      it 'pawn is promoted to specified piece' do
        board.state[0][3] = white_pawn
        white_pawn.set_origin(board.state)
        allow_any_instance_of(Input).to receive(:get_input).and_return('qUeEn')
        y = white_pawn.origin[0]
        x = white_pawn.origin[1]
        white_pawn.promote(board)
        expect(board.state[y][x].instance_of?(Queen)).to be true
      end
    end

    context 'when black pawn arrives at rank 7' do
      it 'pawn is promoted to specified piece' do
        board.state[7][0] = black_pawn
        black_pawn.set_origin(board.state)
        allow_any_instance_of(Input).to receive(:get_input).and_return('ROOK')
        y = black_pawn.origin[0]
        x = black_pawn.origin[1]
        black_pawn.promote(board)
        expect(board.state[y][x].instance_of?(Rook)).to be true
      end
    end
  end
end

describe Board do
  let(:game) { Game.new }
  let(:board) { game.board }
  let(:black_king) { King.new('kin', 'black') }
  let(:white_king) { King.new('Kin', 'white') }

  describe '#reset_piece_state' do
    context 'when a pawn has @moved_two == true' do
      it 'gets set to false' do
        board.setup_board
        board.state[1][0].set_moved_two
        expect { board.reset_piece_state(board.state[1][0]) }.to change { board.state[1][0].moved_two }.to(false)
      end
    end
  end

  describe '#make_move' do
    context 'when opponent pawn has just moved 2 squares and en passant is possible' do
      subject(:en_passantable_white_pawn) { Pawn.new('Pwn', 'white') }
      subject(:friendly_black_pawn) { Pawn.new('pwn', 'black') }

      before do
        board.state[0][0] = black_king
        board.state[0][7] = white_king
        black_king.set_origin(board.state)
        white_king.set_origin(board.state)
        board.state[6][2] = en_passantable_white_pawn
        board.state[4][1] = friendly_black_pawn
      end

      context 'when black pawn is moved forward instead of taking en passant' do
        it 'does NOT remove en passantable pawn from the board' do
          en_passantable_white_pawn.set_destination(5, 2)
          board.make_move(6, 2, 4, 2)
          expect { board.make_move(4, 1, 5, 1) }.not_to change { board.state[4][2] }.from(be_truthy)
        end
      end

      context 'when black pawn captures en passant' do
        it 'removes the en passantable pawn from the board' do
          en_passantable_white_pawn.set_destination(5, 2)
          board.make_move(6, 2, 4, 2)
          expect { board.make_move(4, 1, 5, 2) }.to change { board.state[4][2] }.from(be_truthy)
        end
      end
    end
  end

  describe '#each_square_safe?' do
    context 'when kingside castling' do
      let(:white_king) { King.new('Kin', 'white') }
      let(:black_king) { King.new('kin', 'black') }
      let(:rook) { Rook.new('Roo', 'white') }
      
      before do
        board.state[7][4] = white_king
        board.state[0][0] = black_king
        board.state[7][7] = rook
      end

      context 'when all squares are under attack' do
        it 'returns false' do
          board.state[0][4] = Queen.new('que', 'black')
          board.state[0][5] = Rook.new('roo', 'black')
          board.state[0][6] = Rook.new('roo', 'black')
          white_king.set_origin(board.state)
          expect(board.each_square_safe?(white_king, 1)).to be false
        end
      end
      
      context 'when white_king square is under attack(check)' do
        it 'returns false' do
          board.state[0][4] = Queen.new('que', 'black')
          white_king.set_origin(board.state)
          expect(board.each_square_safe?(white_king, 1)).to be false
        end
      end

      context 'when middle square is under attack' do
        it 'returns false' do
          board.state[0][5] = Rook.new('que', 'black')
          white_king.set_origin(board.state)
          expect(board.each_square_safe?(white_king, 1)).to be false
        end
      end

      context 'when target square is under attack' do
        it 'returns false' do
          board.state[0][6] = Rook.new('que', 'black')
          white_king.set_origin(board.state)
          expect(board.each_square_safe?(white_king, 1)).to be false
        end
      end
      
      context 'when no squares are under attack' do
        it 'returns true' do
          white_king.set_origin(board.state)
          expect(board.each_square_safe?(white_king, 1)).to be true
        end
      end
    end
    
    context 'when queenside castling' do
      let(:white_king) { King.new('Kin', 'white') }
      let(:black_king) { King.new('kin', 'black') }
      let(:rook) { Rook.new('Roo', 'white') }

      before do
        board.state[0][4] = white_king
        board.state[7][7] = black_king
        board.state[0][0] = rook
      end
      
      context 'when all squares are under attack' do
        it 'returns false' do
          board.state[7][2] = Queen.new('que', 'black')
          board.state[7][3] = Rook.new('roo', 'black')
          board.state[7][4] = Rook.new('roo', 'black')
          white_king.set_origin(board.state)
          expect(board.each_square_safe?(white_king, -1)).to be false
        end
      end

      context 'when white_king square is under attack(check)' do
        it 'returns false' do
          board.state[7][4] = Queen.new('que', 'black')
          white_king.set_origin(board.state)
          expect(board.each_square_safe?(white_king, -1)).to be false
        end
      end

      context 'when middle square is under attack' do
        it 'returns false' do
          board.state[7][3] = Rook.new('roo', 'black')
          white_king.set_origin(board.state)
          expect(board.each_square_safe?(white_king, -1)).to be false
        end
      end

      context 'when target square is under attack' do
        it 'returns false' do
          board.state[7][2] = Rook.new('roo', 'black')
          white_king.set_origin(board.state)
          expect(board.each_square_safe?(white_king, -1)).to be false
        end
      end

      context 'when no squares are under attack' do
        it 'returns true' do
          white_king.set_origin(board.state)
          expect(board.each_square_safe?(white_king, -1)).to be true
        end
      end
    end
  end

  describe '#castle' do
    context 'when kingside castling with White' do
      let(:white_king) { King.new('Kin', 'white')}
      let(:black_king) { King.new('kin', 'black')}
      let(:rook) { Rook.new('Roo', 'white') }

      before do
        board.state[7][4] = white_king
        board.state[7][7] = rook
        white_king.set_origin(board.state)
        rook.set_origin(board.state)        
      end

      context 'when path is clear' do
        it 'castles kingside' do
          board.state[7][6] = Knight.new('Kni', 'white')
          board.make_move(7, 6, 5, 5)
          expect { board.castle(white_king, rook, 1) }
            .to change { board.state[7][6] }.to(white_king)
            .and change { board.state[7][5] }.to(rook)
            .and change { board.state[7][4] }.from(be_truthy)
            .and change { board.state[7][7] }.from(be_truthy)
        end
      end

      context 'when path is blocked on 7, 6' do
        it 'does not castle' do
          board.state[7][6] = Knight.new('Kni', 'white')
          expect { board.castle(white_king, rook, 1) }
          .not_to change { board.state }
        end
      end

      context 'when path is blocked on 7, 5' do
        it 'does not castle' do
          board.state[7][5] = Knight.new('Kni', 'white')
          expect { board.castle(white_king, rook, 1) }
          .not_to change { board.state }
        end
      end

      context 'when white_king path is under attack' do
        it 'does not castle' do
          board.state[0][0] = black_king
          black_king.set_origin(board.state)
          board.state[5][7] = Knight.new('kni', 'black')
          expect { board.castle(white_king, rook, 1) }
          .not_to change { board.state }
        end
      end

      context 'when white_king has already moved' do
        it 'does not castle' do
          board.make_move(7, 4, 7, 3)
          board.make_move(7, 3, 7, 4)
          expect { board.castle(white_king, rook, 1) }
          .not_to change { board.state }
        end
      end

      context 'when rook has already moved' do
        it 'does not castle' do
          board.make_move(7, 7, 1, 7)
          board.make_move(1, 7, 7, 7)
          expect { board.castle(white_king, rook, 1) }
          .not_to change { board.state }
        end
      end
    end

    context 'when queenside castling with White' do
      let(:white_king) { King.new('Kin', 'white') }
      let(:black_king) { King.new('kin', 'black') }
      let(:rook) { Rook.new('Roo', 'white') }

      before do
        board.state[7][4] = white_king
        board.state[7][0] = rook
        white_king.set_origin(board.state)
        rook.set_origin(board.state)        
      end

      context 'when path is clear' do
        it 'castles queenside' do
          expect { board.castle(white_king, rook, -1) }
            .to change { board.state[7][2] }.to(white_king)
            .and change { board.state[7][3] }.to(rook)
            .and change { board.state[7][4] }.from(be_truthy)
            .and change { board.state[7][0] }.from(be_truthy)
        end
      end

      context 'when path is blocked on 7, 1' do
        it 'does not castle' do
          board.state[7][1] = Knight.new('Kni', 'white')
          expect { board.castle(white_king, rook, -1) }
          .not_to change { board.state }
        end
      end

      context 'when path is blocked on 7, 2' do
        it 'does not castle' do
          board.state[7][2] = Knight.new('Kni', 'white')
          expect { board.castle(white_king, rook, -1) }
          .not_to change { board.state }
        end
      end

      context 'when path is blocked on 7, 3' do
        it 'does not castle' do
          board.state[7][3] = Knight.new('Kni', 'white')
          expect { board.castle(white_king, rook, -1) }
          .not_to change { board.state }
        end
      end

      context 'when white_king path is under attack' do
        it 'does not castle' do
          board.state[0][7] = black_king
          board.state[6][1] = Bishop.new('bis', 'black')
          expect { board.castle(white_king, rook, -1) }
          .not_to change { board.state }
        end
      end

      context 'when white_king has already moved' do
        it 'does not castle' do
          board.make_move(7, 4, 7, 5)
          board.make_move(7, 5, 7, 4)
          expect { board.castle(white_king, rook, -1) }
          .not_to change { board.state }
        end
      end

      context 'when rook has already moved' do
        it 'does not castle' do
          board.make_move(7, 0, 7, 1)
          board.make_move(7, 1, 7, 0)
          expect { board.castle(white_king, rook, -1) }
          .not_to change { board.state }
        end
      end
    end

    context 'when kingside castling with Black' do
      let(:black_king) { King.new('kin', 'black')}
      let(:white_king) { King.new('Kin', 'white')}
      let(:rook) { Rook.new('roo', 'black') }

      before do
        board.state[0][4] = black_king
        board.state[0][7] = rook
        black_king.set_origin(board.state)
        rook.set_origin(board.state)        
      end

      context 'when path is clear' do
        it 'castles kingside' do
          expect { board.castle(black_king, rook, 1) }
            .to change { board.state[0][6] }.to(black_king)
            .and change { board.state[0][5] }.to(rook)
            .and change { board.state[0][4] }.from(be_truthy)
            .and change { board.state[0][7] }.from(be_truthy)
        end
      end

      context 'when path is blocked on 0, 6' do
        it 'does not castle' do
          board.state[0][6] = Bishop.new('bis', 'black')
          expect { board.castle(black_king, rook, 1) }
          .not_to change { board.state }
        end
      end

      context 'when path is blocked on 0, 5' do
        it 'does not castle' do
          board.state[0][5] = Knight.new('kni', 'black')
          expect { board.castle(black_king, rook, 1) }
          .not_to change { board.state }
        end
      end

      context 'when king path is under attack' do
        it 'does not castle' do
          board.state[2][7] = Knight.new('kni', 'white')
          board.state[0][0] = white_king
          white_king.set_origin(board.state)
          expect { board.castle(black_king, rook, 1) }
          .not_to change { board.state }
        end
      end

      context 'when king has already moved' do
        it 'does not castle' do
          board.make_move(0, 4, 0, 3)
          board.make_move(0, 3, 0, 4)
          expect { board.castle(black_king, rook, 1) }
          .not_to change { board.state }
        end
      end

      context 'when rook has already moved' do
        it 'does not castle' do
          board.make_move(0, 7, 1, 7)
          board.make_move(1, 7, 0, 7)
          expect { board.castle(black_king, rook, 1) }
          .not_to change { board.state }
        end
      end
    end

    context 'when queenside castling with Black' do
      let(:black_king) { King.new('kin', 'black') }
      let(:white_king) { King.new('Kin', 'white') }
      let(:rook) { Rook.new('roo', 'black') }

      before do
        board.state[0][4] = black_king
        board.state[0][0] = rook
        black_king.set_origin(board.state)
        rook.set_origin(board.state)        
      end

      context 'when path is clear' do
        it 'castles queenside' do
          expect { board.castle(black_king, rook, -1) }
            .to change { board.state[0][2] }.to(black_king)
            .and change { board.state[0][3] }.to(rook)
            .and change { board.state[0][4] }.from(be_truthy)
            .and change { board.state[0][0] }.from(be_truthy)
        end
      end

      context 'when path is blocked on 0, 1' do
        it 'does not castle' do
          board.state[0][1] = Knight.new('Kni', 'black')
          expect { board.castle(black_king, rook, -1) }
          .not_to change { board.state }
        end
      end

      context 'when path is blocked on 0, 2' do
        it 'does not castle' do
          board.state[0][2] = Knight.new('Kni', 'black')
          expect { board.castle(black_king, rook, -1) }
          .not_to change { board.state }
        end
      end

      context 'when path is blocked on 0, 1' do
        it 'does not castle' do
          board.state[0][3] = Knight.new('Kni', 'black')
          expect { board.castle(black_king, rook, -1) }
          .not_to change { board.state }
        end
      end

      context 'when king path is under attack' do
        it 'does not castle' do
          board.state[1][1] = Bishop.new('Bis', 'white')
          board.state[7][7] = white_king
          expect { board.castle(black_king, rook, -1) }
          .not_to change { board.state }
        end
      end

      context 'when king has already moved' do
        it 'does not castle' do
          board.make_move(0, 4, 0, 5)
          board.make_move(0, 5, 0, 4)
          expect { board.castle(black_king, rook, -1) }
          .not_to change { board.state }
        end
      end

      context 'when rook has already moved' do
        it 'does not castle' do
          board.make_move(0, 0, 0, 1)
          board.make_move(0, 1, 0, 0)
          expect { board.castle(black_king, rook, -1) }
          .not_to change { board.state }
        end
      end
    end
  end
end


describe Game do
  subject(:game) { described_class.new }

  context 'when a game is played' do
    it 'changes state as expected' do
      arr = ["g1f3", "g8f6", "d2d4", "c7c6", "c2c4", "d7d5", "b1c3", "e7e6", "e2e3", "f8b4", "a2a3", "b4c3", "b2c3", "o-o", "f1d3", "b8d7", "c1b2", "b7b6", "a1b1", "c8b7", "o-o", "c6c5", "c4d5", "f6d5", "c3c4", "d5f6", "d4d5", "e6d5", "c4d5", "b7d5", "f3e5", "d7e5", "b2e5", "d8e7", "e5f6", "e7f6", "d3h7", "g8h7", "d1d5", "a8d8", "d5h5", "h7g8", "h2h3", "d8d6", "f1d1", "f8d8", "a3a4", "g7g6", "h5g4", "d8d7", "d1d6", "f6d6", "g4e4", "d6d5", "e4c2", "g8g7", "c2c3", "f7f6", "c3b3", "d5b3", "b1b3", "d7c7", "b3c3", "g7f7", "c3c4", "f7e6", "e3e4", "e6e5", "g2g3", "c7d7", "f2f4", "e5e6", "g1f2", "d7d3", "h3h4", "d3b3", "g3g4", "b3b4", "c4b4", "c5b4", "f2e2", "e6d6", "e2d2", "d6c5", "d2c2", "a7a5", "c2b3", "c5d4", "h4h5", "g6h5", "g4h5", "d4c5", "e4e5", "b6b5", "a4b5", "a5a4", "b3a4", "c5c4", "b5b6", "b4b3", "b6b7", "b3b2", "b7b8", "queen", "c4c3", "b8b2", "c3b2", "e5f6", "b2c3", "f6f7", "c3d4", "f7f8", "queen", "d4e4", "h5h6", "e4f3", "f4f5", "f3e4", "f5f6", "e4d5", "f6f7", "d5c6", "h6h7", "c6d5", "h7h8", "queen", "d5e6", "f8g8", "e6d5", "f7f8", "queen", "d5c6", "f8f6", "c6c5", "g8g5", "c5c4", "h8h4", "c4d3", "g5g3", "d3c2", "f6f2", "c2c1", "h4h1"]

      allow_any_instance_of(Input).to receive(:get_input).and_return(
        *arr)
      game.play_game
    end 
  end
end