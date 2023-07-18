# feeds move sequences from 600 real games into the chess program and checks that the final board position for each game is identical to the final position of the real game
require_relative '../lib/game.rb'

describe Game do
  File.open('./spec/game-bank-all-end-in-mate.pgn').each("}\n\n") do |game_text|

    it 'plays the game correctly' do
      game_moves = game_text
      .split(/\s/)
      .drop_while { |s| !s.match(/[a-h][1-8][a-h][1-8]|o-o(-o)?/) }
      .take_while { |s| !s.match(/\{/) }
      fen_string = game_text.split(/\s{ \s*/).last.split[0]

      game = Game.new
      allow_any_instance_of(Input).to receive(:get_input).and_return(*game_moves)
      game.play_game

      expect(game.board.output_fen).to eq(fen_string)
    end
  end
end