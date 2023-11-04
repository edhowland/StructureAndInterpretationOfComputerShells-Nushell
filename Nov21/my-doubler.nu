#!/usr/bin/env nu
# Our very own first ever Nushell script

# A simple custom command to double the input
def double [] {
each { |it| 2 * $it }
}


# Doubles the arguments
def main [...rest] {
  $rest | double
}
