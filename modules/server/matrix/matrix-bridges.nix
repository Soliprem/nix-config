{inputs, ...}: {
  flake.modules.nixos.server = {
    config,
    lib,
    pkgs,
    ...
  }: let
    sharedSettings = {
      homeserver = {
        address = "http://127.0.0.1:6167";
        domain = "soliprem.eu";
      };
      appservice = {
        hostname = "127.0.0.1";
        as_token = "$AS_TOKEN";
        hs_token = "$HS_TOKEN";
      };
      bridge = {
        relay.enabled = false;
        permissions = {
          "soliprem.eu" = "user";
          "@soliprem:soliprem.eu" = "admin";
        };
      };
      backfill.enabled = true;
      encryption = {
        allow = true;
        default = true;
        pickle_key = "$ENCRYPTION_PICKLE_KEY";
      };
      double_puppet.secrets."soliprem.eu" = "$DOUBLE_PUPPET_SECRET";
      provisioning.shared_secret = "$PROVISIONING_SHARED_SECRET";
      public_media.signing_key = "$PUBLIC_MEDIA_SIGNING_KEY";
      direct_media.server_key = "$DIRECT_MEDIA_SERVER_KEY";
    };
  in {
    # Drop with the input once nixpkgs ships the bridgev2 module.
    disabledModules = ["services/matrix/mautrix-telegram.nix"];
    imports = [inputs.mautrix-telegram-module.outPath];

    age.secrets = {
      mautrix_signal_env = {
        file = ../../../secrets/server_mautrix_signal_env.age;
      };
      mautrix_whatsapp_env = {
        file = ../../../secrets/server_mautrix_whatsapp_env.age;
      };
      mautrix_telegram_env = {
        file = ../../../secrets/server_mautrix_telegram_env.age;
      };
    };
    # retain upstream Docker's libolm and existing encryption state;
    # remove this exception when the bridges adopt maintained crypto upstream.
    nixpkgs.config.permittedInsecurePackages = ["olm-3.2.16"];

    services.mautrix-signal = {
      enable = true;
      serviceDependencies = ["continuwuity.service" "postgresql.service"];
      environmentFile = config.age.secrets.mautrix_signal_env.path;
      settings = lib.recursiveUpdate sharedSettings {
        database = {
          type = "postgres";
          uri = "postgresql:///mautrix-signal?host=/run/postgresql";
        };
        appservice = {
          address = "http://127.0.0.1:29328";
          bot = {
            displayname = "Signal bridge bot";
            avatar = "mxc://maunium.net/wPJgTQbZOtpBFmDNkiNEMDUp";
          };
        };
      };
    };

    services.mautrix-whatsapp = {
      enable = true;
      serviceDependencies = ["continuwuity.service" "postgresql.service"];
      environmentFile = config.age.secrets.mautrix_whatsapp_env.path;
      settings = lib.recursiveUpdate sharedSettings {
        database = {
          type = "postgres";
          uri = "postgresql:///mautrix-whatsapp?host=/run/postgresql";
        };
        appservice = {
          address = "http://127.0.0.1:29318";
          bot = {
            displayname = "WhatsApp bridge bot";
            avatar = "mxc://maunium.net/NeXNQarUbrlYBiPCpprYsRqr";
          };
        };
        network = {
          displayname_template = "{{or .FullName .BusinessName .PushName .Phone .RedactedPhone \"Unknown user\"}} (WA)";
          identity_change_notices = false;
          history_sync.request_full_sync = false;
        };
      };
    };

    services.mautrix-telegram = {
      enable = true;
      package = pkgs.callPackage ../../../packages/mautrix-telegram.nix {};
      serviceDependencies = ["continuwuity.service" "postgresql.service"];
      environmentFile = config.age.secrets.mautrix_telegram_env.path;
      settings = lib.recursiveUpdate sharedSettings {
        database = {
          type = "postgres";
          uri = "postgresql:///mautrix-telegram?host=/run/postgresql";
        };
        appservice = {
          address = "http://127.0.0.1:29317";
          port = 29317;
        };
        # The upstream default also logs to ./logs, which is read-only here.
        logging = {
          min_level = "info";
          writers = [
            {
              type = "stdout";
              format = "pretty";
            }
          ];
        };
      };
    };
    # NickCao's module leaves the --config quote unterminated.
    systemd.services.mautrix-telegram.serviceConfig.ExecStart = lib.mkForce "${lib.getExe config.services.mautrix-telegram.package} --config=/var/lib/mautrix-telegram/config.json";

    services.postgresql = {
      ensureDatabases = ["mautrix-signal" "mautrix-whatsapp" "mautrix-telegram"];
      ensureUsers = [
        {
          name = "mautrix-signal";
          ensureDBOwnership = true;
        }
        {
          name = "mautrix-whatsapp";
          ensureDBOwnership = true;
        }
        {
          name = "mautrix-telegram";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
