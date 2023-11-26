#!/usr/bin/env nu
# The game of MasterMind (https://en.wikipedia.org/wiki/Mastermind_(board_game)#Gameplay_and_rules)

# Save this file to something like 'mm.nu'.
# then run either 'nu mm.nu' or make it executable: 'chmod +x mm.nu; ./mm.nu'
# Use the --help option to  see the list of options which includes --rules
# which details the game and game play and rules.


# init.nu: initialize guesses, games and running scores

let colors = [r g b y p a]
let color_names = [[Color 'Peg char']; [Red r] [Green g] [Blue b] [Yellow y] [Purple p] [Aqua a] [Black B] [White W] [Blank ' ']]

def "peg to-color" [] {
  let peg = $in
  $color_names | where 'Peg char' == $peg | get Color | get 0
}


def "peg colors" [] {
  split chars | each {|c| $c | peg to-color } | str join ' '
}

# Duplicates the value in a list . E.g. [r] => [r r] Pipe many togeter for longer lists
def cdup [] {
  each {|it| [$it, $it] } | flatten
}

# Returns code string from among list of color chars
def "make code" [] -> string {
  $colors | cdup | cdup | shuffle | first 4 | str join '' 
}

# converts list of colors into a 4 char string
alias color4 = str join ''


## Set operations

# Return the intersect of two lists  or a list and a record whose keys will be used as a list
def "set intersect" [other] {
  reduce -f [] {|it, acc|  if $it in $other { $acc | append $it } else { $acc } }
}

# Returns the sum of the list or 0 if input is empty
def safe-sum [] {
  let li = $in
  if ($li | is-empty) {
    0
  } else {
    $li | math sum
  }
}
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

# fanners.nu : various fanning methods

# Duplicates its input
def dup [] {
  let it = $in
  [$it, $it]
}


# Takes 2 inputs (from a list), and 3 closures applies closure 1 to first
# element of list, applies closure 2 to second element of list and then
#  combines them in third closure where this closure expects standard in and a
# parameter which is the output of second closure
def "fan in" [cl1: closure, cl2: closure, cl3: closure] {
  let dl = $in
  $dl.0 | do $cl1 | do $cl3 ($dl.1 | do $cl2)
}

# analyze.nu: fns to compare guess and unbroken code

## Util fns

# Produces record from list of tuples of key, value pairs
def "keyval to-record" [] {
  reduce -f {} {|it, acc| $acc | upsert $it.0 $it.1 }
}

# Given  result of group-by with key as color char and value as list, returns new
# record with key as color char and count as length of list
def "color counts" [] {
  items {|k,v| [$k, ($v | length)] } | keyval to-record
}



# Converts guess and unbroken code  into list of black pegs and holes
def "black pegs" [c: string, blank: string = ' ']: string -> list {
  split chars | zip ($c | split chars) | each {|l| if $l.0 == $l.1 { 'B' } else { $blank } }
}


# Get only the enumerated holes in the black peg list
def "black holes"  [] {
  filter {|it| $it.item == ' ' } | get index
}



# Gets the count of black pegs
def "black count" [] {
  filter {|it| $it == 'B' } | length
}



# Given a list of color characters return a record of color groups
 alias "color groups" = group-by




# Say: code == rbyb with 2 bees in offsets 1,3
# guess is BBBX' with 3 bees with 1 in exact position
# Hint should have 1 black peg and one white peg with black peg in offset 1
# The white peg positions
# are filled from left to right in empty spaces where black  pegs are not present

# This count of white pegs is the total for  all matching colors not in correct positions

# Converts string of color characters into color counts
def "color to-counts" [] {
  split chars | group-by | color counts
}



# Returns all the possible white pegs given the input guess and the unbroken code
def "white all" [code: string]  {
  let guess = $in
  let code_counts = ($code | color to-counts)
  let guess_counts = ($guess | color to-counts)
  let common_colors = ($code_counts | columns | set intersect $guess_counts)
  $common_colors | reduce -f {} {|it, acc| $acc | insert $it   ([($code_counts | get $it), ($guess_counts | get $it)] | math min) } | values | safe-sum
}


# Returns the actual count of white pegs where white all - black count
def "white count" [code: string] {
  let guess = $in
  ($guess | white all $code) - ($guess | black pegs $code | black count)
}


# Returns the filled in string of white pegs based on  some count, probably from white count
def "white fill" [count: int, max: int = 4] {
  '' | fill -c 'W' -w $count | fill -w $max -c ' ' | split chars
}


# Like black pegs, returns a list of white pegs and blanks
def "white pegs" [code: string] {
  white fill ($in | white count $code)
}

# The main dude!

# Converts enumerated table into list of lists
def "enums to-list" []: table -> list {
  each {|row| [$row.index, $row.item] }
}



# Returns the locations and the black pegs from a partial hint w/only black pegs
def "black loci" [] {
  enumerate | filter {|it| $it.item == 'B' } | enums to-list
}


# Returns the locations of  the holes. Only the locations not the holes themselves
def "hole loci" [] {
  enumerate | filter {|it| $it.item == ' ' } | get index
}


# Returns locations of (possible) white pegs by combining hole loci with white peg list
def "white loci" [wlist: list] {
  zip $wlist
}


# Combines 2 peg lists into a sorted single list
def "sort pegs" [wlist: list] {
  dup | fan in {|| black loci } {|| hole loci | white loci $wlist } {|l2| append $l2 | sort | each {|it| $it.1 } }
}


# Attempt number 5 at hint as more point free
def hint [code: string] {
  let guess = $in
  $guess | black pegs $code | sort pegs ($guess | white pegs $code) | str join ''
}
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


# Prints the rules of the game and exits
def rules [] {
  print $"
The traditional game of MasterMind is played on a board with  rows of holes into
which colored pegs are inserted. The rows are grouped into 2 sets of 4 holes
each with the left group of 4 holes are used by the  code breaker to provide
a guess at the hidden secret code.  There is also often a removable screen
at the top of the board \(from the challenger's perspective\) which obscurs the
actual code. This screen is removed to display the correct answer at the end
of game play.
The 4 holes at the right of the challenger's guess positions are used by the
code maker to provide a hint. with a mix of black or white pegs or empty holes.
  Both the secret code and all of the guesses consist of any permutation of 4
colors from a pallette of 6 possible colors. There can be any number of repeated
colors in the code or any guess. The only disallowed colors are black and white
which are reserved for the hint exclusively.
The game play proceeds thusly:
1. The screen is inserted blocking the view of the 4 code holes.
2. The code maker places any mix of colored pegs in this hidden hole set.
3. The code breaker places a guess in the first set of 4 holes in row 1.
4. The code maker places a  number of black and white pegs  in  right holes.

Steps 3 and 4 are repeated in rows 2 through the last row until the guess matches
the code or until the agreed upon maximum number of guesses is exhausted.
Scoring is different depending on the edition of the game and is not used here.

About the hints:
The hint consists of some combination of black or white pegs or holes
 all of which are significant.

A black peg in any particular hole means that the correct color is matched
there in the correct position.
A white peg in any hole means that the correct color is matched but in the
wrong position.
An empty hole means that some color in some hole is incorrect.

Note: The position of any white pegs are not significant as are the empty
holes. In fact, the code breaker might choose to trick the code breaker
by placing a white peg in the incorrect hole.
How this version is played.
After the intro, the user is asked for a guess which must consist of only 4
characters all lowercase of the first character of the colored peg follwed
by a Enter key.
Here are the colors and characters allowd.

Red: r
Blue: b
Green: g
Yellow: y
Purple: p
Aqua: a


After this has been entered, the hint is generated by comparing the unknown
code and some number of black or white pegs are displayed.

The hint colors

Black: B
White: W
Blank: ' '

If the hint is all black: "BBBB", the player has won and the game exits
and the correct code is displayed with fully spelled out colors:

Blue Red Green Green

If the maximum number of guesses is exhausted, the game is lost and the code is revealed.

The maximum number of guesses is set initially at 8 and cannot exceed 12, but
can be adjusted up or down to change the difficulty of the game.
Screen reader users can pass the '--sr' flag to get the hint displayed as
fully spelled out color names.

An example of game play is now shown using the --sr flag to spell out the
colors:
--- Intro elided

Guess (1)? rbrb
Black White White Black
Guess (2)? rrbb
Black Black Black Black
Congratulations! You are a winner.
This time

The correct code was rrbb
Red Red Blue Blue



Good Luck!

"
  exit
}


#  Plays exactly one round. Checks out for errors in input.
def round [cl: closure,guesses: int] -> bool {
  play (wrap error $cl) $guesses
}
# srfriend.nu: Creen Reader friendly version of output code



# Screen reader friendly version of output
# Formats 4 character string into 4 word string and outputs it.
# Also checks for winning input like output
def srfriend [] -> bool {
  let out = $in
  $out | peg colors | display
  $out == 'BBBB'
}




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

  if (round $one_ply $guesses) { # number of turns
    print "Congratulations! You are a winner.\nThis time\n"
  } else {
    print "Not quite up to the challenge, huh?"
  }
  print $"The correct code was ($code)
  ($code | peg colors)
  
"
}
