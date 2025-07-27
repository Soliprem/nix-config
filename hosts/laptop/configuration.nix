# Laptop config
_: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../shared
    ../../system/modules/ollama.nix
  ];

  networking.hostName = "nixos-laptop"; # Define your hostname.
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

  users.users.soliprem.extraGroups = ["networkmanager" "wheel" "docker"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
