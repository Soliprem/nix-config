{pkgs}: {
  environment.systemPackages = with pkgs; [
    nvim-pkg
  ];
}
