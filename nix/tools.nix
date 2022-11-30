{ actionlint
, alejandra
, ansible-lint
, cabal-fmt
, cabal2nix
, callPackage
, clang-tools
, deadnix
, dhall
, elmPackages
, git
, gitAndTools
, hadolint
, haskell
, haskellPackages
, hindent
, hlint
, hpack
, html-tidy
, hunspell
, luaPackages
, mdsh
, nix-linter
, nixfmt
, nixpkgs-fmt
, nodePackages
, ormolu
, python39Packages
, runCommand
, shellcheck
, shfmt
, statix
, stylish-haskell
, stylua
, texlive
, writeScript
, writeText
, go
, revive ? null
}:

{
  inherit actionlint alejandra cabal-fmt cabal2nix clang-tools deadnix dhall hadolint hindent hlint hpack html-tidy nix-linter nixfmt nixpkgs-fmt ormolu shellcheck shfmt statix stylish-haskell stylua go mdsh revive;
  inherit (elmPackages) elm-format elm-review elm-test;
  # TODO: these two should be statically compiled
  inherit (haskellPackages) brittany fourmolu;
  inherit (luaPackages) luacheck;
  inherit (nodePackages) eslint markdownlint-cli prettier;
  inherit (python39Packages) ansible-lint yamllint;
  purs-tidy = nodePackages.purs-tidy or null;
  cabal2nix-dir = callPackage ./cabal2nix-dir { };
  hpack-dir = callPackage ./hpack-dir { };
  hunspell = callPackage ./hunspell { };
  purty = callPackage ./purty { purty = nodePackages.purty; };
  terraform-fmt = callPackage ./terraform-fmt { };
  latexindent = texlive.combined.scheme-medium;
  chktex = texlive.combined.scheme-medium;
}
