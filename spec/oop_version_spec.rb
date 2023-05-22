require_relative '../lib/oop_version.rb'

describe Knight do
  describe '#legal_move?' do
    subject(:legal_knight) { described_class.new('kn1', 'black') }
    let(:board) { Board.new }

    context 'when knight is at top left corner' do
      before do
        board.state[0][0] = legal_knight
        legal_knight.set_position(board.state)
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

      context 'when destination is 2 left and 1 down' do
        it 'returns false' do
          legal_knight.set_destination(1, -2)
          expect(legal_knight.legal_move?(board)).to be false
        end
      end

      context 'when destination is 1 left and 2 down' do
        it 'returns false' do
          legal_knight.set_destination(2, -1)
          expect(legal_knight.legal_move?(board)).to be false
        end
      end
    end

    context 'when knight is at 4, 2' do
      before do
        board.state[4][2] = legal_knight
        legal_knight.set_position(board.state)
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

    context 'when knight is at 2, 7' do
      before do
        board.state[2][7] = legal_knight
        legal_knight.set_position(board.state)
      end

      context 'when destination is 1 right and 2 down' do
        it 'returns false' do
          legal_knight.set_destination(4, 8)
          expect(legal_knight.legal_move?(board)).to be false
        end
      end
    end
  end
end

describe Bishop do
  describe '#legal_move?' do
    subject(:legal_bishop) { described_class.new('bp1', 'black') }
    let(:board) { Board.new }

    context 'when bishop is at 0, 0' do
      before do
        board.state[0][0] = legal_bishop
        legal_bishop.set_position(board.state)
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

      context 'when destination is out of bounds' do
        it 'returns false' do
          legal_bishop.set_destination(-1, -1)
          expect(legal_bishop.legal_move?(board)).to be false
        end
      end
    end

    context 'when bishop is at 0, 7' do
      before do
        board.state[0][7] = legal_bishop
        legal_bishop.set_position(board.state)
      end

      context 'when destination is at 7, 0' do
        it 'returns true' do
          legal_bishop.set_destination(7, 0)
          expect(legal_bishop.legal_move?(board)).to be true
        end
      end

      context 'when destination is out of bounds' do
        it 'returns false' do
          legal_bishop.set_destination(-1, 8)
          expect(legal_bishop.legal_move?(board)).to be false
        end
      end
    end

    context 'when bishop is at 7, 3' do
      before do
        board.state[7][3] = legal_bishop
        legal_bishop.set_position(board.state)
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

      context 'when destination is 8, 4' do
        it 'returns false' do
          legal_bishop.set_destination(8, 4)
          expect(legal_bishop.legal_move?(board)).to be false
        end
      end
    end

    context 'when bishop is at 3, 3' do
      before do
        board.state[3][3] = legal_bishop
        legal_bishop.set_position(board.state)
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
        between_bishop.set_position(board.state)
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
    let(:board) { Board.new }

    context 'when rook is at 0, 0' do
      before do
        board.state[0][0] = legal_rook
        legal_rook.set_position(board.state)
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

      context 'when destination is out of bounds' do
        it 'returns false' do
          legal_rook.set_destination(0, 8)
          expect(legal_rook.legal_move?(board)).to be false
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
        between_rook.set_position(board.state)
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

end

describe Queen do
  subject(:legal_queen) { described_class.new('qn1', 'black') }
  let(:board) { Board.new }

  describe '#legal_move?' do
    context 'when queen is at 3, 3' do
      before do
        board.state[3][3] = legal_queen
        legal_queen.set_position(board.state)
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

      context 'when destination is out of bounds' do
        it 'returns false' do
          legal_queen.set_destination(-1, -1)
          expect(legal_queen.legal_move?(board)).to be false
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

  describe '#legal_move?' do
    context 'when king is at 3, 3' do
      before do
        board.state[3][3] = legal_king
        legal_king.set_position(board.state)
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
        before { legal_king.set_destination(3, 4) }

        context 'when unobstructed' do
          it 'returns true' do
            expect(legal_king.legal_move?(board)).to be true
          end
        end

        context 'when destination threatened by bishop' do
          it 'returns false' do
            board.state[0][7] = Bishop.new('bsp', 'white')
            expect(legal_king.legal_move?(board)).to be false
          end
        end

        context 'when destination threatened by knight' do
          it 'returns false' do
            board.state[1][5] = Knight.new('knt', 'white')
            expect(legal_king.legal_move?(board)).to be false
          end
        end

        context 'when destination threatened by rook' do
          it 'returns false' do
            board.state[0][4] = Rook.new('rk1', 'white')
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

        context 'when destination threatened by pawn' do
          it 'returns false' do
            board.state[4][5] = Pawn.new('pn1', 'white')
            shitty_print_board board
            expect(legal_king.legal_move?(board)).to be false
          end
        end
      end
    end
  end
end

describe Pawn do
  let(:board) { Board.new }

  context 'when black pawn is at 1, 4' do
    subject(:legal_pawn_black) { described_class.new('pwn', 'black') }

    before do
      board.state[1][4] = legal_pawn_black
      legal_pawn_black.set_position(board.state)
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

    context 'when destination is '
  end

  context 'when white pawn is at 6, 3' do
    subject(:legal_pawn_white) { described_class.new('pwn', 'white') }

    before do
      board.state[6][3] = legal_pawn_white
      legal_pawn_white.set_position(board.state)
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