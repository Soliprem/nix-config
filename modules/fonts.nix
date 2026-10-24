{inputs, ...}: {
  flake.modules.nixos.fonts = {
    config,
    lib,
    pkgs,
    system,
    ...
  }: let
    inherit (lib.attrsets) mapAttrs;
    fontDefaults = config.fonts.fontconfig.defaultFonts;
    fontProfiles = rec {
      serif = "IosevkaTermSlab Nerd Font Propo";
      ui = serif;
      sans = "Iosevka Nerd Font Propo";
      mono = "IosevkaTermSlab Nerd Font Mono";
      symbols = "Symbols Nerd Font";
      emoji = "Noto Color Emoji";
    };
  in {
    hjem.specialArgs.fontProfiles = {
      serif = builtins.head fontDefaults.serif;
      ui = builtins.head fontDefaults.serif;
      sans = builtins.head fontDefaults.sansSerif;
      mono = builtins.head fontDefaults.monospace;
      emoji = builtins.head fontDefaults.emoji;
    };
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
      packages = with pkgs; [
        inputs.self.packages.${system}.cyberarch-fonts
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
        # openmoji-color
        # openmoji-black
      ];
    };
  };
}
