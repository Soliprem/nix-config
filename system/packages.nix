{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    highlight
    git
    wget
    protontricks
    networkmanagerapplet
    alsa-utils
    pipewire
    via
    libgccjit
    linearicons-free
    musescore
    libnotify
  ];
  programs = {
    kdeconnect.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    # river.enable = true;
    niri.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/soliprem/.config/nix-config";
    };
    gamescope = {
      enable = true;
      env = {
        XKB_DEFAULT_LAYOUT = "eu";
        XKB_DEFAULT_OPTIONS = "caps:swapescape";
      };
      args = ["--force-grab-cursor"];
    };
  };
}
