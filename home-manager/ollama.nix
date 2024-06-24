{pkgs, ...}: {
  services.ollama = {
    enable = true;
    home = /home/ollama;
    package = pkgs.ollama-rocm;
  };
}
