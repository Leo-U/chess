require_relative '../lib/oop_version.rb'

describe Game do
  # Read each game from the PGN file
  File.open('./game-bank-mate-only.pgn').each("}\n\n") do |game_text|

    it 'plays the game correctly' do
      # Extract each move and FEN from the game
      game_moves = game_text.scan(/[a-h][1-8][a-h][1-8]|o-o(-o)?/).map(&:strip)
      fen_string = game_text.split(/\s{ \s*/).last.split[0]
      
      p game_moves
      puts fen_string
      # Play the game
      # game = Game.new
      # allow_any_instance_of(Input).to receive(:get_input).and_return(*game_moves)
      # game.play_game

      # # Verify the final FEN matches
      # expect(game.board.output_fen).to eq(fen_string)
    end
  end
end
