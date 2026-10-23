{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.nixos-server = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.agenix.nixosModules.default
      ../../hosts/server/hardware-configuration.nix
      config.flake.modules.nixos.server
      (
        {pkgs, ...}: {
          programs.fish = {
            enable = true;
          };

          networking.hostName = "debian-4gb-fsn1-1";
          time.timeZone = "Europe/Rome";
          i18n.defaultLocale = "en_US.UTF-8";

          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          environment.systemPackages = with pkgs; [
            cifs-utils
            git
            tmux
            inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
            inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nvf-minimal
          ];

          services.fstrim.enable = true;

          system.stateVersion = "26.05";
        }
      )
    ];
  };
}
