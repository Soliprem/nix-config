{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    highlight
  ];
  programs.kdeconnect.enable = true;
}
