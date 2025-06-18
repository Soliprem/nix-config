{inputs, ...}: {
  imports = [
    inputs.hjem.nixosModules.default
    ./matugen.nix
    ./nushell.nix
    ./hypr.nix
    ./ghostty.nix
    ./gtk.nix
    ./fuzzel.nix
    ./helix.nix
    ./qt.nix
    ./niri.nix
    ./way-edges.nix
  ];
}
