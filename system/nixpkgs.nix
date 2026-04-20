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
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
      ];
      allowUnfreePredicate = _: true;
    };
  };
  documentation = {
    enable = true;
    nixos.enable = false;
    man.cache.enable = false;
  };
}
