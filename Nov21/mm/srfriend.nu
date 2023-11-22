# srfriend.nu: Creen Reader friendly version of output code


let char_colors = {
  p: purple,
  y: yellow,
  g: green,
  b: blue,
  r: red,
  a: aqua,
  B: Black,
  W: White,
  ' ': Blank,
}

# Formats 4 character string into 4 word string and outputs it.
# Also checks for winning input like output
def output [blank: string] -> bool {
  let out = $in
  $out | split chars | each {|it| $char_colors | get $it } | str join ' ' | cat
  $out == 'BBBB'
}
