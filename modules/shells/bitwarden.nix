{inputs, ...}: {
  flake.modules.nixos.bitwardenModule = {
    imports = [inputs.agenix.nixosModules.default];
    age.secrets = {
      bitwarden_clientid = {
        file = ../../secrets/bitwarden_clientid.age;
        owner = "soliprem";
      };
      bitwarden_clientsecret = {
        file = ../../secrets/bitwarden_clientsecret.age;
        owner = "soliprem";
      };
      bitwarden_password = {
        file = ../../secrets/bitwarden_password.age;
        owner = "soliprem";
      };
    };
  };
}
