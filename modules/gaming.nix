{inputs, ...}: {
  flake.modules.nixos.gaming = {
    pkgs,
    system,
    ...
  }: {
    programs.steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      protontricks.enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    environment.systemPackages = with pkgs; [
      inputs.amethyst-mod-manager.packages.${system}.default
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
}
