{
  flake.modules.nixos.server = {config, ...}: {
    age.secrets = {
      karakeep_env = {
        file = ../../secrets/server_karakeep_env.age;
      };
      meilisearch_master_key = {
        file = ../../secrets/server_meilisearch_master_key.age;
      };
    };
    services = {
      karakeep = {
        enable = true;
        environmentFile = config.age.secrets.karakeep_env.path;
        extraEnvironment = {
          PORT = "60221";
          HOSTNAME = "127.0.0.1";
          DISABLE_SIGNUPS = "true";
          NEXTAUTH_URL = "http://localhost:60221";
          NEXTAUTH_URL_INTERNAL = "http://127.0.0.1:60221";
        };
      };

      meilisearch.masterKeyFile = config.age.secrets.meilisearch_master_key.path;

      caddy.virtualHosts = {
        "hr.soliprem.eu" = {
          logFormat = null;
          extraConfig = ''
            redir https://hoarder.soliprem.eu{uri} permanent
          '';
        };

        "hoarder.soliprem.eu" = {
          logFormat = null;
          extraConfig = ''
            reverse_proxy localhost:60221
          '';
        };
      };
    };

    systemd.services = {
      karakeep-init = {
        serviceConfig.StateDirectoryMode = "0700";
      };
      karakeep-workers = {
        wants = ["meilisearch.service" "karakeep-browser.service"];
        after = ["meilisearch.service" "karakeep-browser.service"];
      };
      karakeep-web = {
        wants = ["meilisearch.service" "karakeep-browser.service"];
        after = ["meilisearch.service" "karakeep-browser.service"];
      };
    };
  };
}
