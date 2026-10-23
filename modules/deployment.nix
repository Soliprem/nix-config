{
  inputs,
  self,
  ...
}: {
  flake = {
    deploy.nodes =
      inputs.nixpkgs.lib.mapAttrs (name: machine: {
        hostname =
          if name == "nixos-server"
          then "49.12.104.79"
          else machine.config.networking.hostName;
        sshUser = "root";
        activationTimeout = 600;
        confirmTimeout = 60;
        profiles.system = {
          user = "root";
          path = inputs.deploy-rs.lib.${machine.pkgs.stdenv.hostPlatform.system}.activate.nixos machine;
        };
      })
      self.nixosConfigurations;
  };
}
