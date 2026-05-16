{ pkgs, configRoot, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared
    ../shared/desktop.nix
  ]
  ++ map (file: configRoot + "/system/modules/${file}" + ".nix") [
    "ollamaRocm"
    "openrgb"
  ];

  networking = {
    hostName = "nixos-pc";
    firewall.trustedInterfaces = [ "tailscale0" ];
  };

  boot = {
    kernelParams = [ "acpi_backlight=video" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  users.users.soliprem.extraGroups = [
    "gamemode"
    "audio"
    "video"
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "24.05";
}
