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



# Returns list of color charss or '^'s that match or do not match exact color and position
def exacts [c: string]: string -> list {
  split chars | zip ($c | split chars) | each {|l| if $l.0 == $l.1 { $l.0 } else { '^' } }
}



# Given a list of color characters return a record of color groups
 alias "color groups" = group-by




# Say: code == rbyb with 2 bees in offsets 1,3
# guess is BBBX' with 3 bees with 1 in exact position
# Hint should have 1 black peg and one white peg with black peg in offset 1
# The white peg positions
# are filled from left to right in empty spaces where black  pegs are not present

# This count of white pegs is the total for  all matching colors not in correct positions
