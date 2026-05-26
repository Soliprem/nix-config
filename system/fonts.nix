# thanks raf
{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.attrsets) mapAttrs;
  fontProfiles = rec {
    serif = "IosevkaTermSlab Nerd Font Propo";
    ui = serif;
    sans = "Iosevka Nerd Font Propo";
    mono = "IosevkaTermSlab Nerd Font Mono";
    symbols = "Symbols Nerd Font";
    emoji = "Noto Color Emoji";
  };
in {
  fonts = {
    enableDefaultPackages = false;

    fontconfig = {
      enable = true;
      hinting.enable = true;
      antialias = true;
      defaultFonts = let
        # fonts that should be in each font family
        # if applicable
        common = [
          fontProfiles.symbols
          fontProfiles.emoji
        ];
      in
        mapAttrs (_: fonts: fonts ++ common) {
          serif = [fontProfiles.serif];
          sansSerif = [fontProfiles.sans];
          emoji = [fontProfiles.emoji];
          monospace = [fontProfiles.mono];
        };
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    # font packages that should be installed
    packages = with pkgs; [
      # defaults worth keeping
      dejavu_fonts
      freefont_ttf
      gyre-fonts
      liberation_ttf # for PDFs, Roman
      unifont

      # programming fonts
      sarasa-gothic
      nerd-fonts.symbols-only
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term-slab
      # desktop fonts
      corefonts # MS fonts
      courier-prime
      vista-fonts
      material-icons # used in widgets and such
      material-design-icons
      noto-fonts
      noto-fonts-cjk-sans

      # emojis
      font-awesome
      noto-fonts-color-emoji
      twemoji-color-font
      openmoji-color
      openmoji-black
    ];
  };
}
