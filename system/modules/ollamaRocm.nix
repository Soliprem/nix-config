{
  pkgs,
  ...
}: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
    environmentVariables = {
      HIP_VISIBLE_DEVICES = "0";
      ROCR_VISIBLE_DEVICES = "0";
    };
    # rocmOverrideGfx = "12.0.1";
  };
}
