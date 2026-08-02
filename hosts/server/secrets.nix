{
  configRoot,
  inputs,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];

  age.secrets = {
    caddy_env = {
      file = configRoot + /secrets/server_caddy_env.age;
      mode = "0400";
    };
    storage_box_credentials = {
      file = configRoot + /secrets/server_storage_box_credentials.age;
      path = "/etc/backup-credentials.txt";
      mode = "0600";
      symlink = false;
    };
    wakapi_config = {
      file = configRoot + /secrets/server_wakapi_config.age;
      path = "/etc/wakapi/config.yml";
      mode = "0600";
      symlink = false;
    };
  };
}
