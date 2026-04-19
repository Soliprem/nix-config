# Laptop config
_: {
  imports = [
    ./hardware-configuration.nix
    ../shared
    ../shared/desktop.nix
    ../../system/modules/ollama.nix
    ../../system/modules/iio-niri.nix
    # ../../system/modules/howdy.nix
  ];

  networking.hostName = "nixos-laptop";
  hardware = {
    sensor.iio.enable = true;
  };

  services = {
    tlp = {
      enable = true;
      settings = {
        PLATFORM_PROFILE_ON_BAT = "low-power";
        PLATFORM_PROFILE_ON_AC = "performance";
        CPU_BOOST_ON_BAT = 0;
        CPU_BOOST_ON_AC = 1;
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_SCALING_MAX_FREQ_ON_AC = 4546000;
        CPU_SCALING_MAX_FREQ_ON_BAT = 3000000;
      };
    };
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
