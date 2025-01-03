# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  config,
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
    ./swayosd.nix
    # ./schizofox.nix
    # ./river.nix
    ./tofi.nix
    ./fastfetch.nix
    ./qutebrowser.nix
    ./scripts.nix
    ./fuzzel.nix
    ./agenix.nix
    ./wlogout.nix
    ./spicetify.nix
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
        "fluffychat-linux-1.23.0"
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
      nexusmods-app-unfree
      mangohud
      inputs.ghostty.packages.${system}.default
      openrgb-with-all-plugins
      ianny
      fluffychat
      bitwarden-desktop
      showtime
      keyutils
      iamb
      revolt-desktop
      swww
      bitwarden-cli
      bitwarden-menu
      muse-sounds-manager
      nheko
      pwvucontrol
      # heroic
      lutris
      dotacat
      inputs.agenix.packages.${system}.default
      # (inputs.umu.packages.${pkgs.system}.umu.override {version = "${inputs.umu.shortRev}";})
      teams-for-linux
      wlsunset
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
      gamescope
      qpwgraph
      brightnessctl
      # hugo
      stremio
      fd
      killall
      zathura
      papers
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
      element-desktop
      fractal
      # xfce.thunar
      nautilus
      spotube
      glib
      socat
      overskride
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
    git = {
      enable = true;
      userName = "Soliprem";
      userEmail = "franci.solidoro@gmail.com";
    };
    # firefox.enable = true;
  };
  # Nicely reload system units when changing configs
  systemd = {
    user = {
      startServices = "sd-switch";
      sessionVariables = {
        BW_SESSION = "$(cat ${config.age.secrets.bw_sessionkey.path})";
      };
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
