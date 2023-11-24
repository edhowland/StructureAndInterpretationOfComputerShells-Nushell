#!/usr/bin/env nu
# tbd.nu

# Enumerates and filters source lines. Can perform a first or last and get the line number
def "just sources" [] {
  open mm.nu | lines | enumerate | where item =~ '^source '
}


# return the number based on closure
def "get src-line" [cl: closure] {
  just sources | do $cl | get index
}


# Grab just the lines from mm.nu based on closure
def "grab lines" [cl: closure] {
  open --raw mm.nu | lines | do $cl
}



#Extracts and expands source lines in mm.nu
def "extract sources" [] {
rm -f mm-inner.nu
open --raw mm.nu | lines | where $it =~ '^source' | parse "{cmd} {file}" | get file | each {|fl| open --raw $fl | save --raw -a mm-inner.nu }
}

# Extracts the range of lines from mm.nu to file name
def "pull lines" [r: range, fname: path] {
  open --raw mm.nu | lines | range $r | save --raw $fname
}



# Extracts and expands the lines in mm.nu that start with ^source into mm-inner.nu
# Also pulls lines 0 .. first line to mm-first.nu
# then last .. end of file
def main [] {
  let src_first = (get src-line {|| first })
  let src_last = (get src-line {|| last })
  let first_stop = $src_first - 1
  let last_start = $src_last + 1
  let r0 = 0..$first_stop
  let rl = $last_start..

  grab lines {|| range $r0 } | save --raw -f  mm-first.nu
  extract sources
   grab lines {|| range $rl } | save --raw -f  mm-last.nu
  cat mm-first.nu mm-inner.nu mm-last.nu | save --raw -f mm-gist.nu

}
