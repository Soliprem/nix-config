{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.nixos-pc = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ../../hosts/pc/hardware-configuration.nix
      config.flake.modules.nixos.desktop
      config.flake.modules.nixos.ollama-rocm
      config.flake.modules.nixos.vane
      config.flake.modules.nixos.openrgb
      config.flake.modules.nixos.media-library
      config.flake.modules.nixos.proton-vpn
      (
        {pkgs, ...}: {
          networking.hostName = "nixos-pc";
          services.ollama.home = "/storage/ollama";

          boot = {
            kernelParams = ["acpi_backlight=video"];
            kernelPackages = pkgs.linuxPackages_latest;
          };

          users.users.soliprem.extraGroups = [
            "gamemode"
            "audio"
            "video"
          ];

          system.stateVersion = "24.05";
        }
      )
    ];
  };
}
