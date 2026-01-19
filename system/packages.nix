{
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    codex
    meow
    tuifeed
    steam-tui
    wiremix
    rmpc
    ostui
    bluetui
    tealdeer
    jq
    scarab
    lumafly
    distrobox
    distrobox-tui
    wiki-tui
    tor-browser
    lutgen-studio
    nix-your-shell
    imv
    tofi
    openai-whisper
    nushell
    darkman
    swayosd
    litemdview
    servo
    limo
    kanshi
    swaylock-effects
    gretl
    faugus-launcher
    super-productivity
    blanket
    winboat
    wlogout
    dissent
    gnome-feeds
    tray-tui
    wmenu
    darkly
    darkly-qt5
    scenefx
    tree-sitter-grammars.tree-sitter-typst
    typst
    tinymist
    wayneko
    omnissa-horizon-client
    newsflash
    gdb
    beyond-all-reason
    eza
    brave
    ladybird
    mediawriter
    wl-clipboard
    aonsoku
    tauon
    navidrome
    supersonic
    feishin
    spek
    nicotine-plus
    slskd
    feishin
    spicetify-cli
    openvpn
    spotify
    emacs
    bottles
    phoronix-test-suite
    furmark
    nwg-drawer
    swaynotificationcenter
    xwayland-satellite
    comma
    inkscape
    anki-bin
    kew
    gapless
    spotdl
    audacity
    cozy
    gcs
    code-cursor
    jujutsu
    # lazyjj
    calibre
    qutebrowser
    maptool
    anytype
    zed-editor
    kdePackages.qtmultimedia
    kdePackages.plasmatube
    kdePackages.polkit-kde-agent-1
    libsForQt5.qt5.qtgraphicaleffects
    affine
    # gale
    r2modman
    protonvpn-gui
    ffmpeg
    chromium
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nvf
    inputs.thumbpick.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.ekphos.packages.${pkgs.stdenv.hostPlatform.system}.default
    libsForQt5.qt5ct
    kdePackages.qt6ct
    gimp
    highlight
    helix
    cartridges
    fuzzel
    adw-gtk3
    bibata-cursors
    atuin
    fastfetch
    carapace
    starship
    zoxide
    gammastep
    iio-hyprland
    matugen
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
    youtube-tui
    gtk-pipe-viewer
    godot_4
    obs-studio
    lazygit
    ddcutil
    ddcui
    nix-output-monitor
    nexusmods-app-unfree
    # limo
    mangohud
    ghostty
    foot
    # fluffychat
    bitwarden-desktop
    showtime
    keyutils
    iamb
    revolt-desktop
    swww
    # bitwarden-cli
    # bitwarden-menu
    muse-sounds-manager
    pwvucontrol
    heroic
    lutris
    dotacat
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    # inputs.diniamo.legacyPackages.${pkgs.stdenv.hostPlatform.system}.umu-launcher
    # (inputs.umu.packages.${pkgs.stdenv.hostPlatform.system}.umu.override {version = "${inputs.umu.shortRev}";})
    umu-launcher
    teams-for-linux
    sunsetr
    batsignal
    ripgrep
    android-tools
    hyprshade
    loupe
    transmission_4-gtk
    cowsay
    fortune
    starship
    thunderbird
    legcord
    impression
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    freetube
    appimage-run
    obsidian
    kdePackages.kdeconnect-kde
    beeper
    bat
    gamemode
    wtype
    udict
    didyoumean
    fzf
    prismlauncher
    protonup-qt
    protonplus
    telegram-desktop
    qpwgraph
    brightnessctl
    # stremio
    fd
    killall
    zathura
    papers
    yad
    darktable
    nextcloud-client
    planify
    mpv
    btop-rocm
    termdown
    timer
    cliphist
    hyprshot
    swappy
    element-desktop
    nautilus
    spotube
    glib
    socat
    overskride
    blueman
    blueberry
    pamixer
  ];
  programs = {
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
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libXrender
        xorg.libXtst
        xorg.libXScrnSaver
        xorg.libxcb
        xorg.libXi
        xorg.libXcursor
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
    gamescope = {
      enable = true;
      env = {
        XKB_DEFAULT_LAYOUT = "eu";
        XKB_DEFAULT_OPTIONS = "caps:swapescape";
      };
      args = [ "--force-grab-cursor" ];
    };
  };
}
