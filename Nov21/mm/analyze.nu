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
