{
  config,
  inputs,
  lib,
  pkgs,
  configRoot,
  ...
}: {
  imports = [inputs.hermes-agent.nixosModules.default];

  age.secrets.hermes_env = {
    file = configRoot + /secrets/hermes_env.age;
    owner = "soliprem";
    group = "hermes";
  };

  services.hermes-agent = {
    enable = true;
    user = "soliprem";
    group = "hermes";
    createUser = false;
    addToSystemPackages = true;

    # Hindsight moved to Hermes' plugin catalog and is no longer a Python extra.
    extraDependencyGroups = ["messaging" "matrix"];
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
        default = "gpt-6.1-sol";
        # Settings merge into mutable state; clear credentials from prior providers.
        base_url = null;
        api_key = null;
      };

      model_aliases = {
        luna = {
          provider = "openai-codex";
          model = "gpt-6-luna";
        };

        terra = {
          provider = "openai-codex";
          model = "gpt-5.6-terra";
        };

        sol = {
          provider = "openai-codex";
          model = "gpt-6.1-sol";
        };

        astra = {
          provider = "openai-codex";
          model = "gpt-6-astra";
        };
      };

      delegation = {
        provider = "openai-codex";
        model = "gpt-6-luna";
        base_url = null;
        api_key = null;
        api_mode = null;

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

      agent.tool_use_enforcement = true;
    };
  };

  users.groups.hermes = {};

  systemd.services.hermes-agent = {
    after = ["user@1000.service"];
    wants = ["user@1000.service"];
    environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
      DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/user/1000/bus";
    };
  };

  # NOTE: no longer necessary because I dropped thunderbird mpc in favor of mu
  # systemd.services.hermes-agent = {
  #   environment.TMPDIR = "/run/hermes-agent";
  #   serviceConfig = {
  #     RuntimeDirectory = "hermes-agent";
  #     RuntimeDirectoryMode = "0770";
  #     # The Thunderbird MCP extension writes its discovery file to the user's real
  #     # /tmp/thunderbird-mcp/connection.json. A private /tmp for the gateway makes
  #     # /reload-mcp report no connected MCP servers even when Thunderbird is running.
  #     PrivateTmp = lib.mkForce false;
  #   };
  # };
}
