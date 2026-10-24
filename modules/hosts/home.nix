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
      proton-vpn
      (
        {pkgs, ...}: {
          networking.hostName = "nixos-home";
          networking.interfaces.enp113s0.wakeOnLan.enable = true;

          boot.kernelPackages = pkgs.linuxPackages_latest;

          users.users.soliprem.openssh.authorizedKeys.keys = import ../../secrets/user-keys.nix;

          system.stateVersion = "26.05";
        }
      )
    ];
  };
}
