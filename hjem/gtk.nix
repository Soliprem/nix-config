{
  fontProfiles,
  inputs,
  pkgs,
  ...
}: let
  cyberarchShell = inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.cyberarch-shell;
  materialSettings = pkgs.writeText "gtk-material.ini" ''
    [Settings]
    gtk-cursor-theme-name=Bibata-Modern-Ice
    gtk-cursor-theme-size=24
    gtk-font-name=${fontProfiles.ui} 12
    gtk-icon-theme-name=breeze-dark
    gtk-theme-name=adw-gtk3
  '';
  cyberpunkSettings = pkgs.writeText "gtk-cyberpunk.ini" ''
    [Settings]
    gtk-cursor-theme-name=CyberArch-cursors
    gtk-cursor-theme-size=48
    gtk-font-name=${fontProfiles.ui} 12
    gtk-icon-theme-name=CyberArch
    gtk-theme-name=adw-gtk3
    gtk-application-prefer-dark-theme=1
  '';
  materialCss = pkgs.writeText "gtk-material.css" "";
in {
  files = {
    ".config/gtk-3.0/settings.ini".source = materialSettings;
    ".config/gtk-3.0/gtk.css".text = ''
      @import 'colors.css';
      @import 'rice.css';
    '';
    ".config/gtk-3.0/rice.css".source = materialCss;
    ".config/gtk-4.0/settings.ini".source = materialSettings;
    ".config/gtk-4.0/gtk.css".text = ''
      @import 'colors.css';
      @import 'rice.css';
    '';
    ".config/gtk-4.0/rice.css".source = materialCss;

    ".config/nixrice/themes/material/gtk-settings.ini".source = materialSettings;
    ".config/nixrice/themes/material/gtk.css".source = materialCss;
    ".config/nixrice/themes/cyberpunk/gtk-settings.ini".source = cyberpunkSettings;
    ".config/nixrice/themes/cyberpunk/gtk.css".source = "${cyberarchShell}/share/assets/gtk/gtk.css";
    ".config/nixrice/themes/cyberpunk/kvantum.kvconfig".text = ''
      [General]
      theme=NixRiceCyberArch
    '';
    ".config/Kvantum/NixRiceCyberArch/NixRiceCyberArch.kvconfig".source = "${cyberarchShell}/share/Kvantum/Daemon/Daemon.kvconfig";
    ".config/Kvantum/NixRiceCyberArch/NixRiceCyberArch.svg".source = "${cyberarchShell}/share/Kvantum/Daemon/Daemon.svg";
  };
}
