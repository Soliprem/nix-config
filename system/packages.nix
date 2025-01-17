{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    highlight
    git
    wget
    protontricks
    networkmanagerapplet
    alsa-utils
    pipewire
    via
    libgccjit
    linearicons-free
    musescore
    libnotify
    youtube-music
    godot_4
    obs-studio
    lazygit
    ddcutil
    ddcui
    nix-output-monitor
    nexusmods-app-unfree
    mangohud
    # inputs.ghostty.packages.${system}.default
    openrgb-with-all-plugins
    fluffychat
    bitwarden-desktop
    showtime
    keyutils
    cinny-desktop
    iamb
    revolt-desktop
    swww
    bitwarden-cli
    bitwarden-menu
    muse-sounds-manager
    nheko
    pwvucontrol
    heroic
    lutris
    dotacat
    inputs.agenix.packages.${system}.default
    inputs.diniamo.legacyPackages.${pkgs.system}.umu-launcher
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
    fluffychat
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
  programs = {
    kdeconnect.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    # river.enable = true;
    niri.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/soliprem/.config/nix-config";
    };
    gamescope = {
      enable = true;
      env = {
        XKB_DEFAULT_LAYOUT = "eu";
        XKB_DEFAULT_OPTIONS = "caps:swapescape";
      };
      args = ["--force-grab-cursor"];
    };
  };
}
