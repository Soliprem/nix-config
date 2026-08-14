{
  inputs,
  pkgs,
  ...
}: let
  sys = pkgs.stdenv.hostPlatform.system;
  stremioFixed = pkgs.stremio-linux-shell.overrideAttrs (old: {
    nativeBuildInputs =
      (old.nativeBuildInputs or [])
      ++ [
        pkgs.makeWrapper
      ];

    postFixup =
      (old.postFixup or "")
      + ''
        mv $out/bin/stremio $out/bin/stremio-unwrapped

        makeWrapper ${pkgs.strace}/bin/strace $out/bin/stremio \
          --add-flags "-f" \
          --add-flags "-qq" \
          --add-flags "-o" \
          --add-flags "/dev/null" \
          --add-flags "-e" \
          --add-flags "trace=none" \
          --add-flags "$out/bin/stremio-unwrapped"
      '';
  });
  sableSrc = inputs.sable-nightly;
  sableVersion = (builtins.fromJSON (builtins.readFile "${sableSrc}/package.json")).version;
  sableFrontend = pkgs.stdenvNoCC.mkDerivation {
    pname = "sable-frontend";
    version = sableVersion;
    src = sableSrc;
    NODE_OPTIONS = "--max-old-space-size=4096";

    pnpmDeps = pkgs.fetchPnpmDeps {
      pname = "sable";
      version = sableVersion;
      src = sableSrc;
      pnpm = pkgs.pnpm_10;
      fetcherVersion = 3;
      hash = "sha256-1siT4fB6ty2azmWXe5L40EFUdk0th59qIdARUB0cVOc=";
    };

    pnpmInstallFlags = ["--ignore-scripts"];
    nativeBuildInputs = [
      pkgs.git
      pkgs.nodejs_24
      pkgs.pnpm_10
      (pkgs.pnpmConfigHook.override {pnpm = pkgs.pnpm_10;})
    ];

    buildPhase = "pnpm build";
    installPhase = "cp -r dist $out";
  };
  sable-desktop = pkgs.rustPlatform.buildRustPackage {
    pname = "sable";
    version = "${sableVersion}-nightly";
    src = sableSrc;

    cargoRoot = "src-tauri";
    cargoHash = "sha256-GO1hm/4SNqU4OQW5UeZzLZS2J4TMVu1O9SkUGBJ3S8o=";

    postPatch = ''
      ${pkgs.lib.getExe pkgs.jq} \
        '.build.frontendDist = "${sableFrontend}" | del(.build.beforeBuildCommand) | .bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json \
        | ${pkgs.lib.getExe' pkgs.moreutils "sponge"} src-tauri/tauri.conf.json
    '';

    nativeBuildInputs = [
      pkgs.cargo-tauri.hook
      pkgs.dpkg
      pkgs.pkg-config
      pkgs.wrapGAppsHook3
    ];

    buildInputs = [
      pkgs.dbus
      pkgs.glib-networking
      pkgs.libayatana-appindicator
      pkgs.openssl
      pkgs.webkitgtk_4_1
    ];

    buildFeatures = [
      "wry"
      "custom-protocol"
    ];
    buildNoDefaultFeatures = true;
    doCheck = false;

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix PATH : ${
        pkgs.lib.makeBinPath [
          pkgs.desktop-file-utils
          pkgs.xdg-utils
        ]
      }
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${
        pkgs.lib.makeSearchPath "lib/gstreamer-1.0" [
          pkgs.gst_all_1.gst-plugins-base
          pkgs.gst_all_1.gst-plugins-good
        ]
      }
      )
    '';

    installPhase = ''
      runHook preInstall
      dpkg-deb -x src-tauri/target/${pkgs.stdenv.hostPlatform.rust.cargoShortTarget}/release/bundle/deb/*.deb $out
      mv $out/usr/* $out/
      rmdir $out/usr
      runHook postInstall
    '';

    meta = {
      description = "Matrix client based on Cinny";
      homepage = "https://github.com/SableClient/Sable";
      license = pkgs.lib.licenses.agpl3Plus;
      mainProgram = "sable";
      platforms = ["x86_64-linux"];
    };
  };
in {
  environment.systemPackages = with pkgs; [
    # Flake inputs and custom derivations
    (runCommand "stash-symlinks" {} ''
      mkdir -p $out/bin
      for bin in stash-copy stash-paste wl-copy wl-paste; do
        ln -s ${lib.getExe stash-clipboard} $out/bin/$bin
      done
    '')
    inputs.agenix.packages.${sys}.default
    inputs.deploy-rs.packages.${sys}.default
    inputs.self.packages.${sys}.nvf
    inputs.thumbpick.packages.${sys}.default
    inputs.roam-graph.packages.${sys}.default
    inputs.zen-browser.packages.${sys}.default
    inputs.tuicr.packages.${sys}.default
    inputs.ferrosonic.packages.${sys}.default
    inputs.beer.packages.${sys}.default
    cava
    stash-clipboard
    codex
    t3code
    zk
    graphviz
    emacs
    waypipe

    # CLI, shells, and core tools
    gnupg
    xleak
    drawy
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
    pijul
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
    zoom-us
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
    qt5.qtgraphicaleffects
    libsForQt5.qt5ct
    linearicons-free
    matugen
    networkmanagerapplet
    overskride
    satty
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
    cinny-desktop
    sable-desktop
    gomuks-web
    bitwarden-desktop
    rnote
    chromium
    legcord
    nextcloud-client
    qutebrowser
    telegram-desktop
    super-productivity
    thunderbird
    himalaya
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
    stremioFixed
    losange
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
    strawberry
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
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
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
    mango = {
      enable = true;
    };
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/soliprem/.local/src/nix-config";
    };
  };
}
