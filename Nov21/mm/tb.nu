# tbd.nu

# Enumerates and filters source lines. Can perform a first or last and get the line number
def "just sources" [] {
  open mm.nu | lines | enumerate | where item =~ '^source '
}


# return the number based on closure
def "get src-line" [cl: closure] {
  just sources | do $cl | get index
}
