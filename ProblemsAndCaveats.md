# Problems I discovered with Nushell

## Abstract

Although Nushell is a complete system, as far as I can tell, it does have
some rough edges. Here I try to list some of the problems i found.
Some of these problems might be due to a mismatch between the way I think
something should work and the  intentions and philosophy of the Nushell team.


## Problems (or Bugs?)

### The glob command does not sort its output

We checked this and found that the order is the same as the 'ls -U' behaviour
which lists a directory in unsorted  order. This maybe done for performance reasons.
In many cases, you just want the file names for later processing, sorting order be damned.

Update: @fdncred confirmed this over on the Discord.

"Yes, I believe so. If you think about it like this, we like to stream data as much as possible. Sorting usually means you need to have a complete list of items before sorting, which you don't have when streaming. So, sometimes globbing and sorting will happen in two steps, which is why we have the sort and sort-by commands."


The glob command takes a glob pattern like *.csv and expands it into a proper
Nu list of full pathnames. You can get it in sorted order by piping it into 
the sort command:

```sh
glob *.csv | sort
[/full/path/1.csv, /full/path/2.csv, /full/path/3.csv]
```



Note: while this might break your muscle memory,  the sort command is more flexible
with its many  more options.


## Alias command is hindered

If you try to alias a complex set of commands you will get an error telling you
that  you can only alias commands and their options and parameters.

The only way around this is to create your own custum commands.
If there were a Nushell style guide, it would make the point that custom
commands are more flexible than aliases. because you can pass parameters in
myriad ways and even type check them. When I asked this question over on the
Discord server, that is the most common response.

Another solution is to do something like this:

```sh
alias ls-len = do { ls | length }
```

Check out this Changelog entry:

[Nushell release 0. with note about re-write of alias77](https://www.nushell.sh/blog/2023-03-14-nushell_0_77.html)

## Documentation issues

Note: The Command reference  page See [Links.md](Links.md)
lags behind in time from the latest stable release. At the time  of writing this
Nushell was @ 0.83.1. Use the 'help' command from within Nushell to get
more current command references.

```sh
help commands
```

See  [Links.md](Links.md) for links to some of the docs.

- Broken links in the Nushell book
- Deprecated commands and no docs on what the replacement is
- Sparse entries in the Cookbook and the media gallery page.

## Problems with piping input to nu from extrnal program using the --stdin flag:

```bash
echo ls | nu --stdin -c '??? what goes here?'
```

The trouble seems to be that the  command you want to be passed into the Nushell
intepreter cannot be executed. E.g. there is no equivalent to the 'eval'
command in Bash


## Problems with duration literals

At any point you can use durations literals as values in expressions

- 2ms
- 3day
- 5wk

But these specific literals do not work:
- 5month
- 12yr
- 9dec



[Link to discord message thread](https://discord.com/channels/601130461678272522/1141069246386946079)

## Confusion re: The 'http get' command/subcommand

Basically, the  'http get' acts like the curl command, with one exception.
If you pull an XML resource, it gets converted into NUON for sclicing and dicing.
Here is an example from JT and fdncred over on the discord:
jt , eg) http get https://www.jntrnr.com/atom.xml will give you structured data, because it can convert the xml , Today at 2:00 PM message

The confusing part is the  possibility of the 'http get --raw' flag.
It overrides the normal conversion. E.g. If you get a JSON endpoint, you can
get just the raw string text. Kinda like the --raw flag  for the 'open' command.
Without  --raw, http get will convert things it understands like XML, CSV or JSON.
If it doesn't  it will just return HTML string text.

There is a external 'query web' plugin. Here:
From the discord:
The  query web  plugin is part of the nushell repository. if you download our release binaries, it's already built for you. It's called nu_plugin_query . You just have to put it in a folder and register it like register /path/to/nu_plugin_query.

If you installed nu with 'cargo install nu', then do the following

```bash
cargo install nu_plugin_query
# ....
```

After it d/ls and builds go into nu and:




```sh
register ~/.cargo/bin/nu_plugin_query
````


This step only needs to be done once.


## echo probably doesn't  do what you expect

In Bash, echo will send all of its arguments to stdout.
In Nushell, it constructs a list of its arguments to the pipeline.

Try this:

```sh
echo 1 2 3 


# then try this:
[1 2 3]
```



```sh
>>  > echo 1 2 3
 0   1 
 1   2 
 2   3 
>>  > [1 2 3]
 0   1 
 1   2 
 2   3 
thor nushell >>  > 
```


Then there is the  'print' command.

It does not send its arguments to the pipeline.
Think of it as providing (possibly debug) info to the user.
Can be used whithin a pipeline, like in a function to print to real stdout.

Use 'help echo' and 'help print' for more.