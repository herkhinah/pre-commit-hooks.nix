/*
  A module to import into flakes based on flake-parts.
  Makes integration into a flake easy and tidy.
  See https://flake.parts
*/

{ lib, self, flake-parts-lib, ... }:
let
  inherit (lib)
    mkOption
    types
    ;
in
{
  options = {
    perSystem = flake-parts-lib.mkPerSystemOption ({ config, pkgs, ... }:
      let cfg = config.pre-commit;
      in
      {
        options = {
          pre-commit = {
            check.enable = mkOption {
              description = lib.mdDoc ''
                Whether to add a derivation to the flake `checks`.
                It will perform the pre-commit checks in `nix flake check`.

                You can disable this if one of your hooks do not run properly in
                the Nix sandbox; for example because it needs network access.
              '';
              type = types.bool;
              default = true;
            };
            pkgs = mkOption {
              type = types.uniq (types.lazyAttrsOf (types.raw or types.unspecified));
              description = lib.mdDoc ''
                Nixpkgs to use in the pre-commit [`settings`](#opt-perSystem.pre-commit.settings).
              '';
              default = pkgs;
              defaultText = lib.literalDocBook "<literal>pkgs</literal> (module argument)";
            };
            settings = mkOption {
              type = types.submoduleWith {
                modules = [ ./modules/all-modules.nix ];
                specialArgs = { inherit (cfg) pkgs; };
              };
              default = { };
              description = lib.mdDoc ''
                The pre-commit-hooks.nix configuration.
              '';
            };
            installationScript = mkOption {
              type = types.str;
              description = lib.mdDoc "A bash fragment that sets up [pre-commit](https://pre-commit.com/).";
              default = cfg.settings.installationScript;
              defaultText = lib.literalDocBook "bash statements";
              readOnly = true;
            };
          };
        };
        config = {
	  nixpkgs.overlays = [ (_: super: let pkgs = fenix.inputs.nixpkgs.legacyPackages.${super.system}; in fenix.overlays.default pkgs pkgs) ];
          checks = lib.optionalAttrs cfg.check.enable { pre-commit = cfg.settings.run; };
          pre-commit.settings = { pkgs, ... }: {
            rootSrc = self.outPath;
            package = lib.mkDefault pkgs.pre-commit;
            tools = import ./nix/call-tools.nix pkgs;
          };
        };
      });
  };
}
