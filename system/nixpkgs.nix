{pkgs, ...}: {
  nix.package = pkgs.lixPackageSets.stable.lix;
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
      ];
    };
  };
  documentation = {
    enable = true;
    nixos.enable = false;
    man.cache.enable = false;
  };
}
