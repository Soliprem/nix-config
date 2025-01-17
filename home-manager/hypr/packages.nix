{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    gammastep
    hyprsunset
    inputs.iio-hyprland.packages.${pkgs.system}.default
    inputs.astal.packages.${pkgs.system}.io
    inputs.sash.packages.${pkgs.system}.default
  ];
}
