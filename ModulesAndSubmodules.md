# Modules and Submodules

## Abstract

Previously, we have looked at the 'source' command which is like the source
command  in Bash. It loads and evaluates a file in the same context of the
running Nushell process. But there is a better way to organize many Nu files
in what is termed Modules

## From the Nushell Book

The chapter on Modules:

[Modules](https://www.nushell.sh/book/modules.html)

## Modules as directories

The third method of defining modules listed in the chapter above is to use
directories.


Directories that are to become modules must have a file called: mod.nu
even if it is empty.

### Submodules

Submodules within a module are files within the directory named the name of the
submodule with the '.nu' extension.


Note:  Within a submodule, the defined commands cannot have the name that is the
same as the submodule file.nu name.

## Order of naming

1. module name : The directory name
2. submodule name : The submodule.nu file name within the directory
3. command name : The exported 'def command [] { ... }' within the submodule.nu

### Calling convention

let's examine the following example:

```bash
