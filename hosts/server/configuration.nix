{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./storage.nix
    ./firewall.nix
    ./docker-compat.nix
    ./secrets.nix
    ./native-compat.nix
  ];

  # Preserve the production identity: Foundry's signed license binds to it.
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
