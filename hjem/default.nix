{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.hjem.nixosModules.default
  ];

  options.soli.git.signingKey = lib.mkOption {
    type = lib.types.str;
    description = "GPG key ID used by Git to sign commits on this host.";
  };

  config = {
    hjem.specialArgs = {
      inherit inputs;
      gitSigningKey = config.soli.git.signingKey;
    };

    hjem.users.soliprem.imports = [
      ./fish.nix
      ./fastfetch.nix
      ./git.nix
      ./helix.nix
      ./nushell.nix
      ./starship.nix
    ];

    hjem.linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
  };
}
