{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../shared
    ../../system/modules/ollamaRocm.nix
  ];

  networking.hostName = "nixos-pc";

  boot = {
    initrd.kernelModules = ["amdgpu"];
    kernelParams = ["acpi_backlight=video"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  users.users.soliprem.extraGroups = ["gamemode" "audio" "video"];

  virtualisation.docker = {
    enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
