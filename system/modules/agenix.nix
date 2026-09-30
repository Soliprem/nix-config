{
  configRoot,
  inputs,
  lib,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];

  age.secrets = {
    navidrome_authinfo = {
      file = configRoot + /secrets/navidrome_authinfo.age;
      owner = "soliprem";
      mode = "400";
    };

    gomuks_authinfo = {
      file = configRoot + /secrets/gomuks_authinfo.age;
      owner = "soliprem";
      mode = "400";
    };

    bitwarden_clientid = {
      file = configRoot + /secrets/bitwarden_clientid.age;
      owner = "soliprem";
    };

    bitwarden_clientsecret = {
      file = configRoot + /secrets/bitwarden_clientsecret.age;
      owner = "soliprem";
    };

    bitwarden_password = {
      file = configRoot + /secrets/bitwarden_password.age;
      owner = "soliprem";
    };

    github_authinfo = {
      file = configRoot + /secrets/github_authinfo.age;
      owner = "soliprem";
      mode = "600";
    };

    mail_soliprem_accounts_password = {
      file = configRoot + /secrets/mail_soliprem_accounts_password.age;
      owner = "soliprem";
      mode = "400";
    };

    mail_soliprem_password = {
      file = configRoot + /secrets/mail_soliprem_password.age;
      owner = "soliprem";
      mode = "400";
    };
  };
}
