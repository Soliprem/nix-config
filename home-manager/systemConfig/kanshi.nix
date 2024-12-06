_: {
  # Common configuration for both laptop and PC
  services.kanshi = {
    enable = true;
    
    profiles = {
      # Laptop profiles
      laptopOnly = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1080";  # Adjust to your laptop's native resolution
            position = "0,0";
            scale = 1.0;
          }
        ];
      };

      laptopWithExternal = {
        outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1080";  # Adjust to your laptop's native resolution
            position = "0,0";
            scale = 1.0;
          }
          {
            criteria = {
              Serial = "0x01010101";  # Epson projector serial
              Manufacturer = "Seiko Epson Corporation";
              Model = "EPSON PJ";
            };
            mode = "3840x2160";  # 4K resolution
            position = "1920,0";  # Positioned right of laptop screen
            scale = 1.0;  # Adjust if needed for comfortable 4K viewing
          }
        ];
      };

      # Desktop PC profile
      desktopPC = {
        outputs = [
          {
            criteria = "HDMI-A-1";
            mode = "1920x1080";
            position = "0,0";
            scale = 1.0;
          }
        ];
      };
    };
  };
}
