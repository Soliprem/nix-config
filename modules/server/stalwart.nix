{
  flake.modules.nixos.server = {
    config,
    pkgs,
    ...
  }: let
    certificateDir = "/var/lib/caddy/.local/share/caddy/certificates/acme-v02.api.letsencrypt.org-directory/mail.soliprem.eu";
  in {
    age.secrets = {
      stalwart_admin_password = {
        file = ../../secrets/server_stalwart_admin_password.age;
      };
      stalwart_dkim_private_key = {
        file = ../../secrets/server_stalwart_dkim_private_key.age;
      };
    };
    services.stalwart = {
      enable = true;
      stateVersion = "26.05";
      openFirewall = true;
      credentials = {
        admin-password = config.age.secrets.stalwart_admin_password.path;
        dkim-private-key = config.age.secrets.stalwart_dkim_private_key.path;
        tls-cert = "${certificateDir}/mail.soliprem.eu.crt";
        tls-key = "${certificateDir}/mail.soliprem.eu.key";
      };
      settings = {
        server = {
          hostname = "mail.soliprem.eu";
          listener = {
            smtp = {
              bind = ["[::]:25"];
              protocol = "smtp";
            };
            submissions = {
              bind = ["[::]:465"];
              protocol = "smtp";
              tls.implicit = true;
            };
            imaps = {
              bind = ["[::]:993"];
              protocol = "imap";
              tls.implicit = true;
            };
            management = {
              bind = ["127.0.0.1:18081"];
              protocol = "http";
            };
            submission = {
              bind = ["[::]:587"];
              protocol = "smtp";
            };
            imap = {
              bind = ["[::]:143"];
              protocol = "imap";
            };
            pop3 = {
              bind = ["[::]:110"];
              protocol = "pop3";
            };
            pop3s = {
              bind = ["[::]:995"];
              protocol = "pop3";
              tls.implicit = true;
            };
            sieve = {
              bind = ["[::]:4190"];
              protocol = "managesieve";
            };
          };
        };
        http = {
          url = "https://mail.soliprem.eu";
          use-x-forwarded = true;
        };
        authentication.fallback-admin = {
          user = "admin";
          secret = "%{file:/run/credentials/stalwart.service/admin-password}%";
        };
        certificate.mail = {
          cert = "%{file:/run/credentials/stalwart.service/tls-cert}%";
          private-key = "%{file:/run/credentials/stalwart.service/tls-key}%";
          default = true;
        };
        signature.mailcow = {
          algorithm = "rsa-sha256";
          domain = "soliprem.eu";
          selector = "dkim";
          private-key = "%{file:/run/credentials/stalwart.service/dkim-private-key}%";
        };
        auth.dkim.sign = [
          {
            "if" = "sender_domain == 'soliprem.eu'";
            "then" = "['mailcow']";
          }
          {"else" = "false";}
        ];
        auth.arc.seal = "'mailcow'";
        # Mailcow contains a 349 MB draft; preserve it and old Junk/Trash mail.
        imap.request.max-size = 536870912;
        jmap.email.max-size = 536870912;
        jmap.protocol.upload.max-size = 536870912;
        email.auto-expunge = false;
        # The bundled source build currently fails in trunk with GCC 16.
        webadmin.resource = "file://${pkgs.fetchurl {
          url = "https://github.com/stalwartlabs/webadmin/releases/download/v0.1.37/webadmin.zip";
          hash = "sha256-nIJFxOFHoIBt1/lH97tfOHYay6o3Gwtb3Ap5A2s7WQk=";
        }}";
      };
    };

    # LoadCredential takes a snapshot; restart when Caddy renews the mail certificate.
    systemd.paths.stalwart-certificate = {
      wantedBy = ["multi-user.target"];
      pathConfig = {
        PathChanged = ["${certificateDir}/mail.soliprem.eu.crt" "${certificateDir}/mail.soliprem.eu.key"];
      };
    };
    systemd.services.stalwart-certificate = {
      serviceConfig.Type = "oneshot";
      script = "${pkgs.systemd}/bin/systemctl try-restart stalwart.service";
    };

    services.caddy.virtualHosts."stalwart.soliprem.eu".extraConfig = ''
      route {
        import tailscale_only
        reverse_proxy 127.0.0.1:18081
      }
    '';
  };
}
