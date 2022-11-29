{ system ? builtins.currentSystem
, nixpkgs
, lib
, gitignore-nix-src
, isFlakes ? false
, fenix
}:
let
  overlay =
    self: pkgs:
    let
      tools = import ./call-tools.nix pkgs;
      run = pkgs.callPackage ./run.nix { inherit pkgs tools isFlakes gitignore-nix-src; };
    in
    {
      inherit tools run;
      # Flake style attributes
      packages = tools // {
        inherit (pkgs) pre-commit;
      };
      checks = self.packages // {
        # A pre-commit-check for nix-pre-commit itself
        pre-commit-check = run {
          src = ../.;
          hooks = {
            shellcheck.enable = true;
            nixpkgs-fmt.enable = true;
          };
        };
      };
    };
in
import nixpkgs {
  overlays = [ 
    overlay
    (_: super: let pkgs = fenix.inputs.nixpkgs.legacyPackages.${super.system}; in fenix.overlays.default pkgs pkgs)
  ];
  # broken is needed for hindent to build
  config = { allowBroken = true; };
  inherit system;
}
