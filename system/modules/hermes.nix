{
  config,
  inputs,
  configRoot,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.hermes-agent.nixosModules.default];

  services.hermes-agent = {
    enable = true;
    user = "soliprem";
    group = "hermes";
    createUser = false;
    addToSystemPackages = true;

    # Keep the sealed Nix build practical: Telegram/Discord/Slack gateway deps,
    # plus Hindsight memory. Matrix is deliberately omitted because its client
    # stack, especially encryption, is heavier.
    extraDependencyGroups = ["hindsight" "messaging"];
    extraPackages = with pkgs; [
      curl
      jq
      nodejs_22
      perl
      python3
    ];

    environmentFiles = [config.age.secrets.hermes_env.path];

    settings = {
      model = {
        provider = "openai-codex";
        default = "gpt-5.5";
      };

      terminal = {
        backend = "local";
        cwd = "/var/lib/hermes/workspace";
        timeout = 180;
      };

      memory = {
        provider = "hindsight";
        memory_enabled = true;
        user_profile_enabled = true;
      };

      mcp_servers = {
        thunderbird-mail = {
          command = "${pkgs.nodejs_22}/bin/node";
          args = ["${configRoot}/assets/hermes/thunderbird-mcp/mcp-bridge.cjs"];
          env = {
            THUNDERBIRD_MCP_CONNECTION_FILE = "/tmp/thunderbird-mcp/connection.json";
          };
        };
      };
    };
  };

  users.groups.hermes = {};

  systemd.services.hermes-agent.environment.TMPDIR = "/run/hermes-agent";
  systemd.services.hermes-agent.serviceConfig = {
    RuntimeDirectory = "hermes-agent";
    RuntimeDirectoryMode = "0770";
  };

  # The Thunderbird MCP extension writes its discovery file to the user's real
  # /tmp/thunderbird-mcp/connection.json. A private /tmp for the gateway makes
  # /reload-mcp report no connected MCP servers even when Thunderbird is running.
  systemd.services.hermes-agent.serviceConfig.PrivateTmp = lib.mkForce false;
}
