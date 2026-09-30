{
  config,
  configRoot,
  lib,
  pkgs,
  ...
}: let
  vpnRoute = pkgs.writeShellScript "p2p-vpn-route" ''
    set -eu
    route=$(${pkgs.iproute2}/bin/ip -4 route get 1.1.1.1 uid "''${1:-$(${pkgs.coreutils}/bin/id -u)}")
    case " $route " in
      *" dev proton0 "*) ;;
      *) echo 'Proton VPN is not routing this service through proton0.' >&2; exit 1 ;;
    esac
  '';
  p2p = pkgs.writeShellScriptBin "p2p" ''
    set -eu
    test "$(${pkgs.coreutils}/bin/id -u)" = 0 || { echo 'Run with sudo.' >&2; exit 1; }
    case "''${1:-}" in
      on|check)
        ${vpnRoute} "$(${pkgs.coreutils}/bin/id -u slskd)"
        ${vpnRoute} "$(${pkgs.coreutils}/bin/id -u transmission)"
        test "$1" = check && exit 0
        test -f ${config.age.secrets.slskd_env.path} || { echo 'slskd credentials are unavailable.' >&2; exit 1; }
        ${pkgs.systemd}/bin/systemctl start slskd.service transmission.service
        ${pkgs.systemd}/bin/systemctl is-active --quiet slskd.service transmission.service
        ;;
      off) ${pkgs.systemd}/bin/systemctl stop slskd.service transmission.service ;;
      *) echo 'Usage: sudo p2p on|off|check' >&2; exit 2 ;;
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
      "x-systemd.requires=network-online.target"
      "x-systemd.after=network-online.target"
      "x-systemd.mount-timeout=30s"
    ];
  };
  services.davfs2.enable = true;
  environment.systemPackages = [p2p];

  services.slskd = {
    enable = true;
    environmentFile = config.age.secrets.slskd_env.path;
    settings = {
      web.ip_address = "127.0.0.1";
    };
  };
  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    downloadDirPermissions = "770";
    settings = {
      umask = 2;
      port-forwarding-enabled = false;
    };
  };

  # manual disconnects bypass Proton's standard kill switch; run
  # `sudo p2p off` before disconnecting. Add a firewall only if that changes.
  systemd.services.slskd = {
    wantedBy = lib.mkForce [];
    unitConfig.ConditionPathExists = config.age.secrets.slskd_env.path;
    serviceConfig = {
      ExecCondition = vpnRoute;
      UMask = "0007";
    };
  };
  systemd.services.transmission = {
    wantedBy = lib.mkForce [];
    serviceConfig = {
      ExecCondition = vpnRoute;
      RestrictAddressFamilies = ["AF_NETLINK"];
    };
  };

  services.aurral = {
    enable = true;
    port = 3001;
    openFirewall = false;
    directories = [
      "/var/lib/slskd"
      "/mnt/storage-box/music/aurral"
    ];
    environment.DOWNLOAD_FOLDER = "/mnt/storage-box/music/aurral";
  };
  services.lidarr = {
    enable = true;
    openFirewall = false;
    settings.server.bindaddress = "127.0.0.1";
  };
  users.groups.music = {};
  users.users.aurral.extraGroups = ["slskd" "music"];
  users.users.lidarr.extraGroups = ["transmission" "music"];
  users.users.soliprem.extraGroups = ["transmission" "music"];

  systemd.services.music-tailnet = {
    description = "Tailnet access to Aurral and Lidarr";
    wantedBy = ["multi-user.target"];
    wants = ["tailscaled.service"];
    after = ["tailscaled.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "serve-music" ''
        set -e
        ${pkgs.tailscale}/bin/tailscale serve --bg --https=443 http://127.0.0.1:3001
        ${pkgs.tailscale}/bin/tailscale serve --bg --https=10000 http://127.0.0.1:8686
      '';
      ExecStop = pkgs.writeShellScript "unserve-music" ''
        ${pkgs.tailscale}/bin/tailscale serve --https=443 off
        ${pkgs.tailscale}/bin/tailscale serve --https=10000 off
      '';
      Restart = "on-failure";
      RestartSec = 10;
    };
  };
}
