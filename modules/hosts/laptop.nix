{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.nixos-laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ../../hosts/laptop/hardware-configuration.nix
      config.flake.modules.nixos.desktop
      config.flake.modules.nixos.iio-niri
      config.flake.modules.nixos.ollama
      ( # Laptop config
        {pkgs, ...}: {
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

          environment.systemPackages = [
            (pkgs.stdenv.mkDerivation {
              pname = "sysboard";
              version = "unstable";

              src = inputs.sysboard;

              nativeBuildInputs = with pkgs; [
                pkg-config
                wayland-protocols
                wayland-scanner
              ];

              buildInputs = with pkgs; [
                gtk4-layer-shell
                gtkmm4
                wayland
              ];

              makeFlags = ["PREFIX=${placeholder "out"}"];

              preBuild = ''
                substituteInPlace src/main.cpp --replace-fail "/usr" $out
              '';
              postInstall = ''
                patchelf --add-needed libsysboard.so $out/bin/sysboard
              '';
            })
          ];

          users.users.soliprem.extraGroups = [
            "networkmanager"
            "wheel"
            "docker"
          ];

          system.stateVersion = "24.05";
        }
      )
    ];
  };
}
