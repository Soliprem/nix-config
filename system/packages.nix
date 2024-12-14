{inputs, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    highlight
    git
    wget
    fastfetch
    networkmanagerapplet
    via
    libgccjit
    linearicons-free
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
  };
}
