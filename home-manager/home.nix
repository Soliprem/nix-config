# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    ./hyprland.nix
    # ./schizofox.nix
    ./mako.nix
    ./theming.nix
    ./stylix.nix
    ./kitty.nix
    ./foot.nix
    ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "soliprem";
    homeDirectory = "/home/soliprem";
  };

  # Add stuff for your user as you see fit:
  home.packages = with pkgs; [
    pavucontrol
    gamescope
    qjackctl
    brightnessctl
    brave
    hugo
    stremio
    fd
    killall
    qutebrowser
    zathura
    yad
    musescore
    darktable
    nextcloud-client
    planify
    mpv
    btop
    termdown
    timer
    cliphist
    hyprshot
    fuzzel
    nerdfonts
    swww
    element-desktop-wayland
    typst
    xfce.thunar
    gnome.nautilus
    spotube
    glib
    yazi
    socat
    blueman
    pamixer
    sioyek
    inputs.muse-sounds-manager.packages.${pkgs.system}.muse-sounds-manager
    inputs.iio-hyprland.packages.${pkgs.system}.default
  ];

  fonts.fontconfig.enable = true;

  # Enable home-manager and git and other things
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Soliprem";
      userEmail = "franci.solidoro@gmail.com";
    };
    firefox.enable = true;
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
