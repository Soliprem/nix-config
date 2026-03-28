{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hjem.nixosModules.default
  ];

  hjem.users.soliprem.imports = [
    ./fish.nix
    ./fastfetch.nix
    ./git.nix
    ./helix.nix
    ./nushell.nix
    ./starship.nix
  ];

  hjem.linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
}
