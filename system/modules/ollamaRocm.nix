{ pkgs, inputs, ... }:
let
  sys = pkgs.stdenv.hostPlatform.system;
  unstable-pkgs = inputs.nixpkgs-unstable.legacyPackages.${sys};
in 
{
  services.ollama = {
    enable = true;
    package = unstable-pkgs.ollama-rocm;
    # environmentVariables = {
    #   HCC_AMDGPU_TARGET = "gfx1201";
    #   "TORCH_ROCM_AOTRITON_ENABLE_EXPERIMENTAL" = "1";
    # };
    # rocmOverrideGfx = "12.0.1";
  };
}
