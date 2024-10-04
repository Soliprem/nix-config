{pkgs, ...}: {
  imports = [
    ./vpn.nix
    ./printing.nix
    ./steam.nix
    ./overlays.nix
    ./stylix.nix
    ./services.nix
    ./regreet.nix
    ./environment.nix
    ./packages.nix
  ];
}
