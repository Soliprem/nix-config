{pkgs, ...}: {
  imports = [
    ./vpn.nix
    ./printing.nix
    ./steam.nix
    ./overlays.nix
    ./services.nix
    ./regreet.nix
    ./environment.nix
    # ./packages.nix
  ];

  # environment.systemPackages = with pkgs; [
  #   nvim-pkg
  # ];
}
