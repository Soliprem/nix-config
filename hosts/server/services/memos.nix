{
  inputs,
  pkgs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  services.memos = {
    enable = true;
    package = inputs.nixpkgs.legacyPackages.${system}.memos;
    dataDir = "/var/lib/memos";
    settings = {
      MEMOS_MODE = "prod";
      MEMOS_ADDR = "127.0.0.1";
      MEMOS_PORT = "5230";
      MEMOS_DATA = "/var/lib/memos";
      MEMOS_DRIVER = "sqlite";
      MEMOS_INSTANCE_URL = "https://memos.soliprem.eu";
      TZ = "UTC";
    };
  };

  systemd.services.memos = {
    unitConfig.ConditionPathExists = "/var/lib/memos/memos_prod.db";
    serviceConfig.Restart = "on-failure";
  };
}
