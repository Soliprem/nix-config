{inputs, ...}: {
  flake.modules.nixos.audio = {pkgs, ...}: {
    hardware.bluetooth.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
      extraConfig.pipewire."99-allowed-rates"."context.properties"."default.clock.allowed-rates" = [
        44100
        48000
        88200
        96000
        176400
        192000
        352800
        384000
      ];
    };
    imports = [
      inputs.spicetify-nix.nixosModules.default
    ];
    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
        keyboardShortcut
      ];
      enabledCustomApps = with spicePkgs.apps; [
        marketplace
        reddit
      ];
      theme = spicePkgs.themes.hazy;
    };
    environment.systemPackages = with pkgs; [
      alsa-utils
      audacity
      muse-sounds-manager
      musescore
      pipewire
      playerctl
      pwvucontrol
      qpwgraph
      spek
      spotdl
      tauon
      strawberry
      wiremix
    ];
  };
}
