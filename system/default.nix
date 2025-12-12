{inputs, ...}: {
  imports = [
    inputs.mango.nixosModules.mango
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
