# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule
    # inputs.walker.homeManagerModules.default
    # ./walker.nix
    ./hypr
    # ./schizofox.nix
    ./tofi.nix
    ./mako.nix
    ./scripts.nix
    ./fuzzel.nix
    ./wlogout.nix
    ./spicetify.nix
    ./river.nix
    ./theming.nix
    ./stylix.nix
    ./kitty.nix
    ./foot.nix
    ./defaultApplications.nix
    ./nushell.nix
    ./nvf.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default
      inputs.soniksnvim.overlays.default

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
      permittedInsecurePackages = [
        "electron-27.3.11"
        "olm-3.2.16"
      ];
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "soliprem";
    homeDirectory = "/home/soliprem";
    packages = with pkgs; [
      # gimp
      youtube-music
      muse-sounds-manager
      heroic
      lutris
      (inputs.umu.packages.${pkgs.system}.umu.override {version = "${inputs.umu.shortRev}";})
      teams-for-linux
      wlsunset
      musescore
      batsignal
      # zed-editor
      ripgrep
      # ungoogled-chromium
      # signal-desktop
      android-tools
      android-udev-rules
      hyprshade
      loupe
      transmission_4-gtk
      # walker
      cowsay
      fortune
      starship
      thunderbird
      lolcat
      legcord
      impression
      inputs.zen-browser.packages."${system}".default
      freetube
      appimage-run
      # nvim-pkg
      obsidian
      plasma5Packages.kdeconnect-kde
      beeper
      bat
      gamemode
      wtype
      udict
      didyoumean
      fzf
      prismlauncher
      protonup-qt
      telegram-desktop
      pavucontrol
      gamescope
      qpwgraph
      brightnessctl
      # hugo
      stremio
      fd
      killall
      zathura
      yad
      darktable
      nextcloud-client
      planify
      mpv
      btop
      termdown
      timer
      cliphist
      hyprshot
      # nerdfonts.override {fonts = ["Inconsolata"];}
      swww
      element-desktop-wayland
      fractal
      # xfce.thunar
      nautilus
      spotube
      glib
      socat
      blueman
      blueberry
      pamixer
      # inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin
      # python312Packages.simple-websocket-server
      # python312Packages.pynvim
      # python312Packages.requests
      # python312
    ];
  };

  # Add stuff for your user as you see fit:

  fonts.fontconfig.enable = true;

  # Enable home-manager and git and other things
  programs = {
    home-manager.enable = true;
    qutebrowser = {
      enable = true;
      extraConfig = ''
        c.tabs.show = "switching"
      '';
    };
    git = {
      enable = true;
      userName = "Soliprem";
      userEmail = "franci.solidoro@gmail.com";
    };
    # firefox.enable = true;
  };
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
