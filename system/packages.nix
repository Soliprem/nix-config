{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    highlight
  ];
}
