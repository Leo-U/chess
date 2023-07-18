The following is the GPT prompt that I used to generate `verify_ending_positions.rb`

User:
I have a pgn file that reads as follows:

```
[Event "Rated Blitz game"]
[Site "https://lichess.org/A9TSyVf2"]
[Date "2023.06.05"]
[Round "?"]
[White "gatorricky"]
[Black "pawngrid"]
[Result "1-0"]
[WhiteElo "1725"]
[BlackElo "1757"]
[ECO "D01"]
[TimeControl "180+0"]
[UTCDate "2023.06.05"]
[UTCTime "03:27:34"]
[Termination "Normal"]
[WhiteRatingDiff "+6"]
[BlackRatingDiff "-6"]
[Variant "Standard"]

d2d4 g8f6 b1c3 d7d5 c1f4 c7c5 e2e3 e7e6 c3b5 d8a5 c2c3 b8a6 d4c5 f8c5 b5d4 o-o f1a6 a5a6 g1e2 f8e8 f4g5 f6e4 g5h4 c5d6 o-o c8d7 h4g3 e4g3 e2g3 d6c7 d1h5 a6d6 f2f4 e6e5 d4f3 e5f4 f3g5 h7h6 h5f7 g8h8 f1f4 h6g5 f7h5 h8g8 f4f7 d6h6 h5h6 g7h6 f7d7 c7b6 g3f5 e8e5 f5h6 g8f8 h6g4 e5e4 a1f1 f8e8 d7b7 b6e3 g4e3 e4e3 h2h3 a8d8 f1f7 e3e1 g1h2 d8d6 f7h7 d6f6 b7b8 { "1R2k3/p6R/5r2/3p2p1/8/2P4P/PP4PK/4r3 b - - 8 36" } 1-0

[Event "Rated Blitz game"]
[Site "https://lichess.org/3gG8gCFq"]
[Date "2023.06.05"]
[Round "?"]
[White "pawngrid"]
[Black "DANIEL76"]
[Result "1-0"]
[WhiteElo "1751"]
[BlackElo "1784"]
[ECO "D11"]
[TimeControl "180+0"]
[UTCDate "2023.06.05"]
[UTCTime "03:21:08"]
[Termination "Normal"]
[WhiteRatingDiff "+6"]
[BlackRatingDiff "-6"]
[Variant "Standard"]

g1f3 d7d5 d2d4 c7c6 c2c4 g8f6 c4d5 f6d5 e2e4 d5f6 b1c3 c8g4 f1e2 e7e6 o-o b8d7 h2h3 g4h5 d4d5 e6d5 e4d5 c6d5 c3d5 h5f3 d5f6 d7f6 e2f3 d8d1 f1d1 f8c5 d1e1 e8d7 c1f4 h8e8 a1d1 d7c8 f3g4 f6g4 e1e8 { "r1k1R3/pp3ppp/8/2b5/5Bn1/7P/PP3PP1/3R2K1 b - - 0 20" } 1-0

[Event "Rated Bullet game"]
[Site "https://lichess.org/Xgiithho"]
[Date "2023.06.05"]
[Round "?"]
[White "pawngrid"]
[Black "cometomecometohere"]
[Result "0-1"]
[WhiteElo "1613"]
[BlackElo "1584"]
[ECO "A30"]
[TimeControl "60+0"]
[UTCDate "2023.06.05"]
[UTCTime "01:41:56"]
[Termination "Normal"]
[WhiteRatingDiff "-6"]
[BlackRatingDiff "+6"]
[Variant "Standard"]

g1f3 c7c5 c2c4 b7b6 b1c3 c8b7 e2e3 d7d6 f1e2 e7e6 o-o g8f6 d2d4 b8d7 b2b3 a7a6 c1b2 f8e7 d4d5 e6d5 c4d5 b6b5 f1e1 o-o c3b1 b7d5 b1d2 d5b7 d1c2 d8c7 a2a3 h7h6 c2c3 f8e8 e2d3 e7f8 e3e4 c7c6 e4e5 d7e5 f3e5 c6g2 { "r3rbk1/1b3pp1/p2p1n1p/1pp1N3/8/PPQB4/1B1N1PqP/R3R1K1 w - - 0 22" } 0-1

```
The pgn file continues as above for thousands of lines.

I also have written a chess program. It is capable of receiving the moves in the similar-to-UCI format seen above via `gets`, i.e. it `gets` e1e8 etc. from the player.

I need a ruby file, executable by RSpec, that does the following in a loop:

Using Ruby IO, it goes line by line thru the pgn file.

First, it saves an empty array to a variable: let's call that variable `game_moves`.
Then, if the line begins with a character sequence corresponding to `[a-h][1-8][a-h][1-8] ` (trailing space included), then it pushes that character sequence, and every following character sequence that either a) matches that same pattern again, b) is `o-o `, c) is `o-o-o `, d) is `queen `, e) is `rook `, f) is `knight `, or g) is `bishop `, to the `game_moves` variable, until the game is completed. The array will then be an array of moves that looks something like `[g1f3, d7d5, d2d4, c7c6, c2c4, g8f6, c4d5, f6d5 e2e4, d5f6, b1c3, c8g4, f1e2, e7e6, o-o, b8d7]`, etc.

Then, I need to save the string inside the curly braces `{}` to a second variable -- let's call it `fen_string`; the leading and trailing spaces should not be included.

Now, I need to execute the rspec test example. I need to stub `gets`, allowing it to receive and return the series of moves saved in `game_moves`, using the splat operator to pass the moves as arguments to the `allow` statement. Then I need to have the game play a game to update the board state. There'll be a statement that `game = Game.new`, and then `game.play_game`. After execution of `play_game` is complete, the board state will be updated. I then need to expect my chess program's board state to equal the FEN string at the end of the game bank file. The way that'll work is that in my chess program, my Game class will have a `board` instance variable, and `board` itself will be an instance of another class Board which will have a method `output_fen` which will convert the current board state to a fen string and return it. So the expect statement will be something like `expect(game.board.output_fen).to eq(fen_string)`. And that will be the completed test for that one tested game in the pgn game bank file. At this point, the script will go to the next iteration of the loop, redefining the variables as the IO program continues reading the pgn file, until the file is completely read and every game in the pgn file has been input to the chess program.

For your information, the file for the chess game is `oop_version.rb`, and the filename for the pgn file is `uci_promotion-corrected.pgn.` Rrspec has already been initalized in the repo.