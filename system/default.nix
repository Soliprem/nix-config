{inputs, ...}: {
  modules = [
    inputs.lix-module.nixosModules.default
  ];
  imports = [
    ./vpn.nix
    ./printing.nix
    ./modules
    ./overlays.nix
    ./substituters.nix
    ./services.nix
    ./environment.nix
    ./packages.nix
  ];
}
