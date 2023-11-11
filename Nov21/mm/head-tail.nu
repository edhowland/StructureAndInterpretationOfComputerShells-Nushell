# Given a list, return closure that every time it is called mutates by skipping
# one element and then returns that element
def head-tail [l: list] {
  [($l | get 0), {|| head-tail ($l | skip 1)} ]
}




# Returns a tuple with either the passed in value or the result of calling the closure
# If the passed value is returned in the first position of  the tuple, then the closure
# is just passed along in in the second position

def _b-or-w [tval, cl: closure] {
  if $tval == 'B' {
    [$tval, $cl]
  } else {
    do $cl
  }
}


# ctor for initial value for reduce function
def _ctor [itm0, w] {
  [(_b-or-w $itm0 (head-tail $w))]
}


# Curried reduce function that takes list of B's or anys and a list of
#  front loaded list of 0 or more W's with space chars in trailing positions
def red [itm0, w] {
  reduce -f (_ctor $itm0 $w)  {|it, acc| let cl = ($acc | last | last); $acc | append [(_b-or-w $it $cl)] }
}
