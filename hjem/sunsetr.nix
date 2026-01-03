_: {
  files = {
    ".config/sunsetr/sunsetr.toml".text = /* toml */ '''';
    ".config/sunsetr/presets/day/sunsetr.toml".text = /* toml */ ''
      #[Backend]
      backend = "auto"
      transition_mode = "static" # No time-based transitions

      #[Smoothing]
      smoothing = true
      startup_duration = 0.5     # Quick fade-in
      shutdown_duration = 0.5    # Instant shutdown
      adaptive_interval = 1

      #[Static configuration]
      static_temp = 6500         # Neutral daylight
      static_gamma = 100         # Full brightness
    '';
    ".config/sunsetr/presets/gaming/sunsetr.toml".text = /* toml */ ''
      #[Backend]
      backend = "auto"
      transition_mode = "static"

      #[Smoothing]
      smoothing = true
      startup_duration = 0.5
      shutdown_duration = 0.5
      adaptive_interval = 1

      #[Static configuration]
      static_temp = 6500           # Accurate colors
      static_gamma = 115           # Slightly boosted brightness

    '';
    ".config/sunsetr/presets/reading/sunsetr.toml".text = /* toml */ ''
      #[Backend]
      backend = "auto"
      transition_mode = "static"

      #[Smoothing]
      smoothing = true
      startup_duration = 0.5       # Slow transition
      shutdown_duration = 0.5
      adaptive_interval = 1

      #[Static configuration]
      static_temp = 2333           # Very warm
      static_gamma = 75            # Quite dim
    '';
    ".config/sunsetr/presets/no-blue/sunsetr.toml".text = /* toml */ ''
      #[Backend]
      backend = "auto"
      transition_mode = "static"

      #[Smoothing]
      smoothing = true
      startup_duration = 0.5
      shutdown_duration = 0.5
      adaptive_interval = 1

      #[Static configuration]
      static_temp = 1000           # Extreme warmth
      static_gamma = 70            # Reduced brightness
    '';
  };
}
