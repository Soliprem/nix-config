{
  config,
  modulesPath,
  pkgs,
  targetSystem,
  ...
}: {
  imports = [
    (modulesPath + "/installer/netboot/netboot-minimal.nix")
    ./networking.nix
  ];

  networking.hostName = "nixos-vps-installer";
  time.timeZone = "Europe/Rome";

  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "sd_mod"
      "sr_mod"
      "usb_storage"
      "virtio_pci"
      "virtio_scsi"
      "xhci_pci"
    ];
    kernelParams = [
      "console=tty0"
      "console=ttyS0,115200n8"
    ];
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
    e2fsprogs
    git
    gptfdisk
    parted
    rsync
    tmux
    util-linux
  ];

  # If exact networking or key-only SSH fails after kexec, return to the still
  # untouched Debian disk automatically. The operator must create the disarm
  # marker only after installer access and disk preconditions are reverified.
  systemd.services.kexec-access-failsafe = {
    description = "Reboot to Debian unless the NixOS cutover is explicitly armed";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      Restart = "no";
    };
    script = ''
      ${pkgs.coreutils}/bin/sleep 900
      if ! ${pkgs.coreutils}/bin/test -e /run/nixos-cutover-disarmed; then
        ${pkgs.systemd}/bin/systemctl reboot --force
      fi
    '';
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Carry the exact prebuilt target closure inside the installer image. The
  # installer can populate the mounted root without any production-side build.
  netboot.storeContents = [targetSystem];

  # A copyable, dereferenced tree. The generated kexec-boot script contains
  # the exact init closure and kernel parameters from this pinned evaluation.
  system.build.kexecBundle = pkgs.runCommand "nixos-vps-kexec-bundle" {} ''
    mkdir -p "$out"
    cp --dereference ${config.system.build.kexecTree}/bzImage "$out/bzImage"
    cp --dereference ${config.system.build.kexecTree}/initrd.gz "$out/initrd.gz"
    cp --dereference ${config.system.build.kexecTree}/kexec-boot "$out/kexec-boot"
    chmod 0755 "$out/kexec-boot"
  '';

  system.stateVersion = "26.05";
}
