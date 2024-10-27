{pkgs, ...}: {
  home.packages = with pkgs; [
    gammastep
    inputs.iio-hyprland.packages.${pkgs.system}.default
  ];
}
