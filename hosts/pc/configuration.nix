{
  pkgs,
  configRoot,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ../shared
      ../shared/desktop.nix
    ]
    ++ map (file: configRoot + "/system/modules/${file}" + ".nix") [
      "ollamaRocm"
      "vane"
      "openrgb"
      "hermes"
    ];

  networking.hostName = "nixos-pc";

  boot = {
    kernelParams = ["acpi_backlight=video"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  users.users.soliprem.extraGroups = [
    "gamemode"
    "audio"
    "video"
    "hermes"
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "24.05";
}
