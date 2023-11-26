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

