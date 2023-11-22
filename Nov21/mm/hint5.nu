# hint5.nu Fifth attempt
source fanners.nu

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
  fan out | fan in {|| black loci } {|| hole loci | white loci $wlist } {|l2| append $l2 | sort | each {|it| $it.1 } }
}


# Attempt number 5 at hint as more point free
def hint5 [code: string] {
  let guess = $in
  $guess | black pegs $code | sort pegs ($guess | white pegs $code) | str join ''
}
