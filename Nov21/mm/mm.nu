#!/usr/bin/env nu
# The game of MasterMind (https://en.wikipedia.org/wiki/Mastermind_(board_game)#Gameplay_and_rules)

source stack.nu
source init.nu
source player.nu
source analyze.nu




# The game of MasterMind in the Nu programming language
def main [
  --blank (-b):string = ' ' # The character to display for blank holes in hint. Screen reader users should use something like: '%'
    --colors (-c) # Prints the list of colors and exits
    --fake (-t): string # Overrides the random code generator in place of this arg. Used for testing
  guesses:int = 8 # The number of guesses the codebreaker can have. Max 12
  ] {
  if $colors { $color_names | cat; print "\nFor the hints 'B' is used for the black pegs and 'W' is used for the white pegs but only in the hints. They cannot be used in guesses and will never be used in codes"; exit 0 }
  if $guesses > 12 { print -e $"The number of guesses is to high: ($guesses). The max is 12"; exit 1 }
  let code = make code


  print "I am the code maker. I have constructed a 4 color unbreakable code"
  print $"You have ($guesses) attempts, but don't even try because you will not be able to break my code"
  print "After each guess you will see a hint. Black pegs in any of  4 holes  mean you have the correct color in the correct position"
  print "Any white pegs mean you have a correct color but not in the correct position"
  print "Keep adjusting your guess untill all 4 pegs are black. But this will never happen because you are so feeble minded!"
  for $trie in 1..$guesses {
    try {
      guess $trie | hint $code | cat
    print ""
    } catch {|e| print -e $"Dimwit! You lost one turn:  the error was >($e.msg)<" }
  }
  print $"The correct code was ($code)"
  $code | peg colors
}
