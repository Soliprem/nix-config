{
  config,
  inputs,
  lib,
  ...
}: {
  options.neovim = lib.mkOption {
    type = lib.types.attrsOf lib.types.deferredModule;
  };

  config = {
    flake.modules.nixos.neovim = {pkgs, ...}: {
      environment.systemPackages = [inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nvf];
    };

    perSystem = {system, ...}: let
      pkgs = import inputs.nvf.inputs.nixpkgs {
        inherit system;
        config.allowUnfreePredicate = pkg:
          builtins.elem (inputs.nvf.inputs.nixpkgs.lib.getName pkg) ["eyeliner.nvim"];
      };
    in {
      packages =
        lib.mapAttrs (_: module:
          (inputs.nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = [module];
          }).neovim)
        config.neovim
        // {default = inputs.self.packages.${system}.nvf;};
    };
  };
}
