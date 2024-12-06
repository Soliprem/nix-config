{inputs, ...}: {
  imports = [
    inputs.agenix.homeManagerModules.default
  ];
  age = {
    secrets.bw_sessionkey.file = ../secrets/bitwarden_sessionkey.age;
    identityPaths = [
      "/home/soliprem/.ssh/id_rsa"
    ];
  };
}
