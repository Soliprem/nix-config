# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d6267deb-a312-49d0-a74d-92148d325369";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DB10-1557";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/76071ebd-cb46-4583-9169-88d4a6d9adaa";
    fsType = "btrfs";
  };

  # fileSystems."/var/lib/docker/overlay2/38d36a567e4fb6e205601b6311c4b0b5166b4568aff27893a9307fe8b320eb19/merged" =
  #   { device = "overlay";
  #     fsType = "overlay";
  #   };
  #
  fileSystems."/storage" = {
    device = "/dev/disk/by-uuid/69159ca4-a7df-4452-b9da-13a10e03ff0e";
    fsType = "btrfs";
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/1b6cc59f-4273-4a67-8b1a-f114f9859bf2";}
  ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp113s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wg0-mullvad.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}