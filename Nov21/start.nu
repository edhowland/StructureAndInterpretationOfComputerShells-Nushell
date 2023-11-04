# Meant to be sourced by Nu
# TZ=EDT5EST nu -e "source start.nu" 
let glo = 'foo'
mut x = 10
let today = (date now | date to-record | select year month day)  


# aliases

alias oraw = open --raw


# Custom commands

# Raises the bar
def bar [] { print -e "This is the bar" }


## The whole shebang
def "kitchen sink" [
  --use-scrubber (-s)   # when washing dishes, use a scrubpad
  count: int   # Count of dishes
  temp?: float # The tempature of the water to use
  soap: float = 10.0 # The amount of detergent
  ...dishes: string # The actual plates and silverware to wash
  ]: list -> list {
  $in | each {|dish| clean $dish }
}



# Where all the really good stuff happens
def "kitchen range" [] {
  "Home, home on the range"
}

# In Latin, this would be called: Mensa
def "kitchen table" [] {
  "In all the Gin Joints in all the world"
}
