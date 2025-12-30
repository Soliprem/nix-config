# Laptop config
_: {
  imports = [
    ./hardware-configuration.nix
    ../shared
    ../shared/desktop.nix
    ../../system/modules/ollama.nix
    ../../system/modules/iio-niri.nix
  ];

  networking.hostName = "nixos-laptop";
  hardware = {
    sensor.iio.enable = true;
  };

  services.pipewire = {
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

  users.users.soliprem.extraGroups = [
    "networkmanager"
    "wheel"
    "docker"
  ];

  system.stateVersion = "24.05";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
