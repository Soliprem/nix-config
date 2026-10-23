{
  flake.modules.nixos.server = {
    age.secrets = {
      storage_box_credentials = {
        file = ../../secrets/server_storage_box_credentials.age;
        path = "/etc/backup-credentials.txt";
        mode = "0600";
        symlink = false;
      };
    };
    fileSystems."/mnt/storage-box" = {
      device = "//u480084.your-storagebox.de/backup";
      fsType = "cifs";
      options = [
        "seal"
        "credentials=/etc/backup-credentials.txt"
        # Present remote ownership directly. Consumers must pass sentinel and
        # access tests using the mount's native defaults.
        "nounix"
        "noperm"
        "_netdev"
        "nofail"
        "x-systemd.requires=network-online.target"
        "x-systemd.after=network-online.target"
        "x-systemd.mount-timeout=30s"
        "noserverino"
      ];
    };
  };
}
