{
  pkgs,
  src,
}: let
  version = "unstable-2026-09-02";
  python = pkgs.python3.withPackages (ps: [ps.numpy ps.pillow ps.pygobject3]);
  recorder = pkgs.wf-recorder.override {ffmpeg = pkgs.ffmpeg_8;};

  cyberarchRebuild = pkgs.writeShellApplication {
    name = "cyberarch-rebuild";
    runtimeInputs = with pkgs; [coreutils gnused nh socat];
    text = ''
      nh os switch "$@"

      generation="$(readlink /nix/var/nix/profiles/system | sed -n 's/^system-\([0-9][0-9]*\)-link$/\1/p')"
      message="pkg-installed SYSTEM REBUILT!|NIXOS GENERATION ''${generation:-ACTIVE}"
      printf '%s' "$message" | socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/astal/cyberpunk.sock" >/dev/null 2>&1 || true
    '';
  };

  # Package the shell, lock screen, and application theme without pulling in
  # the upstream installer, previews, terminals, or Hyprland plugin.
  shellSource = pkgs.runCommand "cyberarch-shell-source-${version}" {nativeBuildInputs = [pkgs.sassc];} ''
    mkdir -p "$out/assets" "$out/components" "$out/scripts"
    cp -r "${src}/assets/audio" "${src}/assets/cursor" "${src}/assets/fonts" \
      "${src}/assets/gtk" "${src}/assets/icons" "${src}/assets/img" "$out/assets/"
    cp -r "${src}/components/login" "${src}/components/modules" \
      "${src}/components/style" "$out/components/"
    cp "${src}/core.ts" "${src}/env.ts" "${src}/theme.lua" \
      "${src}/components/modules/widget.ts" "$out/"
    cp "${src}/scripts/appvol-keeper" "${src}/scripts/gen-map.py" \
      "${src}/scripts/screenrecord" "$out/scripts/"

    # The installed source is immutable, so compile the stylesheet now and
    # load it directly instead of letting upstream write beside it at runtime.
    chmod -R u+w "$out/components/style"
    chmod u+w "$out/core.ts"
    sassc "$out/components/style/cyber.scss" "$out/components/style/cyber.css"
    substituteInPlace "$out/core.ts" \
      --replace-fail ' compileCss()' ' App.apply_css(CSS, true)'

    # Upstream ships one cursor backup link with no target and makes several
    # icons depend on a host /usr path. Keep the intended icon locally so the
    # packaged themes are self-contained.
    chmod -R u+w "$out/assets/cursor" "$out/assets/gtk"
    rm "$out/assets/cursor/cursors/.pulse-backup/pointer"
    rm "$out/assets/gtk/iconpack/places/22/folder-html.svg"
    cp "$out/assets/gtk/iconpack/mimetypes/22/text-html.svg" \
      "$out/assets/gtk/iconpack/places/22/folder-html.svg"
  '';

  cyberarchLock = pkgs.writeShellApplication {
    name = "cyberarch-lock";
    runtimeInputs = with pkgs; [coreutils curl hyprland quickshell systemd util-linux gtk-layer-shell];
    text = ''
      lock_file="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/cyberarch-lock.lock"
      exec 9>"$lock_file"
      flock -n 9 || exit 0

      export CYBERARCH_CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/cyberarch"
      export QS_PAM_CONFIG=cyberarch-lock
      export QS_THEME=netwatch
      export QS_THEME_PATH="${shellSource}/components/login/themes/netwatch"
      export QT_MEDIA_BACKEND=ffmpeg
      export NIXPKGS_QT6_QML_IMPORT_PATH="${pkgs.kdePackages.qt5compat}/lib/qt-6/qml:${pkgs.kdePackages.qtmultimedia}/lib/qt-6/qml''${NIXPKGS_QT6_QML_IMPORT_PATH:+:$NIXPKGS_QT6_QML_IMPORT_PATH}"
      export QT_PLUGIN_PATH="${pkgs.kdePackages.qtmultimedia}/lib/qt-6/plugins''${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"

      if [ "''${1:-}" = "--test" ]; then
        export QS_TESTING=1 XDG_SESSION_TYPE=x11 QT_QPA_PLATFORM=offscreen
        shift
      else
        export XDG_SESSION_TYPE=wayland
      fi

      exec quickshell --path "${shellSource}/components/login/lock_shell.qml" "$@"
    '';
  };

  runtimePath = with pkgs;
    lib.makeBinPath [
      bash
      bluez
      brightnessctl
      coreutils
      curl
      findutils
      gawk
      gnugrep
      gnused
      grim
      hyprland
      imagemagick
      iproute2
      jq
      libnotify
      networkmanager
      pciutils
      pipewire
      playerctl
      power-profiles-daemon
      procps
      python
      pulseaudio
      rofi
      socat
      sox
      systemd
      upower
      util-linux
      wireplumber
      wirelesstools
      recorder
      wl-clipboard
      xdg-utils
    ];
in
  pkgs.ags.bundle {
    pname = "cyberarch-shell";
    inherit version;
    src = shellSource;
    entry = "core.ts";

    dependencies = with pkgs.astal; [
      mpris
      notifd
      wireplumber
    ];

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
      license = pkgs.lib.licenses.unfree;
      mainProgram = "cyberarch-shell";
      platforms = pkgs.lib.platforms.linux;
    };
  }
