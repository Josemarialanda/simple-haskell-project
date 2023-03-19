# [simple-haskell-project](https://josemarialanda.github.io/simple-haskell-project/)

simple-haskell-project is a convenient script that sets up a haskell project containing:

* **ghc**
* **cabal**
* **hoogle**
* **ormolu**
* **haskell-language-server**.

Check out the example projects in [example projects](https://github.com/Josemarialanda/simple-haskell-project/tree/master/example%20projects).

* Fast!
* Simple!
* Generated code is easy to read and extend!

## Usage

Simply run:

```bash
source <(curl -s https://raw.githubusercontent.com/Josemarialanda/simple-haskell-project/master/shp.sh) run
```

```bash
> ./shp --help

░██████╗██╗░░██╗██████╗░
██╔════╝██║░░██║██╔══██╗
╚█████╗░███████║██████╔╝
░╚═══██╗██╔══██║██╔═══╝░
██████╔╝██║░░██║██║░░░░░
╚═════╝░╚═╝░░╚═╝╚═╝░░░░░ (simple-haskell-project)

Usage: shp.sh run
  
    -h, --help    display this help message and exit
    -v, --version display version information and exit the program

    run           run the program
```
![](https://github.com/Josemarialanda/simple-haskell-project/blob/master/usage.gif)

## Project creation example

```bash
> source <(curl -s https://raw.githubusercontent.com/Josemarialanda/simple-haskell-project/master/shp.sh) run
Enter your name [username]: John Enrico Bubbles
Enter your email [username@email.com]: Johnnyboy_bubbles@gmail.com
Enter the project name [simple-haskell-project]: My Simple Haskell Project
Enter the project description [A simple Haskell project]: 
Enter the source directory name [src]: app
Include a test suite? [y/N] n
Include a benchmark suite? [y/N] n
Include a readme? [y/N] y
Include a license? [y/N] y
     1	AGPL-3.0
     2	Apache-2.0
     3	BSD-2-Clause
     4	BSD-3-Clause
     5	BSL-1.0
     6	CC0-1.0
     7	EPL-2.0
     8	GPL-2.0
     9	GPL-3.0
    10	LGPL-2.1
    11	MIT
    12	MPL-2.0
    13	Unlicense
Enter the number of the license you want to use [11]: 4
Include a changelog? [y/N] y
Do you want to initialize a git repository? [y/N] n
```

This will create a nix flake + cabal based project in the folder my-simple-haskell-project.

You can enter the Nix shell with `nix develop`. From within the shell you can use cabal to enter the repl with `cabal repl` and you can build your project with `cabal build`.

You can also build your project with nix instead using `nix build`.

**Note**: While the script itself does not depend on cabal or nix to run, in order to build/enter the development shell of your newly created project you do need to have nix + flakes installed.

## Install Nix

[NixOS - Getting Nix / NixOS](https://nixos.org/download.html#nix-install-linux)

## Enable flakes

### NixOS

On NixOS set the following options in **configuration.nix** and run `nixos-rebuild`.

```nix
{ pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
```

### Non-NixOS

On non-nixos systems, edit either **~/.config/nix/nix.conf** or **/etc/nix/nix.conf** and add:

```bash
experimental-features = nix-command flakes
```

Here's a handy copy-paste:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```
