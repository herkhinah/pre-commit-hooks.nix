pkgs:
pkgs.lib.flip builtins.removeAttrs [ "override" "overrideDerivation" ]
  (pkgs.callPackage ./tools.nix {
    cabal-fmt = (pkgs.haskell.lib.enableSeparateBinOutput pkgs.haskellPackages.cabal-fmt).bin;
    hindent = pkgs.haskell.lib.enableSeparateBinOutput pkgs.haskellPackages.hindent;
    clippy = pkgs.rustToolchain "stable" [ "clippy" "cargo" ];
    rustfmt = pkgs.rustToolchain "stable" [ "rustfmt" "cargo" ];
    cargo = pkgs.rustToolchain "stable" [ "cargo" ];
  })
