{
  inputs,
  self,
  ...
}: {
  flake = {
    deploy.nodes.nixos-server = {
      hostname = "49.12.104.79";
      sshUser = "root";
      activationTimeout = 600;
      confirmTimeout = 60;
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nixos-server;
      };
    };
  };
}
