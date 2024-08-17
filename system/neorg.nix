{neorg-overlay, ...}: {
  nixpkgs.overlays = [neorg-overlay.overlays.default];
}
