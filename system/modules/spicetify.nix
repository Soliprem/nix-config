{
  inputs,
  pkgs,
  ...
}: {
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
}
