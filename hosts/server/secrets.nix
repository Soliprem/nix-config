{
  configRoot,
  inputs,
  ...
}: {
  imports = [inputs.agenix.nixosModules.default];

  age.secrets = {
    microbin_env = {
      file = configRoot + /secrets/server_microbin_env.age;
    };
    mautrix_signal_env = {
      file = configRoot + /secrets/server_mautrix_signal_env.age;
    };
    mautrix_whatsapp_env = {
      file = configRoot + /secrets/server_mautrix_whatsapp_env.age;
    };
    caddy_env = {
      file = configRoot + /secrets/server_caddy_env.age;
    };
    storage_box_credentials = {
      file = configRoot + /secrets/server_storage_box_credentials.age;
      path = "/etc/backup-credentials.txt";
      mode = "0600";
      symlink = false;
    };
    livekit_keys = {
      file = configRoot + /secrets/server_livekit_keys.age;
    };
    continuwuity_registration_token = {
      file = configRoot + /secrets/server_continuwuity_registration_token.age;
    };
    karakeep_env = {
      file = configRoot + /secrets/server_karakeep_env.age;
    };
    bookorbit_env = {
      file = configRoot + /secrets/server_bookorbit_env.age;
    };
    meilisearch_master_key = {
      file = configRoot + /secrets/server_meilisearch_master_key.age;
    };
    stalwart_admin_password = {
      file = configRoot + /secrets/server_stalwart_admin_password.age;
    };
    stalwart_dkim_private_key = {
      file = configRoot + /secrets/server_stalwart_dkim_private_key.age;
    };
    calendar_credentials = {
      file = configRoot + /secrets/server_calendar_credentials.age;
    };
    filebrowser_env = {
      file = configRoot + /secrets/server_filebrowser_env.age;
    };
  };
}
