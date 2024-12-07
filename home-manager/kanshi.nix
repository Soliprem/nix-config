_: {
  # Common configuration for both laptop and PC
services.kanshi = {
  enable = true;

  settings = [
    # Laptop-only profile
    {
      profile = {
        name = "laptopOnly";
        outputs = [
          {
            criteria = "eDP-1"; # Internal laptop display
            mode = "1920x1080"; # Adjust to your laptop's native resolution
            position = "0,0";
            scale = 1.0;
          }
        ];
      };
    }

    # Laptop with external display profile
    {
      profile = {
        name = "laptopWithExternal";
        outputs = [
          {
            criteria = "eDP-1"; # Internal laptop display
            mode = "1920x1080";
            position = "0,0";
            scale = 1.0;
          }
          {
            criteria = "*"; # External display (projector or monitor)
            mode = "3840x2160"; # 4K resolution
            position = "1920,0"; # Positioned to the right of the laptop screen
            scale = 1.0;
          }
        ];
      };
    }

    # Desktop PC profile
    {
      profile = {
        name = "desktopPC";
        outputs = [
          {
            criteria = "HDMI-A-1"; # First monitor
            mode = "1920x1080@120Hz";
            position = "0,0";
            scale = 1.0;
          }
          {
            criteria = "DP-3"; # Second monitor
            mode = "2560x1440@165Hz";
            position = "0,1080"; # Positioned below the first monitor
            scale = 1.0;
          }
        ];
      };
    }
  ];
};
}
