{...}: {
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1030";
    };
    rocmOverrideGfx = "10.3.0";
  };
  virtualisation.docker.enable = true;
}
