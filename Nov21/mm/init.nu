# init.nu: initialize guesses, games and running scores

let colors = [r g b y p a]


# Duplicates the value in a list . E.g. [r] => [r r] Pipe many togeter for longer lists
def cdup [] {
  each {|it| [$it, $it] } | flatten
}

# Returns code string from among list of color chars
def "make code" [] -> string {
  $colors | cdup | cdup | shuffle | first 4 
}

# converts list of colors into a 4 char string
alias color4 = str join ''


## Set operations

# Return the intersect of two lists  or a list and a record whose keys will be used as a list
def "set intersect" [other] {
  reduce -f [] {|it, acc|  if $it in $other { $acc | append $it } else { $acc } }
}
