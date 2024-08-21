{pkgs, ...}: {
  imports = [
    ./vpn.nix
    ./printing.nix
    ./steam.nix
    ./overlays.nix
    ./services.nix
    ./greetd.nix
    # ./packages.nix
  ];

  # environment.systemPackages = with pkgs; [
  #   nvim-pkg
  # ];
}
