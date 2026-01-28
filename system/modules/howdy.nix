{ inputs, ... }:
{
  imports = [
    inputs.nixpkgs-unstable.nixosModules.howdy
  ];
  services.howdy = {
      enable = true;
    };
}
