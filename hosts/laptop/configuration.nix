# Laptop config
{ configRoot, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../shared
    ../shared/desktop.nix
    inputs.watt.nixosModules.default
  ]
  ++ map (file: configRoot + "/system/modules/${file}" + ".nix") [
    "iio-niri"
    "ollama"
  ];

  networking.hostName = "nixos-laptop";
  hardware = {
    sensor.iio.enable = true;
  };

  services = {
    watt.enable = true;
    pipewire = {
      wireplumber = {
        extraConfig = {
          "10-disable-camera" = {
            "wireplumber.profiles" = {
              main."monitor.libcamera" = "disabled";
            };
          };
        };
      };
    };
  };

  users.users.soliprem.extraGroups = [
    "networkmanager"
    "wheel"
    "docker"
  ];

  system.stateVersion = "24.05";
}
