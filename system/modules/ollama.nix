{pkgs, ...}: {
  services.ollama = {
    enable = true;
  };
  virtualisation.docker.enable = true;
}
