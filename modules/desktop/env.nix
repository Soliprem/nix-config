{
  flake.modules.nixos.desktop-shell = {lib, ...}: {
    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";
      variables = {
        BROWSER = "zen-beta";
        DXVK_HDR = 1;
        TERMINAL = "foot";
        XKB_DEFAULT_OPTIONS = "grp:alt_space_toggle";
        XKD_DEFAULT_LAYOUT = "eu";
        XINITRC = "$HOME/.config/x11/xinitrc";
        GTK2_RC_FILES = "$HOME/.config/gtk-2.0/gtkrc-2.0";
        WINEPREFIX = "$HOME/.local/share/wineprefixes/default";
        KODI_DATA = "$HOME/.local/share/kodi";
        SUDO_ASKPASS = "$HOME/.local/bin/dmenupass";
        QT_QPA_PLATFORM = "wayland";
        MOZ_USE_XINPUT2 = "1";
        AWT_TOOLKIT = "MToolkit wmname LG3D";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };
      shellAliases = {
        river = "XKB_DEFAULT_LAYOUT=eu river";
        aoe2rg = "cd .steam/steam/steamapps/compatdata/813780/pfx/drive_c/users/steamuser/Games/Age\\ of\\ Empires\\ 2\\ DE/76561199050658286/savegame";
        YT = "youtube-viewer";
        z = "zathura";
        startx = "startx $XINITRC";
        sl = "sll";
      };
    };
    hjem.users.soliprem.files.".config/nushell/config.nu".text = lib.mkAfter ''
      alias sl = sll
      alias z = zathura
      alias YT = youtube-viewer
    '';
  };
}
