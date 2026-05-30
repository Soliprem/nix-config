{
  inputs,
  pkgs,
  ...
}: let
  sys = pkgs.stdenv.hostPlatform.system;
in {
  environment.systemPackages = with pkgs; [
    # Flake inputs and custom derivations
    inputs.agenix.packages.${sys}.default
    inputs.self.packages.${sys}.nvf
    inputs.thumbpick.packages.${sys}.default
    inputs.zen-browser.packages.${sys}.default
    inputs.stash.packages.${sys}.default
    inputs.spam.packages.${sys}.default
    codex
    (pkgs.stdenv.mkDerivation {
      pname = "sysboard";
      version = "unstable";

      src = inputs.sysboard;

      nativeBuildInputs = with pkgs; [
        pkg-config
        wayland-protocols
        wayland-scanner
      ];

      buildInputs = with pkgs; [
        gtk4-layer-shell
        gtkmm4
        wayland
      ];

      makeFlags = ["PREFIX=${placeholder "out"}"];

      preBuild = ''
        substituteInPlace src/main.cpp --replace-fail "/usr" $out
      '';
      postInstall = ''
        patchelf --add-needed libsysboard.so $out/bin/sysboard
      '';
    })

    # CLI, shells, and core tools
    gnupg
    atuin
    bat
    btop-rocm
    carapace
    # comma
    cowsay
    eza
    fastfetch
    fd
    fortune
    fzf
    git
    gdb
    killall
    lazygit
    nix-your-shell
    nushell
    ripgrep
    scarab
    starship
    tealdeer
    termdown
    timer
    udict
    wget
    wiki-tui
    zoxide

    # Editors, development, and authoring
    impression
    jujutsu
    openai-whisper
    typst
    tinymist
    zed-editor

    # Wayland, theming, and desktop utilities
    adw-gtk3
    bibata-cursors
    brightnessctl
    darkly
    fuzzel
    gammastep
    ghostty
    hyprshot
    hyprshutdown
    iio-hyprland
    hyprlock
    glib
    kanshi
    kdePackages.polkit-kde-agent-1
    kdePackages.qt6ct
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5ct
    linearicons-free
    matugen
    networkmanagerapplet
    overskride
    swappy
    swaylock-effects
    quickshell
    swayosd
    awww
    tofi
    tray-tui
    wayneko
    wtype
    wlogout
    xwayland-satellite

    # Browsers, communication, and network clients
    beeper
    bitwarden-desktop
    rnote
    chromium
    legcord
    nextcloud-client
    qutebrowser
    telegram-desktop
    super-productivity
    thunderbird
    transmission_4-gtk

    # General desktop applications
    anki-bin
    appimage-run
    darktable
    foot
    gale
    gowall
    imv
    keyutils
    loupe
    lumafly
    lutgen-studio
    mediawriter
    meow
    nautilus
    obsidian
    papers
    proton-vpn-cli
    proton-vpn
    yad
    zathura
    sioyek
    zotero

    # Audio, video, and creative tools
    alsa-utils
    audacity
    ffmpeg
    gimp
    kdePackages.qtmultimedia
    libnotify
    mpv
    muse-sounds-manager
    musescore
    pipewire
    pwvucontrol
    qpwgraph
    spek
    spotdl
    tauon
    wiremix

    # Gaming
    beyond-all-reason
    gamemode
    heroic
    mangohud
    goverlay
    prismlauncher
    protonplus
    umu-launcher

    # Miscellaneous apps and helpers
    bluetui
    wifitui
    via
    dotacat
    nicotine-plus
    sunsetr
  ];
  programs = {
    direnv.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        input-overlay
        obs-livesplit-one
      ];
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        glib
        nss
        nspr
        dbus
        atk
        cups
        gtk3
        alsa-lib
        at-spi2-atk
        at-spi2-core
        pango
        cairo
        fontconfig
        freetype
        harfbuzz
        libgbm
        libdrm
        gdk-pixbuf
        expat
        glibc
        # X11 libraries
        libx11
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxrandr
        libxrender
        libxtst
        libxscrnsaver
        libxcb
        libxi
        libxcursor
        # Additional libraries that might be needed
        libxkbcommon
        wayland
      ];
    };
    kdeconnect.enable = true;
    # river.enable = true;
    niri.enable = true;
    hyprland.enable = true;
    mango.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/soliprem/.config/nix-config";
    };
  };
}
