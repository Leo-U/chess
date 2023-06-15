### Chess

This is a command-line chess game completed as part of the Odin Project curriculum.

I completed it according to these instructions:

https://www.theodinproject.com/lessons/ruby-ruby-final-project

I used a TDD approach for the core game code that determined things like move legality, piece promotion, and castling.

I also wrote a second test script that feeds move sequences from 600 real games into the game and checks that the final board position for each game is identical to the final position of the real game. Said test script gets the move input from a pgn file (portable game notation), which I was able to format to moves that my game could understand by heavily using the pgn-extract tool (https://www.cs.kent.ac.uk/people/staff/djb/pgn-extract/) by David Barnes.