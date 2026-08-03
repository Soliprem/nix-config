{...}: {
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://vw.soliprem.eu";
      SIGNUPS_ALLOWED = false;
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 11001;
    };
  };

  systemd.services.vaultwarden = {
    unitConfig.ConditionPathExists = "/var/lib/vaultwarden/db.sqlite3";
    serviceConfig.StateDirectoryMode = "0700";
  };
}
