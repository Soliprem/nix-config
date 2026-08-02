{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

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
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";
        efiSupport = false;
      };
      efi.canTouchEfiVariables = false;
    };
    kernelModules = ["fuse"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/dda498cf-61af-49e1-addb-633e9e3efdde";
    fsType = "ext4";
    options = ["errors=remount-ro"];
  };

  # The live system is BIOS-booted. The existing ESP is mounted only for
  # preservation/inspection and is not used as evidence of UEFI runtime.
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/66C0-BF9C";
    fsType = "vfat";
    options = [
      "noauto"
      "nofail"
      "umask=0077"
    ];
  };

  swapDevices = [{device = "/home/.swap";}];

  networking.useDHCP = false;
}
