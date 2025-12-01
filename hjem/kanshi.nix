_: {
  hjem.users.soliprem.files = {
    ".config/kanshi/config".text = ''
      # Profile 1: Desk (AOC Main + HDMI Side)
      # HDMI offset 2560 implies it sits right of the AOC (2560px wide)
      profile {
          output "AOC Q27G3XMN 1APQ7JA005710" mode 2560x1440@180.002 position 0,0
          output "HDMI-A-1" mode 1920x1080@120 position 2560,0
      }

      # Profile 2: Projector Presentation
      profile {
          output "eDP-1" enable mode 1920x1200@60 position 0,0 scale 1.5
          output "Seiko Epson Corporation EPSON PJ 0x01010101" scale 1.5 position 1920,0
      }

      # Profile 3: Laptop Only (Fallback)
      profile {
          output "eDP-1" enable mode 1920x1200@60 scale 1.2
      }

      profile {
          output "eDP-1" enable mode 1920x1200@60 scale 1.2
          output "*" enable scale 1
      }
    '';
  };
}
