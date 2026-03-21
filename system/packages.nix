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
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.nvf
    inputs.thumbpick.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.subtui.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.ekphos.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    fluffychat
    nheko
    gowall
    zotero
    grayjay
    linux-wallpaperengine
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
    wlogout
    gnome-feeds
    tray-tui
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
    mediawriter
    wl-clipboard
    aonsoku
    tauon
    spek
    nicotine-plus
    openvpn
    spotify
    emacs
    bottles
    nwg-drawer
    swaynotificationcenter
    xwayland-satellite
    comma
    inkscape
    anki-bin
    kew
    spotdl
    audacity
    # cozy
    # gapless
    gcs
    code-cursor
    jujutsu
    calibre
    qutebrowser
    maptool
    anytype
    zed-editor
    kdePackages.qtmultimedia
    kdePackages.polkit-kde-agent-1
    libsForQt5.qt5.qtgraphicaleffects
    affine
    gale
    protonvpn-gui
    ffmpeg
    chromium
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
    microfetch
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
    mangohud
    ghostty
    foot
    bitwarden-desktop
    showtime
    keyutils
    iamb
    revolt-desktop
    swww
    muse-sounds-manager
    pwvucontrol
    heroic
    lutris
    dotacat
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    umu-launcher
    teams-for-linux
    sunsetr
    ripgrep
    android-tools
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
    beeper
    bat
    gamemode
    wtype
    udict
    fzf
    prismlauncher
    protonplus
    telegram-desktop
    qpwgraph
    brightnessctl
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
    pamixer
    jay
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
