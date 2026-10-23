{inputs, ...}: {
  flake.modules.nixos.platform = {pkgs, ...}: {
    _module.args.system = pkgs.stdenv.hostPlatform.system;
  };
  flake.modules.nixos.nix = {pkgs, ...}: {
    nix = {
      package = pkgs.lixPackageSets.stable.lix;
      settings = {
        trusted-users = [
          "root"
          "@wheel"
        ];
        substituters = [
          "https://hyprland.cachix.org"
          "https://nyx.cachix.org"
          "https://soliprem.cachix.org"
          "https://doom-emacs-unstraightened.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nyx.cachix.org-1:xH6G0MO9PrpeGe7mHBtj1WbNzmnXr7jId2mCiq6hipE="
          "soliprem.cachix.org-1:kwxQ2xmtoQJVrKUBvSkG/+03ZTuxn06Aebh8AZvtMPA="
          "doom-emacs-unstraightened.cachix.org-1:O5oOlRPnmQEvVaFyuMTmthCEooHbrg54WgSLR07tmg4="
        ];
        experimental-features = ["nix-command" "flakes"];
      };
      optimise.automatic = true;
      registry.t.flake = inputs.self;
    };
    nixpkgs = {
      overlays = [
        (final: prev: {
          inherit
            (prev.lixPackageSets.stable)
            nixpkgs-review
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
        })
      ];
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-39.8.10"
          "pnpm-10.29.2"
          "firefox-esr-140-bin-unwrapped-140.17.0esr"
        ];
      };
    };
    documentation = {
      enable = true;
      nixos.enable = false;
      man.cache.enable = false;
    };
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
      flake = "/home/soliprem/.local/src/nix-config";
    };
  };
  systems = ["x86_64-linux"];
  perSystem = {
    pkgs,
    system,
    ...
  }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    formatter = pkgs.alejandra;
  };
  flake.templates = import ../flake-templates;
}
