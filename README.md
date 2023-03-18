# simple-haskell-project

This is a rad script that sets up a haskell project.

* Fast!
* Simple!
* No messing around with template repositories!
* Generated code is easy to read and extend!

## Usage

Simply run:

```bash
source <(curl -s https://raw.githubusercontent.com/Josemarialanda/simple-haskell-project/master/shp.sh) run
```

```bash
> source <(curl -s https://raw.githubusercontent.com/Josemarialanda/simple-haskell-project/master/shp.sh) --help

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
    cool          display a cool message and exit the program
```

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
1. MIT
2. BSD2
3. BSD3
4. GPL-2
5. GPL-3
6. LGPL-2.1
7. LGPL-3
8. AGPL-3
9. Apache-2.0
10. MPL-2.0
11. Unlicense
12. None
Enter the number of the license you want to use [1]: 4
Include a changelog? [y/N] y
Do you want to initialize a git repository? [y/N] n
```

This will create a nix flake + cabal based project in the folder my-simple-haskell-project.

You can enter the Nix shell with nix develop. Running cabal from inside this shell should use the packages that have been pre-built by Nix.

**Note**: While the script itself does not depend on cabal or nix to run, in order to build/enter the development shell of your newly created project you do need to
have nix + flakes installed.

## Install Nix

[NixOS - Getting Nix / NixOS](https://nixos.org/download.html#nix-install-linux)

## Enable flakes

### NixOS

On NixOS set the following options in configuration.nix and run nixos-rebuild.

```nix
{ pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
```

### Non-NixOS

On non-nixos systems, edit either ~/.config/nix/nix.conf or /etc/nix/nix.conf and add:

```bash
experimental-features = nix-command flakes
```

Here's a handy copy-paste:

```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```
