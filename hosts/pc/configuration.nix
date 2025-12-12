{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared
    ../shared/desktop.nix
    ../../system/modules/ollamaRocm.nix
  ];

  networking.hostName = "nixos-pc";

  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    kernelParams = [ "acpi_backlight=video" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  users.users.soliprem.extraGroups = [
    "gamemode"
    "audio"
    "video"
  ];

  virtualisation.docker = {
    enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "24.05";
}
