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
        it 'returns true' do
          legal_bishop.set_destination(5, 1)
          expect(legal_bishop.legal_move?(board)).to be true
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
            shitty_print_board(board)
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
            shitty_print_board(board)
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
            shitty_print_board(board)
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
            shitty_print_board(board)
            expect(between_bishop.diagonal_clear?(board)).to be false
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
      context 'when destination is at 2, 2' do
        it 'returns true' do
          legal_queen.set_destination(2, 2)
          expect(legal_queen.legal_move?(board)).to be true
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
        it 'returns true' do
          legal_rook.set_destination(7, 0)
          expect(legal_rook.legal_move?(board)).to be true
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
          shitty_print_board(board)
        end
      end
    end
  end
end
