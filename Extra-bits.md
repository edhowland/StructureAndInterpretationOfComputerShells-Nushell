# More Nushell niceness

nucheck - syntax check .nu files and strings for evaluation

```bash
$ nu --ide-check file.nu
```

I could not get this to work in either 0.82 or 0.83

## Parallel Execution

Nushell has the ability to run some commands in parallel. Useful if you have multiple cores.

## Sequences and ranges

In addition to the normal `seq` command for ranges numerically, Nushell also has `seq char` and `seq date`
In addition, Nushell supports the 'range' data type natively.

```sh
# create an infinite range from 6 to infinity, but take only 5 of them
6.. | take 5
```



 
## Nushell http commands

## Various http commands to fetch and interact with web sites

## TODO




## Handling stdout, stderr from external command and their exit codes

Nushell needs to be able to interact with external programs and  handle the
communication that they

 generate. This is especially true with respect to standard out and standard
error (stdout, stderr).

[Handling stdout, stderr and exit codes](https://www.nushell.sh/book/stdout_stderr_exit_codes.html#stderr)

An example that uses stdout, then stderr and then both:

```sh
echo hello out> hello.txt
echo bad juju err> err.log
echo both out and error o+e> both.log
```

## Searching for Nushell on the Net

Sometimes the automatic suggestions in search engines get in the way. This also
effects the search results. When searching for Nushell, you will often
get results with 'nutshell' in the name. This might change in the future
after Nushell grows in popularity. In the meantime, you the '-' to filter out
thise results:

```
nushell examples -nutshell
```


## Working with the update command

When you  pass something through the update command and give it a col and a closure,
the passed in parameter is all of the columns of that row

q!vm

```sh

# update-col.nu using update whith record
let x = { foo: 0, bar: 1, baz: 2 }
$x | update bar {|i| $i.bar + 99 }
```



You get

```
╭─────┬─────╮
│ foo │ 0   │
│ bar │ 100 │
│ baz │ 2 
```

## Date/Time formats and the default configuration

Coming from Bash or other shells, you might be surprised that the default format
date/time format seems to be in relative to the current date and time. E.g.

```sh
>>> ls first 3



## Reimplementing the old DOS ren command

In old DOS,  you could do something like this to rename the extension of all files:

```
C> ren *.txt *.md
```

This can be done in Nushell with a custom command:

```sh
# ren - like DOS ren command E.g. ren *.txt *.md
def  ren [src: glob, dest: glob] {
  let ext = ($dest | path parse).extension
  glob $src | each {|f| mv $f ($f | path parse | update extension $ext | path join) }
}

```

Then it can be run like this:


```sh
# create a list of file names from  a range 
 1..9 | each {|e| touch $"nfile($e).txt" }
 empty list 
  > ls
 #      name      type   size   modified 
 0   nfile1.txt   file    0 B   now      
 1   nfile2.txt   file    0 B   now      
 2   nfile3.txt   file    0 B   now      
 3   nfile4.txt   file    0 B   now      
 4   nfile5.txt   file    0 B   now      
 5   nfile6.txt   file    0 B   now      
 6   nfile7.txt   file    0 B   now      
 7   nfile8.txt   file    0 B   now      
 8   nfile9.txt   file    0 B   now      
```


## Closures cannot capture mutable values

This does work


```sh
let y = 10
1..4 | each {|x| x * y }

 0   10 
 1   20 
 2   30 
 3   40
```

But this does not work:



```sh

thor nushell >>  > mut y = 10
thor nushell >>  > 1..4 | each {|x| $y = ($x * 10) }
Error: nu::parser::expected_keyword

   Capture of mutable variable.
   [entry #2:1:1]
 1  1..4 | each {|x| $y = ($x * 10) }
                     
                       capture of mutable variable
   

```


## neat tricks and one-liners

```sh
cal | select 3
```

Gets the 3rd week of the current month

```bash
nu -c 'echo $env.PATH' -m none
```

Every path component on its own line
The '-m none' suppresses the table border decorations
Not sure why this does not obey the  config.nu settings.



# Getting help for commands

The builtin help command actually returns structured data which can be sliced
and diced.  Eg. Let's see what commands deal with the filesystem

```sh
help commands | where category == filesystem
  #     name      category    command_type              usage               ... 
  0   cd         filesystem   builtin        Change directory.              ... 
  1   cp         filesystem   builtin        Copy files.                    ... 
  2   glob       filesystem   builtin        Creates a list of files        ... 
                                             and/or folders based on the        
                                             glob pattern provided.             
  3   load-env   filesystem   builtin        Loads an environment update    ... 
                                             from a record.                     
  4   ls         filesystem   builtin        List the filenames, sizes,     ... 
                                             and modification times of          
                                             items in a directory.              
  5   mkdir      filesystem   builtin        Make directories, creates      ... 
                                             intermediary directories as        
                                             required.                          
  6   mv         filesystem   builtin        Move files or directories.     ... 
  7   open       filesystem   builtin        Load a file into a cell,       ... 
                                             converting to table if             
                                             possible (avoid by appending       
                                              '--raw').                         
  8   rm         filesystem   builtin        Remove files and               ... 
                                             directories.                       
  9   save       filesystem   builtin        Save a file.                   ... 
 10   start      filesystem   builtin        Open a folder, file or         ... 
                                             website in the default             
                                             application or viewer.             
 11   touch      filesystem   builtin        Creates one or more files.     ... 
 12   watch      filesystem   builtin        Watch for file changes and     ... 
                                             execute Nu code when they          
                                             happen.                            



```
