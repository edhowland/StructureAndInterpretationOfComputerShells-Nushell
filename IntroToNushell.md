# Nushell: An Introduction

## What

Nushell is a modern re-interpretation of what a system shell should be.  Nushell
combines features and practices from current software engineering and
traditional Unix-like OS shells. Nushell borrows concepts from Bash, Zsh, and
PowerShell. It also borrows programming language constructs from scripting
languages like Python, Ruby, and Typescript.

Nushell is designed around the functional programming paradigm where data
flows through pipelines and is interacted with small bits of code along the way.
It is also heavily influenced by database languages like SQL.


## Platforms

Nushell is designed to be cross-platform. It runs on:

- Windows
- MacOS
- Linux
- BSD

## Implemented in Rust, a safe compiled systems programming language

* Because it is written in Rust, it should compile on all platforms that Rust targets. Although not mentioned, other Unix-like systems such as the *BSDs should should be able to work.

## Who is it for?

Nushell, although a very young shell, nevertheless can be used by anyone who wants to interact with the command line or terminal of their system to perform tasks that would be tricky to write in other shells.


### Potential users

- Data Scientists
- System admins who needto pull and transform lots of data
- Programmers who need to automate tasks, beef up their FP creds, etc.
- New users to the Terminal environment
- The Shell-curious


Oh, and also for those who want to learn some more programming concepts
that go beyond those offered by traditional shells.
Nushell can be used as either in interactive mode as a REPL or as a script interpreter. IOW, you can use Nushell wherever you use any other shell or scripting language or alongside them.

## Is it production ready?

At this time, I would not use Nushell to control your critical infrastructure.
Nushell seems to be under heavy development. As of this writing, the version
is 0.83.1 Much broke when I tried to use my config from 0.82.


## Installation

- All OSes: via a prebuilt binary
- MacOS: homebrew: `brew install nushell`
- Windows: winget: `winget install nushell`
- Linux: Install through Rust toolchain: 'cargo install nu'
  * also Linux homebrew and some package managers.

We also have a nice little Dockerfile for you.

Andthe links to Nushell binaries are in the  Links.md document.

See: [Links.md](Links.md)

[Next: Pipelines.md](002_Pipelines.md)


[Table of Contents](toc.md)
