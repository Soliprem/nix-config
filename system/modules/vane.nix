_: {
  virtualisation = {
    podman = {
      enable = true;
      defaultNetwork.settings = {
        dns_enabled = true;
        dns_servers = ["1.1.1.1" "8.8.8.8"];
      };
    };
    oci-containers = {
      backend = "podman";
      containers.vane = {
        image = "itzcrazykns1337/vane:latest";
        autoStart = true;
        ports = [
          "127.0.0.1:3000:3000"
        ];
        volumes = [
          "vane-data:/home/vane/data"
        ];
      };
    };
  };
  networking.firewall.interfaces."podman0".allowedTCPPorts = [11434];
}
