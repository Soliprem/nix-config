{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.hjem.nixosModules.default
    ./matugen.nix
    ./mango.nix
    ./nushell.nix
    ./hypr.nix
    ./ghostty.nix
    ./starship.nix
    ./caelestia.nix
    ./kanshi.nix
    ./swaylock.nix
    ./gtk.nix
    # ./fuzzel.nix
    ./helix.nix
    ./qt.nix
    ./fastfetch.nix
  ];

  hjem.linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
}
