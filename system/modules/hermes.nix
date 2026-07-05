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
        context_length = 131072;
      };

      delegation = {
        model = "ornith:9b";
        base_url = "http://127.0.0.1:11434/v1";
        api_key = "ollama";
        api_mode = "chat_completions";

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
          command = "${pkgs.nodejs_22}/bin/node";
          args = ["${configRoot}/assets/hermes/thunderbird-mcp/mcp-bridge.cjs"];
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
