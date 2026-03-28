{
  inputs,
  pkgs,
  ...
}:
let
  unstable-pkgs = inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  environment.systemPackages = with pkgs; [
    # Flake inputs and custom derivations
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.ekphos.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nvf
    inputs.subtui.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.thumbpick.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    unstable-pkgs.codex
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

      makeFlags = [ "PREFIX=${placeholder "out"}" ];

      preBuild = ''
        substituteInPlace src/main.cpp --replace-fail "/usr" $out
      '';
      postInstall = ''
        patchelf --add-needed libsysboard.so $out/bin/sysboard
      '';
    })
    (pkgs.stdenvNoCC.mkDerivation rec {
      pname = "commet";
      version = "0.4.1";

      src = inputs.commet;

      nativeBuildInputs = with pkgs; [
        autoPatchelfHook
        copyDesktopItems
        makeWrapper
        wrapGAppsHook3
      ];

      buildInputs = with pkgs; [
        gtk3
        keybinder3
        mpv-unwrapped
        stdenv.cc.cc.lib
        webkitgtk_4_1
      ];

      dontWrapGApps = true;

      desktopItems = [
        (makeDesktopItem {
          name = "commet";
          exec = "commet";
          icon = "commet";
          desktopName = "Commet";
          genericName = "Matrix client";
          categories = [
            "Network"
            "InstantMessaging"
            "Chat"
          ];
        })
      ];

      installPhase = ''
        runHook preInstall

        mkdir -p $out/bin $out/libexec/commet $out/share/icons/hicolor/512x512/apps
        cp -r ${src}/. $out/libexec/commet
        makeWrapper $out/libexec/commet/commet $out/bin/commet \
          --prefix LD_LIBRARY_PATH : $out/libexec/commet/lib
        install -Dm0644 \
          ${src}/data/flutter_assets/assets/images/app_icon/app_icon_filled.png \
          $out/share/icons/hicolor/512x512/apps/commet.png

        runHook postInstall
      '';

      meta = with pkgs.lib; {
        description = "Feature-rich Matrix client";
        homepage = "https://commet.chat/";
        mainProgram = "commet";
        license = licenses.agpl3Plus;
        platforms = platforms.linux;
      };
    })

    # CLI, shells, and core tools
    atuin
    bat
    btop-rocm
    carapace
    comma
    cowsay
    eza
    fastfetch
    fd
    fortune
    fzf
    git
    gdb
    highlight
    jq
    killall
    lazygit
    nix-output-monitor
    nix-your-shell
    nushell
    openvpn
    ripgrep
    scarab
    socat
    starship
    tealdeer
    termdown
    timer
    tree-sitter-grammars.tree-sitter-typst
    udict
    wget
    wiki-tui
    youtube-tui
    zoxide

    # Editors, development, and authoring
    code-cursor
    emacs
    helix
    impression
    jujutsu
    libgccjit
    litemdview
    openai-whisper
    typst
    tinymist
    zed-editor

    # Wayland, theming, and desktop utilities
    adw-gtk3
    bibata-cursors
    brightnessctl
    cliphist
    darkly
    darkly-qt5
    fuzzel
    gammastep
    ghostty
    glib
    hyprshot
    iio-hyprland
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
    swaynotificationcenter
    swayosd
    swww
    tofi
    tray-tui
    wayneko
    wl-clipboard
    wlogout
    wtype
    xwayland-satellite

    # Browsers, communication, and network clients
    beeper
    bitwarden-desktop
    bitwarden-cli
    chromium
    element-desktop
    fluffychat
    grayjay
    gtk-pipe-viewer
    iamb
    legcord
    nextcloud-client
    omnissa-horizon-client
    qutebrowser
    teams-for-linux
    telegram-desktop
    thunderbird
    tor-browser
    transmission_4-gtk
    youtube-music

    # General desktop applications
    anki-bin
    appimage-run
    blanket
    bottles
    calibre
    darktable
    foot
    gale
    gcs
    godot_4
    gowall
    gretl
    imv
    inkscape
    keyutils
    loupe
    lumafly
    lutgen-studio
    maptool
    mediawriter
    meow
    nautilus
    obsidian
    papers
    protonvpn-gui
    super-productivity
    yad
    zathura
    zotero

    # Audio, video, and creative tools
    alsa-utils
    audacity
    ffmpeg
    gimp
    kew
    kdePackages.qtmultimedia
    libnotify
    mpv
    muse-sounds-manager
    musescore
    pamixer
    pipewire
    pwvucontrol
    qpwgraph
    spek
    spotdl
    spotify
    tauon
    wiremix

    # Gaming
    beyond-all-reason
    gamemode
    heroic
    linux-wallpaperengine
    lutris
    mangohud
    prismlauncher
    protonplus
    protontricks
    umu-launcher

    # Miscellaneous apps and helpers
    # cozy
    # gapless
    aonsoku
    bluetui
    ddcui
    ddcutil
    distrobox
    distrobox-tui
    dotacat
    limo
    nicotine-plus
    obs-studio
    ostui
    sunsetr
    tuifeed
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
    television.enable = true;
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
