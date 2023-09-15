# Nushell Programming

## Abstract

Essentially, at its basic level, Nushell is just a scripting language.
It is fully Turing Complete. It has many built-in programming language
constructs found in other modern languages. And a few of its own making!

Nushell has support for the following additional language features not found
in other shells:

- Blocks : That contain their own scope
  * This has an effect on things like `cd dir`, remains only while block is in scope
- Closures : Lambda functions that are first class language variables and parameters.
- Higher order commands that operate over their input like `each`, `reduce`, `filter`
- Parallel execution of code.


## Defining your own commands

In Nushell lingo, what we typically might call functions are called user
defined commands. An there is the ability to make any Nushell function
behave exactly like a built-in command. User defined commands take parameters,
participate in pipelines and return any data type to their caller.
The parameters of a command can also be optionally statically typed:

```sh
def my-cmd [name: string, age: int] {
  echo $"Nice to meet you ($name)\nI see that you are ($age) years old"
}

# Now call it:
>>> my-cmd "Fred Smith" 53
Nice to meet you Fred Smith
I see that you are 53 years old
```


Now let's make a version that takes input from a pipe:

```sh
def my-in [age: duration] {
  echo $"Nice to meet you ($in)\nI see that you are ($age) years old"
}
# Now really try it out

>>>  > echo "Sigmund Freud" | my-in ((date now) - 1856-05-06)
Nice to meet you Sigmund Freud
I see that you are 167yr 4month 2wk 2day 18hr 25min 17sec 722ms 196s 836ns years old
```
[Next: Scripts.md](007_Scripts.md) [Prev: DataTypes.md](005_DataTypes.md)


[Table of Contents](toc.md)


### Proper use of the $in variable

The $in variable must be part of the  first command/expression encountered
in a block/closure or function.
But you can create a holder for it:

```sh
echo foo bar baz | do {|| let x = $in; print hello; echo $x }
0: foo
1: bar
2: baz
```


## Organizing your code

In addition the 'source <file.nu>' command, you can also create modules in
Nushell. For more on this see: [Modules and Submodules](ModulesAndSubmodules.md)
