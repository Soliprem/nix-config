{pkgs, ...}: {
  environment.systemPackages =
    (with pkgs; [awww swayosd])
    ++ [
      (pkgs.writeShellApplication {
        name = "rice-theme";
        runtimeInputs = with pkgs; [coreutils glib gsettings-desktop-schemas hyprland systemd];
        runtimeEnv.NIXRICE_GSETTINGS_SCHEMA_PATH = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}";
        text = builtins.readFile ../../../scripts/rice-theme.sh;
      })
    ];
  services.udev.packages = [pkgs.swayosd];
  systemd.packages = [pkgs.swayosd];
  systemd.services.swayosd-libinput-backend.wantedBy = ["graphical.target"];
  systemd.user.services = {
    swayosd = {
      description = "SwayOSD server";
      enableDefaultPath = false;
      serviceConfig.ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
    };
    awww = {
      description = "Wallpaper daemon";
      enableDefaultPath = false;
      serviceConfig.ExecStart = "${pkgs.awww}/bin/awww-daemon";
    };
    hypridle = {
      description = "Hyprland idle management";
      unitConfig.ConditionEnvironment = "HYPRLAND_INSTANCE_SIGNATURE";
      enableDefaultPath = false;
      serviceConfig.ExecStart = "${pkgs.hypridle}/bin/hypridle";
    };
  };
}
