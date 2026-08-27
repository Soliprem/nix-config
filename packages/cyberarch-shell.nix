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
      socket="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/astal/cyberpunk.sock"
      if [ -S "$socket" ]; then
        printf '%s' "$message" | socat - "UNIX-CONNECT:$socket" >/dev/null 2>&1 || true
      fi
    '';
  };

  nixUpdate = writeShellApplication {
    name = "cyberarch-update";
    runtimeInputs = [foot];
    text = ''
      case "''${1:-check}" in
        check)
          # Avoid an implicit network request every time the HUD starts. Nix
          # updates happen explicitly through the rebuild action below.
          printf '0\n'
          ;;
        upgrade)
          exec foot ${cyberarchRebuild}/bin/cyberarch-rebuild --update
          ;;
        *)
          printf 'usage: %s [check|upgrade]\n' "$0" >&2
          exit 2
          ;;
      esac
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
    cp "${src}/city.json" "${src}/core.ts" "${src}/env.ts" "${src}/theme.lua" "${src}/widget.ts" "$out/"
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
      --replace-fail 'cat ~/.config/hypr/themes/cyberpunk/city.json 2>/dev/null' \
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

    nativeBuildInputs = [makeWrapper];

    postPatch = ''
            substituteInPlace env.ts \
              --replace-fail 'export const CYBER_DIR = `''${HOME}/.config/hypr/themes/cyberpunk`' \
                'export const CYBER_DIR = SRC
      export const STATE_DIR = `''${GLib.get_user_state_dir()}/cyberarch`
      GLib.mkdir_with_parents(STATE_DIR, 0o755)'

            substituteInPlace core.ts \
              --replace-fail ' compileCss()' ' App.apply_css(CSS, true)' \
              --replace-fail 'NotifPopupWindow, notifReadCurrent, notifDismiss' \
                'NotifPopupWindow, notifExpandCurrent, notifDismiss' \
              --replace-fail 'request === "notif-read"' \
                'request === "notif-expand" || request === "notif-read"' \
              --replace-fail 'notifReadCurrent()' 'notifExpandCurrent()'

            substituteInPlace components/modules/notifmessages.ts \
              --replace-fail 'export const isNotifHudOpen = () => hudVisible' \
                'export const openNotifDetail = (app: string) => { if (!app || !msgs.some(m => m.app === app)) return false; selectedApp = app; view = "detail"; scrollOffset = 0; hoverRow = -1; menuState = null; if (!hudVisible) { hudVisible = true; panelIntro = 0; animProg = 0 }; win.visible = true; applyInput(); kick(); nFire(); return true }
      export const isNotifHudOpen = () => hudVisible'

            substituteInPlace components/modules/notifpopup.ts \
              --replace-fail 'setReadFilter, removeFromHistory' \
                'setReadFilter, removeFromHistory, openNotifDetail' \
              --replace-fail '"READ MESSAGE"' '"EXPAND"' \
              --replace-fail 'export const notifReadCurrent = () => {
    const m = msgs[0]; if (!m || m.out) return
    m.read = true; _readIds.add(m.id)
    removeFromHistory(m.id); dockNotifDecr()
    try {
        const n = notifd?.get_notification?.(m.id)
        if (n) {
            let ids: any[] = []
            try { ids = (n.get_actions?.() ?? n.actions ?? []).map((a: any) => a?.id ?? a) } catch { }
            const act = ids.includes("default") ? "default" : ids[0]
            if (act) n.invoke?.(act); else n.dismiss?.()
        }
    } catch (e) { print("[cyber] notifRead:", e) }
    focusApp(m.appRaw, m.desktopEntry)
    removeMsg(m)
}' \
                'export const notifExpandCurrent = () => {
    const m = msgs[0]; if (!m || m.out) return
    if (openNotifDetail(m.app)) removeMsg(m)
}'

            substituteInPlace components/modules/sidepanel.ts \
              --replace-fail 'import { CYBER_DIR } from "../../env.ts"' \
                'import { CYBER_DIR, STATE_DIR } from "../../env.ts"' \
              --replace-fail 'const WX_STORE = `''${CYBER_DIR}/city.json`' \
                'const WX_STORE = `''${STATE_DIR}/city.json`'

            substituteInPlace components/modules/markets.ts \
              --replace-fail 'import { CYBER_DIR } from "../../env.ts"' \
                'import { CYBER_DIR, STATE_DIR } from "../../env.ts"' \
              --replace-fail 'const STORE = `''${CYBER_DIR}/markets.json`' \
                'const STORE = `''${STATE_DIR}/markets.json`' \
              --replace-fail 'GLib.file_get_contents(`''${CYBER_DIR}/city.json`)' \
                'GLib.file_get_contents(`''${STATE_DIR}/city.json`)'

            substituteInPlace components/modules/cmodal.ts \
              --replace-fail 'pacman -Q 2>/dev/null | wc -l' \
                'nix-store --query --requisites /run/current-system 2>/dev/null | wc -l' \
              --replace-fail '// QUERYING MIRRORS + AUR …' '// CHECKING NIXOS STATE …' \
              --replace-fail 'ctx.showText("SYSTEM UP TO DATE")' 'ctx.showText("NIXOS READY")' \
              --replace-fail '// no pending package updates' '// rebuild from the current flake state' \
              --replace-fail '"CLOSE", () => ctrl.close(), false, g.col)' \
                '"REBUILD", () => { startUpgrade(); ctrl.close() }, true, GRN)' \
              --replace-fail '"LOCK", "loginctl lock-session"' \
                '"LOCK", "rice-lock"'

            substituteInPlace components/modules/appsmenu.ts \
              --replace-fail 'try { menuWin.keymode = cfg.keymode ?? Keymode.ON_DEMAND } catch {}' \
                'try { menuWin.keymode = cfg.keymode ?? Keymode.EXCLUSIVE } catch {}' \
              --replace-fail 'const buildAppEntries = () => loadApps().map((a) => ({ label: a.get_name() || "", badge: "READY", icon: null, glyph: null, data: a }))' \
                'const launchApp = (app) => { const ctx = Gdk.Display.get_default()?.get_app_launch_context?.() ?? null; try { if (app.launch([], ctx)) return true } catch (e) { print("[apps] launch:", e) } try { const cmd = app.get_commandline?.(); if (!cmd) return false; const fallback = Gio.AppInfo.create_from_commandline(cmd, app.get_name() || "", Gio.AppInfoCreateFlags.SUPPORTS_STARTUP_NOTIFICATION); return fallback.launch([], ctx) } catch (e) { print("[apps] fallback:", e); return false } }
      const buildAppEntries = () => loadApps().map((a) => ({ label: a.get_name() || "", badge: "READY", icon: null, glyph: null, data: a }))' \
              --replace-fail 'openWheel({ title: "APPS", subtitle: "// CYBERDECK.OS — RUNNING", footer: FOOTER_APPS, searchable: true, onActivate: (a) => { try { a.launch([], null) } catch (e) { print("[apps] launch:", e) } closeWheel() }, onSecondary: null, onReset: null, emptyText: "// NO APPS" }, buildAppEntries())' \
                'openWheel({ title: "APPS", subtitle: "// CYBERDECK.OS — RUNNING", footer: FOOTER_APPS, searchable: true, onActivate: (a) => { if (launchApp(a)) closeWheel() }, onSecondary: null, onReset: null, emptyText: "// NO APPS" }, buildAppEntries())' \
              --replace-fail 'const r = rowAtY(mouseY)' \
                'let clickY = mouseY; try { const c = e.get_coords?.(); if (c && c.length >= 3) clickY = c[2] } catch {}; const r = rowAtY(clickY)' \
              --replace-fail 'layer: Layer.TOP, exclusivity: Exclusivity.IGNORE, keymode: Keymode.ON_DEMAND,' \
                'layer: Layer.TOP, exclusivity: Exclusivity.IGNORE, keymode: Keymode.EXCLUSIVE,'
    '';

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
