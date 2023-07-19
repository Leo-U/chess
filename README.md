## Chess

This is a command-line chess game completed as part of the Odin Project curriculum.

I completed it according to these instructions:

https://www.theodinproject.com/lessons/ruby-ruby-final-project

I used a TDD approach for some core game code that determined things like move legality, piece promotion, and castling.

I also wrote a second test script that feeds move sequences from 600 real games into the chess program and checks that the final board position for each game is identical to the final position of the real game.

Truth be told, I didn't write the second `verify_ending_positions.rb` rspec file directly -- I did use ChatGPT -- however, the prompt I used shows that I put a good amount of thought into how the script should work. I included the prompt as proof in `gpt-prompt.md`. I *did* write the other rspec script, `tdd_tests.rb`, myself.

`verify_ending_positions.rb` gets the series of moves from a pgn file (portable game notation). The moves were initially in the wrong format, so I had to edit the pgn file by using the pgn-extract tool (https://www.cs.kent.ac.uk/people/staff/djb/pgn-extract/) by David Barnes.

Live version: https://replit.com/@LeoU1/chess?v=1

---
#### How to play
1. Either follow the live version link above (replit.com can be slow), or in Ubuntu 20.04 or other compatible OS, make a local copy of the directory, and with Ruby installed, navigate to the directory and enter `ruby lib/main.rb` in the terminal.

2. To make moves, follow instructions by typing `help` in-game, or by reading `instructions.txt`