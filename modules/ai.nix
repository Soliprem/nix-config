{inputs, ...}: {
  flake.modules.nixos.ollama = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      package = pkgs.ollama;
    };
  };
  flake.modules.nixos.ollama-rocm = {pkgs, ...}: {
    services.ollama = {
      enable = true;
      host = "0.0.0.0";
      port = 11434;
      package = pkgs.ollama-rocm;
      environmentVariables = {
        HIP_VISIBLE_DEVICES = "0";
        ROCR_VISIBLE_DEVICES = "0";
        OLLAMA_CONTEXT_LENGTH = "131072";
        OLLAMA_FLASH_ATTENTION = "1";
        OLLAMA_KV_CACHE_TYPE = "q8_0";
      };
    };
  };
  flake.modules.nixos.vane = {
    virtualisation = {
      podman = {
        enable = true;
        defaultNetwork.settings = {
          dns_enabled = true;
          dns_servers = ["1.1.1.1" "8.8.8.8"];
        };
      };
      oci-containers = {
        backend = "podman";
        containers.vane = {
          image = "itzcrazykns1337/vane:latest";
          autoStart = true;
          ports = [
            "127.0.0.1:3000:3000"
          ];
          volumes = [
            "vane-data:/home/vane/data"
          ];
        };
      };
    };
    # Allow Vane's container bridge to reach Ollama.
    networking.firewall.interfaces."podman0".allowedTCPPorts = [11434];
  };
  flake.modules.nixos.open-webui = {
    services.open-webui = {
      enable = true;
      environment.OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    };
  };
  flake.modules.nixos.hermes = {
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.hermes-agent.nixosModules.default];
    age.secrets.hermes_env = {
      file = ../secrets/hermes_env.age;
      owner = "soliprem";
      group = "hermes";
    };
    services.hermes-agent = {
      enable = true;
      user = "soliprem";
      group = "hermes";
      createUser = false;
      addToSystemPackages = true;
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
  };
}
