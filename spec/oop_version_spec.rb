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
    end



    #context 'when knight is '
  end
end