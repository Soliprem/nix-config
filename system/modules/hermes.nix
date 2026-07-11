{
  config,
  inputs,
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

    extraDependencyGroups = ["hindsight" "messaging" "matrix"];
    extraPackages = with pkgs; [
      curl
      jq
      nodejs_22
      perl
      python3
      thunderbird-mcp
    ];

    environmentFiles = [config.age.secrets.hermes_env.path];

    settings = {
      model = {
        provider = "openai-codex";
        default = "gpt-5.6-terra";
      };

      model_aliases = {
        luna = {
          provider = "openai-codex";
          model = "gpt-5.6-luna";
        };

        terra = {
          provider = "openai-codex";
          model = "gpt-5.6-terra";
        };

        sol = {
          provider = "openai-codex";
          model = "gpt-5.6-sol";
        };
      };

      delegation = {
        provider = "openai-codex";
        model = "gpt-5.6-luna";

        max_concurrent_children = 1;
        max_spawn_depth = 1;
        orchestrator_enabled = false;
        max_iterations = 25;
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
          command = "thunderbird-mcp";
          env = {
            THUNDERBIRD_MCP_CONNECTION_FILE = "/tmp/thunderbird-mcp/connection.json";
          };
        };
      };
      agent.tool_use_enforcement = true;
    };
  };

  users.groups.hermes = {};

  systemd.services.hermes-agent = {
    environment.TMPDIR = "/run/hermes-agent";
    serviceConfig = {
      RuntimeDirectory = "hermes-agent";
      RuntimeDirectoryMode = "0770";
      # The Thunderbird MCP extension writes its discovery file to the user's real
      # /tmp/thunderbird-mcp/connection.json. A private /tmp for the gateway makes
      # /reload-mcp report no connected MCP servers even when Thunderbird is running.
      PrivateTmp = lib.mkForce false;
    };
  };
}
