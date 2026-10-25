{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.nixos-server = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.modules.nixos.platform
      config.flake.modules.nixos.hjem
      config.flake.modules.nixos.envModule
      config.flake.modules.nixos.shellTools
      config.flake.modules.nixos.starshipModule
      config.flake.modules.nixos.fishModule
      inputs.agenix.nixosModules.default
      ../../hosts/server/hardware-configuration.nix
      config.flake.modules.nixos.server
      (
        {
          pkgs,
          system,
          ...
        }: {
          networking.hostName = "debian-4gb-fsn1-1";
          time.timeZone = "Europe/Rome";
          i18n.defaultLocale = "en_US.UTF-8";
          nixpkgs.config.allowUnfree = true;

          users.users.soliprem = {
            isNormalUser = true;
            extraGroups = ["wheel"];
            shell = pkgs.fish;
            openssh.authorizedKeys.keys = import ../../secrets/user-keys.nix;
          };

          nix.settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
          environment.systemPackages = with pkgs; [
            cifs-utils
            git
            tmux
            inputs.agenix.packages.${system}.default
            inputs.self.packages.${system}.nvf-minimal
          ];

          services.fstrim.enable = true;

          system.stateVersion = "26.05";
        }
      )
    ];
  };
}
