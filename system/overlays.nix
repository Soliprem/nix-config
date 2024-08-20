{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.soniksnvim.overlays.default
  ];
}
