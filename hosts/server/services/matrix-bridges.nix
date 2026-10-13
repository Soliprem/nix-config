{
  config,
  lib,
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
        address = "http://mautrix-signal:29328";
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
        address = "http://whatsapp-bridge:29318";
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

  services.postgresql = {
    ensureDatabases = ["mautrix-signal" "mautrix-whatsapp"];
    ensureUsers = [
      {
        name = "mautrix-signal";
        ensureDBOwnership = true;
      }
      {
        name = "mautrix-whatsapp";
        ensureDBOwnership = true;
      }
    ];
  };
}
