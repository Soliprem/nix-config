# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  # fileSystems."/home".neededForBoot = true;

  # Use the systemd-boot EFI boot loader.
  # Bootloader.
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.kernelModules = ["amdgpu"];
    kernelParams = ["acpi_backlight=video"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "nixos-pc"; # Define your hostname.
  # Pick only one of the below networking options.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  #systemd.services.wpa_supplicant.environment.OPENSSL_CONF = pkgs.writeText"openssl.cnf""
  #openssl_conf = openssl_init
  #[openssl_init]
  #ssl_conf = ssl_sect
  #[ssl_sect]
  #Options = UnsalfeLegacyRenegotation
  #[system_default_sect]
  #CipherString = Default:@SECLEVEL=0
  #"
  #;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  hardware = {
    # enableAllFirmware = true;
    bluetooth.enable = true;
    keyboard.qmk.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      # extraPackages = with pkgs; [
      #   amdvlk
      # ];
      # extraPackages32 = with pkgs; [
      #   driversi686Linux.amdvlk
      # ];
    };
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    audio.enable = true;
    wireplumber.enable = true;
  };

  # install fish
  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.soliprem = {
    isNormalUser = true;
    description = "Francesco Prem Solidoro";
    extraGroups = ["networkmanager" "wheel" "gamemode" "audio" "video"];
    packages = with pkgs; [
      wl-clipboard
    ];
    shell = pkgs.nushell;
  };
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
