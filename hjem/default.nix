{
  config,
  inputs,
  pkgs,
  ...
}: let
  fontDefaults = config.fonts.fontconfig.defaultFonts;
  fontProfiles = {
    serif = builtins.head fontDefaults.serif;
    ui = builtins.head fontDefaults.serif;
    sans = builtins.head fontDefaults.sansSerif;
    mono = builtins.head fontDefaults.monospace;
    emoji = builtins.head fontDefaults.emoji;
  };
in {
  imports = [
    inputs.hjem.nixosModules.default
  ];

  hjem.specialArgs = {inherit inputs fontProfiles;};

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
