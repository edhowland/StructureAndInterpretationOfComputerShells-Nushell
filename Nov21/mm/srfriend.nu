# srfriend.nu: Creen Reader friendly version of output code



# Screen reader friendly version of output
# Formats 4 character string into 4 word string and outputs it.
# Also checks for winning input like output
def srfriend [] -> bool {
  let out = $in
  $out | peg colors | display
  $out == 'BBBB'
}

