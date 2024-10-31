{pkgs, inputs, ...}: {
  home.packages = with pkgs; [
    gammastep
    inputs.iio-hyprland.packages.${pkgs.system}.default
    inputs.soluastal.inputs.astal.packages.${pkgs.system}.io
  ];
}
