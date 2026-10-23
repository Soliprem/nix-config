{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.nixos-home = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ../../hosts/home/hardware-configuration.nix
      config.flake.modules.nixos.desktop
      config.flake.modules.nixos.ollama-rocm
      config.flake.modules.nixos.vane
      config.flake.modules.nixos.openrgb
      config.flake.modules.nixos.media-library
      config.flake.modules.nixos.proton-vpn
      (
        {pkgs, ...}: {
          networking.hostName = "nixos-home";

          boot = {
            kernelParams = ["acpi_backlight=video"];
            kernelPackages = pkgs.linuxPackages_latest;
          };

          users.users.soliprem.extraGroups = [
            "gamemode"
            "audio"
            "video"
          ];

          system.stateVersion = "26.05";
        }
      )
    ];
  };
}
