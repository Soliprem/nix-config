{inputs, ...}: {
  flake.modules.nixos.hjem = {config, ...}: let
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
    hjem.specialArgs = {
      inherit fontProfiles;
      suspendOnIdle = config.networking.hostName == "nixos-laptop";
    };
  };
}
