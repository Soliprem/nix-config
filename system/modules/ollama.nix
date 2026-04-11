{
  pkgs,
  inputs,
  ...
}: let
  sys = pkgs.stdenv.hostPlatform.system;
  unstable-pkgs = inputs.nixpkgs-unstable.legacyPackages.${sys};
in {
  services.ollama = {
    enable = true;
    package = unstable-pkgs.ollama;
  };
}
