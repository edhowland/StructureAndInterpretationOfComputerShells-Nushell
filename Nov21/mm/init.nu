# init.nu: initialize guesses, games and running scores

let colors = [r g b y p a]
let color_names = [[Color 'Peg char']; [Red r] [Green g] [Blue b] [Yellow y] [Purple p] [Aqua a] [Black B] [White W]]

def "peg to-color" [] {
  let peg = $in
  $color_names | where 'Peg char' == $peg | get Color | get 0
}


def "peg colors" [] {
  split chars | each {|c| $c | peg to-color }
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


