{ inputs, pkgs, ... }:
{
  nix.package = pkgs.lixPackageSets.stable.lix;
  nixpkgs = {
    # You can add overlays here
    overlays = [
      (final: prev: {
        inherit (prev.lixPackageSets.stable)
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
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      permittedInsecurePackages = [
        "electron-35.7.5"
        "libsoup-2.74.3"
        "qtwebengine-5.15.19"
        "olm-3.2.16"
        "fluffychat-linux-1.26.1"
        "cinny-4.2.3"
        "cinny-unwrapped-4.2.3"
      ];
      allowUnfreePredicate = _: true;
    };
  };
}
