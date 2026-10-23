{inputs, ...}: {
  flake.modules.nixos.gaming = {pkgs, ...}: let
    sys = pkgs.stdenv.hostPlatform.system;
  in {
    programs.steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      protontricks.enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    environment.systemPackages = with pkgs; [
      inputs.self.packages.${sys}.amethyst-mod-manager
      beyond-all-reason
      gamemode
      heroic
      mangohud
      prismlauncher
      protonplus
      umu-launcher
      lumafly
    ];
  };
  perSystem = {pkgs, ...}: {
    packages.amethyst-mod-manager = pkgs.callPackage ../packages/amethyst-mod-manager.nix {
      src = inputs.amethyst-mod-manager;
      liblootSrc = inputs.amethyst-libloot;
    };
  };
}
