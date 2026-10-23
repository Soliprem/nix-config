{inputs, ...}: {
  flake.modules.nixos.server = {
    imports = [inputs.silksong-aa.nixosModules.default];
    services.silksong-aa.enable = true;
  };
}
