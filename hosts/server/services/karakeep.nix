{
  config,
  inputs,
  pkgs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  karakeepPkgs = import inputs.nixpkgs {
    inherit system;
    config.permittedInsecurePackages = ["pnpm-9.15.9"];
  };
in {
  services.karakeep = {
    enable = true;
    # pnpm 9 is used only in nixpkgs' sandboxed build and is not retained by
    # the Karakeep runtime closure.
    package = karakeepPkgs.karakeep;
    environmentFile = config.age.secrets.karakeep_env.path;
    extraEnvironment = {
      PORT = "60221";
      HOSTNAME = "127.0.0.1";
      DISABLE_SIGNUPS = "true";
      NEXTAUTH_URL = "http://localhost:60221";
      NEXTAUTH_URL_INTERNAL = "http://127.0.0.1:60221";
    };
  };

  services.meilisearch.masterKeyFile = config.age.secrets.meilisearch_master_key.path;

  systemd.services = {
    karakeep-init.unitConfig.ConditionPathExists = "/var/lib/karakeep/db.db";
    karakeep-workers = {
      wants = ["meilisearch.service" "karakeep-browser.service"];
      after = ["meilisearch.service" "karakeep-browser.service"];
      unitConfig.ConditionPathExists = "/var/lib/karakeep/db.db";
    };
    karakeep-web = {
      wants = ["meilisearch.service" "karakeep-browser.service"];
      after = ["meilisearch.service" "karakeep-browser.service"];
      unitConfig.ConditionPathExists = "/var/lib/karakeep/db.db";
    };
  };
}
