{pkgs, inputs, ...}: {
  environment.systemPackages = with pkgs; [
    highlight
  ];
  programs = {
    kdeconnect.enable = true;
    # hyprland = {
    #   enable = false;
    #   package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    #   portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    #
    # };
    river.enable = true;
    };
}
