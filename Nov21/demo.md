# Demo

## SICP


## What is the smallest Nu (or Scheme) program?

5

## The REPL

1. R: Reader/Parser or Computerizer
2. E: Eval or Reducer
3. P: Printer or Humanizer
4. Loop or repeat 1 thru 3 again


5, although an Unicode value was input, the Computerizer converted it to a 64 bit twos-compliment  integer.
The Reducer could not refine or reduce it further, so it just returned it unchanged.
The Humanizer took the 64 bit integer and converted it back into the Unicode glyph for the 5.


## Nu is expression based, not command based

Bash is command statement based (mostly)
Where a command statement is defined as Verb [options ..] Noun(s)

Nu is expression based much of the time

5 + 12


3 * (4 + 10)
42

Although this is pretty standard for a PL REPL like Python or Ruby, it is a bit
surprising for those coming from Bash or other POSIX shells.

Note: The parens above  can appear anyplace in the expression.
In Nu, any valid Nu expression (including commands can appear inside parens
and parenthesized expressions can appear anywhere in a valid expression (or command)

E.g.

echo (5 + 12)


## Calling functions

In Python we might want to do the following:

import math as m

m.tan(m.atan(4))
4.0000000



But in Nu we would do the following:


4 | math  arctan | math tan

This style is called point free  because we do not use temporary variables or parameter names.
It is a style of data flowing thru successive functions  composing a result at the end.
You read the data flow left to right.

One quote I heard was:

Point free is to data as structured programming is to code
And Nu is all about structured data.


### Concatenative programming languages like Forth

Forth is  a stack based language but it is also classified as a concatenative language like Factor, Joy and others.

Let's see some Forth in action:

gforth
5 12 + .s




## More differences between POSIX shells and Nushell

In addition to arithmetic expressions, you can also ask conditional questions
and combine them with logical operators

4 < 5
true

4 < 5 and 3 < 2
false

(not 6 > 7) or (4 <= 5)
true



There is:  - No subshells going on here
- The  <, > operators do not define redirection from/to file filesystem



## There are many more data types than just ints and floating points

Too many to cover here but here are some examples

(date now - 7day



 1KB * 1024
1.0 MB



### Strings

There a a plethor of string types in Nu; we are not going to cover all (5 I think)
Most work like POSIX shells.

But, one change from Bash is string interpolation
double quoted strings do not handle any string interpolation

Instead, you must prefix the "" pair with the $ sigil
And you must include runtime interpolated contents inside of round parens

E.g

$"The current date is (date now)"


#### Bare strings

Bare strings (those w/o quotes of any kind, are a bit special
First, in expressions, they are position dependant
If they occur in the leftmost part of the expression, they are interpreted as some command (built-in, external or user defined)
IOW: Like a function call site

We saw this with the (date now) in the interpolation before


When it comes to bare strings in other than the first position in an expression,
the answer is: It depends

For example, if calling a command/function the type of the argument might come into play
E.g. maybe the bare string is a local file in the current dir
Obviously,  if there is any type of absolute or relative path  notation,  it gets interpreted as a pathname

And anything to the right of an assignment operator '=' is another expression, so the leftmost bare string rule applys

But in lists or records, bare strings are used a lot for keys and values, as we will will see below

They also can be used in conditionals


#### Keywords

A special type of bare string is one of the many built-in keywords like def and if .etc

help commands | where category == core | get name

<55 or sor commands>


Note: Even the humble 'if/else' is an expression and can be assigned to a variable or passed to a function
In some cases you must disambiguate  by wrapping it in  a pair of parens




## Collections and data structures

In addition to atoms, Nu sports the following collection data types:

1. Lists
2. Records
3. Tables

We are not going to spend much time on Tables; but you can think of them
as lists of records whose key names are all the same. Nu does not store them
like that though. There are many resources that discuss Nu tables and the
commands that slice and dice them.


### Lists

[]

 empty list 

[foo bar baz]

 0   foo 
 1   bar 
 2   baz 


[foo bar baz].1
bar

This is known as cell paths.

### Records

In Nu, records are like dictionaries in Python, Hashes in Ruby or objects in Javascript.
In fact, they look an awful like JSON.
Internally, Nu stores all of these data types as NUON, or Nu Object Notation
a superset of JSON that understands all of Nu's primitive data types.

{foo: 1, bar: 2, baz: 3}

The cell path:

{foo: 1, bar: 2, baz: 3}.bar
2

Obviously, these data types can be  nested inside each other to any depth.

### Accessing, modification and deletion of lists and records

There are many built-in  functions that allow for CRUD operations on Nu data collections.

help commands | get category | uniq


help commands | where category == filters | get name

<~ 67 or so>


{foo: 1, bar: 2, baz: 3} | get baz
3



{foo: 1, bar: 2, baz: 3} | columns
foo
bar
baz


{foo: 1, bar: 2, baz: 3} | values
1
2
3


This activity is popularly know as ETL or Extract, Transform and Load.







## Variables

For those times when point-free style just wont do

Nushell has two types of variables: Environment variables and shell variables

Both of these types have different syntax and scoping  rules
You will notice major differences between Nushell and other shells like Bash.
Could make porting code over from Bash tricky.

### Nushell shell variables

$glo
foo

Variable $glo is global, can be seen even in blocks, closures and functions



do { echo $glo }
foo

>>> The 'do' is a keyword that kind of executes a block one time unconditionally.



Another variable: $x

$x
10

loop {
  echo $x
  if $x < 0 { break }
  $x = $x - 1
}

10
9
8
7
6
5
4
3
2
1
0

Variables are locally scoped

do { let $glo = 'bar'; echo $glo }
bar
echo $glo
foo



By default, variables are immutable, no changes allowed

$glo = 'bar'
Error:

But why did the do block allow this?
That $glo was a new variable created in a different scope.

But therere is an escape hatch: The mut keyword.

We saw the $x could be changed in our loop, because it was declared with 'mut'

Let's create another mutable variable: $y

mut $y = 9.99

$y = $y + 0.01

$y
10



Variables are typed. The type cannot be changed

$x = 0.1
Error


You can specified the type when you create the variable, but most of the time it is inferred.

let $z: int = 100
$z | describe
int

Declaring types works better in function parameter lists:

def my-fn [x: int, y: string, z: float] -> string {
  $"($x)|($y)|$z)"
}

my-fn 2 hello 9.9
my-fn foo 12 9.9
Error

### Environment variables

Environment variables are stored in a special record called : $env
Like with any record in Nu, you can use cell paths to get at individual values

$env.TZ






To see what environment variables are present when Nu starts:

$env | columns

Like all mutable records, you can add new fields at any time:

$env.foo = 'hello'
$env.foo
hello

There are 2 initialization scripts: env.nu and config.nu whose locations are platform dependent
You can find the value of the location with:
$nu.config-path

The configuration settings are embedded inside the $env record at: $env.config

$env.config | columns

You can change any of these values because the entire $env record and its sub-records are mutable
But you cannot change them inside functions.
Or: You can with a different type of function declaration

$env.foo = 1
def chg-it [] { $env.foo = 2 }
chg-it

$env.foo
1


See: No change. But:

def-env chg-it [] { $env.foo = 2 }

cjg-it
$env.foo
2


### The internal $nu record

Another variable that gets assigned at startup is the $nu which is a record with key/value entries

$nu | columns 

...

This record is immutable and cannot be modified by user code or in the REPL


## Bringing it all together: Writing code

### A slight detour about aliases

In funtional programming patterns we have something called Curring.
After Haskell Curry
It is the technique of creating new functions with pre-bound parameters from existing functions.

E.g. If a function takes 3 parameters, then we can curry one of those parameters and get
a new function that takes 2 parameters.

E.g add(l, r) could be curried into:

incr = curry(add, 1) 
Then used like:

incr(5)
6

Shells sort of do this kind of thing with the alias keyword.

bash
alias foo="echo foo"

foo bar baz
foo bar baz





Aliases in Bash are just string replacers or maybe macro expanders if we are being generous
But they can recursively expand inner aliases
And they can check for infinite loops with cycle checks.

bash
alias foo="bar 11"
alias bar="baz 22"
alias baz="foo 33"

This works, but this bombs at runtime:

foo
Bash:  foo not found
alias foo
alias foo="bar 11"




Nushell aliases are both better than and worse than Bash aliases

alias foo = echo 11

foo
11

The alias command checks  for syntax correctness at compile time. It is possible to create a

syntactilly incorrect alias in Bash that won't be caught  untill runtime

The downside for Nushell aliases is that are limited to just one command



alias foo = (1 + 3)
Error



I asked over on their Discord and they replied with:
If you want to do something more complex, then just create a custom command, IOW: A function.

### Which gets us to writing your own commands or functions



## Coding in Nu

In Nu, the task of providing a solution to a problem is breaking it up into many more smaller
task that are easier to solve.. This is no different for any other programming language

These smaller tasks can then be combined together like Lego bricks to compose
bigger structures until a complete solution is reached.

Here Nu, the programming language, really helps you out
In many more ways than Bash and other shells

#### The def keyword

It is very easy to create a function in Nu which are called 'Custom Commands', if you peruse the Nushell Book

def foo [] { echo I am foo }
foo

...

Note: We get some help for free:

help foo


But we can do better than this. By preceeding the definition with a comment, it becomes
part of the help text

open start.nu | bat -r 14:16

# Raises the bar
def bar [] ...

### Counted, named and typed parameters to functions

Unlike Bash functions, n Nu functions have named (and optinally typed) parameters

def baz [x: int, y: string, z: float] {
  echo
}

These get checked at both compile and runtimes

baz
Error



baz 1 2
Error

The type checking is rather loose, but the required arg count is mandatory
Right now, the type checking  helps with the help command

help baz







#### participating in pipelines
Nu _strongly_ encourages you to write functions that can be composed with
pipes. To that end, the (sort of) hidden parameter exists in the body of the function and is called: '$in'

def quo [] {
  $in.foo
}

{foo: 1, bar: 2} | spam
1



And this $in can be typed:

def quo []: record -> int {
  $in.foo
}

(You might see some similarity to Python and rust in the return type definition: -> int)


### Providing even more help

Functions in Nu can take more type of parameters including:

1. Default values
2. Rest arguments (IOW: unlimited remaining arguments from required positional parameters)
3. Optional flags


....


#### All of these  types can be documented inline

open start start.nu | bat -p -r 19:28

help kitchen sink

Notice the syntax for sub commands
Notice all the options, typed parameters, default values, optional arguments and rest arguments
Also notice the specifications of the input type from the pipeline and the return type and that we (needlessly) use the $in variable  to pipe into the each comand


## Creating handy Nushell scripts

Nu gives us some nice help when we want to produce our own scripts.

It obeys the SheBang rule

We can add a nice main function which  describes our parameters and gives options and help
for our script:

open my-doubler.nu

./my-doubler -h


## What are these funny curly braces after the 'each' command: They are called closures

If you have ever seen any Ruby or Rust code, then you will have seen these
anonymous functions which are called closures. They are called Lambda functions in
languages like Python, Java and Lisp/Scheme



Perusing the command list for filters, we will see a number of commands
that take a closure as an argument and work on a list or table from a pipeline

help commands | where category == filters | get name

each, pareach, filter and reduce are some of these functions.

In Nu, each takes the place of map in many other functional languages,
but can still be used like '.each {|x| x }' in Ruby where you perform some
command witha side-effect

The convention (at least in the docs) is to name the item parameter '$it'
for the parameter that is given on every iteration of the loop.

