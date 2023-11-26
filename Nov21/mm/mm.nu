#!/usr/bin/env nu
# The game of MasterMind (https://en.wikipedia.org/wiki/Mastermind_(board_game)#Gameplay_and_rules)

# Save this file to something like 'mm.nu'.
# then run either 'nu mm.nu' or make it executable: 'chmod +x mm.nu; ./mm.nu'
# Use the --help option to  see the list of options which includes --rules
# which details the game and game play and rules.


source init.nu
source player.nu
source fanners.nu
source analyze.nu
source game.nu
source srfriend.nu



# The game of MasterMind in the Nu programming language
def main [
    --rules (-R)   # Print the rules and then exit
    --sr (-r) # Make the output screen reader friendly
    --colors (-c) # Prints the list of colors and exits
    --fake (-t): string # Overrides the random code generator in place of this arg. Used for testing
  --guesses (-g):int = 8 # The number of guesses the codebreaker can have. Max 12
  ] {
  if $rules { rules }
  if $colors { $color_names | cat; print "\nFor the hints 'B' is used for the black pegs and 'W' is used for the white pegs but only in the hints. They cannot be used in guesses and will never be used in codes"; exit 0 }
  if $guesses > 12 { print -e $"The number of guesses is to high: ($guesses). The max is 12"; exit 1 }
  let code = if not ($fake | is-empty) { $fake } else {  make code }
  let one_ply = if $sr { 
  {|turn| guess $turn | hint $code | srfriend }
  } else { 
  {|turn| guess $turn | hint $code | output } 
  }

  print $"I am the code maker. I have constructed a 4 color unbreakable code
  You have ($guesses) attempts, but don't even try because you will not be able to break my code
   After each guess you will see a hint. Black pegs in any of  4 holes  mean you have the correct color in the correct position
  Any white pegs mean you have a correct color but not in the correct position
"

  if (play $one_ply $guesses) { # number of turns
    print "Congratulations! You are a winner.\nThis time\n"
  } else {
    print "Not quite up to the challenge, huh?"
  }
  print $"The correct code was ($code)
  ($code | peg colors)
  
"
}
