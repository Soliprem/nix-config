{
  configRoot,
  inputs,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];

  age.secrets.bitwarden_clientid = {
    file = configRoot + /secrets/bitwarden_clientid.age;
    owner = "soliprem";
  };

  age.secrets.bitwarden_clientsecret = {
    file = configRoot + /secrets/bitwarden_clientsecret.age;
    owner = "soliprem";
  };

  age.secrets.bitwarden_password = {
    file = configRoot + /secrets/bitwarden_password.age;
    owner = "soliprem";
  };

  age.secrets.github_authinfo = {
    file = configRoot + /secrets/github_authinfo.age;
    owner = "soliprem";
    mode = "600";
  };
}
