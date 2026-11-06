{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.nixos-home = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      ../../hosts/home/hardware-configuration.nix
      platform
      base
      nix
      hjem
      fonts
      shells
      networking
      neovim
      media-library
      (
        {pkgs, ...}: {
          networking.hostName = "nixos-home";
          networking.interfaces.enp113s0.wakeOnLan.enable = true;

          boot.kernelPackages = pkgs.linuxPackages_latest;

          users.users.soliprem.openssh.authorizedKeys.keys = import ../../secrets/user-keys.nix;

          services.minecraft-server = {
            enable = true;
            eula = true;
            declarative = true;
            serverProperties = {
              server-ip = "127.0.0.1";
              max-players = 3;
              white-list = true;
            };
            # Replace the friend's placeholder username and UUID with their Java account.
            whitelist = {
              Soliprem = "4e75f980-2db4-4d9c-9c10-ae732396a725";
              nugge_di_soia = "cfc7ca20-81d2-43e5-86a7-11a67c141e96";
              Aurox_ = "0d2d8f99-fac6-4a92-aa6a-26f8c8414be1";
            };
          };

          systemd.services.minecraft-tailnet = {
            description = "Tailnet access to Minecraft";
            wantedBy = ["multi-user.target"];
            wants = ["tailscaled.service"];
            after = ["tailscaled.service"];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              Restart = "on-failure";
              RestartSec = 10;
              ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --tcp=25565 tcp://127.0.0.1:25565";
              ExecStop = "${pkgs.tailscale}/bin/tailscale serve --tcp=25565 off";
            };
          };

          system.stateVersion = "26.05";
        }
      )
    ];
  };
}
