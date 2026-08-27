{
  ags,
  astal,
  bash,
  bluez,
  brightnessctl,
  coreutils,
  curl,
  findutils,
  foot,
  gawk,
  gnugrep,
  gnused,
  grim,
  hyprland,
  hyprlock,
  imagemagick,
  iproute2,
  jq,
  kdePackages,
  lib,
  libnotify,
  makeWrapper,
  networkmanager,
  nh,
  nix,
  pciutils,
  pipewire,
  playerctl,
  power-profiles-daemon,
  procps,
  pulseaudio,
  quickshell,
  rofi,
  runCommand,
  socat,
  sox,
  src,
  systemd,
  upower,
  util-linux,
  wireplumber,
  wirelesstools,
  wl-clipboard,
  writeShellApplication,
  xdg-utils,
}: let
  version = "unstable-2026-08-26";

  cyberarchRebuild = writeShellApplication {
    name = "cyberarch-rebuild";
    runtimeInputs = [coreutils gnused nh socat];
    text = ''
      nh os switch "$@"

      generation="$(readlink /nix/var/nix/profiles/system | sed -n 's/^system-\([0-9][0-9]*\)-link$/\1/p')"
      message="pkg-installed SYSTEM REBUILT!|NIXOS GENERATION ''${generation:-ACTIVE}"
      printf '%s' "$message" | socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/astal/cyberpunk.sock" >/dev/null 2>&1 || true
    '';
  };

  nixUpdate = writeShellApplication {
    name = "cyberarch-update";
    runtimeInputs = [foot];
    text = ''
      if [ "''${1:-check}" = upgrade ]; then
        exec foot ${cyberarchRebuild}/bin/cyberarch-rebuild --update
      fi
      printf '0\n'
    '';
  };

  # Package the shell, lock screen, and application theme without pulling in
  # the upstream installer, previews, terminals, or Hyprland plugin.
  shellSource = runCommand "cyberarch-shell-source-${version}" {} ''
    mkdir -p "$out/assets" "$out/components" "$out/scripts"
    cp -r "${src}/assets/audio" "${src}/assets/cursor" "${src}/assets/fonts" \
      "${src}/assets/gtk" "${src}/assets/icons" "${src}/assets/img" "$out/assets/"
    cp -r "${src}/components/login" "${src}/components/modules" \
      "${src}/components/style" "$out/components/"
    cp "${src}/config/city.json" "${src}/core.ts" "${src}/env.ts" "${src}/theme.lua" \
      "${src}/components/modules/widget.ts" "$out/"
    cp "${src}/scripts/appvol-keeper" "${src}/scripts/screenrecord" "$out/scripts/"
    cp "${nixUpdate}/bin/cyberarch-update" "$out/scripts/aur"

    # Upstream ships one cursor backup link with no target and makes several
    # icons depend on a host /usr path. Keep the intended icon locally so the
    # packaged themes are self-contained.
    chmod -R u+w "$out/assets/cursor" "$out/assets/gtk"
    rm "$out/assets/cursor/cursors/.pulse-backup/pointer"
    rm "$out/assets/gtk/iconpack/places/22/folder-html.svg"
    cp "$out/assets/gtk/iconpack/mimetypes/22/text-html.svg" \
      "$out/assets/gtk/iconpack/places/22/folder-html.svg"

    substituteInPlace "$out/components/login/lock_shell.qml" \
      --replace-fail 'PamContext {' 'PamContext {
        config: "cyberarch-lock"'
    substituteInPlace "$out/components/login/themes/netwatch/Main.qml" \
      --replace-fail 'import QtGraphicalEffects' 'import Qt5Compat.GraphicalEffects' \
      --replace-fail 'cat ~/.config/hypr/themes/cyberpunk/config/city.json 2>/dev/null' \
        'cat \"$CYBERARCH_STATE_DIR/city.json\" 2>/dev/null'
  '';

  cyberarchLock = writeShellApplication {
    name = "cyberarch-lock";
    runtimeInputs = [coreutils curl hyprland quickshell systemd util-linux];
    text = ''
      lock_file="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/cyberarch-lock.lock"
      exec 9>"$lock_file"
      flock -n 9 || exit 0

      export CYBERARCH_STATE_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/cyberarch"
      export QS_THEME=netwatch
      export QS_THEME_PATH="${shellSource}/components/login/themes/netwatch"
      export QT_MEDIA_BACKEND=ffmpeg
      export NIXPKGS_QT6_QML_IMPORT_PATH="${kdePackages.qt5compat}/lib/qt-6/qml:${kdePackages.qtmultimedia}/lib/qt-6/qml''${NIXPKGS_QT6_QML_IMPORT_PATH:+:$NIXPKGS_QT6_QML_IMPORT_PATH}"
      export QT_PLUGIN_PATH="${kdePackages.qtmultimedia}/lib/qt-6/plugins''${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"

      if [ "''${1:-}" = "--test" ]; then
        export QS_TESTING=1 XDG_SESSION_TYPE=x11 QT_QPA_PLATFORM=offscreen
        shift
      else
        export XDG_SESSION_TYPE=wayland
      fi

      exec quickshell --path "${shellSource}/components/login/lock_shell.qml" "$@"
    '';
  };

  runtimePath = lib.makeBinPath [
    bash
    bluez
    brightnessctl
    coreutils
    curl
    findutils
    foot
    gawk
    gnugrep
    gnused
    grim
    hyprland
    hyprlock
    imagemagick
    iproute2
    jq
    libnotify
    networkmanager
    nh
    nix
    pciutils
    pipewire
    playerctl
    power-profiles-daemon
    procps
    pulseaudio
    rofi
    socat
    sox
    systemd
    upower
    util-linux
    wireplumber
    wirelesstools
    wl-clipboard
    xdg-utils
  ];
in
  ags.bundle {
    pname = "cyberarch-shell";
    inherit version;
    src = shellSource;
    entry = "core.ts";

    dependencies = [
      astal.mpris
      astal.notifd
      astal.wireplumber
    ];

    patches = [./cyberarch-shell.patch];
    nativeBuildInputs = [makeWrapper];

    preFixup = ''
      gappsWrapperArgs+=(--prefix PATH : "${runtimePath}")
    '';

    postFixup = ''
      ln -s ${cyberarchRebuild}/bin/cyberarch-rebuild "$out/bin/cyberarch-rebuild"
      ln -s ${cyberarchLock}/bin/cyberarch-lock "$out/bin/cyberarch-lock"
      mkdir -p "$out/share/icons" "$out/share/Kvantum"
      ln -s ../assets/gtk/iconpack "$out/share/icons/CyberArch"
      ln -s ../assets/cursor "$out/share/icons/CyberArch-cursors"
      ln -s ../assets/gtk/DaemonKvantum "$out/share/Kvantum/Daemon"
      mkdir -p "$out/share/fonts/truetype/cyberarch"
      for font in "$out"/share/assets/fonts/*; do
        ln -s "../../../assets/fonts/$(basename "$font")" \
          "$out/share/fonts/truetype/cyberarch/$(basename "$font")"
      done
    '';

    meta = {
      description = "NixOS-packaged CyberArch AGS shell";
      homepage = "https://github.com/arcangel0/cyberarch-dotfiles";
      # Upstream currently has no repository-level license declaration.
      license = lib.licenses.unfree;
      mainProgram = "cyberarch-shell";
      platforms = lib.platforms.linux;
    };
  }
