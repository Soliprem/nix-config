{inputs, ...}: {
  flake.modules.nixos.searx = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.agenix.nixosModules.default];

    age.secrets.searx_env.file = ../secrets/server_searx_env.age;

    services.searx = {
      enable = true;
      environmentFile = config.age.secrets.searx_env.path;
      configureUwsgi = true;
      uwsgiConfig = {
        http = "127.0.0.1:8888";
        disable-logging = true;
      };
      settings.server = {
        secret_key = "$SEARX_SECRET_KEY";
        base_url = lib.mkDefault "http://localhost:8888/";
      };
    };
  };
}
