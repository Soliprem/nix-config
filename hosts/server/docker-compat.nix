{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    # Keep the image store used by the remaining containers.
    daemon.settings.features.containerd-snapshotter = false;
  };

  environment.systemPackages = [pkgs.docker-compose];
}
