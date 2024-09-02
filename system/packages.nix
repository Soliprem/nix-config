{pkgs, inputs, ...}: {
  environment.systemPackages = with pkgs; [
    highlight
  ];
  programs = {
    kdeconnect.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    };
}
