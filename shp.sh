version=0.1

function help {
  cat <<EOF

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
EOF
}

function version {
  cat <<EOF
simple-haskell-project $version
EOF
}

# If the first argument is -v or --version then display the version information and exit the program.
if [ "$1" = "-v" ] || [ "$1" = "--version" ]; then
  version
  exit 0
fi

# If the first argument is -h or --help then display the help message and exit the program.
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  help
  exit 0
fi

# If the first argument is not -v, --version, -h, --help, run or cool then display the help message and exit the program.
if [ "$1" != "-v" ] && [ "$1" != "--version" ] && [ "$1" != "-h" ] && [ "$1" != "--help" ] && [ "$1" != "run" ] && [ "$1" != "cool" ]; then
  help
  exit 0
fi


function usage {

  # Ask for name, default is user name of the current user.
  read -p "Enter your name [$(whoami)]: " name
  name=${name:-$(whoami)}
  
  # Ask for email, default is the variable name with @email.com appended.
  read -p "Enter your email [$(whoami)@email.com]: " email
  email=${email:-${name}@email.com}
  
  # Ask for the project name, default is simple-haskell-project.
  # remove whitespaces and replace with hyphens and convert to lowercase.
  read -p "Enter the project name [simple-haskell-project]: " project
  project=${project:-simple-haskell-project}
  project=$(echo $project | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '[:space:]')
  
# If project name contains any non-alphanumeric characters (with the exception of hyphens)
# or if project name is the same as the name of a directory in the current directory then
# ask for a new project name until a valid project name is entered.
  while [[ ! $project =~ ^[a-z0-9-]+$ ]] || [ -d $project ]; do
    if [[ ! $project =~ ^[a-z0-9-]+$ ]]; then
      echo "Project name must only contain alphanumeric characters and hyphens."
    fi
    if [ -d $project ]; then
      echo "Project name must not be the same as the name of a directory in the current directory."
    fi
    read -p "Enter the project name [simple-haskell-project]: " project
    project=${project:-simple-haskell-project}
    project=$(echo $project | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -d '[:space:]')
  done
  
  # Ask for the project description, default is A simple Haskell project.
  read -p "Enter the project description [A simple Haskell project]: " description
  description=${description:-A simple Haskell project}
  
  # Ask the user what the source directory should be called, default is src.
  read -p "Enter the source directory name [src]: " srcdir
  srcdir=${srcdir:-src}
  
  # if the source directory name contains any non-alphanumeric characters (with the exception of hyphens) 
  # then ask for a new source directory name until a valid source directory name is entered.
  while [[ ! $srcdir =~ ^[a-z0-9-]+$ ]]; do
    echo "Source directory name must only contain alphanumeric characters and hyphens."
    read -p "Enter the source directory name [src]: " srcdir
    srcdir=${srcdir:-src}
  done
  
  mkdir $project
  pushd $project > /dev/null
  
  # Create src directory.
  mkdir $srcdir
  
  # Create Main.hs file.
  cat <<EOF > $srcdir/Main.hs
module Main where

main :: IO ()
main = putStrLn "Hello, World!"
EOF
  
  # Ask if the user wants to include a test suite, default is no.
  read -p "Include a test suite? [y/N] " testsuite
  testsuite=${testsuite:-n}
  
  # if test suite is not yes or no then ask for a new test suite option until a valid test suite option is entered.
  while [[ ! $testsuite =~ ^[yYnN]$ ]]; do
    echo "Test suite option must be y or n."
    read -p "Include a test suite? [y/N] " testsuite
    testsuite=${testsuite:-n}
  done
  
  # If test suite is yes then create a test suite.
  if [ $testsuite = "y" ] || [ $testsuite = "Y" ]; then
    mkdir test
    cat <<EOF > test/Spec.hs
import Test.Tasty

main :: IO ()
main = defaultMain tests

tests :: TestTree
tests = testGroup "Tests" []
EOF
  fi
  
  # Ask if the user wants to include a benchmark suite, default is no.
  read -p "Include a benchmark suite? [y/N] " benchmarksuite
  benchmarksuite=${benchmarksuite:-n}
  
  # If benchmark suite is not yes or no then ask for a new benchmark suite option until a valid benchmark suite option is entered.
  while [[ ! $benchmarksuite =~ ^[yYnN]$ ]]; do
    echo "Benchmark suite option must be y or n."
    read -p "Include a benchmark suite? [y/N] " benchmarksuite
    benchmarksuite=${benchmarksuite:-n}
  done
  
  # If benchmark suite is yes then create a benchmark suite.
  if [ $benchmarksuite = "y" ] || [ $benchmarksuite = "Y" ]; then 
    mkdir bench
    cat <<EOF > bench/Main.hs
import Criterion.Main

main :: IO ()
main = defaultMain []
EOF
  fi
  
  # Ask if the user wants to include a readme, default is no.
  read -p "Include a readme? [y/N] " readme
  readme=${readme:-n}
  
  # If readme is not yes or no then ask for a new readme option until a valid readme option is entered.
  while [[ ! $readme =~ ^[yYnN]$ ]]; do
    echo "Readme option must be y or n."
    read -p "Include a readme? [y/N] " readme
    readme=${readme:-n}
  done
  
  # If readme is yes then create a readme file.
  if [ $readme = "y" ] || [ $readme = "Y" ]; then 
    echo "$description" > README.md 
  fi
  
  # Ask if the user wants to include a license, default is no.
  read -p "Include a license? [y/N] " license
  license=${license:-n}
  
  # If license is yes then ask which license to use.
  # Display a list of licenses and ask the user to enter the number of the license they want to use. Default is MIT.
  # If the user enters a number that is not in the list then ask for a new license number until a valid license number is entered.
  if [ $license = "y" ] || [ $license = "Y" ]; then
    echo "1. MIT"
    echo "2. BSD2"
    echo "3. BSD3"
    echo "4. GPL-2"
    echo "5. GPL-3"
    echo "6. LGPL-2.1"
    echo "7. LGPL-3"
    echo "8. AGPL-3"
    echo "9. Apache-2.0"
    echo "10. MPL-2.0"
    echo "11. Unlicense"
    echo "12. None"
    read -p "Enter the number of the license you want to use [1]: " licensechoice
    licensechoice=${licensechoice:-1}
    while [[ ! $licensechoice =~ ^[1-9]$ ]] && [[ ! $licensechoice =~ ^1[0-2]$ ]]; do
      echo "License number must be between 1 and 12."
      read -p "Enter the number of the license you want to use [1]: " licensechoice
      licensechoice=${licensechoice:-1}
    done
    # If the licence number is 12 then set the license to no.
    if [ $licensechoice = "12" ]; then
      license=n
    fi
  fi
  
  # If license is yes then fetch the license from the GitHub API and save it to a file called LICENSE.
  if [ $license = "y" ] || [ $license = "Y" ]; then 
    licenseurl=$(curl -s https://api.github.com/licenses | jq -r ".[$licensechoice-1].url")
    licensespdx_id=$(curl -s https://api.github.com/licenses | jq -r ".[$licensechoice-1].spdx_id")
    curl -s $licenseurl | jq -r ".body" > LICENSE
  fi
  
  # Ask if the user wants to include a changelog, default is no.
  read -p "Include a changelog? [y/N] " changelog
  changelog=${changelog:-n}
  
  # If changelog is not yes or no then ask for a new changelog option until a valid changelog option is entered.
  while [[ ! $changelog =~ ^[yYnN]$ ]]; do
    echo "Changelog option must be y or n."
    read -p "Include a changelog? [y/N] " changelog
    changelog=${changelog:-n}
  done
  
  # If changelog is yes then create a changelog file.
  if [ $changelog = "y" ] || [ $changelog = "Y" ]; then 
    echo "# Changelog" > CHANGELOG.md 
  fi
  
  # Create cabal file.
  cat <<EOF > $project.cabal 
cabal-version:   2.4
name:            $project
version:         0
tested-with:     GHC ==8.6.3 || ==8.8.3 || ==8.10.5
description:     $description
author:          $name
maintainer:      $name - $email
copyright:       $(date '+%Y-%m-%d') $name
build-type:      Simple
extra-doc-files: 
  README.md
EOF
  
  # If changelog is yes then add the changelog to the cabal file generated above.
  if [ $changelog = "y" ] || [ $changelog = "Y" ]; then
    cat <<EOF >> $project.cabal
  CHANGELOG.md
EOF
  fi
  
  # If license is yes then add the license to the cabal file generated above.
  if [ $license = "y" ] || [ $license = "Y" ]; then
    cat <<EOF >> $project.cabal
license:         $licensespdx_id
license-file:    LICENSE
EOF
  fi
  
  # If license is no then add NONE to the license field in the cabal file generated above.
  if [ $license = "n" ] || [ $license = "N" ]; then
    cat <<EOF >> $project.cabal
license:         NONE
EOF
  fi
  
  cat <<EOF >> $project.cabal 
  
common common-options
  build-depends:      base >=4.9 && <5
  default-language:   Haskell2010
  default-extensions: 
  build-depends:
  ghc-options:

executable $project-exe
  import:         common-options
  type:           exitcode-stdio-1.0
  hs-source-dirs: $srcdir
  main-is:        Main.hs
  ghc-options:    -threaded -rtsopts -with-rtsopts=-N
EOF
  
  # If either test suite or benchmark suite is yes then add the following to the cabal file generated above.
  if [ $testsuite = "y" ] || [ $testsuite = "Y" ] || [ $benchmarksuite = "y" ] || [ $benchmarksuite = "Y" ]; then
    cat <<EOF >> $project.cabal
  build-depends:  $project

library
  import:          common-options
  hs-source-dirs:  lib
  exposed-modules: Lib
  build-depends:
EOF
  
    mkdir lib
    pushd lib > /dev/null
  
    cat <<EOF > Lib.hs
module Lib where
EOF
    popd > /dev/null
  fi
  
  # If test suite is yes then add the test suite to the cabal file generated above.
  if [ $testsuite = "y" ] || [ $testsuite = "Y" ]; then
    cat <<EOF >> $project.cabal

test-suite $project-test
  import:         common-options
  type:           exitcode-stdio-1.0
  hs-source-dirs: test
  main-is:        Spec.hs
  build-depends:
    , $project
    , hspec
    , HUnit
    , tasty
    , QuickCheck
  ghc-options:    -threaded -rtsopts -with-rtsopts=-N
EOF
  fi
  
  # If benchmark suite is yes then add the benchmark suite to the cabal file generated above.
  if [ $benchmarksuite = "y" ] || [ $benchmarksuite = "Y" ];  then
    cat <<EOF >> $project.cabal

benchmark $project-bench
  import:         common-options
  type:           exitcode-stdio-1.0
  hs-source-dirs: bench
  main-is:        Main.hs
  build-depends:
    , $project
    , criterion
  ghc-options:    -threaded -rtsopts -with-rtsopts=-N
EOF
  fi
  
  # Create cabal.project file.
  cat <<EOF > cabal.project
packages: ./
EOF
  
  # If test suite is yes then add the test suite to the cabal.project file generated above.
  if [ $testsuite = "y" ] || [ $testsuite = "Y" ]; then
    cat <<EOF >> cabal.project
package $project
tests: true
EOF
  fi
  
  # Create hie.yaml file.
  cat <<EOF > hie.yaml
cradle:
  multi:
    # - path: "ignore/"
    #   config: {cradle: {none: }}
    - path: "src"
      config: {cradle: {cabal: {component: "$project:$project-exe"}}}
EOF
  
  # If test suite is yes then add the test suite to the hie.yaml file generated above.
  if [ $testsuite = "y" ] || [ $testsuite = "Y" ]; then
    cat <<EOF >> hie.yaml
  
    - path: "test"
      config: {cradle: {cabal: {component: "$project:$project-test"}}}
EOF
  fi
  
  # If benchmark suite is yes then add the benchmark suite to the hie.yaml file generated above.
  if [ $benchmarksuite = "y" ] || [ $benchmarksuite = "Y" ]; then
    cat <<EOF >> hie.yaml
    
    - path: "bench"
      config: {cradle: {cabal: {component: "$project:$project-bench"}}}
EOF
  fi
  
  # Create .hlint.yaml file.
  cat <<EOF > .hlint.yaml
# Example hlint file

# Generalise map to fmap, ++ to <>. Off by default
- group:
    name: generalise
    enabled: true

- ignore:
    name: Use section

- ignore:
    name: Use infix
EOF
  
  # Create flake.nix
  cat <<EOF > flake.nix
{
  description = "$description";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = inputs:
    let
      overlay = final: prev: {
        haskell = prev.haskell // {
          packageOverrides = hfinal: hprev:
            prev.haskell.packageOverrides hfinal hprev // {
              $project = hfinal.callCabal2nix "$project" ./. { };
            };
        };
        $project = final.haskell.lib.compose.justStaticExecutables final.haskellPackages.$project;
      };
      perSystem = system:
        let
          pkgs = import inputs.nixpkgs { inherit system; overlays = [ overlay ]; };
          hspkgs = pkgs.haskellPackages;
        in
        {
          devShell = hspkgs.shellFor {
            withHoogle = true;
            packages = p: [ p.$project ];
            buildInputs = [
              hspkgs.cabal-install
              hspkgs.haskell-language-server
              hspkgs.hlint
              hspkgs.ormolu
              pkgs.bashInteractive
            ];
          };
          defaultPackage = pkgs.$project;
        };
    in
    { inherit overlay; } // 
      inputs.flake-utils.lib.eachDefaultSystem perSystem;
}
EOF
  
  # Ask if the user wants to create a git repository. Default is no.
  read -p "Do you want to initialize a git repository? [y/N] " gitrepo
  gitrepo=${gitrepo:-n}
  
  # If gitrepo is not yes or no then ask for a new changelog option until a valid changelog option is entered.  
  while [[ ! $gitrepo =~ ^[yYnN]$ ]]; do
    echo "Initialize git repo option must be y or n."
    read -p "Do you want to initialize a git repository? [y/N] " gitrepo
    gitrepo=${gitrepo:-n}
  done

  # If gitrepo is yes then initialize a git repository.
  if [ $gitrepo = "y" ] || [ $gitrepo = "Y" ]; then
    git init
    git add .
    git commit -m "Initial commit"
  fi
  
  popd > /dev/null
}

# If the first argument is -r or --run then run the program.
if [ "$1" = "run" ]; then
  usage
  exit 0
fi

function cool () {

cat <<EOF

██████████████████████████████████████████████████████████████████████████████████████████
█▄─▄█─▄─▄─█░█─▄▄▄▄███▄─▀█▀─▄█─▄▄─█▄─▄▄▀█▄─▄▄─█─█─█▄─▄█▄─▀█▄─▄███─▄─▄─█▄─▄█▄─▀█▀─▄█▄─▄▄─█░█
██─████─███▄█▄▄▄▄─████─█▄█─██─██─██─▄─▄██─▄▄▄█─▄─██─███─█▄▀─██████─████─███─█▄█─███─▄█▀█▄█
▀▄▄▄▀▀▄▄▄▀▀▀▀▄▄▄▄▄▀▀▀▄▄▄▀▄▄▄▀▄▄▄▄▀▄▄▀▄▄▀▄▄▄▀▀▀▄▀▄▀▄▄▄▀▄▄▄▀▀▄▄▀▀▀▀▄▄▄▀▀▄▄▄▀▄▄▄▀▄▄▄▀▄▄▄▄▄▀▄▀
                                                                      
                                      ▓▓▓▓▓▓  ▓▓▓▓▓▓                                
                                      ▓▓  ░░▓▓▓▓  ▓▓▓▓▓▓                            
                                ▓▓▓▓▓▓▓▓░░  ░░▓▓░░░░▓▓▓▓  ▓▓                        
                              ▒▒▓▓░░  ▓▓░░░░░░░░░░░░▓▓░░░░▓▓                        
                                  ▒▒░░  ░░░░░░░░░░░░░░░░▓▓▓▓▒▒                      
                                  ▓▓░░░░░░░░░░░░░░░░░░░░▓▓░░▓▓                      
                ██████████    ▒▒▓▓░░░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░▓▓                      
            ██████      ██████    ▓▓▓▓▓▓▓▓▓▓▓▓▒▒    ▒▒▒▒▒▒▓▓▓▓                      
          ████              ████████▓▓▓▓▓▓▓▓▓▓▒▒    ▒▒  ▒▒▓▓                        
        ████                  ██████░░  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                        
                          ██████████░░  ░░░░░░██░░░░░░████                          
                    ██████████    ██░░░░░░░░░░▒▒░░░░░░▒▒██                          
              ██████████          ██░░░░░░░░░░░░░░░░░░░░██                          
        ██████████                  ████░░░░░░░░░░░░░░░░██                          
      ██████                          ████░░░░░░▒▒▒▒░░██                            
    ████                              ██▓▓██░░░░░░░░██                              
  ████                          ████████▓▓▓▓████████                                
  ██                          ████▓▓▓▓▓▓████████▓▓██████                            
  ██                        ████▓▓▓▓▓▓▓▓▓▓██████▓▓██▓▓▓▓██                          
                          ▓▓████▓▓▓▓██▓▓▓▓▓▓▓▓██▓▓██▓▓██▓▓▓▓                        
                        ████████▓▓▓▓██▓▓▓▓▓▓▓▓██▓▓██▓▓██▓▓██                        
                      ██▓▓▓▓▓▓▓▓████████████████▓▓██████▓▓██                        
                      ██▓▓██▓▓▓▓████▒▒░░░░  ░░░░▓▓██▒▒██▓▓██                        
                    ██▓▓▓▓██████████▒▒  ░░░░    ▓▓██▒▒██▓▓████                      
                    ██▓▓▓▓▓▓████  ██▒▒░░    ░░░░▓▓██▒▒▒▒██████                      
                  ██▓▓▓▓▓▓▓▓██    ██▒▒░░░░      ▓▓██▒▒▒▒██▓▓██                      
                  ██▓▓▓▓▓▓▓▓██    ██▒▒░░░░░░░░░░░░▓▓██▒▒██▓▓██                      
                ██▓▓▓▓████▓▓██    ████▒▒░░    ░░░░▓▓██▒▒██▓▓▓▓██                    
                ██▓▓██░░░░██        ████████▓▓▓▓▓▓▓▓████████▓▓▓▓████                
                  ██░░░░████        ████████████████████████▓▓████░░████            
                ██░░░░░░░░██        ██▒▒░░░░░░░░░░░░░░░░████▓▓██░░░░░░░░██          
                ██░░░░░░░░░░██      ██░░    ░░░░░░░░░░░░░░░░████░░░░░░░░██          
                ██░░░░░░░░░░██      ██▒▒░░░░    ░░░░██░░░░░░████░░░░░░██            
                ██░░░░░░░░██      ██▒▒  ▒▒▒▒▒▒░░░░░░██░░░░░░░░████████              
                  ████████        ██████    ▒▒▒▒████░░████░░░░██                    
                                  ██    ████▒▒██  ████▒▒▒▒▒▒▒▒░░██                  
                                ██░░░░░░  ▒▒▒▒██    ██▒▒▒▒▒▒▒▒░░░░██                
                                ██░░░░░░▒▒▒▒██        ██▒▒▒▒▒▒▒▒░░██                
                              ██░░░░░░▒▒▒▒▒▒██        ██▒▒▒▒▒▒▒▒░░██                
                            ██░░░░░░░░▒▒▒▒██            ██▒▒▒▒▒▒▒▒░░██              
                            ██░░░░░░▒▒▒▒▒▒██            ██▒▒▒▒▒▒▒▒░░██              
                          ██░░░░░░▒▒▒▒▒▒██              ██▒▒▒▒▒▒░░░░██              
                        ██░░░░░░▒▒▒▒▒▒██                ██▒▒▒▒▒▒▒▒░░██              
                        ██░░░░░░▒▒▒▒▒▒██                ██▒▒▒▒▒▒▒▒░░██              
                          ██░░▒▒▒▒▒▒██                    ████████████              
                        ████████████                        ████████                
                        ██▓▓▓▓████                          ██▓▓▓▓██                
                      ████████████                        ██▓▓██████████            
                    ██▓▓▓▓▓▓▓▓██                          ██▓▓▓▓▓▓▓▓▓▓▓▓████        
                  ██▓▓▓▓▓▓▓▓▓▓██                          ██████▓▓▓▓▓▓░░░░░░██      
                ██▓▓░░░░░░░░████                                ██████████████      
                ██████████████                                                      
EOF

}

# If the first argument is cool then display a cool message and exit the program.
if [ "$1" = "cool" ]; then
    cool
    exit 0
fi