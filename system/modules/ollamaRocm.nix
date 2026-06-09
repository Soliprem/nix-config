{pkgs, ...}: {
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    port = 11434;
    package = pkgs.ollama-rocm;
    environmentVariables = {
      HIP_VISIBLE_DEVICES = "0";
      ROCR_VISIBLE_DEVICES = "0";
    };
    # rocmOverrideGfx = "12.0.1";
  };
  systemd.services.ollama = {
    after = [ "systemd-modules-load.service" ];
    wants = [ "systemd-modules-load.service" ];
  };
}
