### Chess

This is a command-line chess game completed as part of the Odin Project curriculum.

I completed it according to these instructions:

https://www.theodinproject.com/lessons/ruby-ruby-final-project

I used a TDD approach for the core game code that determined things like move legality, piece promotion, and castling.

I also wrote a second test script that feeds move sequences from 600 real games into the game and checks that the final board position for each game is identical to the final position of the real game. Said test script gets the move input from a pgn file (portable game notation), which I was able to format to moves that my game could understand by heavily using the pgn-extract tool (https://www.cs.kent.ac.uk/people/staff/djb/pgn-extract/) by David Barnes.

### To input moves:

To move or capture with pieces that are not pawns: use piece letter with destination square, e.g. 'nf3' or 'bg7'.

If two of the same piece can move to the destination square, use unambiguous notation e.g. 'e4d5', which is original square + destination square

To push pawns: use file followed by rank number, e.g. 'e4', 'd4', 'h4', etc.
To capture with pawns : use aforementioned unambiguous notation.

To kingside castle: enter o-o

To queenside castle: enter o-o-o

To promote, push pawn to the end of the board and then simply follow the prompt instructions.