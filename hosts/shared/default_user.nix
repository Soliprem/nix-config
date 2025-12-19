{ pkgs, ... }:
{
  users.users.soliprem = {
    isNormalUser = true;
    description = "Francesco Prem Solidoro";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
    ];
    shell = pkgs.dash;
  };

  environment.shells = [
    pkgs.nushell
  ];
}
