{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.neorg-overlay.overlays.default
    inputs.soniksnvim.overlays.default
  ];
}
