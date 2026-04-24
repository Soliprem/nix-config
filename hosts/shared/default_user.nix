{ pkgs, ... }:
{
  users.users.soliprem = {
    isNormalUser = true;
    description = "Francesco Prem Solidoro";
    extraGroups = [
      "networkmanager"
      "wheel"
      "podman"
      "plugdev"
    ];
    shell = pkgs.dash;
  };

  environment.shells = with pkgs; [
    nushell
    dash
  ];
}
