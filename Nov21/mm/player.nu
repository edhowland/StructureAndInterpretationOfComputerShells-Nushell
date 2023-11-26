# player.nu: functions that deal with player input

# Creates a simple error with a simple msg string
def simple-error [m: string] {
    error make {msg: $m }
}


# Surrounds execution of closure with try/catch.
def "wrap error" [cl: closure] -> closure {
  {|t|
    try {
      do $cl $t
    } catch {|err|
      print -e $"($err.msg)\n   and you lose one turn"
      false
    }
  }
}

# Checks if input guess only has colors in $colors
def "colors valid" [] {
  split chars | each {|it| $it in $colors} | all {|e| $e }
}




# Asks the player for a guess. Will error if not the correct possible colors
# or count is not exact
def guess [number: int = 0, req: int = 4] {
  let g = (input $"Guess \(($number)\)? ")
  if ($g | str length) != $req {
    simple-error $"Must enter the correct number of color guesses which must be ($req)"
  }
  if not ($g | colors valid) {
    simple-error "Colors input are not all in set of valid colors"
  }
  $g
}

