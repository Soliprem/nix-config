{
  config,
  configRoot,
  lib,
  pkgs,
  ...
}: let
  requireProton = pkgs.writeShellScript "require-proton-vpn" ''
    route=$(${pkgs.iproute2}/bin/ip -4 route get 1.1.1.1 uid "$(${pkgs.coreutils}/bin/id -u)")
    case " $route " in
      *" dev proton0 "*) ;;
      *) echo "Refusing to start: traffic is not routed through proton0" >&2; exit 1 ;;
    esac
  '';
in {
  age.secrets.storage_box_webdav = {
    file = configRoot + /secrets/pc_storage_box_webdav.age;
    path = "/etc/davfs2/secrets";
    mode = "0600";
    symlink = false;
  };

  age.secrets.slskd_env = {
    file = configRoot + /secrets/pc_slskd_env.age;
    mode = "0400";
  };

  services.davfs2.enable = true;

  fileSystems."/mnt/storage-box" = {
    device = "https://u480084.your-storagebox.de";
    fsType = "davfs";
    noCheck = true;
    options = [
      "uid=soliprem"
      "gid=music"
      "grpid"
      "file_mode=0660"
      "dir_mode=0770"

      "_netdev"
      "nofail"

      "x-systemd.automount"
      "x-systemd.mount-timeout=30s"
    ];
  };

  users.groups.music = {};
  users.users = {
    soliprem.extraGroups = ["music" "slskd"];
    slskd.extraGroups = ["music"];
  };

  services.slskd = {
    enable = true;

    environmentFile = config.age.secrets.slskd_env.path;

    settings = {
      web.ip_address = "127.0.0.1";

      directories = {
        incomplete = "/var/lib/slskd/incomplete";
        downloads = "/mnt/storage-box/music";
      };
    };
  };

  # Start after connecting Proton; stop before disconnecting it.
  systemd.services.slskd = {
    wantedBy = lib.mkForce [];
    serviceConfig = {
      ExecCondition = requireProton;
      UMask = "0007";
    };
  };

  systemd.services.music-tailnet = {
    description = "Tailnet access to slskd";
    wantedBy = ["multi-user.target"];
    wants = ["tailscaled.service"];
    after = ["tailscaled.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      RestartSec = 10;
      ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=443 http://127.0.0.1:5030";
      ExecStop = "${pkgs.tailscale}/bin/tailscale serve --https=443 off";
    };
  };
}
