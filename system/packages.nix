{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    beyond-all-reason
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
    # swaynotificationcenter
    xwayland-satellite
    inputs.ignis.packages.${system}.ignis
    inputs.way-edges.packages.${system}.way-edges
    inputs.caelestia.packages.${system}.debug
    inputs.caelestia-cli.packages.${system}.default
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
    lazyjj
    calibre
    hyprpanel
    qutebrowser
    maptool
    # anytype
    inputs.quickshell.packages.${pkgs.system}.default
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
    # inputs.nvf-soli.packages.${pkgs.system}.default
    libsForQt5.qt5ct
    kdePackages.qt6ct
    gimp
    highlight
    helix
    cartridges
    fuzzel
    adw-gtk3
    bibata-cursors
    inputs.atuin.packages.${pkgs.system}.default
    fastfetch
    carapace
    starship
    zoxide
    gammastep
    inputs.iio-hyprland.packages.${pkgs.system}.default
    inputs.astal.packages.${pkgs.system}.io
    inputs.sash.packages.${pkgs.system}.default
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
    godot_4
    obs-studio
    lazygit
    ddcutil
    ddcui
    nix-output-monitor
    nexusmods-app-unfree
    mangohud
    inputs.ghostty.packages.${system}.default
    # (inputs.ghostty.packages.${system}.default.overrideAttrs (drv: {
    #   patches =
    #     drv.patches or []
    #     ++ [
    #       (pkgs.fetchpatch {
    #         url = "https://github.com/Opposite34/ghostty/commit/5b871c595254eece6bf44ab48f71409b7ed36088.patch";
    #         hash = "sha256-hCWp2MdoD89oYN3I+Pq/HW4k4RcozS1tDuXHO3Nd+Y8=";
    #       })
    #     ];
    # }))
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
    kdePackages.neochat
    pwvucontrol
    heroic
    lutris
    dotacat
    inputs.agenix.packages.${system}.default
    # inputs.diniamo.legacyPackages.${pkgs.system}.umu-launcher
    # (inputs.umu.packages.${pkgs.system}.umu.override {version = "${inputs.umu.shortRev}";})
    umu-launcher
    teams-for-linux
    wlsunset
    batsignal
    ripgrep
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
    stremio
    fd
    killall
    zathura
    papers
    yad
    # darktable
    nextcloud-client
    # planify
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
    # hyprland = {
    #   enable = true;
    #   package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    #   portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    # };
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
