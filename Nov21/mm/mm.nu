#!/usr/bin/env nu
# The game of MasterMind (https://en.wikipedia.org/wiki/Mastermind_(board_game)#Gameplay_and_rules)



# Is this a valid guess. IOW: does it have the right number of pegs?
def "valid guess" [] {
  ($in | str length) == 4
}

# The game of MasterMind in the Nu programming language
def main [
  --blank (-b):string = ' ' # The character to display for blank holes in hint. Screen reader users should use something like: '%'
  guesses:int = 8 # The number of guesses the codebreaker can have. Max 12
  ] {
  if $guesses > 12 { print -e $"The number of guesses is to high: ($guesses). The max is 12"; exit 1 }

  for $trie in 1..$guesses {
    print $"Guess #($trie)"
  }
}
