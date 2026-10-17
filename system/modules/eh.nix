{inputs, ...}: {
  imports = [
    inputs.eh.nixosModules.default
  ];
  programs.eh = {
    enable = true;
    comma.enable = true;
  };
}
