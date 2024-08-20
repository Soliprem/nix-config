{
  neorg-overlay,
  soniksnvim,
  ...
}: {
  nixpkgs.overlays = [
    neorg-overlay.overlays.default
    soniksnvim.overlays.default
  ];
}
