{inputs, ...}: {
  imports = [
    inputs.lix-module.nixosModules.default
    ./vpn.nix
    ./printing.nix
    ./modules
    ./nixpkgs.nix
    ./substituters.nix
    ./services.nix
    ./environment.nix
    ./packages.nix
    ./fonts.nix
  ];
}
