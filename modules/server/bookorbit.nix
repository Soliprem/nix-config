{
  flake.modules.nixos.server = {config, ...}: {
    age.secrets = {
      bookorbit_env = {
        file = ../../secrets/server_bookorbit_env.age;
      };
    };
    services = {
      bookorbit = {
        enable = true;
        environment = {
          PORT = 25132;
          HOST = "127.0.0.1";
          APP_URL = "https://bookorbit.soliprem.eu";
        };
        environmentFile = config.age.secrets.bookorbit_env.path;
      };

      caddy.virtualHosts."bookorbit.soliprem.eu".extraConfig = ''
        reverse_proxy 127.0.0.1:25132
      '';
    };
  };
}
