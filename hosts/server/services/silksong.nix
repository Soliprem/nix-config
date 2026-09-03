{inputs, ...}: {
  imports = [inputs.silksong-aa.nixosModules.default];
  services.silksong-aa.enable = true;
}
