{
  neorg-overlay,
  sonicksnvim,
  ...
}: {
  nixpkgs.overlays = [
    neorg-overlay.overlays.default
    sonicksnvim.overlays.default
  ];
}
