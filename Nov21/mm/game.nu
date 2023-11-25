# game.nu: various helper functions for game play

# Force the input to be displayed on the terminal
def display [] {
  print $"($in)"
}


# Given a string in  the input prints it to stdout
# If the input here is 'BBBB', all black pegs, then true is returned signifying a win
def output [blank: string = ' '] {
  let out = $in
  $out | display
  $out == 'BBBB'
}


# Actually plays the game through multiple plys. The action of game play
# is defined by the passed closure. If the game is won, then the closure
# # should return true, else false in which case it loops till all plys
# are exausted. If that happens, then play returns false
def play [game: closure, turns: int, ply: int = 1] -> bool {
  if $ply > $turns {
    return false  # Because the player lost
  } else if (do $game $ply) {
    return true # The player won
  } else {
    play $game $turns ($ply + 1) # Play again
  }
}
