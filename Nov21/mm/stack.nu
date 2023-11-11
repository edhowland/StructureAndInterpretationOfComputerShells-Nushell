# Implements stack data structure

# The stack
$env.stack = []

# Clears the global stack
def-env "stack clear" [] {
  $env.stack = []
}

# Returns true if stack is empty
def "stack is-empty" [] {
  $env.stack | is-empty
}


# Consumes one item from input and pushes it on stack
def-env "stack push" [] {
  let item = $in
  $env.stack = ($env.stack | append $item)
}




# Pops one item off the stack and returns it
def-env "stack pop" [] {
  if (stack is-empty) {
    error make {msg: 'stack empty error'}
  }
  let item = ($env.stack | last 1 | get 0)
  $env.stack = ($env.stack | drop 1)
  $item
}


# Creates a closure that can be used in each
def "stack push-closure" [] {
  {|it| $it | stack push }
}
