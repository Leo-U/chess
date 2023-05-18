require_relative '../lib/oop_version.rb'

describe Knight do
  describe '#legal_move?' do
    subject(:legal_knight) { described_class.new('knight', 'black') }
    let(:state) { 8.times.map { 8.times.map { nil } } }

    context 'when knight is at top left corner' do
      before do
        state[0][0] = legal_knight
        legal_knight.set_position(state)
      end

      context 'when  destination is 2 right and 1 down' do
        it 'returns true' do
          legal_knight.set_destination(1, 2)
          expect(legal_knight.legal_move?).to be true
        end
      end

      context 'when destination is 1 right and 2 down' do
        it 'returns true' do
          legal_knight.set_destination(2, 1)
          expect(legal_knight.legal_move?).to be true
        end
      end

      context 'when destination is 2 left and 1 down' do
        it 'returns false' do
          legal_knight.set_destination(1, -2)
          expect(legal_knight.legal_move?).to be false
        end
      end

      context 'when destination is 1 left and 2 down' do
        it 'returns false' do
          legal_knight.set_destination(2, -1)
          expect(legal_knight.legal_move?).to be false
        end
      end
    end

    context 'when knight is at 4, 2' do
      before do
        state[4][2] = legal_knight
        legal_knight.set_position(state)
      end

      context 'when destination is 1 left and 2 down' do
        it 'returns true' do
          legal_knight.set_destination(6, 1)
          pp state
          expect(legal_knight.legal_move?).to be true
        end
      end

      context 'when destination is 1 left and 2 up' do
        it 'returns true' do
          legal_knight.set_destination(2, 1)
          expect(legal_knight.legal_move?).to be true
        end
      end
    end

    context 'when knight is at 2, 7' do
      before do
        state[2][7] = legal_knight
        legal_knight.set_position(state)
      end

      context 'when destination is 1 right and 2 down' do
        it 'returns false' do
          legal_knight.set_destination(4, 8)
          pp state
          expect(legal_knight.legal_move?).to be false
        end
      end
    end
  end
end