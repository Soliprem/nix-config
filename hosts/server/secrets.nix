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
    livekit_keys = {
      file = configRoot + /secrets/server_livekit_keys.age;
      mode = "0400";
    };
    continuwuity_registration_token = {
      file = configRoot + /secrets/server_continuwuity_registration_token.age;
      mode = "0400";
    };
    karakeep_env = {
      file = configRoot + /secrets/server_karakeep_env.age;
      mode = "0400";
    };
    meilisearch_master_key = {
      file = configRoot + /secrets/server_meilisearch_master_key.age;
      mode = "0400";
    };
  };
}
