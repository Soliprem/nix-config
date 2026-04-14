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
    package = unstable-pkgs.ollama-rocm;
    environmentVariables = {
      HIP_VISIBLE_DEVICES = "0";
      ROCR_VISIBLE_DEVICES = "0";
    };
    # rocmOverrideGfx = "12.0.1";
  };
}
