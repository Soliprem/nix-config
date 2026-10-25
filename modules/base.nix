{inputs, ...}: {
  flake.modules.nixos.base = {
    pkgs,
    system,
    ...
  }: {
    imports = [inputs.agenix.nixosModules.default];
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    time.timeZone = "Europe/Rome";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "it_IT.UTF-8";
        LC_IDENTIFICATION = "it_IT.UTF-8";
        LC_MEASUREMENT = "it_IT.UTF-8";
        LC_MONETARY = "it_IT.UTF-8";
        LC_NAME = "it_IT.UTF-8";
        LC_NUMERIC = "it_IT.UTF-8";
        LC_PAPER = "it_IT.UTF-8";
        LC_TELEPHONE = "it_IT.UTF-8";
        LC_TIME = "it_IT.UTF-8";
      };
    };
    environment = {
      systemPackages = [inputs.agenix.packages.${system}.default];
      shells = with pkgs; [
        busybox
        "${busybox}/bin/ash"
      ];
    };
    users.users.root.openssh.authorizedKeys.keys = import ../secrets/user-keys.nix;
    users.users.soliprem = {
      isNormalUser = true;
      description = "Francesco Prem Solidoro";
      extraGroups = [
        "networkmanager"
        "wheel"
        "podman"
        "plugdev"
      ];
      shell = "${pkgs.busybox}/bin/ash";
    };
  };
}
