{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hjem.nixosModules.default
  ];

  hjem.users.soliprem = {
    imports = [
      ./tofi.nix
      ./caelestia.nix
      ./darkman.nix
      ./fastfetch.nix
      ./ghostty.nix
      ./git.nix
      ./gtk.nix
      ./helix.nix
      ./hypr.nix
      ./kanshi.nix
      ./mango.nix
      ./matugen.nix
      ./nushell.nix
      ./qt.nix
      ./starship.nix
      ./swaylock.nix
    ];
  };

  hjem.linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
}
