{
  description = "A simple Haskell project";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = inputs:
    let
      overlay = final: prev: {
        haskell = prev.haskell // {
          packageOverrides = hfinal: hprev:
            prev.haskell.packageOverrides hfinal hprev // {
              project-with-no-tests-or-bench = hfinal.callCabal2nix "project-with-no-tests-or-bench" ./. { };
            };
        };
        project-with-no-tests-or-bench = final.haskell.lib.compose.justStaticExecutables final.haskellPackages.project-with-no-tests-or-bench;
      };
      perSystem = system:
        let
          pkgs = import inputs.nixpkgs { inherit system; overlays = [ overlay ]; };
          hspkgs = pkgs.haskellPackages;
        in
        {
          devShell = hspkgs.shellFor {
            withHoogle = true;
            packages = p: [ p.project-with-no-tests-or-bench ];
            buildInputs = [
              hspkgs.cabal-install
              hspkgs.haskell-language-server
              hspkgs.hlint
              hspkgs.ormolu
              pkgs.bashInteractive
            ];
          };
          defaultPackage = pkgs.project-with-no-tests-or-bench;
        };
    in
    { inherit overlay; } // 
      inputs.flake-utils.lib.eachDefaultSystem perSystem;
}
