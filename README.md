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

## Project creation example

![](https://github.com/Josemarialanda/simple-haskell-project/blob/master/usage.gif)

This will create a nix flake + cabal based project in the folder a-basic-app.

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
