{
  inputs,
  self,
  ...
}: let
  server = self.nixosConfigurations.nixos-server;
in {
  flake = {
    deploy.nodes.nixos-server = {
      hostname = "49.12.104.79";
      sshUser = "root";
      activationTimeout = 600;
      confirmTimeout = 60;
      profiles.system = {
        user = "root";
        path = inputs.deploy-rs.lib.${server.pkgs.stdenv.hostPlatform.system}.activate.nixos server;
      };
    };
  };
}
