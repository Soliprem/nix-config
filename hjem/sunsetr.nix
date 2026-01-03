_: {
  files = {
    ".config/sunsetr/config.toml".text = /* toml */ ''
      temp_day = 6500
      temp_night = 3500

      # Only needed if timezone-based detection is insufficient
      # [location]
      # latitude = 45.0
      # longitude = 9.0
    '';
  };
}
