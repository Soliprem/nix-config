{inputs, ...}: {
  imports = [
    inputs.lix-module.nixosModules.default
    ./printing.nix
    ./scripts.nix
    ./modules
    ./nixpkgs.nix
    ./substituters.nix
    ./services.nix
    ./environment.nix
    ./packages.nix
    ./fonts.nix
  ];
}
